#!/bin/bash

# Backup
BACKUP_DIR="$HOME/install_backup"
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR"
    fi
}

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
if grep "noatime" /etc/fstab &>/dev/null; then
    echo 1 > /dev/null
else
    sudo sed -i -e '/home/s/\<defaults\>/&,noatime/' /etc/fstab &>/dev/null
fi

# Input controller overclocking
if grep "usbhid.jspoll=1" /etc/default/grub &>/dev/null; then
    echo 1 > /dev/null
else
    sudo sed -i 's/\bGRUB_CMDLINE_LINUX_DEFAULT="\b/&usbhid.jspoll=1 /' /etc/default/grub &>/dev/null
    sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
fi

# Stop unnecessary services
sudo systemctl stop steamos-cfs-debugfs-tunings.service &>/dev/null
sudo systemctl stop gpu-trace.service &>/dev/null
sudo systemctl stop steamos-log-submitter.service &>/dev/null
sudo systemctl stop cups.service &>/dev/null
sudo systemctl stop avahi-daemon.socket &>/dev/null
sudo systemctl stop avahi-daemon.service &>/dev/null

# Mask unnecessary services
sudo systemctl mask steamos-cfs-debugfs-tunings.service &>/dev/null
sudo systemctl mask gpu-trace.service &>/dev/null
sudo systemctl mask steamos-log-submitter.service &>/dev/null
sudo systemctl mask cups.service &>/dev/null
sudo systemctl mask avahi-daemon.socket &>/dev/null
sudo systemctl mask avahi-daemon.service &>/dev/null

# RM unnecessary .conf
backup_file /usr/lib/sysctl.d/60-crash-hook.conf &>/dev/null
backup_file /usr/lib/sysctl.d/20-sched.conf &>/dev/null
backup_file /usr/lib/sysctl.d/50-coredump.conf &>/dev/null
sudo rm -f /usr/lib/sysctl.d/50-coredump.conf &>/dev/null
sudo rm -f /etc/udev/rules.d/64-ioschedulers.rules &>/dev/null
sudo rm -f /usr/lib/sysctl.d/60-crash-hook.conf &>/dev/null
sudo rm -f /usr/lib/sysctl.d/20-sched.conf &>/dev/null

# remove gamemoded
sudo pacman -Rdd --noconfirm gamemode &>/dev/null
