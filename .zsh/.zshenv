if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]] then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH="/usr/local/cuda/bin:/usr/local/sioyek:$HOME/.modular/pkg/packages.modular.com_max/bin:$PATH"
export TERM='xterm-kitty'
export EDITOR='/bin/vimx'
export VISUAL='/bin/vimx'
export PROMPT_DIRTRIM=3
export MODULAR_HOME="/home/aditya/.modular"
export OPENAI_API_KEY=$(secret-tool lookup key openai_api_key)
export HF_TOKEN=$(secret-tool lookup access_token hugging_face_access_token)

source "$HOME/.cargo/env"
