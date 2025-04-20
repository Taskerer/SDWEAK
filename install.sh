#!/bin/bash

# Key = language code, value = text
declare -A texts
texts["en_ping_success"]="Internet connection established."
texts["ru_ping_success"]="Интернет соединение установлено."
texts["en_ping_fail"]="No connection to the server! Please connect to the internet or check the server's availability, try using a VPN, and run the script again."
texts["ru_ping_fail"]="Отсутствует соединение с сервером! Пожалуйста, подключитесь к интернету или проверьте доступность сервера, попробуйте использовать VPN и запустите скрипт снова."

texts["en_nar_cel"]="SDWEAK integrity violated, files corrupted or deleted! Reinstall SDWEAK!"
texts["ru_nar_cel"]="Нарушена целостность SDWEAK, файлы повреждены или удалены! Переустановите SDWEAK!"
texts["en_error_sv"]="A serious error has occurred! The system is corrupted, SDWEAK cannot be installed, call for help!"
texts["ru_error_sv"]="Произошла серьезная ошибка! Система повреждена, установка SDWEAK невозможна, обратитесь за помощью!"

texts["en_script_continue"]="The script continues execution..."
texts["ru_script_continue"]="Скрипт продолжает выполнение..."
texts["en_skip"]="Skipping..."
texts["ru_skip"]="Пропуск..."

texts["en_optimization_start"]="SDWEAK installation begins."
texts["ru_optimization_start"]="Начинается установка SDWEAK."
texts["en_copable"]="SDWEAK is compatible with Steam Deck only!"
texts["ru_copable"]="SDWEAK совместим только со Steam Deck!"
texts["en_pacman_keys"]="Pacman keys successfully initialized."
texts["ru_pacman_keys"]="Ключи pacman-key успешно инициализированы."

texts["en_tweaks_install"]="Starting tweaks installation..."
texts["ru_tweaks_install"]="Начинается установка твиков..."

texts["en_invalid_input"]="Invalid input. Please enter 'y' or 'n'."
texts["ru_invalid_input"]="Неправильный ввод. Пожалуйста, введите 'y' или 'n'."

texts["en_kernel_install"]="Starting kernel installation..."
texts["ru_kernel_install"]="Начинается установка ядра..."
texts["en_kernel_success"]="Kernel successfully installed."
texts["ru_kernel_success"]="Ядро успешно установлено."
texts["en_kernel_prompt"]="Install optimized kernel?"
texts["ru_kernel_prompt"]="Установить оптимизированное ядро?"

texts["en_fix_install"]="Starting microstutters fix installation..."
texts["ru_fix_install"]="Начинается установка исправления микрозаиканий..."
texts["en_fix_success"]="Microstutters fix successfully installed."
texts["ru_fix_success"]="Исправление микрозаиканий успешно установлено."
texts["en_fix_prompt"]="Install microstutters fix?"
texts["ru_fix_prompt"]="Установить исправление микрозаиканий?"

texts["en_hz_install"]="Starting Overclocking to 70Hz installation..."
texts["ru_hz_install"]="Начинается установка разгона дисплея до 70Hz..."
texts["en_hz_success"]="Overclocking to 70Hz successfully installed."
texts["ru_hz_success"]="Разгон до 70Hz успешно установлен."
texts["en_hz_prompt"]="Overclock the display to 70Hz?"
texts["ru_hz_prompt"]="Разогнать дисплей до 70Hz?"

texts["en_batt_install"]="Starting to prioritize power efficiency..."
texts["ru_batt_install"]="Начинается установка приоритета энергоэффективности..."
texts["en_batt_success"]="Power efficiency prioritization successfully installed."
texts["ru_batt_success"]="Приоритет энергоэффективности успешно установлен."
texts["en_batt_prompt"]="Prioritize power efficiency? (BETA)"
texts["ru_batt_prompt"]="Установить приоритет энергоэффективности? (БЕТА)"

texts["en_yet_mglru"]="MGLRU successfully activated."
texts["ru_yet_mglru"]="MGLRU успешно активирован."
texts["en_yet_ov"]="Input controller overclocking successfully activated."
texts["ru_yet_ov"]="Разгон контроллера ввода успешно активирован."
texts["en_yet_un"]="Unnecessary services have been successfully disabled."
texts["ru_yet_un"]="Ненужные службы успешно отключены."

texts["en_daem_anan"]="Ananicy-cpp successfully installed."
texts["ru_daem_anan"]="Ananicy-cpp успешно установлен."

texts["en_se"]="Installation completed in"
texts["ru_se"]="Установка завершена за"
texts["en_sec"]="seconds."
texts["ru_sec"]="секунды."

texts["en_sdweak_success"]="The installation of SDWEAK has been successfully completed! If you enjoy SDWEAK, you can also support the project's further development with a donation via the link in the GitHub repository. Thank you for using it!"
texts["ru_sdweak_success"]="Установка SDWEAK успешно завершена! Если вам понравится SDWEAK, вы также можете поддержать донатом дальнейшее развитие проекта по ссылке в репозитории на GITHUB. Спасибо за использование!"

