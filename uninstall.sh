#!/bin/bash

# Connect a common script with functions and variables
source ./scripts/common.sh

# Root check
check_root
sudo steamos-readonly disable

# Checking Internet access
if ping -c 1 8.8.8.8 &>/dev/null || ping -c 1 1.1.1.1 &>/dev/null || ping -c 1 208.67.222.222 &>/dev/null || ping -c 1 9.9.9.9 &>/dev/null || ping -c 1 94.140.14.14 &>/dev/null || ping -c 1 8.26.56.26 &>/dev/null; then
  echo 1 >/dev/null
else
  red_msg "No Internet connection! Please connect to the Internet and run the script again."
  exit 1
fi

# Checking access to Valve's server
if curl --speed-limit 3 --speed-time 2 --max-time 30 https://steamdeck-packages.steamos.cloud/archlinux-mirror/core-main/os/x86_64/sed-4.9-3-x86_64.pkg.tar.zst --output /dev/null &>/dev/null; then
  echo 1 >/dev/null
else
  red_msg "No connection to Valve server! Your ISP has probably blocked Valve's servers. Try connecting to another network or using a VPN (or other blocking methods)."
  exit 1
fi

clear
# Logo
print_logo

# Compatibility check
if [[ "$MODEL" != "Jupiter" && "$MODEL" != "Galileo" ]]; then
  err_msg "SDWEAK is compatible with Steam Deck only!"
  sleep 5
  exit 1
fi
if [ "$steamos_version" != "3.7" ] && [ "$steamos_version" != "3.8" ]; then
  err_msg "SDWEAK is only compatible with SteamOS 3.7 and higher! Please update your system!"
  sleep 5
  exit 1
fi

red_msg "Uninstalling..."
sudo systemctl disable sshd &>/dev/null

# Pacman
sudo rm -rf /home/.steamos/offload/var/cache/pacman/pkg/{*,.*}
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init
sudo pacman-key --populate
if ! sudo pacman -Sy; then
  err_msg "A serious error has occurred! The system is corrupted, SDWEAK cannot be installed. Try updating the system to the beta version or call for help."
  exit 1
fi
sudo pacman -S --noconfirm sed &>/dev/null
if ! sudo pacman -S --noconfirm sed; then
  err_msg "A serious error has occurred! The system is corrupted, SDWEAK cannot be installed. Try updating the system to the beta version or call for help."
  exit 1
fi

# Yet-tweak
# Restore stock grub
restore_file "$GRUB"
sudo rm -f /etc/tmpfiles.d/mglru.conf
sudo rm -f /etc/security/limits.d/memlock.conf
sudo sed -i -e 's/,noatime//' /etc/fstab
sudo rm -f /etc/modprobe.d/usbhid.conf
services="steamos-cfs-debugfs-tunings.service gpu-trace.service steamos-log-submitter.service cups.service avahi-daemon.socket avahi-daemon.service"
sudo systemctl unmask $services --quiet
restore_file /usr/lib/sysctl.d/50-coredump.conf
restore_file /usr/lib/sysctl.d/20-sched.conf
restore_file /usr/lib/sysctl.d/60-crash-hook.conf
sudo pacman -S --noconfirm --needed gamemode &>/dev/null

# Ananicy-cpp
sudo systemctl disable ananicy-cpp &>/dev/null
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git
sudo rm -rf /etc/ananicy.d/{*,.*}

# Sysctl Tweaks
sudo systemctl disable tweak &>/dev/null
sudo rm -f $HOME/.local/tweak/SDWEAK.sh
sudo rm -f /etc/systemd/system/tweak.service
sudo rm -rf $HOME/.local/tweak/

# I/O schedulers
sudo rm -f /etc/udev/rules.d/60-ioschedulers.rules

# ZRAM Tweaks
sudo rm -f /usr/lib/systemd/zram-generator.conf
sudo pacman -Rdd --noconfirm holo-zram-swap zram-generator
sudo pacman -S --noconfirm --needed holo-zram-swap zram-generator
sudo systemctl restart systemd-zram-setup@zram0

# Frametime fix
sudo pacman -S --noconfirm gamescope vulkan-radeon

# Overclock LCD to 70Hz
LUA_BAK_PATH="${LUA_PATH}.bak"
if [ -f "$LUA_BAK_PATH" ]; then
  sudo mv "$LUA_BAK_PATH" "$LUA_PATH"
else
  sudo sed -z -i "s/$MODIFIED_STRING/$ORIGINAL_STRING/" "$LUA_PATH"
fi

# Power efficiency priority
sudo systemctl disable --now energy.timer &>/dev/null
sudo rm -f /etc/systemd/system/energy.service
sudo rm -f /etc/systemd/system/energy.timer

# SDKERNEL
if [ "$steamos_version" = "3.7" ]; then
  sudo pacman -S --noconfirm linux-neptune-611 &>/dev/null
  sudo pacman -R --noconfirm linux-neptune-611-headers &>/dev/null
  sudo rm -f /usr/lib/tmpfiles.d/thp-shrinker.conf &>/dev/null
fi

# AMDGPU optimization
sudo rm -f /etc/modprobe.d/amdgpu.conf

sudo systemctl daemon-reload &>/dev/null
sudo mkinitcpio -P &>/dev/null
sudo grub-mkconfig -o "$GRUB_CFG" &>/dev/null

red_msg "A reboot is required!"
