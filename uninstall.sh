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

# Checking Internet access
if ping -c 1 8.8.8.8 &>/dev/null || ping -c 1 1.1.1.1 &>/dev/null || ping -c 1 208.67.222.222 &>/dev/null || ping -c 1 9.9.9.9 &>/dev/null || ping -c 1 94.140.14.14 &>/dev/null || ping -c 1 8.26.56.26 &>/dev/null; then
    echo 1 > /dev/null
else
    red_msg "No Internet connection! Please connect to the Internet and run the script again."
    exit 1
fi

# Checking access to Valve's server
if curl --speed-limit 3 --speed-time 2 --max-time 30 https://steamdeck-packages.steamos.cloud/archlinux-mirror/core-main/os/x86_64/sed-4.9-3-x86_64.pkg.tar.zst --output /dev/null &>/dev/null; then
    echo 1 > /dev/null
else
    red_msg "No connection to Valve server! Your ISP has probably blocked Valve's servers. Try connecting to another network or using a VPN (or other blocking methods)."
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
DEVELOPER: @biddbb
TG GROUP: @steamdeckoverclock
"
if [[ "$MODEL" != "Jupiter" && "$MODEL" != "Galileo" ]]; then
    exit 1
fi
red_msg "Uninstalling..."
sudo steamos-readonly disable
sudo systemctl disable sshd
# Pacman
sudo rm -rf /home/.steamos/offload/var/cache/pacman/pkg/{*,.*}
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate
if ! sudo pacman -Sy; then
    exit 1
fi
if ! sudo pacman -S --noconfirm sed; then
    exit 1
fi

# Yet-tweak
sudo rm -f /etc/tmpfiles.d/mglru.conf
sudo rm -f /etc/security/limits.d/memlock.conf
sudo sed -i -e 's/,noatime//' /etc/fstab
sudo sed -i -e 's/usbhid.jspoll=1 //' /etc/default/grub
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg
sudo systemctl unmask steamos-cfs-debugfs-tunings.service
sudo systemctl unmask gpu-trace.service
sudo systemctl unmask steamos-log-submitter.service
sudo systemctl unmask cups.service
sudo systemctl unmask gamemoded.service
sudo systemctl unmask avahi-daemon.service
sudo systemctl unmask avahi-daemon.socket
sudo cp -f $HOME/install_backup/50-coredump.conf /usr/lib/sysctl.d/50-coredump.conf
sudo cp -f $HOME/install_backup/20-sched.conf /usr/lib/sysctl.d/20-sched.conf
sudo cp -f $HOME/install_backup/60-crash-hook.conf /usr/lib/sysctl.d/60-crash-hook.conf

# Daemon uninstall
sudo systemctl disable ananicy-cpp
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git
sudo rm -rf /etc/ananicy.d/{*,.*}

# Tweaks disable
sudo systemctl disable tweak
sudo rm -f $HOME/.local/tweak/SDWEAK.sh
sudo rm -f /etc/systemd/system/tweak.service
sudo rm -rf $HOME/.local/tweak/
sudo rm -f /etc/udev/rules.d/60-ioschedulers.rules

sudo rm -f /usr/lib/systemd/zram-generator.conf
sudo pacman -Rdd --noconfirm holo-zram-swap zram-generator
sudo pacman -S --noconfirm --needed holo-zram-swap zram-generator
sudo systemctl restart systemd-zram-setup@zram0
# THP
sudo rm -f /usr/lib/tmpfiles.d/thp-shrinker.conf
sudo rm -f /usr/lib/tmpfiles.d/thp.conf

sudo sed -i "s/ENABLE_GAMESCOPE_WSI=0/ENABLE_GAMESCOPE_WSI=1/g" /usr/{bin/gamescope-session,lib/steamos/gamescope-session}
sudo pacman -S --noconfirm --needed vulkan-radeon lib32-vulkan-radeon

sudo sed -z -i "s/58, 59,\n        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,\n        70/58, 59,\n        60/g" /usr/share/gamescope/scripts/00-gamescope/displays/valve.steamdeck.lcd.lua

if sudo sed -i -E '/^GRUB_CMDLINE_LINUX_DEFAULT=/ {
    s/(amd_pstate=)[^ "]*//g
    s/  +/ /g
    s/(GRUB_CMDLINE_LINUX_DEFAULT=") /\1/
    s/ (")/\1/}' /etc/default/grub
then
    sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
fi
sudo systemctl disable --now energy.timer
sudo rm -f /etc/systemd/system/energy.service
sudo rm -f /etc/systemd/system/energy.timer

if { [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    sudo pacman -S --noconfirm linux-neptune-611 linux-neptune-611-headers
fi

params=("gpu_sched.sched_policy=0" "amdgpu.mes=1" "amdgpu.moverate=128" "amdgpu.uni_mes=1" "amdgpu.lbpw=0" "amdgpu.mes_kiq=1")

for param in "${params[@]}"; do
    if grep -q "$param" /etc/default/grub &>/dev/null; then
        sudo sed -i "s/\b$param\b//g" /etc/default/grub &>/dev/null
    else
        echo 1 > /dev/null
    fi
done
sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
sudo systemctl daemon-reload
