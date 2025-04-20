#!/bin/bash

# Colorized output
green_msg() {
    tput setaf 14
    echo "[*] --- $1"
    tput sgr0
}
err_msg() {
    tput setaf 1
    echo "[!] --- $1"
    tput sgr0
}
log() {
    echo "[!] --- $1"
}

# Log
sudo rm -f $HOME/SDWEAK-daemon.log &>/dev/null
LOG_FILE="$HOME/SDWEAK-daemon.log"
steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
MODEL=$(cat /sys/class/dmi/id/board_name)
BIOS_VERSION=$(cat /sys/class/dmi/id/bios_version)
DATE=$(date '+%T %d.%m.%Y')
log "$DATE" >> "$LOG_FILE" 2>&1
log "VERSION: RELEASE 1.3" >> "$LOG_FILE" 2>&1
log "$steamos_version" >> "$LOG_FILE" 2>&1
log "$MODEL" >> "$LOG_FILE" 2>&1
log "$BIOS_VERSION" >> "$LOG_FILE" 2>&1
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

# Ananicy-cpp install
log "INSTALL ANANICY-CPP PACKAGES" >> "$LOG_FILE" 2>&1
sudo systemctl disable --now scx &>/dev/null
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git >> "$LOG_FILE" 2>&1
sudo pacman -S --noconfirm ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '60%'
sudo systemctl enable --now ananicy-cpp >> "$LOG_FILE" 2>&1

# Compile and install Cachyos-ananicy-rules
sudo rm -rf $HOME/cachyos-ananicy-rules-git &>/dev/null
sudo rm -rf /etc/ananicy.d/{*,.*} &>/dev/null
log "GIT CLONE ANANICY" >> "$LOG_FILE" 2>&1
sudo -u deck git clone https://aur.archlinux.org/cachyos-ananicy-rules-git.git $HOME/cachyos-ananicy-rules-git >> "$LOG_FILE" 2>&1
green_msg '70%'
cd $HOME/cachyos-ananicy-rules-git
log "MAKE RULES ANANICY" >> "$LOG_FILE" 2>&1
if ! sudo -u deck makepkg -sr --noconfirm >> "$LOG_FILE" 2>&1; then
    err_msg "An error occurred while cloning the repository. Start installing SDWEAK again. If the problem persists, please contact me via feedback."
    sleep 10
    exit 1
fi
green_msg '80%'
log "INSTALL RULES ANANICY" >> "$LOG_FILE" 2>&1
sudo pacman -U *.zst --noconfirm &>/dev/null
green_msg '90%'
sudo pacman -U *.zst --noconfirm >> "$LOG_FILE" 2>&1
sudo systemctl restart ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '100%'

# Uninstall irqbalance
sudo systemctl disable irqbalance >> "$LOG_FILE" 2>&1
sudo pacman -R --noconfirm irqbalance >> "$LOG_FILE" 2>&1

# Edit pacman.conf
if [[ $steamos_version == "3.5" || $steamos_version == "3.6" || $steamos_version == "3.7" ]]; then
    sudo sed -i "s/main/$steamos_version/g" /etc/pacman.conf
fi
sudo pacman -Syy &>/dev/null
