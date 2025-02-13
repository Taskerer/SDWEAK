#!/bin/bash

# backup
BACKUP_DIR="/tmp/install_backup"
start_time=$(date +%s)
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR"
    fi
}

# Activate MGLRU (Multi-Gen. Least Recently Used)
cat << EOF | sudo tee /etc/tmpfiles.d/mglru.conf &>/dev/null
w /sys/kernel/mm/lru_gen/enabled - - - - 7
w /sys/kernel/mm/lru_gen/min_ttl_ms - - - - 0
EOF

# Unlocking the memory lock
cat << EOF | sudo tee /etc/security/limits.d/memlock.conf &>/dev/null
* hard memlock 2147484
* soft memlock 2147484
EOF

# Preventing the superfluous book-keeping of File Access Times
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

# stopping unnecessary services
sudo systemctl stop systemd-coredump.socket &>/dev/null
sudo systemctl stop kdumpst-init.service &>/dev/null
sudo systemctl stop steamos-kdumpst-layer.service &>/dev/null
sudo systemctl stop steamos-dump-info.service &>/dev/null
sudo systemctl stop steamos-cfs-debugfs-tunings.service &>/dev/null
sudo systemctl stop gpu-trace.service &>/dev/null
sudo systemctl stop steamos-log-submitter.service &>/dev/null
sudo systemctl stop steamos-devkit-service.service &>/dev/null
sudo systemctl stop cups.service &>/dev/null
sudo systemctl stop firewalld.service &>/dev/null

# mask unnecessary services
sudo systemctl mask systemd-coredump.socket &>/dev/null
sudo systemctl mask kdumpst-init.service &>/dev/null
sudo systemctl mask steamos-kdumpst-layer.service &>/dev/null
sudo systemctl mask steamos-dump-info.service &>/dev/null
sudo systemctl mask steamos-cfs-debugfs-tunings.service &>/dev/null
sudo systemctl mask gpu-trace.service &>/dev/null
sudo systemctl mask steamos-log-submitter.service &>/dev/null
sudo systemctl mask steamos-devkit-service.service &>/dev/null
sudo systemctl mask cups.service &>/dev/null
sudo systemctl mask firewalld.service &>/dev/null

# rm unnecessary .conf
backup_file /usr/lib/sysctl.d/21-steamos-panic-sysctls.conf &>/dev/null
backup_file /usr/lib/sysctl.d/50-coredump.conf &>/dev/null
backup_file /usr/lib/sysctl.d/20-panic-sysctls.conf &>/dev/null
sudo rm /usr/lib/sysctl.d/21-steamos-panic-sysctls.conf &>/dev/null
sudo rm /usr/lib/sysctl.d/50-coredump.conf &>/dev/null
sudo rm /usr/lib/sysctl.d/20-panic-sysctls.conf &>/dev/null
