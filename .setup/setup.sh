#!/bin/bash

trap SIGINT

if [ "$EUID" -ne 0 ]; then
    echo "This script requires root privileges."
    exit 1
fi

read -p "Are you sure you want to continue? [y/N] " answer
answer="${answer,,}"
if [[ "$answer" != "y" && "$answer" != "yes" ]]; then
    echo "Aborted."
    exit 0
fi

username=aditya

if ! grep -qE "^kernel.sysrq = 1$" /etc/sysctl.d/90-sysrq.conf; then
	echo "1" > /proc/sys/kernel/sysrq
	echo "kernel.sysrq = 1" >> /etc/sysctl.d/90-sysrq.conf
	echo "Enabled sysrq"
else
	echo "sysrq already enabled"
fi

systemctl disable NetworkManager-wait-online.service
echo "Disabled NetworkManager-wait-online.service"

if ! grep -qE "^fastestmirror=True$" /etc/dnf/dnf.conf; then
	echo "fastestmirror=True" >> /etc/dnf/dnf.conf
	echo "DNF will now use the fastest mirror"
else
	echo "DNF already using fastest mirror"
fi

if ! grep -qE "max_parallel_downloads" /etc/dnf/dnf.conf; then
	echo "max_parallel_downloads=20" >> /etc/dnf/dnf.conf
	echo "DNF max_parallel_downloads is now 20"
else
	echo "DNF max_parallel_downloads already set to some value"
	echo "Bash skill issue; can't change that value :-("
fi

read -p "Enter the desired Bluetooth system alias: " bt_alias
bluetoothctl system-alias "${bt_alias}"
echo "Bluetooth alias is now '${bt_alias}'"

read -p "Do you want to set up Hotspot to autoconnect on startup? (yes/no): " setup_hotspot
if [[ "${setup_hotspot,,}" =~ ^(y|yes)$ ]]; then
    nmcli con modify Hotspot connection.autoconnect true
    echo "Hotspot will now turn on when the machine turns on"
else
    echo "Hotspot autoconnect setup skipped"
fi

cp libinput.conf /etc/libinput.conf
mkdir -p /etc/keyd && cp keyd/default.conf /etc/keyd/
echo -e "\nCopied keyd and libinput configs"

# Dotfiles
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/adityasz/.dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles

# Important packages
dnf install @development-tools python3-pip fd-find zsh kitty ranger cargo gdk-pixbuf2-devel pango-devel graphene-devel cairo-gobject-devel cairo-devel python2-cairo-devel gtk4-devel meson ninja-build libinput-devel systemd-devel -y
dnf install jetbrains-mono-fonts-all rsms-inter-{,vf-}fonts
cargo install ripdrag csvlens

# Keyd
cd /tmp
git clone https://github.com/rvaiya/keyd
cd keyd
make && sudo make install
sudo systemctl enable keyd && sudo systemctl start keyd

# libinput-config
cd /tmp
git clone https://gitlab.com/warningnonpotablewater/libinput-config
cd libinput-config
meson build
cd build
ninja
sudo ninja install

# Neovim
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
rm -rf /opt/nvim
tar -C /opt -xzf nvim-linux64.tar.gz
dnf install -y python3-neovim

# GNOME Settings
dconf load / < $HOME/.config/gnome-settings/{application-settings,extensions,keybindings,shell-settings}.ini

# GNOME Extensions
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
    gext install "$extension"
done
