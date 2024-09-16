if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]] then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export PATH="/usr/local/cuda/bin:/usr/local/sioyek:/opt/nvim-linux64/bin:$HOME/.modular/pkg/packages.modular.com_max/bin:$PATH"
export TERM='xterm-kitty'
export EDITOR='/opt/nvim-linux64/bin/nvim'
export VISUAL='/opt/nvim-linux64/bin/nvim'
export PROMPT_DIRTRIM=3

# TODO: Sort out env mess
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export ANDROID_USER_HOME="$XDG_DATA_HOME/android"
export ADOTDIR="$XDG_DATA_HOME/antigen"
export ASYMPTOTE_HOME="$XDG_CONFIG_HOME/asymptote"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export DOTNET_CLI_HOME="$XDG_DATA_HOME/dotnet"
export GDBHISTFILE="$XDG_CONFIG_HOME/gdb/.gdb_history"
export GEF_RC="$XDG_CONFIG_HOME/gef/.gef.rc"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java -Djavafx.cachedir=$XDG_CACHE_HOME/openjfx"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export JUPYTER_RUNTIME_DIR="$XDG_RUNTIME_DIR/jupyter"
export MATHEMATICA_USERBASE="$XDG_CONFIG_HOME/mathematica"
export MODULAR_HOME="$XDG_DATA_HOME/modular"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/python_history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
export WINEPREFIX="$XDG_DATA_HOME/wine"
export XCURSOR_PATH="/usr/share/icons:$XDG_DATA_HOME/icons"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

export OPENAI_API_KEY=$(secret-tool lookup key openai_api_key)
export ANTHROPIC_API_KEY=$(secret-tool lookup api_key anthropic_api_key)
export HF_TOKEN=$(secret-tool lookup access_token hugging_face_access_token)
export IITB_INTERNET_TOKEN=$(secret-tool lookup token iitb_internet_token)
