HISTFILE=~/.histfile
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

PROMPT="%B%n%b%B@%b%B%m%b%B:%b%B%(5~|%-1~/…/%3~|%4~)$%b "

vman() {
    # export MANPAGER="col -b" # for macOS
    eval 'man $@ | vim -c "set nonu" -MR +"set filetype=man" -'
    unset MANPAGER
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
# export LD_LIBRARY_PATH=/opt/missing-mojo-deps/lib/x86_64-linux-gnu:/opt/missing-mojo-deps/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

fpath+=~/.zfunc
autoload -Uz compinit && compinit

source $HOME/.env
source $HOME/.zsh/.zsh_aliases
source $HOME/.zsh/antigen.zsh

antigen bundle jeffreytse/zsh-vi-mode
antigen apply
