#!/bin/bash

# Check if Bash supports associative arrays
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
    echo "This script requires Bash 4.0 or higher."
    exit 1
fi

# Associative arrays for storing texts in different languages
declare -A texts

# Fill the arrays with texts for each language
texts["en_ping_success"]="Internet connection established."
texts["ru_ping_success"]="Интернет соединение установлено."

texts["en_ping_fail"]="No internet connection! Please connect to the internet and run the script again."
texts["ru_ping_fail"]="Отсутствует интернет соединение! Пожалуйста, подключитесь к интернету и запустите скрипт снова."

texts["en_nar_cel"]="SDWEAK integrity violated, files corrupted or deleted! Reinstall SDWEAK!"
texts["ru_nar_cel"]="Нарушена целостность SDWEAK, файлы повреждены или удалены! Переустановите SDWEAK!"

texts["en_script_continue"]="The script continues execution..."
texts["ru_script_continue"]="Скрипт продолжает выполнение..."

texts["en_optimization_start"]="Starting SteamOS optimization..."
texts["ru_optimization_start"]="Начинается оптимизация SteamOS."

texts["en_copable"]="SDWEAK is compatible with Steam Deck only!"
texts["ru_copable"]="SDWEAK совместим только со Steam Deck!"

texts["en_pacman_keys"]="Pacman keys successfully initialized."
texts["ru_pacman_keys"]="Ключи pacman-key успешно инициализированы."

texts["en_tweaks_install"]="Starting tweaks installation..."
texts["ru_tweaks_install"]="Начинается установка твиков..."

texts["en_zswap_enable"]="Starting ZSWAP installation..."
texts["ru_zswap_enable"]="Начинается установка ZSWAP..."
texts["en_zswap_success"]="ZSWAP successfully installed."
texts["ru_zswap_success"]="ZSWAP успешно установлен."
texts["en_zswap_prompt"]="Install ZSWAP?"
texts["ru_zswap_prompt"]="Установить ZSWAP?"

texts["en_skip"]="Skipping..."
texts["ru_skip"]="Пропуск..."

texts["en_invalid_input"]="Invalid input. Please enter 'y' or 'n'."
texts["ru_invalid_input"]="Неправильный ввод. Пожалуйста, введите 'y' или 'n'."

texts["en_kernel_install"]="Starting kernel installation..."
texts["ru_kernel_install"]="Начинается установка ядра..."
texts["en_kernel_success"]="Kernel successfully installed."
texts["ru_kernel_success"]="Ядро успешно установлено."
texts["en_kernel_prompt"]="Install optimized kernel?"
texts["ru_kernel_prompt"]="Установить оптимизированное ядро?"

texts["en_reboot_prompt"]="Reboot to apply changes?"
texts["ru_reboot_prompt"]="Перезагрузить для применения изменений?"
texts["en_reboot_required"]="Reboot is required."
texts["ru_reboot_required"]="Обязательно перезагрузите."

texts["en_fix_install"]="Starting microstutters fix installation..."
texts["ru_fix_install"]="Начинается установка исправление микрозаиканий..."
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

texts["en_audio_install"]="Starting to install the sound driver fix..."
texts["ru_audio_install"]="Начинается установка фикса звукового драйвера..."
texts["en_audio_success"]="Sound driver fix successfully installed."
texts["ru_audio_success"]="Фикс звукового драйвера успешно установлен."
texts["en_audio_prompt"]="Install sound driver fix?(only if there are problems!)"
texts["ru_audio_prompt"]="Установить фикс звукового драйвера?(только при проблемах!)"

texts["en_tweaks_applied"]="Tweaks successfully installed."
texts["ru_tweaks_applied"]="Твики успешно установлены."

texts["en_se"]="Installation completed in"
texts["ru_se"]="Установка завершена за"
texts["en_sec"]="seconds."
texts["ru_sec"]="секунды."

texts["en_yet_mglru"]="MGLRU successfully activated."
texts["ru_yet_mglru"]="MGLRU успешно активирован."
texts["en_yet_io"]="I/O scheduler successfully changed."
texts["ru_yet_io"]="I/O scheduler успешно изменен."
texts["en_yet_ov"]="Input controller overclocking successfully activated."
texts["ru_yet_ov"]="Разгон контроллера ввода успешно активирован."
texts["en_yet_un"]="Unnecessary services have been successfully disabled."
texts["ru_yet_un"]="Ненужные службы успешно отключены."

texts["en_daem_anan"]="ananicy-cpp successfully installed."
texts["ru_daem_anan"]="ananicy-cpp успешно установлен."

# Function for color message output
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
logo() {
    tput setaf 11
    echo "$1"
    tput sgr0
}
log() {
    echo "[!] --- $1"
}

