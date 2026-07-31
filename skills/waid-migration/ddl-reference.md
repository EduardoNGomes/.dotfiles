# O que cada DDL faz fisicamente (MariaDB / InnoDB)

Referência para preencher a seção "Como é aplicada" do bloco de impacto com precisão, em vez de adivinhar o risco.

## Tabela de consulta rápida

| Operação | Algoritmo típico | O que acontece fisicamente | Risco |
|---|---|---|---|
| `CREATE TABLE` | — | cria arquivo novo, vazio | 🔵 |
| `ADD COLUMN` anulável, no fim | INSTANT | só metadata; nenhuma linha tocada | 🔵 |
| `ADD COLUMN ... AFTER <col>` | INSTANT ou COPY | depende da versão; se não for instant, **reconstrói** | 🟡🔴 |
| `DROP COLUMN` | INSTANT ou COPY | instant nas versões novas; senão **reconstrói** | 🟡🔴 |
| `MODIFY COLUMN` VARCHAR maior, **sem** cruzar 255 bytes | INPLACE | metadata | 🔵 |
| `MODIFY COLUMN` VARCHAR cruzando 255 bytes | COPY | muda o byte de tamanho → **reconstrói** | 🔴 |
| `MODIFY COLUMN` mudança de tipo (TINYINT→SMALLINT, etc.) | COPY (geralmente) | **reconstrói** a tabela | 🔴 |
| `ADD INDEX` (secundário) | INPLACE, LOCK=NONE | varre a tabela, ordena, escreve páginas do índice novo | 🟡 |
| `DROP INDEX` | INPLACE | metadata + libera páginas | 🔵 |
| `ADD FULLTEXT` — **o primeiro** da tabela | COPY | precisa criar a coluna oculta `FTS_DOC_ID` → **reconstrói** | 🔴 |
| `ADD FULLTEXT` — os seguintes | INPLACE, LOCK=SHARED | **bloqueia escrita** durante o build | 🟡🔴 |
| `ADD PRIMARY KEY` | COPY | PK é o índice clusterizado = **a tabela**. Sempre reconstrói | 🔴 |
| `DROP PRIMARY KEY` | COPY | **reconstrói** | 🔴 |
| `CONVERT TO CHARACTER SET` | COPY | reescreve todas as linhas + **todos** os índices | 🔴 |
| `ADD FOREIGN KEY` | COPY ou INPLACE | valida todas as linhas; bloqueia escrita na validação | 🔴 |
| `ROW_FORMAT` / `OPTIMIZE TABLE` / `FORCE` | COPY | **reconstrói** | 🔴 |
| `RENAME TABLE` | — | metadata; precisa de metadata lock exclusivo (breve, mas espera queries longas) | 🔵🟡 |
| `UPDATE` de backfill | DML | locks de linha, undo log, binlog; replica | 🟡🔴 |

## O que "reconstrói" (COPY) significa de verdade

Esta é a frase que precisa aparecer no PR quando o risco é alto:

```
1. cria uma tabela temporária nova (#sql-*) com o schema de destino
2. copia TODAS as linhas, uma a uma, aplicando a transformação
3. reconstrói TODOS os índices da tabela
4. RENAME atômico e dropa a antiga
```

Três consequências que decorrem disso:

- **Disco:** durante a operação existem **duas cópias completas**. Precisa de ≥1x o tamanho da tabela livre, na prática ~2x com folga.
- **Escrita bloqueada:** o `CONVERT` e a maioria dos COPY não aceitam `LOCK=NONE`.
- **Abortar não é grátis:** o rollback do InnoDB consome IO, e o `#sql-*` pode ficar **órfão ocupando disco indefinidamente**. Concluir libera; abortar pode não liberar.

## O que `ALGORITHM=INPLACE, LOCK=NONE` protege — e o que não

**Protege:** leitura e escrita naquela tabela continuam durante o build.

**Não protege:**

