---
name: pr
description: Cria um Pull Request usando a CLI do GitHub (gh), preenchendo o template do projeto quando existir. Use quando o usuário pedir para abrir/criar um PR ou pull request.
allowed-tools: Bash, Read, Glob
---

# Pull Request

Cria um Pull Request com o `gh` a partir da branch atual.

## Regras

1. **Nunca faça commit.** Não rode `git add`, `git commit` nem altere o working tree. Trabalhe apenas com o que já está commitado. Se houver mudanças não commitadas, avise o usuário e pare — ele decide se quer commitar antes (pode usar a skill `commit`).
2. **Use sempre o `gh`** (`gh pr create`). Não use a API web nem outros meios.
3. **Respeite o template do projeto.** Se houver um template de PR, preencha-o de acordo com a estrutura dele (seções, checklists, etc.). Se não houver, use um corpo simples e claro.

## Passos

1. Verifique o estado:
   - `git status` — se houver mudanças não commitadas/não pushadas relevantes, avise. **Não commite.**
   - `git branch --show-current` — confirme que não está na branch padrão (`main`/`master`). Se estiver, avise e pare.
   - `git push -u origin HEAD` se a branch ainda não tiver upstream (apenas push, nunca commit).
2. Procure o template de PR do projeto, nesta ordem (use o primeiro encontrado):
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/PULL_REQUEST_TEMPLATE/*.md`
   - `docs/pull_request_template.md`
   - `pull_request_template.md` (raiz)
3. Determine o conteúdo:
   - Título: resuma as mudanças seguindo o padrão usado pelo projeto (se os commits usam Conventional Commits, mantenha o padrão).
   - Corpo: se achou template, **preencha as seções dele** com base no `git log`/`git diff` da branch contra a base. Não invente itens de checklist — marque apenas o que de fato se aplica. Se não achou template, escreva um resumo curto das mudanças.
4. Crie o PR escrevendo o corpo em arquivo temporário para preservar a formatação:
   - `gh pr create --title "<titulo>" --body-file <arquivo>` (adicione `--base <branch>` se a base não for a padrão).
5. Mostre ao usuário a URL retornada pelo `gh`.

## Observações

- Para inspecionar as mudanças da branch: `git log <base>..HEAD --oneline` e `git diff <base>...HEAD`.
- Se o repositório não tiver `gh` autenticado, avise o usuário para rodar `gh auth login`.
