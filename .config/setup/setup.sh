#!/bin/bash

USERNAME="aditya"
SYSRQ_CONF="/etc/sysctl.d/90-sysrq.conf"
SYSRQ_PROC="/proc/sys/kernel/sysrq"
DNF_CONF="/etc/dnf/dnf.conf"
DOTFILES_GIT="$HOME/.dotfiles"
DOTFILES_TEMP="tmpdotfiles"
LIBINPUT_CONF_DIR="/etc"
LIBINPUT_CONF="libinput.conf"
KEYD_CONF_DIR="/etc/keyd"
KEYD_CONF="default.conf"
KEYD_REPO="https://github.com/rvaiya/keyd"
LIBINPUT_CONFIG_REPO="https://gitlab.com/warningnonpotablewater/libinput-config"
NEOVIM_RELEASE="https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz"
NEOVIM_INSTALL_DIR="/opt/nvim"
GNOME_SETTINGS_DIR="$HOME/.config/gnome-settings"

check_root() {
    if [ "$EUID" -ne 0 ]; then
	# TODO: there are better ways to handle this
        echo "This script requires root privileges. sudo su in this directory."
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
        echo "Bash skill issue; can't change that value :-("
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
    dnf install -y @development-tools python3-pip fd-find zsh kitty ranger cargo gdk-pixbuf2-devel pango-devel graphene-devel cairo-gobject-devel cairo-devel python2-cairo-devel gtk4-devel meson ninja-build libinput-devel systemd-devel
    dnf install -y jetbrains-mono-fonts-all rsms-inter-{,vf-}fonts
    cargo install ripdrag csvlens
}

# Do this manually before starting the script (clone over SSH instead)
# setup_dotfiles() {
#     git clone --separate-git-dir="$DOTFILES_GIT" https://github.com/adityasz/.dotfiles.git "$DOTFILES_TEMP"
#     rsync --recursive --verbose --exclude '.git' "$DOTFILES_TEMP/" "$HOME/"
#     rm -r "$DOTFILES_TEMP"
# }

copy_config_files() {
    cp zshenv /etc/zshenv
    cp $LIBINPUT_CONF $LIBINPUT_CONF_DIR
    mkdir -p "$KEYD_CONF_DIR" && cp "keyd/$KEYD_CONF" "$KEYD_CONF_DIR"
    echo -e "\nCopied keyd and libinput configs"
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

# create_hist_files() {
#     # for idiotic software that doesn't create them
#     # python history file
#     # zsh history file
# }

load_gnome_settings() {
	for file in {application-settings,extensions,keybindings,shell-settings};
		do dconf load / < "$GNOME_SETTINGS_DIR"/$file.ini;
	done;
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
    for extension in "${extensions[@]}"; do
        gext install "${extension//$/\\$}"
    done
}

run_all() {
    trap SIGINT
    check_root
    confirm_continuation
    enable_sysrq
    disable_nm_wait_online
    configure_dnf
    set_bluetooth_alias
    setup_hotspot_autoconnect
    copy_config_files
    # setup_dotfiles
    install_packages
    install_keyd
    install_libinput_config
    install_neovim
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
    # echo "  setup_dotfiles"
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
