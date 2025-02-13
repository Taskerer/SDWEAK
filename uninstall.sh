#!/bin/bash

# Checking root access
if [ "$(id -u)" != "0" ]; then
    PASSWORD=$(zenity --password --title="Введите пароль sudo")
    if [ -z "$PASSWORD" ]; then
        zenity --error --text="Пароль не был введен. Скрипт завершен." --title="Ошибка"
        exit 1
    fi
    echo "$PASSWORD" | sudo -S echo "" 2>/dev/null
    if [ $? -ne 0 ]; then
        zenity --error --text="Неверный пароль. Скрипт завершен." --title="Ошибка"
        exit 1
    fi
fi

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
sudo steamos-readonly disable &>/dev/null
# ssh
sudo systemctl disable sshd &>/dev/null
# pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf &>/dev/null
sudo pacman-key --init &>/dev/null
sudo pacman-key --populate &>/dev/null
sudo pacman -Sy &>/dev/null

# yet-tweak
sudo rm /etc/tmpfiles.d/mglru.conf
sudo rm /etc/security/limits.d/memlock.conf
sudo systemctl unmask systemd-coredump.socket &>/dev/null
sudo systemctl unmask kdumpst-init.service &>/dev/null
sudo systemctl unmask steamos-kdumpst-layer.service &>/dev/null
sudo systemctl unmask steamos-dump-info.service &>/dev/null
sudo systemctl unmask steamos-cfs-debugfs-tunings.service &>/dev/null
sudo systemctl unmask gpu-trace.service &>/dev/null
sudo systemctl unmask steamos-log-submitter.service &>/dev/null
sudo systemctl unmask steamos-devkit-service.service &>/dev/null
sudo systemctl unmask cups.service &>/dev/null
sudo systemctl unmask firewalld.service &>/dev/null

sudo systemctl start systemd-coredump.socket &>/dev/null
sudo systemctl start kdumpst-init.service &>/dev/null
sudo systemctl start steamos-kdumpst-layer.service &>/dev/null
sudo systemctl start steamos-dump-info.service &>/dev/null
sudo systemctl start steamos-cfs-debugfs-tunings.service &>/dev/null
sudo systemctl start gpu-trace.service &>/dev/null
sudo systemctl start steamos-log-submitter.service &>/dev/null
sudo systemctl start steamos-devkit-service.service &>/dev/null
sudo systemctl start cups.service &>/dev/null
sudo systemctl start firewalld.service &>/dev/null

# daemon install
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git irqbalance &>/dev/null

# tweaks enable
sudo systemctl disable --now tweak &>/dev/null
sudo rm /home/deck/.local/tweak/SDWEAK.sh &>/dev/null
sudo rm /home/deck/.local/tweak/SDOC-TWEAKS.sh &>/dev/null
sudo rm /etc/systemd/system/tweak.service &>/dev/null
sudo rm -r /home/deck/.local/tweak/

sudo pacman -S --noconfirm holo-zram-swap zram-generator &>/dev/null

sudo sed -i "s/ENABLE_GAMESCOPE_WSI=0/ENABLE_GAMESCOPE_WSI=1/g" /usr/bin/gamescope-session &>/dev/null

sudo sed -z -i "s/58, 59,\n        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,\n        70/58, 59,\n        60/g" /usr/share/gamescope/scripts/00-gamescope/displays/valve.steamdeck.lcd.lua &>/dev/null

sudo sed -i 's/\bGRUB_CMDLINE_LINUX_DEFAULT="\b/&amd_pstate=disable /' /etc/default/grub &>/dev/null
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
sudo systemctl disable --now energy.timer &>/dev/null
sudo rm /etc/systemd/system/energy.service &>/dev/null
sudo rm /etc/systemd/system/energy.timer &>/dev/null


if [ $steamos_version = 3.7 ]
then
    sudo pacman -S --noconfirm linux-neptune-68 &>/dev/null
fi
if [ $steamos_version = 3.6 ]
then
    sudo pacman -S --noconfirm linux-neptune-65 &>/dev/null
    sudo pacman -R --noconfirm linux-neptune-68 &>/dev/null
fi
if [ $steamos_version = 3.8 ]
then
    sudo pacman -S --noconfirm linux-neptune-611 &>/dev/null
    sudo pacman -R --noconfirm linux-neptune-68 &>/dev/null
fi

# vulkan
sudo pacman -S --noconfirm vulkan-radeon lib32-vulkan-radeon &>/dev/null
sudo systemctl daemon-reload &>/dev/null
