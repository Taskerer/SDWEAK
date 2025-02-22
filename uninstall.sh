#!/bin/bash

# Function for color message output
green_msg() {
    tput setaf 14
    echo "[*] --- $1"
    tput sgr0
}
red_msg() {
    tput setaf 3
    echo "[*] --- $1"
    tput sgr0
}
logo() {
    tput setaf 11
    echo "$1"
    tput sgr0
}


# check root
if [ "$(id -u)" != "0" ]
then
    red_msg "This script must be run as root."
    exit 1
fi

# Checking Internet connection
if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
    echo 1 > /dev/null
else
    red_msg "No Internet!"
    exit 1
fi

clear
steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
MODEL=$(cat /sys/class/dmi/id/board_name)
BIOS_VERSION=$(cat /sys/class/dmi/id/bios_version)
logo "

>>====================================================<<
|| ███████╗██████╗ ██╗    ██╗███████╗ █████╗ ██╗  ██╗ ||
|| ██╔════╝██╔══██╗██║    ██║██╔════╝██╔══██╗██║ ██╔╝ ||
|| ███████╗██║  ██║██║ █╗ ██║█████╗  ███████║█████╔╝  ||
|| ╚════██║██║  ██║██║███╗██║██╔══╝  ██╔══██║██╔═██╗  ||
|| ███████║██████╔╝╚███╔███╔╝███████╗██║  ██║██║  ██╗ ||
|| ╚══════╝╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ||
>>====================================================<<
TG: @biddbb
TG GROUP: @steamdeckoverclock
DONAT: https://www.tinkoff.ru/cf/8HHVDNi8VMS
"
if [[ "$MODEL" != "Jupiter" && "$MODEL" != "Galileo" ]]; then
    exit 1
fi
red_msg "Uninstalling..."
sudo steamos-readonly disable
# ssh
sudo systemctl disable sshd
# pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman -Sy

# yet-tweak
sudo rm /etc/tmpfiles.d/mglru.conf
sudo rm /etc/security/limits.d/memlock.conf
sudo systemctl unmask systemd-coredump.socket
sudo systemctl unmask kdumpst-init.service
sudo systemctl unmask steamos-kdumpst-layer.service
sudo systemctl unmask steamos-dump-info.service
sudo systemctl unmask steamos-cfs-debugfs-tunings.service
sudo systemctl unmask gpu-trace.service
sudo systemctl unmask steamos-log-submitter.service
sudo systemctl unmask steamos-devkit-service.service
sudo systemctl unmask cups.service
sudo systemctl unmask firewalld.service

sudo systemctl start systemd-coredump.socket
sudo systemctl start kdumpst-init.service
sudo systemctl start steamos-kdumpst-layer.service
sudo systemctl start steamos-dump-info.service
sudo systemctl start steamos-cfs-debugfs-tunings.service
sudo systemctl start gpu-trace.service
sudo systemctl start steamos-log-submitter.service
sudo systemctl start steamos-devkit-service.service
sudo systemctl start cups.service
sudo systemctl start firewalld.service

# daemon install
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git irqbalance

# tweaks enable
sudo systemctl disable --now tweak
sudo rm /home/deck/.local/tweak/SDWEAK.sh
sudo rm /home/deck/.local/tweak/SDOC-TWEAKS.sh
sudo rm /etc/systemd/system/tweak.service
sudo rm -r /home/deck/.local/tweak/

sudo pacman -S --noconfirm holo-zram-swap zram-generator

sudo sed -i "s/ENABLE_GAMESCOPE_WSI=0/ENABLE_GAMESCOPE_WSI=1/g" /usr/bin/gamescope-session

sudo sed -z -i "s/58, 59,\n        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,\n        70/58, 59,\n        60/g" /usr/share/gamescope/scripts/00-gamescope/displays/valve.steamdeck.lcd.lua

sudo sed -i 's/\bGRUB_CMDLINE_LINUX_DEFAULT="\b/&amd_pstate=disable /' /etc/default/grub
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg
sudo systemctl disable --now energy.timer
sudo rm /etc/systemd/system/energy.service
sudo rm /etc/systemd/system/energy.timer


if [ $steamos_version = 3.7 ]
then
    sudo pacman -S --noconfirm linux-neptune-68
fi
if [ $steamos_version = 3.6 ]
then
    sudo pacman -S --noconfirm linux-neptune-65
    sudo pacman -R --noconfirm linux-neptune-68
fi
if [ $steamos_version = 3.8 ]
then
    sudo pacman -S --noconfirm linux-neptune-611
    sudo pacman -R --noconfirm linux-neptune-68
fi
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
# vulkan
sudo pacman -S --noconfirm vulkan-radeon lib32-vulkan-radeon
sudo systemctl daemon-reload
