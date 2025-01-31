# v1
# PROMPT="%{$fg[cyan]%}%{$reset_color%} "
# PROMPT+="%{$fg[cyan]%}%c%{$reset_color%}"
# PROMPT+=' $(git_prompt_info)'
# PROMPT+="
# %(?:%{$fg_bold[cyan]%}%1{»%} :%{$fg_bold[red]%}%1{»%} )%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
#
#v2
PROMPT="%F{#47E4AE}%f "
PROMPT+="%F{#47E4AE}%c%f"
PROMPT+=' $(git_prompt_info)'
PROMPT+="
%(?:%F{#47E4AE}%B%1{»%}%b :%F{red}%B%1{»%}%b )%f"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{#309BD6}%Bgit:(%F{#F26B71}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{#309BD6}) %F{yellow}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{#309BD6})"



#precmd() { print "" }
function precmd() {
    # Print a newline before the prompt, unless it's the
    # first prompt in the process.
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}
