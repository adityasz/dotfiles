HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTORY_IGNORE='([bf]g *|..|cd|cd ..|pwd|exit|l[ls]|l[ls]#( *)#|clear|nvim|history|history *)'
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt BEEP
setopt AUTO_CD
setopt PROMPT_SUBST
setopt INTERACTIVE_COMMENTS

unsetopt LIST_BEEP

bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

unset command_not_found_handle

fpath+=(
    "${ZDOTDIR}"/completions
    "${ZDOTDIR}"/functions
)

autoload -Uz $ZDOTDIR/functions/*(:t)

function precmd() {
    print -Pn "\e]0;%~\a"
}

function ..() {
    local dots="${1:-1}"
    local cmd="cd "
    for ((i=1; i<=dots; i++)); do
        cmd+="../"
    done
    eval "$cmd"
}

prompt='%B%n%b%B@%b%B%m%b%B:%b%B%(5~|%-1~/…/%3~|%4~)%b$(git_branch_name)$ '

source $HOME/.profile
source $ZDOTDIR/.zsh_aliases

zstyle ':zim:zmodule' use 'degit'
zstyle ':zim:completion' dumpfile "${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump"
zstyle ':completion::complete:*' cache-path "${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompcache"
ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
zmodload -F zsh/terminfo +p:terminfo
source ${ZIM_HOME}/init.zsh

source ${ZDOTDIR:-${HOME}}/tv_stuff

. "$HOME/.local/share/../bin/env"
