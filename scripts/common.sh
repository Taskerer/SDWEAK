#!/bin/bash

export BACKUP_DIR="$HOME/sdweak_backup"
export steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
export MODEL=$(cat /sys/class/dmi/id/board_name)
export BIOS_VERSION=$(cat /sys/class/dmi/id/bios_version)
export DATE=$(date '+%T %d.%m.%Y')
export SDWEAK_VERSION="1.10 RELEASE"
export LUA_PATH="/usr/share/gamescope/scripts/00-gamescope/displays/valve.steamdeck.lcd.lua"
export MODIFIED_STRING="58, 59,\n        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,\n        70"
export ORIGINAL_STRING="58, 59,\n        60"
export GRUB="/etc/default/grub"
export GRUB_CFG="/boot/efi/EFI/steamos/grub.cfg"

# Colorized output
green_msg() { tput setaf 14; echo "[*] --- $1"; tput sgr0; }
red_msg() { tput setaf 3; echo "[*] --- $1"; tput sgr0; }
err_msg() { tput setaf 1; echo "[ERR] --- $1"; tput sgr0; }
logo() { tput setaf 11; echo "$1"; tput sgr0; }
log() { echo "[LOG] --- $1"; }

# Logo
print_logo() {
  logo "

>>====================================================<<
|| ███████╗██████╗ ██╗    ██╗███████╗ █████╗ ██╗  ██╗ ||
|| ██╔════╝██╔══██╗██║    ██║██╔════╝██╔══██╗██║ ██╔╝ ||
|| ███████╗██║  ██║██║ █╗ ██║█████╗  ███████║█████╔╝  ||
|| ╚════██║██║  ██║██║███╗██║██╔══╝  ██╔══██║██╔═██╗  ||
|| ███████║██████╔╝╚███╔███╔╝███████╗██║  ██║██║  ██╗ ||
|| ╚══════╝╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ||
>>====================================================<<
VERSION: $SDWEAK_VERSION
DEVELOPER: @noncatt
TG GROUP: @steamdeckoverclock
"
}

# Root check
check_root() {
if [ "$(id -u)" != "0" ]; then
  err_msg "This script must be run as root."
  exit 1
fi
}

# local setup with wildcards
install_local() {
  local pkg_name=$1
  local pkg_file=$(ls ./packages/${pkg_name}*.pkg.tar.zst 2>/dev/null | head -n 1)

  if [[ -f "$pkg_file" ]]; then
    sudo pacman -U --noconfirm "$pkg_file" >>"$LOG_FILE" 2>&1
  else
    err_msg "$(print_text bundled_package_missing)"
    log "$(print_text bundled_package_missing) $pkg_name" >>"$LOG_FILE"
    sleep 10
    exit 1
  fi
}

backup_file() {
    local file_path="$1"
    if [ -f "$file_path" ]; then
      mkdir -p "$BACKUP_DIR"
      cp ./packages/grub-stock "$BACKUP_DIR/grub.bak"
      local backup_path="$BACKUP_DIR/$(basename "$file_path").bak"
      if [[ ! -f "$backup_path" ]]; then
        sudo cp -f "$file_path" "$backup_path"
      fi
    fi
}

restore_file() {
  local file_path="$1"
  local backup_path="$BACKUP_DIR/$(basename "$file_path").bak"

  if [[ -f "$backup_path" ]]; then
    sudo cp -f "$backup_path" "$file_path"
  fi
}
