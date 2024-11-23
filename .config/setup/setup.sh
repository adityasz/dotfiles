#!/bin/bash

XDG_DATA_HOME="$HOME/.local/share"
XDG_CONFIG_HOME="$HOME/.config"
XDG_STATE_HOME="$HOME/.local/state"
XDG_CACHE_HOME="$HOME/.cache"

SYSRQ_CONF="/etc/sysctl.d/90-sysrq.conf"
SYSRQ_PROC="/proc/sys/kernel/sysrq"

DNF_CONF="/etc/dnf/dnf.conf"

LIBINPUT_CONF_DIR="/etc"
LIBINPUT_CONF="libinput.conf"
LIBINPUT_CONFIG_REPO="https://gitlab.com/warningnonpotablewater/libinput-config"

KEYD_CONF_DIR="/etc/keyd"
KEYD_CONF="default.conf"
KEYD_REPO="https://github.com/rvaiya/keyd"

NEOVIM_RELEASE="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
NEOVIM_INSTALL_DIR="/opt/nvim"

GNOME_SETTINGS_DIR="$HOME/.config/gnome-settings"


check_root() {
	if [ "$EUID" -eq 0 ]; then
		echo "Do not run this sript as root."
		exit 1
	fi
}


enable_sysrq() {
	if ! grep -qE "^kernel.sysrq = 1$" "$SYSRQ_CONF"; then
		echo "1" > "$SYSRQ_PROC"
		echo "kernel.sysrq = 1" >> "$SYSRQ_CONF"
		echo "Enabled sysrq"
	else
		echo "sysrq already enabled"
	fi
}

enable_dmesg() {
	# if ! grep -qE "^"
	echo "Make this work!"
}


disable_nm_wait_online() {
	systemctl disable NetworkManager-wait-online.service
	echo "Disabled NetworkManager-wait-online.service"
}


configure_dnf() {
	if ! grep -qE "^fastestmirror=True$" "$DNF_CONF"; then
		echo "fastestmirror=True" >> "$DNF_CONF"
		echo "DNF will now use the fastest mirror"
	else
		echo "DNF already using fastest mirror"
	fi

	if ! grep -qE "max_parallel_downloads" "$DNF_CONF"; then
		echo "max_parallel_downloads=20" >> "$DNF_CONF"
		echo "DNF max_parallel_downloads is now 20"
	else
		echo "DNF max_parallel_downloads already set to some value"
		echo "Bash/sed skill issue; can't change that value :-("
	fi
}


set_bluetooth_alias() {
	read -p "Enter the desired Bluetooth system alias: " bt_alias
	bluetoothctl system-alias "${bt_alias}"
	echo "Bluetooth alias is now '${bt_alias}'"
}


setup_hotspot_autoconnect() {
	read -p "Do you want to set up Hotspot to autoconnect on startup? (yes/no): " setup_hotspot
	if [[ "${setup_hotspot,,}" =~ ^(y|yes)$ ]]; then
		nmcli con modify Hotspot connection.autoconnect true
		echo "Hotspot will now turn on when the machine turns on"
	else
		echo "Hotspot autoconnect setup skipped"
	fi
}


install_packages() {
	dnf install -y @development-tools python3-pip fd-find sd procs eza zsh kitty ranger cargo gdk-pixbuf2-devel pango-devel graphene-devel cairo-gobject-devel cairo-devel python2-cairo-devel gtk4-devel meson ninja-build libinput-devel systemd-devel clang clang-tools-extra
	dnf install -y jetbrains-mono-fonts-all rsms-inter-{,vf-}fonts
}


copy_config_files() {
    cat << 'EOF' >> "/etc/zshenv"
export XDG_DATA_HOME="\$HOME/.local/share"
export XDG_CONFIG_HOME="\$HOME/.config"
export XDG_STATE_HOME="\$HOME/.local/state"
export XDG_CACHE_HOME="\$HOME/.cache"
export ZDOTDIR="\$XDG_CONFIG_HOME/zsh"
EOF
	cp $LIBINPUT_CONF $LIBINPUT_CONF_DIR
	mkdir -p "$KEYD_CONF_DIR" && cp "keyd/$KEYD_CONF" "$KEYD_CONF_DIR"
}


