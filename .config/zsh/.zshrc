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

fpath+=(
    "${ZDOTDIR}"/completions
    "${ZDOTDIR}"/functions
)
autoload -Uz compinit vcs_info $ZDOTDIR/functions/*(:t)

function precmd() {
    print -Pn "\e]0;%~\a" # set the terminal window title to the current working directory path
    vcs_info
}

# Type `.. 3` in place of `cd ../../../` and so on.
function ..() {
    cd -- "$(repeat ${1:-1} printf '../')"
}

# TODO: Check if this speeds things up or not.
# TODO: Move compilation dump to `$XDG_CACHE_HOME/zsh`.
# Credits: https://news.ycombinator.com/user?id=bongobingo1
# https://news.ycombinator.com/item?id=40128826
compinit
{
    # Compile the completion dump to increase startup speed. Run in background.
    zcompdump="$ZDOTDIR/.zcompdump"
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        # if zcompdump file exists, and we don't have a compiled version or the
        # dump file is newer than the compiled file
        zcompile "$zcompdump"
    fi
} &!

# TODO: Are these two lines needed?
# Configure the completion system to cache parsed completion scripts.
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "$ZDOTDIR/.zcompdump"

zstyle ':vcs_info:git:*' formats ' (%b)'

prompt='%B%n%b%B@%b%B%m%b%B:%b%B%(5~|%-1~/…/%3~|%4~)%b${vcs_info_msg_0_}$ '

# This can be uncommented when `~/.config/environment.d/all.conf` is changed
# (environment variables modified).
# if [[ -f ~/.config/environment.d/all.conf ]]; then
# 	while IFS= read -r line; do
# 		if [[ ! $line =~ ^[[:space:]]*# && -n $line ]]; then
# 			eval "export $line"
# 		fi
# 	done < ~/.config/environment.d/all.conf
# fi

if ! [[ "$PATH" =~ $HOME/.local/bin: ]]; then
	PATH="$HOME/.local/bin:$PATH"
fi

export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:$BUN_INSTALL/bin"
export PATH="$PATH:$CARGO_HOME/bin"
export PATH="$PATH:$XDG_DATA_HOME/JetBrains/Toolbox/scripts"

export CDPATH="$HOME/IITB/year-4/autumn"
export EDITOR="nvim"
export VISUAL="nvim"
export PROMPT_DIRTRIM=3

export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GPG_TTY=$(tty)

# TODO: Check if zsh follows symlinks when checking if `.zwc` is newer.
# NOTE: Startup time is low enough that it probably does not matter. Seeing how
#       zsh works is not worth it. zsh is not micro-optimized. .zshrc should
#       also not be micro-optimized: zsh does not deserve it.
source $ZDOTDIR/.zsh_aliases
source $ZDOTDIR/plugins/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-vi-mode.zsh
