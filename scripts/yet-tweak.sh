#!/bin/bash

# Connect a common script with functions and variables
source ./scripts/common.sh

# Restore stock grub
restore_file "$GRUB"

# Activate MGLRU
cat << EOF | sudo tee /etc/tmpfiles.d/mglru.conf &>/dev/null
w /sys/kernel/mm/lru_gen/enabled - - - - 7
w /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 200
EOF

# Unlocking the memory lock
cat << EOF | sudo tee /etc/security/limits.d/memlock.conf &>/dev/null
* hard memlock 2147484
* soft memlock 2147484
EOF

# Disable file access time tracking
if ! grep "noatime" /etc/fstab &>/dev/null; then
  backup_file /etc/fstab
  sudo sed -i -e '/home/s/\<defaults\>/&,noatime/' /etc/fstab &>/dev/null
fi

# Input controller overclocking
echo "options usbhid jspoll=1 kbpoll=1 mousepoll=1" | sudo tee /etc/modprobe.d/usbhid.conf &>/dev/null

# List of unnecessary services
services="steamos-cfs-debugfs-tunings.service gpu-trace.service steamos-log-submitter.service cups.service avahi-daemon.socket avahi-daemon.service"

# Stopping and masking unnecessary services
sudo systemctl stop $services --quiet
sudo systemctl mask $services --quiet

# RM unnecessary .conf
backup_file /usr/lib/sysctl.d/50-coredump.conf &>/dev/null
backup_file /usr/lib/sysctl.d/60-crash-hook.conf &>/dev/null
backup_file /usr/lib/sysctl.d/20-sched.conf &>/dev/null
sudo rm -f /usr/lib/sysctl.d/50-coredump.conf /etc/udev/rules.d/64-ioschedulers.rules /usr/lib/sysctl.d/60-crash-hook.conf /usr/lib/sysctl.d/20-sched.conf

# Remove gamemoded
sudo pacman -Rdd --noconfirm gamemode &>/dev/null
