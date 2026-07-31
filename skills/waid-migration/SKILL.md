---
name: waid-migration
description: Cria migrations no repo waid-clients-db-migrations (banco dos clientes, MariaDB multi-tenant, ~3000 bancos) — é o único caminho que chega em produção. Use SEMPRE que alguém pedir para criar, editar, remover ou rodar uma migration do banco do cliente, mencionar o runner/dispatch de migrations, ou depois de validar uma migration local no Phinx (a contraparte de produção é obrigatória). NÃO use para migrations do Prisma (schema da própria API).
allowed-tools: Bash, Read, Write, Edit, Glob, Grep
---

# Migration no waid-clients-db-migrations

Runner multi-tenant (Umzug + mysql2) que aplica migrations em **~3000 bancos MariaDB de clientes**, espalhados por **4 clusters**. Repo: `waid-clients-db-migrations`.

**Princípio central:** aqui uma migration não roda uma vez — ela roda milhares de vezes, em paralelo, em bancos que driftaram por anos. O custo de um `ALTER` se multiplica pela frota. **Toda migration precisa declarar, no PR, como ela é aplicada fisicamente e qual o impacto.** Isso é obrigatório, não opcional.

## Toda migration é um PAR — as duas são obrigatórias

**Sempre que esta skill for usada, invoque também a skill `migrate-php`** e crie a mesma migration lá. Não é opcional e não é "se sobrar tempo": a do Phinx é como você valida localmente antes de mandar algo para ~3000 bancos.

| | Phinx (`migrate-php`) | Este repo (`waid`) |
|---|---|---|
| Para que serve | **validar localmente** | **produção** |
| Escopo | docker local, 1 banco | ~3000 bancos, 4 clusters |
| Chega no cliente | ❌ não | ✅ sim |
| **Commit** | ❌ **nunca** | ✅ sim |
| **PR** | ❌ **nunca** | ✅ sim, para a `main` |
| `down()` | obrigatório | não existe |
| Idempotência | não crítica | **obrigatória** |
| Nome | `AddNewLessonPublishType` | `<timestamp UTC>_snake_case.sql` |

⚠️ **O arquivo do Phinx é descartável e local.** Ele fica em `~/curseduca/curseduca-master/utils/db/migrations/` e **não entra em commit nem em PR** — é scratch de validação. Se ele aparecer no `git status` do `curseduca-master`, deixe fora do commit.

Só o arquivo deste repo é versionado, commitado e vai para a `main` com PR (com o bloco de impacto obrigatório).

Não copie o arquivo do Phinx: aqui a versão precisa ser idempotente, sem `down()`, com `ALGORITHM`/`LOCK` explícitos e classificada por risco. Semanticamente equivalente, fisicamente diferente.

## Regras invioláveis

1. **Nome:** `<timestamp UTC>_<snake_case>.<sql|js>` — gere com `date -u +%Y%m%d%H%M%S`. A ordem de execução é a ordem alfabética do nome.
2. **`.sql` é o padrão.** Use `.js` só quando precisar de condicional, loop ou decisão baseada em dado.
3. **Idempotente e defensiva, sempre.** `IF NOT EXISTS`, `IF EXISTS`, checagem prévia no `information_schema`. Os bancos driftaram — nunca assuma estado limpo.
4. **Roll-forward only.** Não existe `down` automático. Para reverter, escreva uma migration nova.
5. **Nunca reutilize um nome de arquivo já usado.** O rastreamento é pela *string* do nome, sem checksum. Um arquivo com nome já existente pula nos tenants que têm a linha e roda nos outros, ficando meio aplicado.
6. **`ALGORITHM` e `LOCK` explícitos em todo `ALTER`.** Declarados, o servidor **erra** se não puder cumprir. Omitidos, ele escolhe — e pode fazer um rebuild COPY silencioso.
7. **`max_statement_time` no MariaDB é em SEGUNDOS**, não milissegundos. `60000` = 16h40, não 60s.
8. **Bloco de impacto obrigatório no PR.** Ver `impact-template.md`. PR de migration sem ele não deve ser aberto.
9. **Par obrigatório com o Phinx.** Toda migration criada aqui exige a contraparte local via skill `migrate-php`, validada com `migrate`→`rollback`→`migrate`. A do Phinx **não é commitada nem entra em PR** — só a deste repo é versionada.

## Como funciona o rastreamento (entenda antes de mexer)

Por tenant, existe a tabela `schema_migrations` com `name` (PK) + `applied_at`. **Sem checksum.** O Umzug calcula:

```
pendentes(tenant) = arquivos em migrations/  −  nomes gravados no schema_migrations DAQUELE tenant
```

Consequências que mudam decisões:

| Ação | Efeito real |
|---|---|
| Editar um arquivo já aplicado | **Não reexecuta.** A edição só alcança tenants sem a linha |
| Apagar o arquivo | Nunca mais entra em `pending`, em nenhum tenant. Linhas órfãs são ignoradas em silêncio |
| Esvaziar o `up()` e dar `return` | Grava a linha **como aplicada** sem ter feito nada — envenena o tracker. Prefira apagar |
| Um `up()` que lança | Não grava a linha; o tenant conta como falha e segue pendente |

**O estado não é global.** Não existe "a frota está na migration N" — existem ~3000 estados independentes. Um tenant atrasado recebe **toda** a dívida acumulada de uma vez.

## Como isso chega em produção

Este é o passo que mais gera engano:

```
merge na main   →  NÃO muda nada em produção
release         →  build da imagem (COPY migrations ./migrations) + terraform apply
dispatch        →  NÃO rebuilda; só start-execution na task definition PINADA
```

