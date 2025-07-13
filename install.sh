#!/bin/bash

# Connecting a file with translations
source ./packages/lang.sh

# Colorized output
green_msg() {
    tput setaf 14
    echo "[*] --- $1"
    tput sgr0
}
red_msg() {
    tput setaf 3
    echo "[*] --- $1"
    tput sgr0
}
err_msg() {
    tput setaf 1
    echo "[!] --- $1"
    tput sgr0
}
logo() {
    tput setaf 11
    echo "$1"
    tput sgr0
}
log() {
    echo "[!] --- $1"
}

# Root check
if [ "$(id -u)" != "0" ]
then
    err_msg "This script must be run as root."
    exit 1
fi

# Log
sudo rm -f $HOME/SDWEAK-install.log &>/dev/null
LOG_FILE=$HOME/SDWEAK-install.log
start_time=$(date +%s)

# Select_lang [en|ru]
choose_language() {
    clear
    sleep 0.3
    green_msg "Please select your language / Пожалуйста, выберите язык:"
    red_msg "1. Русский"
    red_msg "2. English"
    read -p "Enter the needed number / Введите нужную цифру: " choice
    case $choice in
        1)
            selected_lang="ru"
            ;;
        2)
            selected_lang="en"
            ;;
        *)
            red_msg "Неверный выбор. По умолчанию выбран Русский."
            selected_lang="ru"
            ;;
    esac
    red_msg "Language selected / Выбранный язык: $selected_lang"
}

# Localized echo
print_text() {
    local key=$1
    echo "${texts[${selected_lang}_${key}]}"
}
choose_language

# Checking Internet access
if ping -c 1 8.8.8.8 &>/dev/null || ping -c 1 1.1.1.1 &>/dev/null || ping -c 1 208.67.222.222 &>/dev/null || ping -c 1 9.9.9.9 &>/dev/null || ping -c 1 94.140.14.14 &>/dev/null || ping -c 1 8.26.56.26 &>/dev/null; then
    green_msg "$(print_text ping_success)"
else
    err_msg "$(print_text ping_fail)"
    exit 1
fi

# Checking access to Valve's server
if curl --speed-limit 3 --speed-time 2 --max-time 30 https://steamdeck-packages.steamos.cloud/archlinux-mirror/core-main/os/x86_64/sed-4.9-3-x86_64.pkg.tar.zst --output /dev/null &>/dev/null; then
    green_msg "$(print_text server_success)"
else
    err_msg "$(print_text server_fail)"
    exit 1
fi

# Checksum validation
files=(
    "./packages/linux-neptune-611-headers-SDKERNEL.pkg.tar.zst"
    "./packages/linux-neptune-611-SDKERNEL.pkg.tar.zst"
    "./packages/vulkan-radeon-SDWEAK.pkg.tar.zst"
    "./packages/lib32-vulkan-radeon-SDWEAK.pkg.tar.zst"
    "./packages/cachyos-ananicy-rules-git-latest-plus-SDWEAK.pkg.tar.zst"
)
checksums=(
    "bab6d349ea3f0f98f71b6a5ddd86f4d2f728eabdf0ece569898de729c74e467f"
    "72a930fdc8620b697a8ce33a0d358cfebd50586499222a28ea3083feb1a3ed94"
    "7d1f326afb32caabb0c0f82dba8b7e77de69264e243843369ffc3e13611de80c"
    "8b94a8ecd8b7c87852f8c12ff7dab16ff46ada7f4062d5ee5b72bbda3812e91c"
    "49e26ce4342211bc896cab00043b3d84bf8057d82c175db30db9ef440edb9797"
)
for i in "${!files[@]}"; do
    file="${files[i]}"
    [[ -f "$file" ]] || { err_msg "$(print_text nar_cel)"; exit 1; }
    [[ $(sha256sum "$file" | awk '{print $1}') == "${checksums[i]}" ]] || exit 1
done

