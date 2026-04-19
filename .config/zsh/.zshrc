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

function zvm_after_init() {
    bindkey -M viins "^K" clear-screen
    bindkey -M vicmd "^K" clear-screen
}

fpath+=(
    "${ZDOTDIR}"/completions
    "${ZDOTDIR}"/functions
)
autoload -Uz compinit
autoload -Uz vcs_info
autoload -Uz "${ZDOTDIR}"/functions/*(:t)

function precmd() {
    # Set the terminal window title to the current working directory path
    print -Pn "\e]0;%~\a"
    vcs_info
}

# The escape code has to be emitted in preexec and not precmd; don't care about why
# Credits: https://tanutaran.medium.com/tmux-jump-between-prompt-output-with-osc-133-shell-integration-standard-84241b2defb5
function preexec() {
    if [[ -n "$TMUX" ]]; then
        echo -n "\\x1b]133;A\\x1b\\"
    fi
    # kitty has its own code at the end. Don't care if they work together or
    # not; I anyways wouldn't use tmux in kitty.
}

# Type `.. 3` in place of `cd ../../../` and so on.
function ..() {
    cd -- "$(repeat ${1:-1} printf '../')"
}

zcompdump="${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}/.zcompdump-${USER:-$(id -un)}-${ZSH_VERSION}"
compinit -d "$zcompdump"
{
    # Compile the completion dump to increase startup speed. Run in background.
    if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
        # If zcompdump file exists, and we don't have a compiled version or the
        # dump file is newer than the compiled file
        zcompile "$zcompdump"
    fi
} &!

# Credits: https://thevaluable.dev/zsh-completion-guide-examples/
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$zcompdump"
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zstyle ':vcs_info:git:*' formats ' (%b)'
prompt='%B%n@%m:%(5~|%-1~/…/%3~|%4~)%b${vcs_info_msg_0_}$ '

if [[ -o login && -f ~/.config/environment.d/all.conf ]]; then
    while IFS= read -r line; do
        if [[ ! $line =~ ^[[:space:]]*# && -n $line ]]; then
            eval "export $line"
        fi
    done < ~/.config/environment.d/all.conf
fi

if ! [[ "$PATH" =~ $HOME/.local/bin: ]]; then
    PATH="$HOME/.local/bin:$PATH"
fi

export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:$BUN_INSTALL/bin"
export PATH="$PATH:$CARGO_HOME/bin"
export PATH="$PATH:$XDG_DATA_HOME/JetBrains/Toolbox/scripts"

export CDPATH="$HOME/IITB/year-4/spring"
export EDITOR="nvim"
export VISUAL="nvim"
export PROMPT_DIRTRIM=3

export FZF_DEFAULT_COMMAND='fd --type file'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export GPG_TTY=$(tty)

source $ZDOTDIR/.zsh_aliases

zsh_plugin_dir=/usr/share/zsh/plugins
for f in "${zsh_plugin_dir}"/**/*.plugin.zsh(N); do
    source "$f"
done
source "${zsh_plugin_dir}/zsh-history-substring-search/zsh-history-substring-search.zsh"

autoload -Uz edit-command-line
zle -N edit-command-line
function kitty_scrollback_edit_command_line() {
    local VISUAL="$XDG_DATA_HOME/nvim/lazy/kitty-scrollback.nvim/scripts/edit_command_line.sh"
    zle edit-command-line
    zle kill-whole-line
}
zle -N kitty_scrollback_edit_command_line
bindkey '^xi' kitty_scrollback_edit_command_line

if [[ -n "$SSH_CLIENT" && "$TERM" == "xterm-kitty" ]]; then
    export KITTY_INSTALLATION_DIR=/usr/lib/kitty
fi
if test -n "$KITTY_INSTALLATION_DIR"; then
    export KITTY_SHELL_INTEGRATION="enabled"
    autoload -Uz -- "$KITTY_INSTALLATION_DIR"/shell-integration/zsh/kitty-integration
    kitty-integration
    unfunction kitty-integration
fi
