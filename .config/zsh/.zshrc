HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=$HISTSIZE
HISTORY_IGNORE='([bf]g *|..|cd|cd ..|pwd|exit|gpu|cpus|gpu-state|l[ls]|l[ls]#( *)#|clear|nvim|history|history *)'
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
autoload -Uz compinit vcs_info "${ZDOTDIR}"/functions/*(:t)

function precmd() {
    # set the terminal window title to the current working directory path
    print -Pn "\e]0;%~\a"
    vcs_info
}

# the escape code has to be emitted in preexec and not precmd; don't care about why
# Credits: https://tanutaran.medium.com/tmux-jump-between-prompt-output-with-osc-133-shell-integration-standard-84241b2defb5
function preexec() {
    if [[ -n "$TMUX" ]]; then
        echo -n "\\x1b]133;A\\x1b\\"
    fi
    # kitty has its own code at the end. Don't care if they work together or
    # not; there is no need to use a subset of kitty in kitty
}

# Type `.. 3` in place of `cd ../../../` and so on.
function ..() {
    cd -- "$(repeat ${1:-1} printf '../')"
}

# TODO: Check if this speeds things up or not.
# TODO: Move compilation dump to `$XDG_CACHE_HOME/zsh`
#       (does not seem to be as simple as changing the path below)
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
#   while IFS= read -r line; do
#       if [[ ! $line =~ ^[[:space:]]*# && -n $line ]]; then
#           eval "export $line"
#       fi
#   done < ~/.config/environment.d/all.conf
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

source $ZDOTDIR/.zsh_aliases
source $ZDOTDIR/plugins/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-vi-mode.zsh

autoload -Uz edit-command-line
zle -N edit-command-line
function kitty_scrollback_edit_command_line() {
    local VISUAL="$XDG_DATA_HOME/nvim/lazy/kitty-scrollback.nvim/scripts/edit_command_line.sh"
    zle edit-command-line
    zle kill-whole-line
}
zle -N kitty_scrollback_edit_command_line
bindkey '^xi' kitty_scrollback_edit_command_line

if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi
