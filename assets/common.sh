#!/bin/bash

export steamos_version=$(grep '^VERSION_ID' /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"' | cut -d. -f1,2)
export MODEL=$(cat /sys/class/dmi/id/board_name 2>/dev/null)
export BIOS_VERSION=$(cat /sys/class/dmi/id/bios_version 2>/dev/null)
export DATE=$(date '+%T %d.%m.%Y')
export SDWEAK_VERSION="2.0 RELEASE"
export BACKUP_DIR="$HOME/sdweak_backup"
export LOG_FILE="$HOME/SDWEAK-install.log"
export UNINSTALL_LOG_FILE="$HOME/SDWEAK-uninstall.log"
export GRUB_CFG="/boot/efi/EFI/steamos/grub.cfg"
export LCD_LUA_PATH="/usr/share/gamescope/scripts/00-gamescope/displays/valve.steamdeck.lcd.lua"
export ORIGINAL_STRING="58, 59,\n        60"
export MODIFIED_STRING="58, 59,\n        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,\n        70"
readonly DESKTOP_DIR="${XDG_DESKTOP_DIR:-$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")}"


green_msg()  { printf '\033[0;92m[*] --- %s\033[0m\n' "$1"; }
yellow_msg() { printf '\033[0;33m[*] --- %s\033[0m\n' "$1"; }
err_msg()    { printf '\033[0;91m[ERR] --- %s\033[0m\n' "$1" >&2; }
log()        { printf '[LOG] --- %s\n' "$1" >> "$LOG_FILE"; }
log_uninstall()  { printf '[LOG] --- %s\n' "$1" >> "$UNINSTALL_LOG_FILE"; }

print_logo() {
    printf '\033[0;93m'
    cat << 'LOGO'

>>====================================================<<
|| ███████╗██████╗ ██╗    ██╗███████╗ █████╗ ██╗  ██╗ ||
|| ██╔════╝██╔══██╗██║    ██║██╔════╝██╔══██╗██║ ██╔╝ ||
|| ███████╗██║  ██║██║ █╗ ██║█████╗  ███████║█████╔╝  ||
|| ╚════██║██║  ██║██║███╗██║██╔══╝  ██╔══██║██╔═██╗  ||
|| ███████║██████╔╝╚███╔███╔╝███████╗██║  ██║██║  ██╗ ||
|| ╚══════╝╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ||
>>====================================================<<
LOGO
    printf '\033[0mVERSION: %s\nDEVELOPER: @noncatt\nTG GROUP: @steamdeckoverclock\n\n' "$SDWEAK_VERSION"
}

die() {
    err_msg "$1"
    log "ERROR: $1"
    sleep "${2:-5}"
    exit 1
}

print_text() {
    printf '%s\n' "${texts[${selected_lang}_${1}]}"
}

check_file() {
    [[ -f "$1" ]] || die "$(print_text integrity_fail)" 10
}