# check root
if [ "$(id -u)" != "0" ]
then
    red_msg "This script must be run as root."
    exit 1
fi

# backup
BACKUP_DIR="/home/deck/install_backup"
sudo mkdir -p "$BACKUP_DIR"
start_time=$(date +%s)
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        sudo cp "$file" "$BACKUP_DIR"
    fi
}

# log
sudo rm /home/deck/SDWEAK-install.log >/dev/null
LOG_FILE="/home/deck/SDWEAK-install.log"

# Function for language selection
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
    red_msg "Language selected: $selected_lang"
}

# Function for outputting text in the selected language
print_text() {
    local key=$1
    echo "${texts[${selected_lang}_${key}]}"
}
choose_language

# Checking Internet connection
if ping -c 1 1.1.1.1 >/dev/null 2>&1; then
    green_msg "$(print_text ping_success)"
else
    red_msg "$(print_text ping_fail)"
    exit 1
fi

# check files
files=("./packages/linux-neptune-68-headers-SDKERNEL.pkg.tar.zst" "./packages/linux-neptune-68-SDKERNEL.pkg.tar.zst" "./packages/vulkan-radeon-SDWEAK.pkg.tar.zst")
checksums=("692ec08be5f9a90a3351c406ece1b0336facbb7ab3f064ff902e7cc1b32a4a79" "205777be0b87123e29db7b996ac883ba43f6ff6d253e7f065443905ac47046b6" "7d1f326afb32caabb0c0f82dba8b7e77de69264e243843369ffc3e13611de80c")
for i in {0..2}; do
    file="${files[i]}"
    expected="${checksums[i]}"

    [ -f "$file" ] || { red_msg "$(print_text nar_cel)"; exit 1; }

    actual=$(sha256sum "$file" | awk '{print $1}')
    [ "$actual" = "$expected" ] || {
        exit 1
    }
done


# Start of the main script
green_msg "$(print_text script_continue)"
clear
steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
MODEL=$(cat /sys/class/dmi/id/board_name)
BIOS_VERSION=$(cat /sys/class/dmi/id/bios_version)
log "VERSION: RELEASE 1.2" >> "$LOG_FILE" 2>&1
log "$MODEL" >> "$LOG_FILE" 2>&1
log "$BIOS_VERSION" >> "$LOG_FILE" 2>&1
log "$steamos_version" >> "$LOG_FILE" 2>&1
logo "

>>====================================================<<
|| ███████╗██████╗ ██╗    ██╗███████╗ █████╗ ██╗  ██╗ ||
|| ██╔════╝██╔══██╗██║    ██║██╔════╝██╔══██╗██║ ██╔╝ ||
|| ███████╗██║  ██║██║ █╗ ██║█████╗  ███████║█████╔╝  ||
|| ╚════██║██║  ██║██║███╗██║██╔══╝  ██╔══██║██╔═██╗  ||
|| ███████║██████╔╝╚███╔███╔╝███████╗██║  ██║██║  ██╗ ||
|| ╚══════╝╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝ ||
>>====================================================<<
TG: @biddbb
TG GROUP: @steamdeckoverclock
DONAT(RU): https://www.tinkoff.ru/cf/8HHVDNi8VMS
DONAT(All): https://www.donationalerts.com/r/biddbb
"
if [[ "$MODEL" != "Jupiter" && "$MODEL" != "Galileo" ]]; then
    red_msg "$(print_text copable)"
    sleep 5
    exit 1
fi
green_msg "$(print_text optimization_start)"
sudo steamos-readonly disable &>/dev/null
sudo systemctl enable --now sshd >> "$LOG_FILE" 2>&1
# pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf &>/dev/null
log "PACMAN INIT" >> "$LOG_FILE" 2>&1
sudo pacman-key --init >> "$LOG_FILE" 2>&1
sudo pacman-key --populate >> "$LOG_FILE" 2>&1
sudo pacman -Sy >> "$LOG_FILE" 2>&1
log "SED INSTALL" >> "$LOG_FILE" 2>&1
sudo pacman -S --noconfirm sed &>/dev/null
sudo pacman -S --noconfirm sed >> "$LOG_FILE" 2>&1
green_msg "$(print_text pacman_keys)"

# yet-tweak
sudo chmod 775 ./scripts/yet-tweak.sh &>/dev/null
sudo ./scripts/yet-tweak.sh
green_msg "$(print_text yet_mglru)"
green_msg "$(print_text yet_io)"
green_msg "$(print_text yet_ov)"
green_msg "$(print_text yet_un)"

