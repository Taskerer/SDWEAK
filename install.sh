#!/bin/bash

source ./assets/strings.sh
source ./assets/common.sh

: > "$LOG_FILE"

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
log "LANGUAGE: $selected_lang"

clear
print_logo

sudo steamos-readonly disable 2>/dev/null || die "$(print_text readonly_fail)"

# Compatibility check
[[ "$MODEL" == "Jupiter" || "$MODEL" == "Galileo" ]] || die "$(print_text compatible)"  10
[[ "$steamos_version" == "3.8" ]]                    || die "$(print_text old_steamos)" 10

# Checking Internet access
if ping -c1 -W1 8.8.8.8   &>/dev/null ||
   ping -c1 -W1 1.1.1.1   &>/dev/null ||
   ping -c1 -W1 77.88.8.8 &>/dev/null ||
   ping -c1 -W1 9.9.9.9   &>/dev/null; then
    green_msg "$(print_text ping_success)"
else
    die "$(print_text ping_fail)" 10
fi

# Checksum validation
declare -A CHECKSUMS=(
    ["./assets/gamescope-3.16.23.2-1-SDWEAK.pkg.tar.zst"]="f77b6051d6ec65b5804f700a6c809bf3ca338aebdaab2f293247a1175a9ecb8e"
    ["./assets/vulkan-radeon-SDWEAK.pkg.tar.zst"]="8ff7950a7fca82fe0f9b3c68581ac10ea7c8e74d90e5850b0ca18eb62296b839"
)
for f in "${!CHECKSUMS[@]}"; do
    [[ -f "$f" ]]                                                  || die "$(print_text integrity_fail)" 10
    [[ $(sha256sum "$f" | awk '{print $1}') == "${CHECKSUMS[$f]}" ]] || die "$(print_text integrity_fail)" 10
done

# Start
{
    log "DATE: $DATE"
    log "SDWEAK $SDWEAK_VERSION"
    log "STEAMOS: $steamos_version"
    log "MODEL: $MODEL"
    log "BIOS: $BIOS_VERSION"
}

green_msg "$(print_text installation_start)"
start_time=$(date +%s)

# Pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf
log "PACMAN INIT"
sudo rm -rf /home/.steamos/offload/var/cache/pacman/pkg/{*,.*} 2>/dev/null
sudo rm -rf /etc/pacman.d/gnupg
sudo pacman-key --init >>"$LOG_FILE" 2>&1
sudo pacman-key --populate >>"$LOG_FILE" 2>&1

# Unlocking the memory lock
printf '* hard memlock 2147484\n* soft memlock 2147484\n' | sudo tee /etc/security/limits.d/99-memlock.conf > /dev/null
log "MEMLOCK: limits.d/99-memlock.conf installed"

# Disable file access time tracking
sudo mkdir -p /etc/systemd/system/home.mount.d
printf '[Mount]\nOptions=defaults,nofail,x-systemd.growfs,noatime\n' | sudo tee /etc/systemd/system/home.mount.d/override.conf > /dev/null
log "NOATIME: home.mount.d/override.conf installed"

# Input controller overclocking
printf 'options usbhid jspoll=1 kbpoll=1 mousepoll=1\n' | sudo tee /etc/modprobe.d/usbhid.conf > /dev/null
log "USBHID: 1000Hz polling enabled"
green_msg "$(print_text usbhid_success)"

# Remove gamemoded
sudo pacman -Rdd --noconfirm gamemode &>/dev/null

# scx-lavd
check_file "./assets/scx"
sudo cp -f ./assets/scx /etc/default/scx
sudo systemctl unmask scx.service  >> "$LOG_FILE" 2>&1
sudo systemctl restart scx.service >> "$LOG_FILE" 2>&1
sleep 1
if [[ "$(cat /sys/kernel/sched_ext/state 2>/dev/null)" == "enabled" ]] &&
   grep -q "lavd" /sys/kernel/sched_ext/root/ops 2>/dev/null; then
    log "SCX: lavd scheduler confirmed active"
    green_msg "$(print_text scx_success)"
else
    log "SCX: verification failed, lavd scheduler not confirmed"
    yellow_msg "$(print_text scx_warning)"
fi

# Sysctl Tweaks
sudo rm -rf "$HOME/.local/tweak/"
sudo rm -f /etc/systemd/system/sdweak.service
sudo mkdir -p "$HOME/.local/tweak/"
check_file "./assets/SDWEAK.sh"
sudo cp -f ./assets/SDWEAK.sh "$HOME/.local/tweak/SDWEAK.sh"
sudo chmod 755 "$HOME/.local/tweak/SDWEAK.sh"
check_file "./assets/sdweak.service"
sudo cp -f ./assets/sdweak.service /etc/systemd/system/sdweak.service
log "SYSCTL: SDWEAK.sh + sdweak.service installed"
green_msg "$(print_text sysctl_success)"

# ZRAM Tweaks
check_file "./assets/zram-generator.conf"
sudo cp -f ./assets/zram-generator.conf /usr/lib/systemd/zram-generator.conf
sudo systemctl restart systemd-zram-setup@zram0 >> "$LOG_FILE" 2>&1
log "ZRAM: zram-generator.conf installed, zram0 restarted"
green_msg "$(print_text zram_conf)"

# Changing amdgpu parameters
printf 'options gpu_sched sched_policy=0\noptions amdgpu moverate=256 lbpw=0\n' | sudo tee /etc/modprobe.d/amdgpu.conf > /dev/null
log "AMDGPU: gpu_sched + amdgpu module parameters set"
green_msg "$(print_text gpu_optimization_success)"