install_keyd() {
	cd /tmp
	git clone "$KEYD_REPO"
	cd keyd
	make && sudo make install
	sudo systemctl enable keyd && sudo systemctl start keyd
}


install_libinput_config() {
	cd /tmp
	git clone "$LIBINPUT_CONFIG_REPO"
	cd libinput-config
	meson build
	cd build
	ninja
	sudo ninja install
}


install_neovim() {
	cd /tmp
	curl -LO "$NEOVIM_RELEASE"
	rm -rf "$NEOVIM_INSTALL_DIR"
	tar -C /opt -xzf nvim-linux64.tar.gz
	dnf install -y python3-neovim
}


user_installs() {
	pip install numpy matplotlib pyyaml colorama python-box pyright
	cargo install ripdrag csvlens monolith texlab tinymist typst
}


create_hist_files() {
	mkdir -p "$XDG_STATE_HOME/python"
	mkdir -p "$XDG_STATE_HOME/zsh"
	touch "$XDG_STATE_HOME/zsh/history"
	touch "$XDG_STATE_HOME/python/python_history"
}


load_gnome_settings() {
	for file in "$GNOME_SETTINGS_DIR"/*
	do
		dconf load / < $GNOME_SETTINGS_DIR/$file
	done
}


install_gnome_extensions() {
	pip install gnome-extensions-cli
	extensions=(
		"appindicatorsupport@rgcjonas.gmail.com"
		"places-menu@gnome-shell-extensions.gcampax.github.com"
		"Battery-Health-Charging@maniacx.github.com"
		"battery-indicator-icon@Deminder"
		"blur-my-shell@aunetx"
		"caffeine@patapon.info"
		"clipboard-indicator@tudmotu.com"
		"drive-menu@gnome-shell-extensions.gcampax.github.com"
		"gnome-ui-tune@itstime.tech"
		"gsconnect@andyholmes.github.io"
		"just-perfection-desktop@just-perfection"
		"middleclickclose@paolo.tranquilli.gmail.com"
		"rounded-window-corners@fxgn"
		"search-light@icedman.github.com"
		"smile-extension@mijorus.it"
		"tiling-assistant@leleat-on-github"
		"user-theme@gnome-shell-extensions.gcampax.github.com"
		"vim-altTab@kokong.info"
		"windowsNavigator@gnome-shell-extensions.gcampax.github.com"
	)
	for extension in "${extensions[@]}"
	do
		gext install "${extension//$/\\$}"
	done
}


run_root_stuff() {
	trap SIGINT
	check_root

	sudo bash << EOF
$(declare -f confirm_continuation)
$(declare -f enable_sysrq)
$(declare -f disable_nm_wait_online)
$(declare -f configure_dnf)
$(declare -f set_bluetooth_alias)
$(declare -f setup_hotspot_autoconnect)
$(declare -f copy_config_files)
$(declare -f install_packages)
$(declare -f install_keyd)
$(declare -f install_libinput_config)
$(declare -f install_neovim)
EOF
}

run_other_stuff() {
	user_installs
	load_gnome_settings
	install_gnome_extensions
}


show_help() {
	echo "Usage: $0 [FUNCTION]"
	echo "If no function is specified, all functions will be executed."
	echo ""
	echo "Available functions:"
	echo "  enable_sysrq"
	echo "  disable_nm_wait_online"
	echo "  configure_dnf"
	echo "  set_bluetooth_alias"
	echo "  setup_hotspot_autoconnect"
	echo "  copy_config_files"
	echo "  install_packages"
	echo "  install_keyd"
	echo "  install_libinput_config"
	echo "  install_neovim"
	echo "  load_gnome_settings"
	echo "  install_gnome_extensions"
	echo ""
	echo "Use 'all' to run all functions."
}


main() {
	if [ $# -eq 0 ]; then
		run_all
	else
		case "$1" in
			enable_sysrq|disable_nm_wait_online|configure_dnf|set_bluetooth_alias|setup_hotspot_autoconnect|copy_config_files|setup_dotfiles|install_packages|install_keyd|install_libinput_config|install_neovim|load_gnome_settings|install_gnome_extensions)
				check_root
				$1
				;;
			all)
				run_all
				;;
			--help|-h)
				show_help
				;;
			*)
				echo "Invalid function name. Use 'help' to see available functions."
				exit 1
				;;
		esac
	fi
}


main "$@"
