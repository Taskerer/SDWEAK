#!/bin/bash

source ./assets/strings.sh
source ./assets/common.sh

: > "$UNINSTALL_LOG_FILE"

# Select_lang [ru|en]
choose_language() {
    clear; sleep 0.3
    green_msg "Please select your language / Пожалуйста, выберите язык:"
    yellow_msg "1. Русский"
    yellow_msg "2. English"
    read -rp "Enter number / Введите цифру: " choice
    case $choice in
        1) selected_lang="ru" ;;
        2) selected_lang="en" ;;
        *) yellow_msg "Default: Русский"; selected_lang="ru" ;;
    esac
    yellow_msg "Language selected / Выбранный язык: $selected_lang"
}
choose_language
log_uninstall "LANGUAGE: $selected_lang"

clear
print_logo

sudo steamos-readonly disable 2>/dev/null || die "$(print_text readonly_fail)"

# Compatibility check
[[ "$MODEL" == "Jupiter" || "$MODEL" == "Galileo" ]] || die "$(print_text compatible)" 10

# Checking Internet access
if ping -c1 -W1 8.8.8.8   &>/dev/null ||
   ping -c1 -W1 1.1.1.1   &>/dev/null ||
   ping -c1 -W1 77.88.8.8 &>/dev/null ||
   ping -c1 -W1 9.9.9.9   &>/dev/null; then
    green_msg "$(print_text ping_success)"
else
    die "$(print_text ping_fail)" 10
fi

# Checking access to Valve's package server
check_valve_server() {
    local url="https://steamdeck-packages.steamos.cloud/archlinux-mirror/holo-main/os/x86_64/pulseaudio-qt-1.6.1-2-x86_64.pkg.tar.zst"
    local tmp_file
    tmp_file=$(mktemp --suffix=".zst")

    yellow_msg "$(print_text valve_check_start)"
    log_uninstall "VALVE CHECK: downloading $url"

    curl --silent --location --speed-limit 3 --speed-time 2 --max-time 30 --output "$tmp_file" "$url" 2>>"$UNINSTALL_LOG_FILE"
    local exit_code=$?

    if [[ $exit_code -eq 0 && -s "$tmp_file" ]]; then
        rm -f "$tmp_file"
        green_msg "$(print_text valve_check_success)"
        log_uninstall "VALVE CHECK: OK"
        return 0
    fi

    rm -f "$tmp_file"
    err_msg "$(print_text valve_check_fail)"
    log_uninstall "VALVE CHECK: FAILED (curl_exit=$exit_code)"

    local answer
    while true; do
        printf '\033[0;33m'
        read -rp "$(print_text valve_check_prompt) [y/N]: " answer
        printf '\033[0m'
        case "${answer,,}" in
            y)
                yellow_msg "$(print_text valve_check_warn)"
                log_uninstall "VALVE CHECK: user bypassed — continuing"
                return 0
                ;;
            n|"")
                die "$(print_text valve_check_abort)" 5
                ;;
            *)
                yellow_msg "$(print_text invalid_input)"
                ;;
        esac
    done
}
check_valve_server

# Start
{
    log_uninstall "DATE: $DATE"
    log_uninstall "SDWEAK $SDWEAK_VERSION"
    log_uninstall "STEAMOS: $steamos_version"
    log_uninstall "MODEL: $MODEL"
    log_uninstall "BIOS: $BIOS_VERSION"
}

green_msg "$(print_text uninstall_start)"
start_time=$(date +%s)

# Pacman
sudo sed -i "s/TrustAll/Required DatabaseOptional/g" /etc/pacman.conf
log_uninstall "PACMAN RESTORE: SigLevel reverted to Required DatabaseOptional"
sudo rm -rf /home/.steamos/offload/var/cache/pacman/pkg/{*,.*} 2>/dev/null
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init >>"$UNINSTALL_LOG_FILE" 2>&1
sudo pacman-key --populate >>"$UNINSTALL_LOG_FILE" 2>&1
log_uninstall "PACMAN INIT"

# Restoring memory lock limits
sudo rm -f /etc/security/limits.d/99-memlock.conf
log_uninstall "MEMLOCK: limits.d/99-memlock.conf removed"

# Restoring file access time tracking
sudo rm -rf /etc/systemd/system/home.mount.d
log_uninstall "NOATIME: home.mount.d override removed"

# Restoring input controller polling rate
sudo rm -f /etc/modprobe.d/usbhid.conf
log_uninstall "USBHID: polling rate restored to default"
green_msg "$(print_text usbhid_reverted)"

# Restoring gamemoded
sudo pacman -S --noconfirm --needed gamemode >> "$UNINSTALL_LOG_FILE" 2>&1
log_uninstall "GAMEMODE: reinstalled"