# daemon install
green_msg "$(print_text tweaks_install)"
sudo rm /home/deck/daemon-install.sh &>/dev/null
cp ./scripts/daemon-install.sh /home/deck/daemon-install.sh &>/dev/null
sudo chmod 775 /home/deck/daemon-install.sh &>/dev/null
sudo /home/deck/daemon-install.sh
green_msg "$(print_text daem_anan)"

# tweaks enable
sudo mkdir -p /home/deck/.local/tweak/ &>/dev/null
sudo rm /home/deck/.local/tweak/SDWEAK.sh &>/dev/null
sudo rm /home/deck/.local/tweak/SDOC-TWEAKS.sh &>/dev/null
sudo cp ./home/deck/.local/tweak/SDWEAK.sh /home/deck/.local/tweak/SDWEAK.sh &>/dev/null
sudo rm /etc/systemd/system/tweak.service &>/dev/null
sudo cp ./etc/systemd/system/tweak.service /etc/systemd/system/tweak.service &>/dev/null
sudo chmod 777 /home/deck/.local/tweak/SDWEAK.sh &>/dev/null

# Enable ZRAM
sudo pacman -S --noconfirm holo-zram-swap zram-generator &>/dev/null

# FRAMETIME FIX LCD
fix() {
    while true; do
        tput setaf 3
        read -p "$(print_text fix_prompt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text fix_install)"
            sudo sed -i "s/ENABLE_GAMESCOPE_WSI=1/ENABLE_GAMESCOPE_WSI=0/g" /usr/bin/gamescope-session &>/dev/null
            log "VULKAN RADEON" >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/vulkan-radeon-SDWEAK.pkg.tar.zst >> "$LOG_FILE" 2>&1
            sudo pacman -S --noconfirm lib32-vulkan-radeon >> "$LOG_FILE" 2>&1
            green_msg "$(print_text fix_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            sudo sed -i "s/ENABLE_GAMESCOPE_WSI=0/ENABLE_GAMESCOPE_WSI=1/g" /usr/bin/gamescope-session &>/dev/null
            sudo pacman -S --noconfirm vulkan-radeon lib32-vulkan-radeon &>/dev/null
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
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

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
            sudo cp ./etc/systemd/system/energy.service /etc/systemd/system/energy.service &>/dev/null
            sudo rm /etc/systemd/system/energy.timer &>/dev/null
            sudo cp ./etc/systemd/system/energy.timer /etc/systemd/system/energy.timer &>/dev/null
            sudo systemctl daemon-reload &>/dev/null
            sudo systemctl enable --now energy.timer &>/dev/null
            green_msg "$(print_text batt_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
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

# kernel install
kernel-3.7() {
    while true; do
        tput setaf 3
        read -p "$(print_text kernel_prompt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            red_msg "$(print_text kernel_install)"
            log "SDKERNEL INSTALL" >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/linux-neptune-68-SDKERNEL.pkg.tar.zst >> "$LOG_FILE" 2>&1
            sudo pacman -U --noconfirm ./packages/linux-neptune-68-headers-SDKERNEL.pkg.tar.zst >> "$LOG_FILE" 2>&1
            log "REMOVE 6.11" >> "$LOG_FILE" 2>&1
            sudo pacman -R --noconfirm linux-neptune-611 >> "$LOG_FILE" 2>&1
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

# reboot
rebooot() {
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

# start tweaks
sudo systemctl daemon-reload &>/dev/null
sudo systemctl enable --now tweak.service &>/dev/null

# kernel
if { [ "$steamos_version" = "3.6" ] || [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    kernel-3.7
fi

# FRAMETIME FIX LCD
if [ "$MODEL" = "Jupiter" ] && { [ "$steamos_version" = "3.6" ] || [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    fix
fi

# 70Hz LCD
if [ "$MODEL" = "Jupiter" ] && { [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    hz
fi


if [ "$MODEL" = "Galileo" ] && { [ "$steamos_version" = "3.6" ] || [ "$steamos_version" = "3.7" ] || [ "$steamos_version" = "3.8" ]; }; then
    sudo pacman -Rdd --noconfirm xorg-xwayland-jupiter &>/dev/null
    sudo pacman -Sydd --noconfirm xorg-xwayland &>/dev/null
    sudo pacman -S --noconfirm vulkan-radeon lib32-vulkan-radeon gamescope &>/dev/null
fi

# clean tmp files
sudo rm /home/deck/daemon-install.sh &>/dev/null
sudo rm -r /home/deck/cachyos-ananicy-rules-git &>/dev/null

# great job
green_msg "$(print_text tweaks_applied)"
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
green_msg "$(print_text se) $elapsed_time $(print_text sec)"
log "COMPLETE" >> "$LOG_FILE" 2>&1

# reboot
rebooot