check_file() {
    local file_path="$1"
    if [[ ! -f "$file_path" ]]; then
        err_msg "$(print_text nar_cel)"
        exit 1
    fi
}

# --- Main ---
clear
steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
MODEL=$(cat /sys/class/dmi/id/board_name)
BIOS_VERSION=$(cat /sys/class/dmi/id/bios_version)
DATE=$(date '+%T %d.%m.%Y')
log "$DATE" >> "$LOG_FILE" 2>&1
log "VERSION: SDWEAK RELEASE 1.7" >> "$LOG_FILE" 2>&1
log "$steamos_version" >> "$LOG_FILE" 2>&1
log "$MODEL" >> "$LOG_FILE" 2>&1
log "$BIOS_VERSION" >> "$LOG_FILE" 2>&1
logo "

>>====================================================<<
|| ███████╗██████╗ ██╗    ██╗███████╗ █████╗ ██╗  ██╗ ||
|| ██╔════╝██╔══██╗██║    ██║██╔════╝██╔══██╗██║ ██╔╝ ||
|| ███████╗██║  ██║██║ █╗ ██║█████╗  ███████║█████╔╝  ||
|| ╚════██║██║  ██║██║███╗██║██╔══╝  ██╔══██║██╔═██╗  ||
|| ███████║██████╔╝╚███╔███╔╝███████╗██║  ██║██║  ██╗ ||
|| ╚══════╝╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ||
>>====================================================<<
VERSION: 1.7 RELEASE
DEVELOPER: @biddbb
TG GROUP: @steamdeckoverclock
"
# Compatibility check
if [[ "$MODEL" != "Jupiter" && "$MODEL" != "Galileo" ]]; then
    err_msg "$(print_text copable)"
    sleep 5
    exit 1
fi
if [ "$steamos_version" != "3.7" ] && [ "$steamos_version" != "3.8" ]; then
    err_msg "$(print_text old_steamos)"
    sleep 5
    exit 1
fi

check_file "./packages/lang.sh"
# -- Start --
green_msg "$(print_text optimization_start)"
sudo steamos-readonly disable &>/dev/null
sudo systemctl enable --now sshd >> "$LOG_FILE" 2>&1

# Pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf &>/dev/null
log "PACMAN INIT" >> "$LOG_FILE" 2>&1
sudo rm -rf /home/.steamos/offload/var/cache/pacman/pkg/{*,.*} &>/dev/null
sudo rm -rf /etc/pacman.d/gnupg &>/dev/null
sudo pacman-key --init >> "$LOG_FILE" 2>&1
sudo pacman-key --populate >> "$LOG_FILE" 2>&1
if ! sudo pacman -Sy >> "$LOG_FILE" 2>&1; then
    err_msg "$(print_text error_sv)"
    exit 1
fi
log "SED INSTALL" >> "$LOG_FILE" 2>&1
sudo pacman -S --noconfirm sed &>/dev/null
if ! sudo pacman -S --noconfirm sed >> "$LOG_FILE" 2>&1; then
    err_msg "$(print_text error_sv)"
    exit 1
fi

# Yet-tweak
check_file  "./scripts/yet-tweak.sh"
sudo chmod 775 ./scripts/yet-tweak.sh &>/dev/null
sudo --preserve-env=HOME ./scripts/yet-tweak.sh
green_msg "$(print_text yet_mglru)"
green_msg "$(print_text yet_ov)"
green_msg "$(print_text yet_un)"

# Ananicy-cpp
green_msg "$(print_text tweaks_install)"
sudo rm -f $HOME/daemon-install.sh &>/dev/null
check_file "./scripts/daemon-install.sh"
sudo cp -f ./scripts/daemon-install.sh $HOME/daemon-install.sh &>/dev/null
check_file "$HOME/daemon-install.sh"
sudo chmod 775 $HOME/daemon-install.sh &>/dev/null
sudo --preserve-env=HOME $HOME/daemon-install.sh
green_msg "$(print_text daem_anan)"

