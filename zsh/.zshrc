# IMPORT ALIASES
if [ -f ~/.zsh-custom/aliases.zsh ]; then
  source ~/.zsh-custom/aliases.zsh
fi

# IMPORT ENVIRONMENT VARIABLES
if [ -f ~/.zsh-custom/env_vars.zsh ]; then
  source ~/.zsh-custom/env_vars.zsh
fi

# IMPORT CUSTOM FUNCTIONS
if [ -f ~/.zsh-custom/functions.zsh ]; then
  source ~/.zsh-custom/functions.zsh
fi
source ~/.dotfiles/zsh/functions.zsh


# ALIAS
alias nv="nvim"
alias hconf="nvim ~/.config/hypr/hyprland.conf"
alias kconf="nvim ~/.config/kitty/kitty.conf"
alias waybar-reload="killall -SIGUSR2 waybar"
alias wconf="nvim ~/.config/waybar"
alias tmks="tmux kill-session"
alias nvconf="cd ~/.config/nvim/"
alias aliasconf="nvim ~/.zsh-custom/aliases.zsh"
alias envconf="nvim ~/.zsh-custom/env_vars.zsh"
alias zsconf="nvim ~/.zshrc"
alias dtconf="cd ~/.dotfiles/"
alias cl="clear"
alias dw="cd ~/Downloads"
alias clb="git branch --merged main | grep -v "main" | xargs git branch -D"


# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export PATH="$PATH:/opt/nvim-linux64/bin"
export EDITOR=vim
export VISUAL=vim



ZSH_THEME="leaf"

# zoxide
eval "$(zoxide init zsh)"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh


# Bind new key to accept autosuggestion
bindkey '^@' autosuggest-accept

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

