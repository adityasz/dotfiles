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
zstyle :compinstall filename '/home/aditya/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

PROMPT="%B%n%b%B@%b%B%m%b%B:%b%B%(5~|%-1~/…/%3~|%4~)$%b "

vman() {
    # export MANPAGER="col -b" # for macOS
    eval 'man $@ | vim -c "set nonu" -MR +"set filetype=man" -'
    unset MANPAGER
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

fpath+=~/.zfunc
autoload -Uz compinit && compinit

typeset -a ANTIGEN_CHECK_FILES=(${ZDOTDIR:-~}/.zshrc ${ZDOTDIR:-~}/antigen.zsh)

source $HOME/.profile
source $ZDOTDIR/.zsh_aliases
source $ZDOTDIR/antigen.zsh

antigen bundle jeffreytse/zsh-vi-mode
antigen apply
