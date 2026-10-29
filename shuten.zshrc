# Show the current Git branch and a dirty marker in the prompt.

git_prompt_info() {
    command git rev-parse --is-inside-work-tree &>/dev/null || {
        print -r -- " %k%F{#573586}%f"
        return
    }

    local branch git_status=""
    branch=$(command git symbolic-ref --quiet --short HEAD 2>/dev/null) ||
        branch=$(command git rev-parse --short HEAD 2>/dev/null) ||
        return

    if ! command git diff --quiet --ignore-submodules -- ||
       ! command git diff --cached --quiet --ignore-submodules -- ||
       [[ -n $(command git ls-files --others --exclude-standard) ]]; then
        git_status=" ●"
    fi

    print -r -- " %k%F{#573586}%K{#57655A}%F{#ffffff}  ${branch}${git_status} %k%F{#57655A}%f"
}

setopt PROMPT_SUBST

PROMPT=$'%F{#B82645}%K{#B82645}%F{#ffffff} %n %K{#8a1931}%F{#B82645} %F{#ffffff}%* %k%F{#8a1931}\n%f%F{#573586}%f%K{#573586}%F{#ffffff} %~$(git_prompt_info)\n%F{#57655A}❯%f '

_add_newline_before_prompt() {
    if (( ${_prompt_shown_before:-0} )); then
        printf '\n'
    fi

    _prompt_shown_before=1
}

precmd_functions=(${precmd_functions:#_add_newline_before_prompt})
precmd_functions+=(_add_newline_before_prompt)

fastfetch