O ref escolhido no formulário do dispatch seleciona apenas o **workflow**, não o conjunto de migrations. Depois do release, **confirme a revisão pinada**:

```bash
ARN=$(aws stepfunctions list-state-machines \
  --query "stateMachines[?ends_with(name,'-clients-db-migrations')].stateMachineArn | [0]" --output text)
TD=$(aws stepfunctions describe-state-machine --state-machine-arn "$ARN" \
  --query definition --output text | jq -r '.States.RunMigration.Parameters.TaskDefinition')
aws ecs describe-task-definition --task-definition "$TD" \
  --query 'taskDefinition.containerDefinitions[0].image'
```

## Fluxo de trabalho

1. **Gere o timestamp:** `date -u +%Y%m%d%H%M%S`
2. **Escreva a migration deste repo** (ver padrões abaixo).
3. **Crie e valide a contraparte no Phinx** — invoque a skill `migrate-php`. Rode `migrate`→`rollback`→`migrate` para provar que o `down()` funciona e que o banco volta a migrar. É aqui que você descobre erro de sintaxe e de lógica antes de tocar em produção.
   - **Não commite esse arquivo.** Ele é local e descartável.
4. **Classifique o risco** e monte o bloco de impacto — ver `ddl-reference.md` para a mecânica física de cada operação e `impact-template.md` para o bloco do PR.
5. **Se for risco ALTO:** meça o alvo antes de escrever o número no PR:
   ```sql
   SELECT table_schema, table_name,
          ROUND((data_length + index_length)/1024/1024/1024, 2) AS gb,
          table_rows, table_collation
   FROM information_schema.tables
   WHERE table_name = '<tabela>'
   ORDER BY gb DESC LIMIT 20;
   ```
6. **Commit e PR — só o arquivo deste repo.** Use as skills `commit` e `pr`. O arquivo do Phinx fica de fora.
7. **Rollout:** `mode=smoke` → `mode=dry-run` → `mode=canary` → `mode=apply` escopado. **Nunca pule direto para apply.**

## Padrões

**`.sql` — barata e idempotente:**

```sql
-- Coluna nova, anulável, no fim da tabela: metadata-only.
-- ALGORITHM=INSTANT declarado para o servidor ERRAR se não puder cumprir.
ALTER TABLE clas_section_banner
  ADD COLUMN IF NOT EXISTS nm_analytics_identifier VARCHAR(255) NULL,
  ALGORITHM=INSTANT;
```

**`.js` — quando precisa decidir por tenant:**

```js
/**
 * [descreva: o que faz, por que .js, o que é pulado e por quê]
 */
export async function up({ context }) {
  const { connection } = context;

  // Segundos, não milissegundos.
  await connection.query('SET SESSION max_statement_time=900');
  // Falha rápido em vez de enfileirar atrás de metadata lock.
  await connection.query('SET SESSION lock_wait_timeout=10');

  const [rows] = await connection.query(
    `SELECT table_collation AS collation FROM information_schema.tables
      WHERE table_schema = DATABASE() AND table_name = ? LIMIT 1`,
    ['minha_tabela'],
  );

  // Tenant sem a tabela (drift) → skip silencioso.
  if (rows.length === 0) return;
  // Já no estado desejado → no-op, sem ALTER.
  if (rows[0].collation.startsWith('utf8mb4')) return;

  await connection.query('ALTER TABLE `minha_tabela` ...');
}
```

## Guards para migration pesada

Se a operação reconstrói tabela, o guard vai **dentro do arquivo** — é o único lugar que não depende de quem dispara escolher as flags certas.

```js
// Teto de tamanho: acima disso, pula e loga para tratar fora de banda (gh-ost).
const MAX_REBUILD_BYTES = 5 * 1024 ** 3;

const [[size]] = await connection.query(
  `SELECT data_length + index_length AS bytes FROM information_schema.tables
    WHERE table_schema = DATABASE() AND table_name = ?`, [table]);

if (size && size.bytes > MAX_REBUILD_BYTES) {
  console.log(JSON.stringify({ event: 'skipped_too_large', table, bytes: size.bytes }));
  return;
}
```

Outras formas: allowlist de databases no próprio arquivo (`SELECT DATABASE()` e compara), ou exigir opt-in por env (`process.env.MIGRATE_ALLOW_HEAVY !== '1'` → `return`).

## Erros comuns

| Erro | Consequência |
|---|---|
| `ALTER` sem `ALGORITHM`/`LOCK` | rebuild COPY silencioso, escrita bloqueada |
| `max_statement_time=60000` achando que são ms | vira 16h40 = sem limite |
| Editar migration já aplicada esperando reexecução | não reexecuta; frota fica em dois estados sob o mesmo nome |
| `mode=apply` com formulário em branco | cai no fallback `--all` = frota inteira, ~3000 bancos, 4 clusters |
| Não verificar folga de disco antes de rebuild | rebuild precisa ~2x o tamanho da tabela; `storage-full` derruba a instância |
| Pular o `dry-run` | você não sabe quantas migrations pendentes cada tenant tem |
| Concorrência default (10/cluster) em migration pesada | até 40 rebuilds simultâneos |

## Red flags — pare e reavalie

- A operação é `CONVERT TO CHARACTER SET`, `MODIFY COLUMN` de tipo, ou `ADD FOREIGN KEY`
- A tabela alvo passa de 1 GB em algum tenant
- Você não sabe dizer quantos tenants a migration vai realmente alterar
- Você não mediu o tamanho da tabela nos maiores tenants
- O PR não tem o bloco de impacto

**Todos significam: não abra o PR ainda. Meça primeiro.**
