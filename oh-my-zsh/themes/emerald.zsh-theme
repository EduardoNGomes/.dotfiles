PROMPT="%F{#47E4AE}%f "
PROMPT+="%F{#47E4AE}%c%f"
PROMPT+=' $(git_prompt_info)'
PROMPT+="
%(?:%F{#47E4AE}%B%1{»%}%b :%F{red}%B%1{»%}%b )%f"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{#309BD6}%Bgit:(%F{#F26B71}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%f "
ZSH_THEME_GIT_PROMPT_DIRTY="%F{#309BD6}) %F{yellow}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{#309BD6})"

function precmd() {
    if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
        NEW_LINE_BEFORE_PROMPT=1
    elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
        echo ""
    fi
}
