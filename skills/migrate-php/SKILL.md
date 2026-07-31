---
name: migrate-php
description: Cria e valida novas migrations no PHP (Phinx) ou no banco do cliente da Curseduca. Use SEMPRE que alguém pedir para "criar uma migration" no PHP ou no banco do cliente.
allowed-tools: Bash, Read, Edit, Write
---

# Migration Creator (Phinx / Curseduca)

## Objetivo
Este agente é o responsável **exclusivo** por criar e orientar a execução/validação de **novas migrations** no PHP (Phinx) ou no **banco do cliente**.

> **Regra:** Sempre que alguém pedir para "criar uma migration" (no PHP ou no banco do cliente), **use este agente**.

---

## ⚠️ Phinx é SÓ validação local — não commite, não abra PR

O Phinx roda apenas no ambiente local (docker), num único banco. **Ele está desativado em produção.** A migration criada aqui é **scratch de validação**: serve para provar que o SQL funciona antes de mandar algo para ~3000 bancos de clientes.

| | Phinx (esta skill) | `waid-clients-db-migrations` |
|---|---|---|
| Para que serve | **validar localmente** | **produção** |
| Onde roda | docker local, 1 banco | **~3000 bancos de clientes, 4 clusters** |
| Chega no cliente | ❌ **não** | ✅ **sim** |
| **Commit** | ❌ **nunca** | ✅ sim |
| **PR** | ❌ **nunca** | ✅ sim, para a `main` |
| `down()` | obrigatório | não existe — roll-forward only |
| Idempotência | não crítica | **obrigatória** (os bancos driftaram) |
| Nome do arquivo | `AddNewLessonPublishType` | `<timestamp UTC>_snake_case.sql` |
| Bloco de impacto | — | **obrigatório no PR** |

**O arquivo desta skill não é versionado.** Ele vai aparecer como untracked no `git status` do `curseduca-master` — deixe assim. Não rode `git add` nele, não inclua em commit, não abra PR.

**Criar só a do Phinx = a mudança nunca chega no cliente.** Ela funciona no seu ambiente e não existe em produção — falha silenciosa, descoberta semanas depois.

Depois de validar aqui, use a skill `waid-migration` para escrever a contraparte. As duas precisam ser semanticamente equivalentes, mas **não são o mesmo arquivo copiado**: a versão de produção é idempotente, sem `down()`, com `ALGORITHM`/`LOCK` explícitos e classificada por risco.

---

## Criar Migration

### Comando
```bash
docker exec curseduca_app php ./curseduca-master/bin/phinx.php create <NomeDaMigration>
```

### Exemplo
```bash
docker exec curseduca_app php ./curseduca-master/bin/phinx.php create AddNewLessonPublishType
```

---

## Local onde a migration será criada
As migrations ficam em:

~/curseduca/curseduca-master/utils/db/migrations/

---

## Padrão obrigatório (UP e DOWN)
**Use SEMPRE `up()` e `down()` nas migrations.**

- `up()` deve aplicar as mudanças (create/alter/insert/etc).
- `down()` deve desfazer exatamente o que o `up()` fez (drop/revert/delete/etc).

---

## Checklist de validação (obrigatório)
Após criar e ajustar a migration para o que precisa:

1) **Executar a migration (migrate)**
```bash
docker exec curseduca_app php ./curseduca-master/bin/phinx.php migrate
```

2) **Executar rollback para validar o DOWN**
```bash
docker exec curseduca_app php ./curseduca-master/bin/phinx.php rollback
```

3) **Executar a migration novamente (migrate)**
```bash
docker exec curseduca_app php ./curseduca-master/bin/phinx.php migrate
```

> Isso garante que o `down()` funciona corretamente e que o banco volta a migrar sem problemas.

4) **Criar a contraparte em `waid-clients-db-migrations`** — obrigatório, senão a mudança fica só no seu ambiente. Use a skill `waid-migration`.

A tarefa **não está concluída** enquanto essa contraparte não existir. Se você validou o Phinx e parou aí, avise explicitamente ao usuário que a migration de produção ainda falta.

---

## Observações
- Nomeie migrations de forma clara e descritiva (ex.: `AddNewLessonPublishType`, `CreateUserPreferencesTable`, `AlterCoursesAddStatus`).
- Evite `down()` parcial: rollback precisa deixar o banco no estado anterior sem "restos".
