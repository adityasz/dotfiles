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

bluetoothctl system-alias 'Intel AX201'
echo "Bluetooth alias is now 'Intel AX201'"

nmcli con modify Hotspot connection.autoconnect true
echo "Hotspot will now turn on when the machine turns on"

cp libinput.conf /etc/libinput.conf
mkdir -p /etc/keyd && cp keyd/default.conf /etc/keyd/
echo -e "\nCopied keyd and libinput configs"
echo -e "\nInstall libinput-config manually!"

git clone --separate-git-dir=$HOME/.dotfiles https://github.com/adityasz/.dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles

dnf install @development-tools python3-pip fd-find zsh kitty ranger cargo gdk-pixbuf2-devel pango-devel graphene-devel cairo-gobject-devel cairo-devel python2-cairo-devel gtk4-devel -y
cargo install ripdrag csvlens

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
mkdir -p $HOME/.local/bin
mv nvim.appimage $HOME/.local/bin/nvim

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"
