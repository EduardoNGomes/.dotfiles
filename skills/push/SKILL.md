---
name: push
description: Faz push da branch atual para o remoto de forma segura. Use quando o usuário pedir para fazer push, enviar/subir commits, ou publicar a branch no remoto.
allowed-tools: Bash
---

# Push

Faz push dos commits da branch atual para o remoto.

## Regras

1. **NUNCA faça force push.** Esta é a regra principal e inviolável. Jamais use `--force`, `-f`, `--force-with-lease`, `--force-if-includes` ou qualquer variante que reescreva o histórico remoto. Se um push for rejeitado por divergência (`non-fast-forward`), **pare e avise o usuário** — não force, não sobrescreva. Resolva trazendo as mudanças do remoto (ex.: `git pull --rebase` ou merge) e fazendo um novo push normal, sempre com confirmação do usuário.
2. **Só faça push do que já está commitado.** Não rode `git add` nem `git commit`. Se houver mudanças não commitadas relevantes, avise o usuário (ele pode usar a skill `commit`). O push trabalha apenas com o histórico já existente.
3. **Confirme a branch e o destino.** Faça push da branch atual para o remoto correspondente. Não faça push para uma branch diferente da atual sem que o usuário peça explicitamente.

## Passos

1. Verifique o estado:
   - `git status` — confirme o que será enviado e se há algo não commitado (apenas avise; não commite).
   - `git branch --show-current` — confirme a branch atual.
   - `git log @{u}..HEAD --oneline` (se houver upstream) para mostrar os commits que serão enviados.
2. Faça o push:
   - Se a branch já tem upstream: `git push`.
   - Se a branch ainda não tem upstream: `git push -u origin HEAD`.
3. Se o push for **rejeitado** (`non-fast-forward` / branch divergiu):
   - **NÃO** force o push. Avise o usuário do que aconteceu.
   - Sugira integrar o remoto antes (`git pull --rebase` ou merge), e só então um novo `git push` normal — sempre com confirmação.
4. Confirme o resultado ao usuário (branch, remoto e commits enviados).

## Observações

- Se o remoto não estiver configurado ou o `git push` falhar por autenticação, avise o usuário em vez de tentar contornar.
- Qualquer pedido de "forçar", "sobrescrever o remoto" ou "force push" deve ser **recusado**, explicando o risco de perda de histórico. No máximo, explique manualmente os comandos para o usuário decidir por conta própria.
