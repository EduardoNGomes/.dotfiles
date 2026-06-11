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

---

## Observações
- Nomeie migrations de forma clara e descritiva (ex.: `AddNewLessonPublishType`, `CreateUserPreferencesTable`, `AlterCoursesAddStatus`).
- Evite `down()` parcial: rollback precisa deixar o banco no estado anterior sem "restos".
