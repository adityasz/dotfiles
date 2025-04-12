if ! [[ "$PATH" =~ $HOME/.local/bin: ]]; then
	PATH="$HOME/.local/bin:$PATH"
fi

export PATH="$PATH:/usr/local/cuda/bin"
export PATH="$PATH:$CARGO_HOME/bin"
export PATH="$PATH:$MODULAR_HOME/bin"
export PATH="$PATH:$XDG_DATA_HOME/JetBrains/Toolbox/scripts"

export CDPATH="$HOME/IITB/year-3/spring"
export EDITOR="nvim"
export VISUAL="nvim"
export PROMPT_DIRTRIM=3

if command -v secret-tool &> /dev/null; then
	export OPENAI_API_KEY=$(secret-tool lookup key openai_api_key)
	export ANTHROPIC_API_KEY=$(secret-tool lookup api_key anthropic_api_key)
	export GEMINI_API_KEY=$(secret-tool lookup key gemini_api_key)
	export GOOGLE_AI_API_KEY=$GEMINI_API_KEY
	export HF_TOKEN=$(secret-tool lookup access_token hugging_face_access_token)
	export IITB_INTERNET_TOKEN=$(secret-tool lookup token iitb_internet_token)
fi

export GPG_TTY=$(tty)

if [[ -f ~/.config/environment.d/all.conf ]]; then
	while IFS= read -r line; do
		if [[ ! $line =~ ^[[:space:]]*# && -n $line ]]; then
			eval "export $line"
		fi
	done < ~/.config/environment.d/all.conf
fi
