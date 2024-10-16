export HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE

setopt HIST_IGNORE_SPACE
setopt beep

bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char

unset command_not_found_handle

# The following lines were added by compinstall
autoload -Uz compinit
compinit
# End of lines added by compinstall
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

vman() {
    # export MANPAGER="col -b" # for macOS
    eval 'man $@ | vim -c "set nonu" -MR +"set filetype=man" -'
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

setopt PROMPT_SUBST
prompt='%B%n%b%B@%b%B%m%b%B:%b%B%(5~|%-1~/…/%3~|%4~)%b$(git_branch_name)$ '

fpath+=~/.zfunc
autoload -Uz compinit && compinit

typeset -a ANTIGEN_CHECK_FILES=(${ZDOTDIR:-~}/.zshrc ${ZDOTDIR:-~}/antigen.zsh)

source $HOME/.profile
source $ZDOTDIR/.zsh_aliases
source $ZDOTDIR/antigen.zsh

antigen bundle jeffreytse/zsh-vi-mode
antigen apply

eval "$(magic completion --shell zsh)"
