PROMPT="%B%F{#47E4AE}󰌪%f%b "
PROMPT+="%B%F{#47E4AE}%c%f%b"

PROMPT+=' $(git_prompt_info)'
PROMPT+="
%(?:%F{#47E4AE}%B%1{»%}%b :%F{red}%B%1{»%}%b )%f"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{#309BD6}%Bgit:(%F{#F26B71}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{#309BD6}) %F{yellow}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{#309BD6})"


function precmd() {
    local last_command=$(fc -ln -1 | xargs echo)
    if [[ "$last_command" != "cl" && "$last_command" != "clear" ]]; then
        if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
            NEW_LINE_BEFORE_PROMPT=1
        elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
            echo ""
        fi
    fi
}