# scx-lavd (revert)
sudo systemctl stop scx.service >> "$UNINSTALL_LOG_FILE" 2>&1
sudo systemctl disable scx.service >> "$UNINSTALL_LOG_FILE" 2>&1
log_uninstall "SCX: stopped and disabled"
green_msg "$(print_text scx_reverted)"

# Sysctl Tweaks (revert)
sudo systemctl disable --now sdweak.service >> "$UNINSTALL_LOG_FILE" 2>&1
sudo rm -f /etc/systemd/system/sdweak.service
sudo rm -rf "$HOME/.local/tweak/"
log_uninstall "SYSCTL: sdweak.service + SDWEAK.sh removed"
green_msg "$(print_text sysctl_reverted)"

# ZRAM Tweaks (revert)
sudo rm -f /usr/lib/systemd/zram-generator.conf
sudo pacman -Rdd --noconfirm holo-zram-swap zram-generator >> "$UNINSTALL_LOG_FILE" 2>&1
sudo pacman -S --noconfirm --needed holo-zram-swap zram-generator >> "$UNINSTALL_LOG_FILE" 2>&1
sudo systemctl restart systemd-zram-setup@zram0 >> "$UNINSTALL_LOG_FILE" 2>&1
log_uninstall "ZRAM: stock zram-generator.conf restored via package reinstall, zram0 restarted"
green_msg "$(print_text zram_reverted)"

# Restoring amdgpu parameters
sudo rm -f /etc/modprobe.d/amdgpu.conf
log_uninstall "AMDGPU: module parameters removed"
green_msg "$(print_text gpu_reverted)"

# Mitigations on
sudo rm -f /etc/default/grub.d/99-mitigations.cfg
log_uninstall "MITIGATIONS: grub.d/99-mitigations.cfg removed"

# Frametime fix (revert)
sudo pacman -S --noconfirm gamescope vulkan-radeon >> "$UNINSTALL_LOG_FILE" 2>&1
log_uninstall "FRAMETIME FIX: stock gamescope/vulkan-radeon packages restored"
green_msg "$(print_text frametime_reverted)"

# Overclock LCD to 70Hz (revert)
if [[ "$MODEL" == "Jupiter" ]]; then
    lua_bak="${LUA_PATH}.bak"
    if [[ -f "$lua_bak" ]]; then
        sudo mv -f "$lua_bak" "$LUA_PATH"
        log_uninstall "DISPLAY OVERCLOCK: restored from backup"
    elif grep -q "68, 69," "$LUA_PATH" 2>/dev/null; then
        sudo sed -z -i "s/$MODIFIED_STRING/$ORIGINAL_STRING/" "$LUA_PATH"
        log_uninstall "DISPLAY OVERCLOCK: reverted via sed (no backup found)"
    else
        log_uninstall "DISPLAY OVERCLOCK: already stock, nothing to do"
    fi
    green_msg "$(print_text display_reverted)"
fi

# Power efficiency priority (revert)
sudo rm -f /etc/default/grub.d/99-amd-pstate.cfg
sudo systemctl disable --now energy.path >> "$UNINSTALL_LOG_FILE" 2>&1
sudo rm -f /etc/systemd/system/energy.service
sudo rm -f /etc/systemd/system/energy.path
log_uninstall "POWER EFFICIENCY: reverted to stock"
green_msg "$(print_text power_efficiency_reverted)"

# Finalize
sudo systemctl daemon-reload >> "$UNINSTALL_LOG_FILE" 2>&1
sudo mkinitcpio -P >> "$UNINSTALL_LOG_FILE" 2>&1
sudo grub-mkconfig -o "$GRUB_CFG" >> "$UNINSTALL_LOG_FILE" 2>&1
sudo steamos-readonly enable >> "$UNINSTALL_LOG_FILE" 2>&1
log_uninstall "FINALIZE: daemon-reload, initramfs + grub.cfg regenerated, read-only filesystem restored"

log_uninstall "COMPLETE"
green_msg "$(print_text uninstall_success)"
sleep 3

end_time=$(date +%s)
log_uninstall "UNINSTALL TIME: $((end_time - start_time))s"
green_msg "$(print_text uninstall_time) $((end_time - start_time)) $(print_text seconds)"
sleep 1

# Reboot
sys_reboot() {
    local answer
    while true; do
        printf '\033[0;33m'
        read -rp "$(print_text reboot_prompt) [Y/n]: " answer
        printf '\033[0m'
        case "${answer,,}" in
            y|"") sudo reboot; return ;;
            n)    yellow_msg "$(print_text reboot_required)"; sleep 5; return ;;
            *)    yellow_msg "$(print_text invalid_input)" ;;
        esac
    done
}
rm -f "$DESKTOP_DIR/SDWEAK-uninstaller.desktop"
sys_reboot
