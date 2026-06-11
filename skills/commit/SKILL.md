---
name: commit
description: Cria commits seguindo Conventional Commits, dividindo as mudanças em múltiplos commits por finalidade. Use quando o usuário pedir para commitar, fazer commit, ou versionar mudanças.
allowed-tools: Bash, Read
---

# Commit

Cria commits a partir das mudanças no working tree seguindo regras estritas.

## Regras

1. **Um commit por finalidade.** Analise todas as mudanças (staged e unstaged). Se elas cobrem mais de uma funcionalidade/finalidade distinta, crie **vários commits**, um para cada finalidade — fazendo `git add` apenas dos arquivos (ou trechos) daquela finalidade antes de cada commit.
2. **Sem body.** A mensagem é apenas a linha de assunto (subject). Nunca adicione corpo, rodapé, nem `Co-Authored-By`.
3. **Conventional Commits.** Formato: `<tipo>(<escopo opcional>): <descrição>`
   - Tipos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`
   - Descrição no imperativo, em minúsculo, sem ponto final.
4. **Sempre em inglês.** A mensagem do commit (escopo e descrição) deve ser escrita **sempre em inglês**, independentemente do idioma usado na conversa ou no código.
5. **Migrations isoladas.** Mudanças em `prisma/` ou em migrations devem **sempre** ficar em um commit separado, nunca misturadas com outras finalidades.

## Passos

1. Rode `git status` e `git diff` (e `git diff --staged`) para ver todas as mudanças.
2. Agrupe os arquivos/mudanças por finalidade. Liste para o usuário o plano de commits proposto (quais arquivos vão em qual commit e a mensagem de cada um).
3. Para cada grupo, na ordem:
   - `git add <arquivos do grupo>` (use `git add -p` se for preciso separar trechos do mesmo arquivo).
   - `git commit -m "<tipo>(<escopo>): <descrição>"` — apenas `-m`, uma única linha.
4. Ao final, rode `git log --oneline -n <qtd>` para confirmar os commits criados.

## Exemplo

Mudanças: novo endpoint de login + correção de typo no README.

→ Dois commits (mensagens em inglês):
```
feat(auth): add login endpoint
docs: fix typo in readme
```
