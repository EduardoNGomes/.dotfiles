# Bloco de impacto obrigatório no PR

Todo PR que adiciona, altera ou remove uma migration **precisa** abrir com este bloco, antes de qualquer outra seção. Objetivo: quem revisa entende o custo físico da operação sem precisar ler o SQL.

## Como pintar de vermelho/amarelo no GitHub

Dois recursos nativos — não use `<span style>`, o GitHub sanitiza.

**1. Alerts** (renderizam com cor e ícone):

| Sintaxe | Cor | Use para |
|---|---|---|
| `> [!CAUTION]` | 🔴 vermelho | risco ALTO — rebuild, lock de escrita, pico de disco |
| `> [!WARNING]` | 🟡 amarelo | risco MÉDIO — build de índice, backfill, CPU/IO alto |
| `> [!NOTE]` | 🔵 azul | risco BAIXO — metadata-only, `CREATE TABLE` |

**2. Bloco `diff`** — linhas com `-` renderizam em **vermelho**, com `+` em **verde**. É a única forma de ter texto colorido de verdade:

````
```diff
- 🔴 RISCO ALTO — reconstrói a tabela inteira e bloqueia escrita
```
````

Combine os dois: alert para a caixa colorida, `diff` para a manchete em vermelho.

---

## Template — RISCO ALTO 🔴

````markdown
> [!CAUTION]
> ## 🔴🔴 MIGRATION DE ALTO RISCO — LEIA ANTES DE APROVAR 🔴🔴

```diff
- ⛔ RECONSTRÓI A TABELA INTEIRA — BLOQUEIA ESCRITA — PICO DE ~2x DISCO
- ⛔ NÃO APROVE sem ler "Como é aplicada" e "Consequências" abaixo
```

### 🔧 Como é aplicada fisicamente

`ALTER TABLE clas_x CONVERT TO CHARACTER SET utf8mb4` **não altera a tabela no lugar.** O MariaDB:

1. Cria uma **tabela temporária nova** (`#sql-*`) com o schema de destino
2. **Copia linha por linha** a tabela inteira, re-encodando cada texto
3. **Reconstrói todos os índices**, inclusive os FULLTEXT
4. Faz o `RENAME` atômico e dropa a antiga

Ou seja: **durante a operação existem duas cópias completas dos dados em disco.**

### 💥 Consequências

| Dimensão | Impacto | Detalhe |
|---|---|---|
| 🔒 **Lock** | 🔴 **escrita bloqueada** na tabela durante toda a operação | `CONVERT` não suporta `LOCK=NONE`. Leitura continua |
| ⏱️ **Downtime** | 🔴 efetivo para quem escreve nessa tabela | proporcional ao tamanho: ~X min em tabela de Y GB |
| 💾 **Storage** | 🔴 **pico de ~2x o tamanho da tabela** | tabela de 20 GB exige ≥20 GB livres. Se abortar, o `#sql-*` pode ficar órfão e **não liberar** |
| 🔥 **CPU** | 🔴 alto e sustentado | re-encode + rebuild de índice são CPU-bound |
| 📈 **IO** | 🔴 alto | reescreve o dataset inteiro |
| 🔌 **Connections** | 🟡 indireto, pode ser severo | escritas enfileiram; com pool grande, vira exaustão de conexão e contenção de `LOCK_open` |
| 🔁 **Replicação** | 🟡 lag | o DDL replica |

### 📊 Alcance (medido, não estimado)

```sql
SELECT table_schema, ROUND((data_length+index_length)/1024/1024/1024,2) AS gb, table_rows
FROM information_schema.tables WHERE table_name = 'clas_x' ORDER BY gb DESC LIMIT 10;
```

- Tenants afetados: **N de ~3000**
- Maior tabela: **X GB / Y milhões de linhas** (tenant `Z`)
- Tenants pulados pelo guard: **N** (acima de W GB → tratar com `gh-ost`)

### 🛡️ Guards no arquivo

- [ ] Condicional de estado (só age se ainda não está no alvo)
- [ ] Teto de tamanho (`MAX_REBUILD_BYTES`), pula e loga acima dele
- [ ] `max_statement_time` em **segundos**
- [ ] `lock_wait_timeout` baixo
- [ ] `ALGORITHM`/`LOCK` explícitos onde aplicável

### 🚀 Rollout obrigatório

