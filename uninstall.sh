#!/bin/bash

# Colorized output
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


# Root check
if [ "$(id -u)" != "0" ]
then
    red_msg "This script must be run as root."
    exit 1
fi

# Server ping test
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
sudo systemctl disable sshd
# Pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf
sudo pacman-key --init
sudo pacman-key --populate
sudo pacman -Sy

# Yet-tweak
sudo rm /etc/tmpfiles.d/mglru.conf
sudo rm /etc/security/limits.d/memlock.conf
sudo sed -i -e 's/,noatime//' /etc/fstab
sudo sed -i -e 's/usbhid.jspoll=1 //' /etc/default/grub
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg
sudo systemctl unmask steamos-cfs-debugfs-tunings.service
sudo systemctl unmask gpu-trace.service
sudo systemctl unmask steamos-log-submitter.service
sudo systemctl unmask steamos-devkit-service.service
sudo systemctl unmask cups.service
sudo systemctl unmask firewalld.service
sudo systemctl unmask gamemoded.service
sudo systemctl unmask avahi-daemon.service
sudo systemctl unmask avahi-daemon.socket

sudo systemctl start steamos-cfs-debugfs-tunings.service
sudo systemctl start gpu-trace.service
sudo systemctl start steamos-log-submitter.service
sudo systemctl start steamos-devkit-service.service
sudo systemctl start cups.service
sudo systemctl start firewalld.service
sudo systemctl start gamemoded.service
sudo systemctl start avahi-daemon.service
sudo systemctl start avahi-daemon.socket
cp -f $HOME/install_backup/50-coredump.conf /usr/lib/sysctl.d/50-coredump.conf
cp -f $HOME/install_backup/21-steamos-panic-sysctls.conf /usr/lib/sysctl.d/21-steamos-panic-sysctls.conf
cp -f $HOME/install_backup/20-panic-sysctls.conf /usr/lib/sysctl.d/20-panic-sysctls.conf
cp -f $HOME/install_backup/20-sched.conf /usr/lib/sysctl.d/20-sched.conf
cp -f $HOME/install_backup/60-crash-hook.conf /usr/lib/sysctl.d/60-crash-hook.conf

# Daemon uninstall
sudo systemctl disable ananicy-cpp
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git
sudo rm -rf /etc/ananicy.d/{*,.*}

# Tweaks disable
sudo systemctl disable tweak
sudo rm $HOME/.local/tweak/SDWEAK.sh
sudo rm /etc/systemd/system/tweak.service
sudo rm -r $HOME/.local/tweak/

sudo sed -i "s/ENABLE_GAMESCOPE_WSI=0/ENABLE_GAMESCOPE_WSI=1/g" /usr/{bin/gamescope-session,lib/steamos/gamescope-session/gamescope-session}

sudo sed -z -i "s/58, 59,\n        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,\n        70/58, 59,\n        60/g" /usr/share/gamescope/scripts/00-gamescope/displays/valve.steamdeck.lcd.lua

if sudo sed -i -E '/^GRUB_CMDLINE_LINUX_DEFAULT=/ {
     s/(amd_pstate=)[^ "]*//g
     s/(=")(.*")/\1amd_pstate=disable \2/
     s/  +/ /g
     s/" /"/}' /etc/default/grub
then
    sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
fi
sudo systemctl disable --now energy.timer
sudo rm /etc/systemd/system/energy.service
sudo rm /etc/systemd/system/energy.timer


if [ $steamos_version = 3.7 ]
then
    sudo pacman -S --noconfirm linux-neptune-611
fi
if [ $steamos_version = 3.6 ]
then
    sudo pacman -S --noconfirm linux-neptune-65
    sudo pacman -R --noconfirm linux-neptune-611
fi
if [ $steamos_version = 3.8 ]
then
    sudo pacman -S --noconfirm linux-neptune-611
fi
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
# Vulkan
sudo pacman -S --noconfirm vulkan-radeon lib32-vulkan-radeon
sudo systemctl daemon-reload
