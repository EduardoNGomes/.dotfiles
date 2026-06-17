---
name: commit
description: Cria commits seguindo Conventional Commits, dividindo as mudanças em múltiplos commits por finalidade. Use quando o usuário pedir para commitar, fazer commit, ou versionar mudanças.
allowed-tools: Bash, Read
---

# Commit

Cria commits a partir das mudanças no working tree seguindo regras estritas.

## Regras

1. **Nunca commite na `main`/`master`.** Antes de qualquer coisa, rode `git branch --show-current`. Se estiver na branch padrão (`main` ou `master`), **pare e avise o usuário** — não commite. Sugira criar/trocar para uma branch de trabalho antes (ex.: `git switch -c <branch>`) e siga só após confirmação.
2. **Um commit por finalidade.** Analise todas as mudanças (staged e unstaged). Se elas cobrem mais de uma funcionalidade/finalidade distinta, crie **vários commits**, um para cada finalidade — fazendo `git add` apenas dos arquivos (ou trechos) daquela finalidade antes de cada commit.
3. **Sem body.** A mensagem é apenas a linha de assunto (subject). Nunca adicione corpo, rodapé, nem `Co-Authored-By`.
4. **Conventional Commits.** Formato: `<tipo>(<escopo opcional>): <descrição>`
   - Tipos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`
   - Descrição no imperativo, em minúsculo, sem ponto final.
5. **Sempre em inglês.** A mensagem do commit (escopo e descrição) deve ser escrita **sempre em inglês**, independentemente do idioma usado na conversa ou no código.
6. **Migrations isoladas.** Mudanças em `prisma/` ou em migrations devem **sempre** ficar em um commit separado, nunca misturadas com outras finalidades.
7. **Lint isolado.** Mudanças que são **apenas** de lint/formatação (ex.: reformatação automática de linter/formatter, ajustes de espaçamento, aspas, ordenação de imports, ponto e vírgula) devem ficar em um commit separado, nunca misturadas com mudanças de lógica/funcionalidade. Use o tipo `style` (formatação que não altera o comportamento do código). Se um arquivo tem **tanto** mudança de lint quanto mudança de lógica, separe os trechos com `git add -p`.

## Passos

1. Rode `git status` e `git diff` (e `git diff --staged`) para ver todas as mudanças.
2. Agrupe os arquivos/mudanças por finalidade. Liste para o usuário o plano de commits proposto (quais arquivos vão em qual commit e a mensagem de cada um).
3. Para cada grupo, na ordem:
   - `git add <arquivos do grupo>` (use `git add -p` se for preciso separar trechos do mesmo arquivo).
   - `git commit -m "<tipo>(<escopo>): <descrição>"` — apenas `-m`, uma única linha.
4. Ao final, rode `git log --oneline -n <qtd>` para confirmar os commits criados.

## Exemplo

Mudanças: novo endpoint de login + correção de typo no README + reformatação automática do linter em vários arquivos.

→ Três commits (mensagens em inglês), com o lint isolado:
```
feat(auth): add login endpoint
docs: fix typo in readme
style: apply linter formatting
```
