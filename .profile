if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]] then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi

export TERM='xterm-kitty'
export EDITOR='/opt/nvim-linux64/bin/nvim'
export VISUAL='/opt/nvim-linux64/bin/nvim'
export PROMPT_DIRTRIM=3

export OPENAI_API_KEY=$(secret-tool lookup key openai_api_key)
export ANTHROPIC_API_KEY=$(secret-tool lookup api_key anthropic_api_key)
export HF_TOKEN=$(secret-tool lookup access_token hugging_face_access_token)
export IITB_INTERNET_TOKEN=$(secret-tool lookup token iitb_internet_token)

if [[ -f ~/.config/environment.d/all.conf ]]; then
    while IFS= read -r line; do
        if [[ ! $line =~ ^[[:space:]]*# && -n $line ]]; then
            eval "export $line"
        fi
    done < ~/.config/environment.d/all.conf
fi

export PATH="/usr/local/cuda/bin:/usr/local/sioyek:/opt/nvim-linux64/bin:$CARGO_HOME/bin:$PATH"