texts["en_reboot_prompt"]="Reboot to apply changes?"
texts["ru_reboot_prompt"]="Перезагрузить для применения изменений?"
texts["en_reboot_required"]="Reboot is required."
texts["ru_reboot_required"]="Обязательно перезагрузите."

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

# Backup
BACKUP_DIR="$HOME/install_backup"
sudo mkdir -p "$BACKUP_DIR"
start_time=$(date +%s)
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        sudo cp "$file" "$BACKUP_DIR"
    fi
}

# Log
sudo rm $HOME/SDWEAK-install.log &>/dev/null
LOG_FILE=$HOME/SDWEAK-install.log

# Select_lang [en|ru]
choose_language() {
    clear
    sleep 0.3
    green_msg "Please select your language / Пожалуйста, выберите язык:"
    red_msg "1. English"
    red_msg "2. Русский"
    read -p "Enter the needed number / Введите нужную цифру: " choice
    case $choice in
        1)
            selected_lang="en"
            ;;
        2)
            selected_lang="ru"
            ;;
        *)
            red_msg "Invalid choice. Defaulting to English."
            selected_lang="en"
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

# Server ping test
if git ls-remote --exit-code https://aur.archlinux.org/cachyos-ananicy-rules-git.git &>/dev/null; then
    green_msg "$(print_text ping_success)"
else
    err_msg "$(print_text ping_fail)"
    exit 1
fi

