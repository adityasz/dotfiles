export HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTORY_IGNORE='([bf]g *|..|cd|cd ..|pwd|exit|l[ls]|l[ls]#( *)#|clear|nvim|history|history *)'

setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt beep
setopt AUTO_CD

bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

unset command_not_found_handle

fpath+="${ZDOTDIR}"/conda-zsh-completion
fpath+="${ZDOTDIR}"/magic-completion
fpath+="${ZDOTDIR}"/.zfunc

autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

function precmd() {
    print -Pn "\e]0;%~\a"
}

function vman() {
    # export MANPAGER="col -b" # for macOS
    eval 'man $@ | nvim -c "set nonu" -MR +"set filetype=man" -'
    unset MANPAGER
}

function git_branch_name() {
    branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
    if [[ $branch == "" ]];
    then
        :
    else
        echo ' ('$branch')'
    fi
}

function ..() {
    local dots="${1:-1}"  # Default to 1 if no argument provided
    local cmd="cd "
    for ((i=1; i<=dots; i++)); do
        cmd+="../"
    done
    eval "$cmd"
}

function clear() {
    /usr/bin/clear
    printf '\033[2J\033[3J\033[1;1H' # clear kitty scrollback
}

setopt PROMPT_SUBST
prompt='%B%n%b%B@%b%B%m%b%B:%b%B%(5~|%-1~/…/%3~|%4~)%b$(git_branch_name)$ '

typeset -a ANTIGEN_CHECK_FILES=(${ZDOTDIR:-~}/.zshrc ${ZDOTDIR:-~}/antigen.zsh)

source $HOME/.profile
source $ZDOTDIR/.zsh_aliases
source $ZDOTDIR/antigen.zsh

antigen bundle jeffreytse/zsh-vi-mode
antigen apply
export PATH="$PATH:/home/aditya/.local/share/modular/bin"
