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
# UPDATE TERMINAL TITLE
update_terminal_title() {
  if [[ -n "$TMUX" ]]; then
    printf "\033]0;%s\033\\" "${PWD##*/}"
  else
    print -Pn "\e]0;${PWD##*/}\a"
  fi
}
precmd_functions+=(update_terminal_title)


count(){
	local files=( *(N) )
    print ${#files}
}

# Function to open PDF files
function pdf(){
	if [ -z "$1" ]; then
		echo "Usage: pdf <file_path>"
		return 1
	fi

	FILE_PATH="$1"
	
	# Check if the file exists
	if [ ! -f "$FILE_PATH" ]; then
		echo "File not found. Please check the file path. 😢"
		return 1
	fi

	# Check if the file is a PDF
	FILE_EXTENSION="${FILE_PATH##*.}"
	if [ "$FILE_EXTENSION" != "pdf" ]; then
		echo "File is not a PDF. Please check the file path. 😢"
		return 1
	fi
	
	zathura "$FILE_PATH" &
}

# Function to create my notes
note() {
	local original_dir
    original_dir="$(pwd)"

    cd ~ || return 1

    [ -d "notes" ] || mkdir "notes"
    cd "notes" || return 1

	if [[ "$1" == "-l" ]]; then
		ls -la
		cd "$original_dir" || return 1
		return 0
	fi

    local filename="$1"
	if [[ -z "$filename" ]]; then
        echo "Usage: note <filename>"
        return 1
	fi

    [[ "$filename" == *.md ]] || filename="${filename}.md"

    [ -f "$filename" ] || touch "$filename"

    nvim "$filename"
}


ZSH_THEME="leaf"


plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh


# Bind new key to accept autosuggestion
bindkey '^@' autosuggest-accept

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