- [ ] Folga de disco verificada nos 4 clusters (`FreeStorageSpace`) — ≥2x a maior tabela
- [ ] `mode=smoke` → `mode=dry-run` → `mode=canary` → `apply`
- [ ] `apply` **escopado** (`--keys=` / `--host=`), **nunca** frota inteira
- [ ] `--concurrency=1`
- [ ] Um cluster por vez
- [ ] Fora das janelas de cron de sync
- [ ] Nenhum backup em andamento nos clusters alvo
- [ ] Alguém acompanhando CPU/disco/conexões durante a execução

### ↩️ Reversão

Roll-forward only. Reverter exige migration nova. **Se abortar no meio**, o rollback do InnoDB consome IO e pode deixar `#sql-*` órfão ocupando disco:

```sql
SELECT table_schema, table_name, ROUND((data_length+index_length)/1024/1024) AS mb
FROM information_schema.tables WHERE table_name LIKE '#sql%' ORDER BY mb DESC;
```
````

---

## Template — RISCO MÉDIO 🟡

````markdown
> [!WARNING]
> ## 🟡 MIGRATION DE RISCO MÉDIO — build de índice online

```diff
- ⚠️ ~5-15 min por tenant grande, CPU/IO alto. Não bloqueia leitura nem escrita.
```

### 🔧 Como é aplicada fisicamente

`ADD INDEX ... ALGORITHM=INPLACE, LOCK=NONE`: a tabela **não é recriada**. O InnoDB varre a tabela, ordena as chaves em buffer de sort e escreve as páginas do índice novo. Escritas concorrentes vão para um log de alteração online, aplicado no fim.

### 💥 Consequências

| Dimensão | Impacto | Detalhe |
|---|---|---|
| 🔒 **Lock** | 🟢 sem bloqueio de leitura/escrita | `LOCK=NONE`. Só um metadata lock breve no início e no fim |
| ⏱️ **Downtime** | 🟢 nenhum | |
| 💾 **Storage** | 🟡 cresce pelo tamanho do índice + espaço de sort | não é 2x a tabela |
| 🔥 **CPU** | 🟡 alto durante o build | ~X min por tenant grande |
| 📈 **IO** | 🟡 varre a tabela inteira | polui o buffer pool |
| 🔌 **Connections** | 🟢 normalmente sem efeito | |

⚠️ **`LOCK=NONE` é por tenant, não protege o cluster.** N builds concorrentes saturam o cluster mesmo sendo todos "online". **Use `--concurrency=1`.**

### 📊 Alcance
[medido, como acima]

### 🚀 Rollout
- [ ] `dry-run` antes
- [ ] `--concurrency=1`
- [ ] Fora das janelas de cron
````

---

## Template — RISCO BAIXO 🔵

````markdown
> [!NOTE]
> ## 🔵 MIGRATION DE BAIXO RISCO — metadata-only

### 🔧 Como é aplicada fisicamente

`ADD COLUMN ... NULL ... ALGORITHM=INSTANT` no fim da tabela: **só metadata**, nenhuma linha é tocada. Instantâneo mesmo em tabela grande.

### 💥 Consequências

| Dimensão | Impacto |
|---|---|
| 🔒 Lock | 🟢 metadata lock de milissegundos |
| ⏱️ Downtime | 🟢 nenhum |
| 💾 Storage | 🟢 desprezível |
| 🔥 CPU | 🟢 desprezível |
| 🔌 Connections | 🟢 nenhum |

`ALGORITHM=INSTANT` declarado: se o servidor não puder cumprir, ele **erra** em vez de fazer um rebuild silencioso.

### 📊 Alcance
Todos os tenants (`IF NOT EXISTS` cobre quem já tem a coluna por drift).
````

---

## Checklist do revisor

Antes de aprovar qualquer PR de migration:

- [ ] O bloco de impacto existe e está no topo
- [ ] O nível de risco bate com a operação real (confira em `ddl-reference.md`)
- [ ] "Como é aplicada" descreve o mecanismo físico, não repete o SQL
- [ ] Todas as 6 dimensões estão preenchidas (lock, downtime, storage, CPU, IO, connections)
- [ ] O alcance foi **medido**, não estimado
- [ ] `ALGORITHM`/`LOCK` explícitos em todo `ALTER`
- [ ] `max_statement_time` em segundos
- [ ] Idempotente (`IF NOT EXISTS` / checagem prévia)
- [ ] Nome de arquivo novo, nunca reutilizado
- [ ] Risco alto/médio → plano de rollout escopado, com concorrência 1

**Falta qualquer item → request changes.** O custo de pedir o número é minutos; o de descobrir em produção foi um cluster fora do ar.
