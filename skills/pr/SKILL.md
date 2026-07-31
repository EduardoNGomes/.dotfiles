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
4. **PR com migration exige bloco de impacto.** Se o diff toca migrations de banco, o corpo do PR **precisa começar** com o bloco de impacto obrigatório, antes de qualquer outra seção — inclusive antes do template do projeto. Ver regra detalhada abaixo.

## Migrations: bloco de impacto obrigatório

Se o diff da branch contra a base toca qualquer um destes caminhos:

- `migrations/` (repo `waid-clients-db-migrations` — banco dos clientes)
- `prisma/**/migrations/`
- `db/migrate/`, `*.sql` de schema

**Exceção:** `curseduca-master/utils/db/migrations/` (Phinx) é validação **local** e nunca deve estar num PR. Se aparecer no diff, avise o usuário — ele foi commitado por engano e precisa sair antes.

então **antes de montar o corpo**, leia `~/.dotfiles/skills/waid-migration/impact-template.md` e use o template do nível de risco adequado. Para classificar o risco corretamente, consulte `~/.dotfiles/skills/waid-migration/ddl-reference.md` — não adivinhe o custo da operação.

O bloco precisa, obrigatoriamente:

1. **Chamar atenção visualmente** — `> [!CAUTION]` (vermelho) / `> [!WARNING]` (amarelo) / `> [!NOTE]` (azul), mais uma manchete dentro de um bloco de código `diff`, onde linhas iniciadas por `-` renderizam em vermelho no GitHub, e emoji. Nunca `<span style>`: o GitHub sanitiza.
2. **Explicar como a migration é aplicada fisicamente** — o mecanismo, não uma paráfrase do SQL. Ex.: "`CONVERT TO CHARACTER SET` cria uma tabela temporária nova, copia todas as linhas re-encodando, reconstrói todos os índices e faz o RENAME — durante a operação existem duas cópias completas em disco."
3. **Declarar as consequências, dimensão por dimensão** — lock, downtime, storage, CPU, IO, connections, replicação. Nenhuma em branco; se não se aplica, escreva 🟢 e por quê.
4. **Informar o alcance medido** — quantos tenants e o tamanho da maior tabela alvo. Medido com query, não estimado.
5. **Descrever o plano de rollout e a reversão** — para risco alto/médio: escopo, concorrência, ordem dos clusters, janela.

Se você não tem os números para preencher, **pare e peça ao usuário** ou rode a query de medição. Não abra o PR com o bloco pela metade e não invente valores.

## Passos

1. Verifique o estado:
   - `git status` — se houver mudanças não commitadas/não pushadas relevantes, avise. **Não commite.**
   - `git branch --show-current` — confirme que não está na branch padrão (`main`/`master`). Se estiver, avise e pare.
   - `git push -u origin HEAD` se a branch ainda não tiver upstream (apenas push, nunca commit).
2. **Detecte se há migration no diff** — antes de montar o corpo:
   - `git diff --name-only <base>...HEAD` e procure por `migrations/`, `prisma/**/migrations/`, `db/migrate/`
   - Se houver, leia `~/.dotfiles/skills/waid-migration/impact-template.md` e `ddl-reference.md`, classifique o risco pela operação real e monte o bloco de impacto. Ele vai **no topo** do corpo.
3. Procure o template de PR do projeto, nesta ordem (use o primeiro encontrado):
   - `.github/pull_request_template.md`
   - `.github/PULL_REQUEST_TEMPLATE.md`
   - `.github/PULL_REQUEST_TEMPLATE/*.md`
   - `docs/pull_request_template.md`
   - `pull_request_template.md` (raiz)
4. Determine o conteúdo:
   - Título: resuma as mudanças seguindo o padrão usado pelo projeto (se os commits usam Conventional Commits, mantenha o padrão).
   - Corpo: se achou template, **preencha as seções dele** com base no `git log`/`git diff` da branch contra a base. Não invente itens de checklist — marque apenas o que de fato se aplica. Se não achou template, escreva um resumo curto das mudanças.
   - **Se houver migration:** o bloco de impacto vem **primeiro**, acima do template/resumo. Ele não substitui o template — precede.
5. Crie o PR escrevendo o corpo em arquivo temporário para preservar a formatação:
   - `gh pr create --title "<titulo>" --body-file <arquivo>` (adicione `--base <branch>` se a base não for a padrão).
   - Arquivo temporário é obrigatório aqui: o bloco de impacto tem blocos de código aninhados e alerts, que quebram com `--body` inline.
6. Mostre ao usuário a URL retornada pelo `gh`.

## Observações

- Para inspecionar as mudanças da branch: `git log <base>..HEAD --oneline` e `git diff <base>...HEAD`.
- Se o repositório não tiver `gh` autenticado, avise o usuário para rodar `gh auth login`.