# Checksum validation
files=(
    "./packages/linux-neptune-611-headers-SDKERNEL.pkg.tar.zst"
    "./packages/linux-neptune-611-SDKERNEL.pkg.tar.zst"
    "./packages/vulkan-radeon-SDWEAK.pkg.tar.zst"
    "./packages/lib32-vulkan-radeon-SDWEAK.pkg.tar.zst"
)
checksums=(
    "62105c33017833c0aa699aff9cb36abf374d73b742928954b05f07cf579b4f69"
    "2a17f68f70a738f899827b91b566c33670c739ccae9daafbd2028b04807898be"
    "7d1f326afb32caabb0c0f82dba8b7e77de69264e243843369ffc3e13611de80c"
    "8b94a8ecd8b7c87852f8c12ff7dab16ff46ada7f4062d5ee5b72bbda3812e91c"
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
green_msg "$(print_text script_continue)"
clear
steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
MODEL=$(cat /sys/class/dmi/id/board_name)
BIOS_VERSION=$(cat /sys/class/dmi/id/bios_version)
DATE=$(date '+%T %d.%m.%Y')
log "$DATE" >> "$LOG_FILE" 2>&1
log "VERSION: SDWEAK RELEASE 1.3" >> "$LOG_FILE" 2>&1
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
VERSION: 1.3 RELEASE
DEVELOPER: @biddbb
TG GROUP: @steamdeckoverclock
"
if [[ "$MODEL" != "Jupiter" && "$MODEL" != "Galileo" ]]; then
    err_msg "$(print_text copable)"
    sleep 5
    exit 1
fi
green_msg "$(print_text optimization_start)"
sudo steamos-readonly disable &>/dev/null
sudo systemctl enable --now sshd >> "$LOG_FILE" 2>&1
# Pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf &>/dev/null
log "PACMAN INIT" >> "$LOG_FILE" 2>&1
sudo pacman-key --init >> "$LOG_FILE" 2>&1
sudo pacman-key --populate >> "$LOG_FILE" 2>&1
if ! sudo pacman -Sy >> "$LOG_FILE" 2>&1; then
    err_msg "$(print_text error_sv)"
    exit 1
fi
log "SED INSTALL" >> "$LOG_FILE" 2>&1
sudo pacman -S --noconfirm sed &>/dev/null
sudo pacman -S --noconfirm sed >> "$LOG_FILE" 2>&1
green_msg "$(print_text pacman_keys)"

# Yet-tweak
check_file  "./scripts/yet-tweak.sh"
sudo chmod 775 ./scripts/yet-tweak.sh &>/dev/null
sudo --preserve-env=HOME ./scripts/yet-tweak.sh
green_msg "$(print_text yet_mglru)"
green_msg "$(print_text yet_ov)"
green_msg "$(print_text yet_un)"

# Ananicy-cpp
green_msg "$(print_text tweaks_install)"
sudo rm $HOME/daemon-install.sh &>/dev/null
check_file "./scripts/daemon-install.sh"
sudo cp -f ./scripts/daemon-install.sh $HOME/daemon-install.sh &>/dev/null
check_file "$HOME/daemon-install.sh"
sudo chmod 775 $HOME/daemon-install.sh &>/dev/null
sudo --preserve-env=HOME $HOME/daemon-install.sh
green_msg "$(print_text daem_anan)"

# Sysctl Tweaks
sudo rm $HOME/.local/tweak/SDWEAK.sh &>/dev/null
sudo rm -r $HOME/.local/tweak/ &>/dev/null
sudo mkdir -p $HOME/.local/tweak/ &>/dev/null
check_file "./home/deck/.local/tweak/SDWEAK.sh"
sudo cp ./home/deck/.local/tweak/SDWEAK.sh $HOME/.local/tweak/SDWEAK.sh &>/dev/null
sudo rm /etc/systemd/system/tweak.service &>/dev/null
check_file "./etc/systemd/system/tweak.service"
sudo cp ./etc/systemd/system/tweak.service /etc/systemd/system/tweak.service &>/dev/null
sudo chmod 777 $HOME/.local/tweak/SDWEAK.sh &>/dev/null

# ZRAM Tweaks
sudo pacman -S --noconfirm --needed holo-zram-swap zram-generator &>/dev/null
check_file "./packages/zram-generator.conf"
sudo cp -f ./packages/zram-generator.conf /usr/lib/systemd/zram-generator.conf &>/dev/null
sudo systemctl restart systemd-zram-setup@zram0 &>/dev/null

# THP
sudo find / -type f -regex ".*/core\.[0-9]+" -exec rm -f {} \; &>/dev/null
check_file "./packages/thp-shrinker.conf"
sudo cp -f ./packages/thp-shrinker.conf /usr/lib/tmpfiles.d/thp-shrinker.conf &>/dev/null
check_file "./packages/thp.conf"
sudo cp -f ./packages/thp.conf /usr/lib/tmpfiles.d/thp.conf &>/dev/null

# FRAMETIME FIX LCD
fix() {
    while true; do
        tput setaf 3
        read -p "$(print_text fix_prompt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text fix_install)"
            sudo sed -i "s/ENABLE_GAMESCOPE_WSI=1/ENABLE_GAMESCOPE_WSI=0/g" /usr/{bin/gamescope-session,lib/steamos/gamescope-session/gamescope-session} 2>/dev/null
            log "VULKAN RADEON" >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/vulkan-radeon-SDWEAK.pkg.tar.zst >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/lib32-vulkan-radeon-SDWEAK.pkg.tar.zst >> "$LOG_FILE" 2>&1
            green_msg "$(print_text fix_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
            sudo sed -i "s/ENABLE_GAMESCOPE_WSI=0/ENABLE_GAMESCOPE_WSI=1/g" /usr/{bin/gamescope-session,lib/steamos/gamescope-session/gamescope-session} 2>/dev/null
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
            sudo rm /etc/systemd/system/energy.service &>/dev/null
            check_file "./etc/systemd/system/energy.service"
            sudo cp ./etc/systemd/system/energy.service /etc/systemd/system/energy.service &>/dev/null
            sudo rm /etc/systemd/system/energy.timer &>/dev/null
            check_file "./etc/systemd/system/energy.timer"
            sudo cp ./etc/systemd/system/energy.timer /etc/systemd/system/energy.timer &>/dev/null
            sudo systemctl daemon-reload &>/dev/null
            sudo systemctl enable --now energy.timer &>/dev/null
            green_msg "$(print_text batt_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
            if sudo sed -i -E '/^GRUB_CMDLINE_LINUX_DEFAULT=/ {
                s/(amd_pstate=)[^ "]*//g
                s/(=")(.*")/\1amd_pstate=disable \2/
                s/  +/ /g
                s/" /"/}' /etc/default/grub
            then
                sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
            fi
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
            if [ $steamos_version = 3.6 ]
            then
                sudo sed -i "s/3.6/3.7/g" /etc/pacman.conf &>/dev/null
                sudo pacman -Sy ell readline iwd networkmanager steamos-networking-tools steamos-manager iptables linux-api-headers jupiter-firewall linux-firmware-neptune linux-firmware-neptune-whence >> "$LOG_FILE" 2>&1
            fi
            sudo pacman -U --noconfirm ./packages/linux-neptune-611-SDKERNEL.pkg.tar.zst >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/linux-neptune-611-headers-SDKERNEL.pkg.tar.zst >> "$LOG_FILE" 2>&1
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
if { [ "$steamos_version" = "3.6" ] || [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    sdkernel
fi

# FRAMETIME FIX LCD
if [ "$MODEL" = "Jupiter" ] && { [ "$steamos_version" = "3.6" ] || [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    fix
fi

# 70Hz
if [ "$MODEL" = "Jupiter" ] && { [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    hz
fi

# Clean tmp files
sudo rm $HOME/daemon-install.sh &>/dev/null
sudo rm -r $HOME/cachyos-ananicy-rules-git &>/dev/null

green_msg "$(print_text sdweak_success)"
sleep 2
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
green_msg "$(print_text se) $elapsed_time $(print_text sec)"
log "COMPLETE" >> "$LOG_FILE" 2>&1
sleep 1

# reboot
sys-reboot
