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

# Ananicy-cpp install
log "INSTALL ANANICY-CPP PACKAGES" >> "$LOG_FILE" 2>&1
sudo systemctl disable --now scx &>/dev/null
sudo systemctl mask scx &>/dev/null
green_msg '10%'
sudo pacman -Rdd --noconfirm ananicy-cpp cachyos-ananicy-rules-git >> "$LOG_FILE" 2>&1
green_msg '20%'
install_local "ananicy-cpp"
green_msg '40%'
sudo systemctl unmask ananicy-cpp &>/dev/null
sudo systemctl enable --now ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '60%'

# Install ananicy-rules
sudo rm -rf /etc/ananicy.d/{*,.*} &>/dev/null
log "INSTALL RULES ANANICY" >> "$LOG_FILE" 2>&1
sudo pacman -U ./packages/cachyos-ananicy-rules-git-latest-plus-SDWEAK.pkg.tar.zst --noconfirm >> "$LOG_FILE" 2>&1
green_msg '80%'
sudo pacman -U ./packages/cachyos-ananicy-rules-git-latest-plus-SDWEAK.pkg.tar.zst --noconfirm >> "$LOG_FILE" 2>&1
sudo systemctl restart ananicy-cpp >> "$LOG_FILE" 2>&1
green_msg '100%'