# Sysctl Tweaks
sudo rm -f $HOME/.local/tweak/SDWEAK.sh &>/dev/null
sudo rm -rf $HOME/.local/tweak/ &>/dev/null
sudo mkdir -p $HOME/.local/tweak/ &>/dev/null
check_file "./packages/SDWEAK.sh"
sudo cp ./packages/SDWEAK.sh $HOME/.local/tweak/SDWEAK.sh &>/dev/null
sudo rm -f /etc/systemd/system/tweak.service &>/dev/null
check_file "./packages/tweak.service"
sudo cp ./packages/tweak.service /etc/systemd/system/tweak.service &>/dev/null
sudo chmod 777 $HOME/.local/tweak/SDWEAK.sh &>/dev/null

# I/O schedulers
sudo rm -f /etc/udev/rules.d/60-ioschedulers.rules &>/dev/null
check_file "./packages/60-ioschedulers.rules"
sudo cp ./packages/60-ioschedulers.rules /etc/udev/rules.d/60-ioschedulers.rules &>/dev/null
green_msg "$(print_text sysctl_en)"

# ZRAM Tweaks
sudo pacman -S --noconfirm --needed holo-zram-swap zram-generator &>/dev/null
check_file "./packages/zram-generator.conf"
sudo cp -f ./packages/zram-generator.conf /usr/lib/systemd/zram-generator.conf &>/dev/null
sudo systemctl restart systemd-zram-setup@zram0 &>/dev/null
green_msg "$(print_text zram_optim)"

# THP
check_file "./packages/thp.conf"
sudo cp -f ./packages/thp.conf /usr/lib/tmpfiles.d/thp.conf &>/dev/null
green_msg "$(print_text thp_shrink)"