- **O cluster.** `LOCK=NONE` é por tenant. N builds concorrentes saturam CPU e IO do cluster igual. Um índice "online" que leva 10 min por tenant, com 10 tenants em paralelo, é 10 builds simultâneos.
- **O buffer pool.** Varrer a tabela inteira despeja o working set. Depois do build, a aplicação sofre até reaquecer.
- **O table cache.** Muito DDL invalida definições de tabela; com milhares de databases por cluster, isso pode virar contenção no `LOCK_open` — todas as threads da aplicação param em `Opening tables`, CPU em 100% girando em mutex, throughput zero.
- **O `innodb_online_alter_log_size`.** Escritas concorrentes durante um ALTER online vão para um log em memória. Se ele estourar, **o ALTER falha** no fim, depois de ter feito todo o trabalho. Tabela com escrita intensa + build longo = risco real.

## Variáveis de sessão

```sql
SET SESSION max_statement_time=900;   -- SEGUNDOS (double). 60000 = 16h40, não 60s
SET SESSION lock_wait_timeout=10;     -- segundos; espera por metadata lock
```

- `max_statement_time` no MariaDB é em **segundos** — diferente do `max_execution_time` do MySQL, que é em milissegundos. Confundir os dois é como se anula o limite sem perceber.
- Não conte com `max_statement_time` para interromper DDL: não é claro que o MariaDB o aplique a `ALTER TABLE`. Trate como não-garantido e limite o trabalho por outros meios (teto de tamanho, escopo).
- `lock_wait_timeout` baixo é preferível: falhar rápido é melhor que enfileirar atrás de um metadata lock e arrastar todas as queries da tabela.

## Como verificar antes de subir

**1. O servidor aceita o algoritmo?** Declare e deixe ele recusar:

```sql
ALTER TABLE minha_tabela ADD INDEX idx_x (col), ALGORITHM=INPLACE, LOCK=NONE;
-- Se não puder cumprir: ERROR 1845 ALGORITHM=INPLACE is not supported...
```

Erro explícito é o resultado desejado — melhor que um COPY silencioso.

**2. Qual o tamanho real nos maiores tenants?**

```sql
SELECT table_schema, table_name,
       ROUND((data_length + index_length)/1024/1024/1024, 2) AS gb,
       table_rows, table_collation
FROM information_schema.tables
WHERE table_name = '<tabela>'
ORDER BY gb DESC LIMIT 20;
```

**3. Tem folga de disco?** CloudWatch `FreeStorageSpace` nos 4 clusters. Precisa de ≥2x a maior tabela alvo. Sem isso, `storage-full` derruba a instância — e o RDS bloqueia `modify` justamente quando você precisa dele.

**4. Tem `#sql-*` órfão de tentativa anterior?**

```sql
SELECT table_schema, table_name, ROUND((data_length+index_length)/1024/1024) AS mb
FROM information_schema.tables WHERE table_name LIKE '#sql%' ORDER BY mb DESC;
```

**5. Durante a execução:**

```sql
SELECT ID, USER, DB, COMMAND, TIME, STATE, LEFT(INFO,120)
FROM information_schema.PROCESSLIST WHERE COMMAND <> 'Sleep' ORDER BY TIME DESC;
```

Estados que importam: `copy to tmp table` (rebuild em curso), `Creating index`, `Opening tables` **em massa** (contenção de table cache — pare de adicionar carga), `Rollback` (abort drenando).

## Quando não usar migration

Se a tabela é grande e a operação reconstrói, o próprio `migrations/README.md` do repo prescreve DDL online fora de banda:

- `gh-ost` ou `pt-online-schema-change` — constroem a tabela nova em ritmo controlado, com throttling, e fazem o swap no fim
- A migration então fica condicional: quando encontra a tabela já no estado alvo, é no-op e grava a linha sozinha

Regra prática: **acima de ~5 GB numa tabela com escrita ativa, não faça rebuild por migration.**
