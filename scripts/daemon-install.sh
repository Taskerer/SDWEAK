#!/bin/bash

# Connect a common script with functions and variables
source ./scripts/common.sh

# Log
sudo rm -f $HOME/SDWEAK-daemon.log &>/dev/null
LOG_FILE="$HOME/SDWEAK-daemon.log"
{
log "DATE: $DATE"
log "SDWEAK $SDWEAK_VERSION"
log "STEAMOS: $steamos_version"
log "MODEL: $MODEL"
log "BIOS: $BIOS_VERSION"
} >>"$LOG_FILE" 2>&1
green_msg '0%'

# Edit pacman.conf
if [[ $steamos_version == "3.7" ]]; then
    sudo sed -i "s/main/$steamos_version/g" /etc/pacman.conf &>/dev/null
    sudo sed -i "s/3.5/$steamos_version/g" /etc/pacman.conf &>/dev/null
    sudo sed -i "s/3.6/$steamos_version/g" /etc/pacman.conf &>/dev/null
elif [[ $steamos_version == "3.8" ]]; then
    sudo sed -i "s/3.7/main/g" /etc/pacman.conf &>/dev/null
    sudo sed -i "s/3.5/main/g" /etc/pacman.conf &>/dev/null
    sudo sed -i "s/3.6/main/g" /etc/pacman.conf &>/dev/null
fi
green_msg '10%'

# Install packages
log "INSTALL DEPS" >> "$LOG_FILE" 2>&1
sudo pacman -Sy --noconfirm spdlog fmt &>/dev/null
green_msg '20%'
sudo pacman -S --noconfirm spdlog fmt >> "$LOG_FILE" 2>&1
green_msg '30%'

log "INSTALL GLIBC" >> "$LOG_FILE" 2>&1
sudo pacman -S --noconfirm --needed glibc lib32-glibc holo-glibc-locales >> "$LOG_FILE" 2>&1
green_msg '40%'

# Ananicy-cpp install
log "INSTALL ANANICY-CPP PACKAGES" >> "$LOG_FILE" 2>&1
sudo systemctl disable --now scx &>/dev/null
sudo systemctl mask scx &>/dev/null
green_msg '50%'
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git >> "$LOG_FILE" 2>&1
green_msg '60%'
sudo pacman -S --noconfirm ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '70%'
sudo systemctl unmask ananicy-cpp &>/dev/null
sudo systemctl enable --now ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '80%'

# Install ananicy-rules
sudo rm -rf /etc/ananicy.d/{*,.*} &>/dev/null
log "INSTALL RULES ANANICY" >> "$LOG_FILE" 2>&1
sudo pacman -U ./packages/cachyos-ananicy-rules-git-latest-plus-SDWEAK.pkg.tar.zst --noconfirm >> "$LOG_FILE" 2>&1
green_msg '90%'
sudo pacman -U ./packages/cachyos-ananicy-rules-git-latest-plus-SDWEAK.pkg.tar.zst --noconfirm >> "$LOG_FILE" 2>&1
sudo systemctl restart ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '100%'