# FRAMETIME FIX LCD
fix() {
    while true; do
        tput setaf 3
        read -p "$(print_text fix_prompt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text fix_install)"
            sudo sed -i "s/ENABLE_GAMESCOPE_WSI=1/ENABLE_GAMESCOPE_WSI=0/g" /usr/{bin/gamescope-session,lib/steamos/gamescope-session} 2>/dev/null
            log "VULKAN RADEON" >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/vulkan-radeon-SDWEAK.pkg.tar.zst >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/lib32-vulkan-radeon-SDWEAK.pkg.tar.zst >> "$LOG_FILE" 2>&1
            green_msg "$(print_text fix_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
            sudo sed -i "s/ENABLE_GAMESCOPE_WSI=0/ENABLE_GAMESCOPE_WSI=1/g" /usr/{bin/gamescope-session,lib/steamos/gamescope-session} 2>/dev/null
            sudo pacman -S --noconfirm --needed vulkan-radeon lib32-vulkan-radeon &>/dev/null
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

# 70Hz
hz() {
    while true; do
        tput setaf 3
        read -p "$(print_text hz_prompt) [y/N]: " answer
        tput sgr0
        answer=${answer:-n}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text hz_install)"
            if grep "68, 69," /usr/share/gamescope/scripts/00-gamescope/displays/valve.steamdeck.lcd.lua &>/dev/null; then
                echo 1 > /dev/null
            else
                sudo sed -z -i "s/58, 59,\n        60/58, 59,\n        60, 61, 62, 63, 64, 65, 66, 67, 68, 69,\n        70/g" /usr/share/gamescope/scripts/00-gamescope/displays/valve.steamdeck.lcd.lua &>/dev/null
            fi
            green_msg "$(print_text hz_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

# Power efficiency priority
battery() {
    while true; do
        tput setaf 3
        read -p "$(print_text batt_prompt) [y/N]: " answer
        tput sgr0
        answer=${answer:-n}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text batt_install)"
            if sudo sed -i -E '/^GRUB_CMDLINE_LINUX_DEFAULT=/ {
                s/(amd_pstate=)[^ "]*//g
                s/(=")(.*")/\1amd_pstate=active \2/
                s/  +/ /g
                s/" /"/}' /etc/default/grub
            then
                sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
            fi
            sudo rm -f /etc/systemd/system/energy.service &>/dev/null
            check_file "./packages/energy.service"
            sudo cp ./packages/energy.service /etc/systemd/system/energy.service &>/dev/null
            sudo rm -f /etc/systemd/system/energy.timer &>/dev/null
            check_file "./packages/energy.timer"
            sudo cp ./packages/energy.timer /etc/systemd/system/energy.timer &>/dev/null
            sudo systemctl daemon-reload &>/dev/null
            sudo systemctl enable --now energy.timer &>/dev/null
            green_msg "$(print_text batt_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
            if sudo sed -i -E '/^GRUB_CMDLINE_LINUX_DEFAULT=/ {
                s/(amd_pstate=)[^ "]*//g
                s/  +/ /g
                s/(GRUB_CMDLINE_LINUX_DEFAULT=") /\1/
                s/ (")/\1/}' /etc/default/grub
            then
                sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
            fi
            sudo systemctl disable energy.timer &>/dev/null
            sudo rm -f /etc/systemd/system/energy.service &>/dev/null
            sudo rm -f /etc/systemd/system/energy.timer &>/dev/null
            sudo systemctl daemon-reload &>/dev/null
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

# SDKERNEL Install
sdkernel() {
    while true; do
        tput setaf 3
        read -p "$(print_text kernel_prompt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            red_msg "$(print_text kernel_install)"
            log "SDKERNEL INSTALL" >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/linux-neptune-611-SDKERNEL.pkg.tar.zst >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/linux-neptune-611-headers-SDKERNEL.pkg.tar.zst >> "$LOG_FILE" 2>&1
            check_file "./packages/thp-shrinker.conf"
            sudo cp -f ./packages/thp-shrinker.conf /usr/lib/tmpfiles.d/thp-shrinker.conf &>/dev/null
            sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
            green_msg "$(print_text kernel_success)"
            if [ "$MODEL" = "Galileo" ]; then
                battery
            elif [ "$MODEL" = "Jupiter" ] && [ "$BIOS_VERSION" = "F7A0131" ]; then
                battery
            fi
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

# AMDGPU optimization
gpu-optimization() {
    while true; do
        tput setaf 3
        read -p "$(print_text gpu_prompt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text gpu_install)"
            params=("gpu_sched.sched_policy=0" "amdgpu.mes=1" "amdgpu.moverate=128" "amdgpu.uni_mes=1" "amdgpu.lbpw=0" "amdgpu.mes_kiq=1")
            missing=()
            for param in "${params[@]}"; do
                if ! grep -q "$param" /etc/default/grub &>/dev/null; then
                    missing+=("$param")
                fi
            done
            if [ ${#missing[@]} -gt 0 ]; then
                missing_str=$(IFS=" "; echo "${missing[*]}")
                sudo sed -i "s/\bGRUB_CMDLINE_LINUX_DEFAULT=\"\b/&$missing_str /" /etc/default/grub &>/dev/null
                sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
            fi
            green_msg "$(print_text gpu_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

# System reboot
sys-reboot() {
    while true; do
        tput setaf 3
        read -p "$(print_text reboot_prompt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            sudo reboot
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            red_msg "$(print_text reboot_required)"
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

sudo systemctl daemon-reload &>/dev/null
sudo systemctl enable --now tweak.service &>/dev/null

# SDKERNEL
if { [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    sdkernel
fi

# FRAMETIME FIX LCD
if [ "$MODEL" = "Jupiter" ] && { [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    fix
    hz
fi

# GPU OPTIMIZATION
gpu-optimization

# Clean tmp files
sudo rm -f $HOME/daemon-install.sh &>/dev/null
red_msg "$(print_text sdweak_success)"
sleep 3
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
green_msg "$(print_text se) $elapsed_time $(print_text sec)"
log "COMPLETE" >> "$LOG_FILE" 2>&1
sleep 1

# reboot
sys-reboot
