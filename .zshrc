# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
# End of lines configured by zsh-newuser-install

# The following lines were added by compinstall
zstyle :compinstall filename '/home/aditya/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt beep
bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char
unset command_not_found_handle

export EDITOR='/bin/vimx'
export VISUAL='/bin/vimx'
export PROMPT_DIRTRIM=3

PROMPT="%B%n%b%B@%b%B%m%b%B:%b%B%(5~|%-1~/…/%3~|%4~)$%b "

export OPENAI_API_KEY=$(secret-tool lookup key openai_api_key)

vman() {
    # export MANPAGER="col -b" # for macOS
    eval 'man $@ | vim -c "set nonu" -MR +"set filetype=man" -'
    unset MANPAGER
}

parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

export PATH="$HOME/.cargo/bin/:/usr/local/cuda/bin:/usr/local/sioyek/:$PATH"

source ~/.zsh_aliases
