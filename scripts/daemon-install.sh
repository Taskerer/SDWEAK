#!/bin/bash

# color echo
green_msg() {
    tput setaf 14
    echo "[*] --- $1"
    tput sgr0
}
log() {
    echo "[*] --- $1"
}

# log
sudo rm /home/deck/SDWEAK-daemon.log >/dev/null
LOG_FILE="/home/deck/SDWEAK-daemon.log"

steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
log "$steamos_version" >> "$LOG_FILE" 2>&1
green_msg '0%'

# Edit pacman.conf
sudo sed -i "s/3.5/main/g" /etc/pacman.conf &>/dev/null
green_msg '10%'
sudo sed -i "s/3.6/main/g" /etc/pacman.conf &>/dev/null
sudo sed -i "s/3.7/main/g" /etc/pacman.conf &>/dev/null
green_msg '20%'

# Install packages
log "INSTALL DEPS" >> "$LOG_FILE" 2>&1
sudo pacman -Syy --noconfirm base-devel git spdlog fmt &>/dev/null
sudo pacman -S --noconfirm base-devel git spdlog fmt >> "$LOG_FILE" 2>&1
green_msg '30%'

log "INSTALL GLIBC" >> "$LOG_FILE" 2>&1
if { [ "$steamos_version" = "3.6" ] || [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    sudo pacman -S --noconfirm --needed glibc lib32-glibc holo-glibc-locales >> "$LOG_FILE" 2>&1
    green_msg '40%'
else
    sudo pacman -S --noconfirm --needed glibc lib32-glibc >> "$LOG_FILE" 2>&1
    green_msg '40%'
fi
green_msg '50%'

# ananicy-cpp install
log "INSTALL ANANICY-CPP PACKAGES" >> "$LOG_FILE" 2>&1
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git >> "$LOG_FILE" 2>&1
sudo pacman -S --noconfirm ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '60%'
sudo systemctl enable --now ananicy-cpp >> "$LOG_FILE" 2>&1

# compile and install cachyos-ananicy-rules
sudo rm -r /home/deck/cachyos-ananicy-rules-git &>/dev/null
log "GIT CLONE ANANICY" >> "$LOG_FILE" 2>&1
sudo -u deck git clone https://aur.archlinux.org/cachyos-ananicy-rules-git.git /home/deck/cachyos-ananicy-rules-git >> "$LOG_FILE" 2>&1
green_msg '70%'
cd /home/deck/cachyos-ananicy-rules-git
sudo rm -rf /etc/ananicy.d/{*,.*} &>/dev/null
log "MAKE RULES ANANICY" >> "$LOG_FILE" 2>&1
sudo -u deck makepkg -sr --noconfirm >> "$LOG_FILE" 2>&1
green_msg '80%'
log "INSTALL RULES ANANICY" >> "$LOG_FILE" 2>&1
sudo pacman -U *.zst --noconfirm &>/dev/null
green_msg '90%'
sudo pacman -U *.zst --noconfirm >> "$LOG_FILE" 2>&1
sudo systemctl restart ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '100%'

# uninstall irqbalance
sudo systemctl disable irqbalance >> "$LOG_FILE" 2>&1
sudo pacman -R --noconfirm irqbalance >> "$LOG_FILE" 2>&1

# Edit pacman.conf
if [ $steamos_version = 3.7 ]
then
    sudo sed -i "s/main/3.7/g" /etc/pacman.conf
fi
if [ $steamos_version = 3.6 ]
then
    sudo sed -i "s/main/3.6/g" /etc/pacman.conf
fi
if [ $steamos_version = 3.5 ]
then
    sudo sed -i "s/main/3.5/g" /etc/pacman.conf
fi
sudo pacman -Syy &>/dev/null