# Mitigations off
sudo mkdir -p /etc/default/grub.d
echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT mitigations=off"' | sudo tee /etc/default/grub.d/99-mitigations.cfg > /dev/null
log "MITIGATIONS: grub.d/99-mitigations.cfg installed"

# Frametime fix
frametime_fix() {
    local answer
    while true; do
        printf '\033[0;33m'
        read -rp "$(print_text frametime_fix_prompt) [y/N]: " answer
        printf '\033[0m'
        case "${answer,,}" in
            y)
                yellow_msg "$(print_text frametime_fix_install)"
                sudo pacman -U --noconfirm ./assets/gamescope-3.16.23.2-1-SDWEAK.pkg.tar.zst >> "$LOG_FILE" 2>&1
                sudo pacman -U --noconfirm ./assets/vulkan-radeon-SDWEAK.pkg.tar.zst >> "$LOG_FILE" 2>&1
                log "FRAMETIME FIX: custom gamescope/vulkan-radeon packages installed"
                green_msg "$(print_text frametime_fix_success)"
                return ;;
            n|"")
                green_msg "$(print_text skip)"
                sudo pacman -S --noconfirm --needed gamescope vulkan-radeon lib32-vulkan-radeon >> "$LOG_FILE" 2>&1
                log "FRAMETIME FIX: stock packages kept"
                return ;;
            *)
                yellow_msg "$(print_text invalid_input)" ;;
        esac
    done
}

# Overclock LCD to 70Hz
display_overclock() {
    local answer
    while true; do
        printf '\033[0;33m'
        read -rp "$(print_text display_overclock_prompt) [y/N]: " answer
        printf '\033[0m'
        case "${answer,,}" in
            y)
                if grep -q "68, 69," "$LUA_PATH"; then
                    log "DISPLAY OVERCLOCK: already applied, skipping"
                else
                    sudo sed -z -i.bak "s/$ORIGINAL_STRING/$MODIFIED_STRING/" "$LUA_PATH"
                    log "DISPLAY OVERCLOCK: 70Hz patch applied"
                fi
                green_msg "$(print_text display_overclock_success)"
                return ;;
            n|"")
                green_msg "$(print_text skip)"
                local lua_bak="${LUA_PATH}.bak"
                if [[ -f "$lua_bak" ]]; then
                    sudo mv -f "$lua_bak" "$LUA_PATH"
                    log "DISPLAY OVERCLOCK: restored from backup"
                elif grep -q "68, 69," "$LUA_PATH"; then
                    sudo sed -z -i "s/$MODIFIED_STRING/$ORIGINAL_STRING/" "$LUA_PATH"
                    log "DISPLAY OVERCLOCK: reverted via sed (no backup found)"
                else
                    log "DISPLAY OVERCLOCK: already stock, nothing to do"
                fi
                return ;;
            *)
                yellow_msg "$(print_text invalid_input)" ;;
        esac
    done
}

# Power efficiency priority
power_efficiency() {
    local answer
    while true; do
        printf '\033[0;33m'
        read -rp "$(print_text power_efficiency_prompt) [y/N]: " answer
        printf '\033[0m'
        case "${answer,,}" in
            y)
                yellow_msg "$(print_text power_efficiency_install)"
                sudo mkdir -p /etc/default/grub.d
                echo 'GRUB_CMDLINE_LINUX_DEFAULT="$GRUB_CMDLINE_LINUX_DEFAULT amd_pstate=active"' | sudo tee /etc/default/grub.d/99-amd-pstate.cfg > /dev/null
                sudo rm -f /etc/systemd/system/energy.service
                check_file "./assets/energy.service"
                sudo cp -f ./assets/energy.service /etc/systemd/system/energy.service
                sudo rm -f /etc/systemd/system/energy.timer
                check_file "./assets/energy.path"
                sudo cp -f ./assets/energy.path /etc/systemd/system/energy.path
                sudo systemctl daemon-reload >> "$LOG_FILE" 2>&1
                sudo systemctl enable --now energy.path >> "$LOG_FILE" 2>&1
                log "POWER EFFICIENCY: amd_pstate=active + energy.path enabled"
                green_msg "$(print_text power_efficiency_success)"
                return ;;
            n|"")
                green_msg "$(print_text skip)"
                sudo rm -f /etc/default/grub.d/99-amd-pstate.cfg
                sudo systemctl disable --now energy.path >> "$LOG_FILE" 2>&1
                sudo rm -f /etc/systemd/system/energy.service
                sudo rm -f /etc/systemd/system/energy.timer
                sudo rm -f /etc/systemd/system/energy.path
                sudo systemctl daemon-reload >> "$LOG_FILE" 2>&1
                log "POWER EFFICIENCY: reverted to stock"
                return ;;
            *)
                yellow_msg "$(print_text invalid_input)" ;;
        esac
    done
}

# display overclock LCD
if [[ "$MODEL" == "Jupiter" ]]; then
    display_overclock
fi
frametime_fix
power_efficiency

# Finalize
sudo systemctl daemon-reload >> "$LOG_FILE" 2>&1
sudo systemctl enable --now sdweak.service >> "$LOG_FILE" 2>&1
sudo mkinitcpio -P >> "$LOG_FILE" 2>&1
sudo grub-mkconfig -o "$GRUB_CFG" >> "$LOG_FILE" 2>&1
log "FINALIZE: daemon-reload, sdweak.service enabled, initramfs + grub.cfg regenerated"

log "COMPLETE"
green_msg "$(print_text sdweak_success)"
sleep 3

end_time=$(date +%s)
log "INSTALL TIME: $((end_time - start_time))s"
green_msg "$(print_text installation_time) $((end_time - start_time)) $(print_text seconds)"
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
sys_reboot
