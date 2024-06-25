#!/bin/bash
# Copyright (c) 2023 Aditya Singh <1adityasingh@proton.me>

# if grep -q "^\" set background=light" ~/.vimrc; then # dark mode -> light mode
if [ "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'prefer-dark'" ]; then
	# GNOME dark mode -> light mode
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
	gsettings set org.gnome.desktop.interface cursor-theme 'custom'

	# Vim
	sed -i 's/^" set background=light/set background=light/' ~/.vimrc
	sed -i 's/^" colorscheme onehalflight/colorscheme onehalflight/' ~/.vimrc
	sed -i 's/^set background=dark/" set background=dark/' ~/.vimrc
	sed -i 's/^colorscheme onehalfdark/" colorscheme onehalfdark/' ~/.vimrc

	# Sioyek
	sed -i 's/^default_dark_mode 1/default_dark_mode 0/' ~/.config/sioyek/prefs_user.config
	sed -i 's/^background_color 0.14 0.14 0.14/background_color 0.5 0.5 0.5/' ~/.config/sioyek/prefs_user.config
	sed -i 's/^page_separator_color 0.14 0.14 0.14/page_separator_color 0.5 0.5 0.5/' ~/.config/sioyek/prefs_user.config

	# Bat
	sed -i 's/^--theme="OneHalfDark"/# --theme="OneHalfDark"/' ~/.config/bat/config
	sed -i 's/^# --theme="OneHalfLight"/--theme="OneHalfLight"/' ~/.config/bat/config

	# Obsidian
	sed -i 's/obsidian/moonstone/' ~/Obsidian/.obsidian/appearance.json

	# Extensions
	dconf write /org/gnome/shell/extensions/search-light/background-color "(1.0, 1.0, 1.0, 1.0)"
	dconf write /org/gnome/shell/extensions/search-light/border-color "(0.73333334922790527, 0.73333334922790527, 0.73333334922790527, 1.0)"
	dconf write /org/gnome/shell/extensions/blur-my-shell/panel/blur false
	# dconf write /org/gnome/shell/extensions/blur-my-shell/overview/blur false
	# dconf write /org/gnome/shell/extensions/blur-my-shell/panel/color "(1.0, 1.0, 1.0, 0.5)"
	# dconf write /org/gnome/shell/extensions/blur-my-shell/panel/brightness 1
	# dconf write /org/gnome/shell/extensions/dash-to-dock/custom-background-color true
	# gnome-extensions disable blur-my-shell@aunetx
	# gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com

	# Tilix
	dconf write /com/gexperts/Tilix/profiles/default "'2b7c4080-0ddd-46c5-8f23-563fd3ba789d'"
	dconf write /com/gexperts/Tilix/theme-variant "'light'"
else
	# GNOME light mode -> dark mode
	gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
	gsettings set org.gnome.desktop.interface cursor-theme 'custom-white'

	# Vim
	sed -i 's/^set background=light/" set background=light/' ~/.vimrc
	sed -i 's/^colorscheme onehalflight/" colorscheme onehalflight/' ~/.vimrc
	sed -i 's/^" set background=dark/set background=dark/' ~/.vimrc
	sed -i 's/^" colorscheme onehalfdark/colorscheme onehalfdark/' ~/.vimrc

	# Sioyek
	sed -i 's/^default_dark_mode 0/default_dark_mode 1/' ~/.config/sioyek/prefs_user.config
	sed -i 's/^background_color 0.5 0.5 0.5/background_color 0.14 0.14 0.14/' ~/.config/sioyek/prefs_user.config
	sed -i 's/^page_separator_color 0.5 0.5 0.5/page_separator_color 0.14 0.14 0.14/' ~/.config/sioyek/prefs_user.config

	# Bat
	sed -i 's/^# --theme="OneHalfDark"/--theme="OneHalfDark"/' ~/.config/bat/config
	sed -i 's/^--theme="OneHalfLight"/# --theme="OneHalfLight"/' ~/.config/bat/config

	# Obsidian
	sed -i 's/moonstone/obsidian/' ~/Obsidian/.obsidian/appearance.json

	# Extensions
	dconf write /org/gnome/shell/extensions/search-light/background-color "(0.0, 0.0, 0.0, 1.0)"
	dconf write /org/gnome/shell/extensions/search-light/border-color "(0.18823529779911041, 0.18823529779911041, 0.18823529779911041, 1.0)"
	dconf write /org/gnome/shell/extensions/blur-my-shell/panel/blur true
	dconf write /org/gnome/shell/extensions/blur-my-shell/panel/color "(0.0, 0.0, 0.0, 0.5)"
	dconf write /org/gnome/shell/extensions/blur-my-shell/panel/brightness 0.75
	dconf write /org/gnome/shell/extensions/blur-my-shell/panel/brightness 0.75
	# dconf write /org/gnome/shell/extensions/dash-to-dock/custom-background-color false
	# gnome-extensions enable blur-my-shell@aunetx
	# gnome-extensions disable user-theme@gnome-shell-extensions.gcampax.github.com

	# Tilix
	dconf write /com/gexperts/Tilix/profiles/default "'e3f8efc1-aae2-43c4-8bde-960c392a8ed3'"
	dconf write /com/gexperts/Tilix/theme-variant "'dark'"
fi
