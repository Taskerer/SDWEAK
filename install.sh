#!/bin/bash

# Checking root access
if [ "$(id -u)" != "0" ]; then
    PASSWORD=$(zenity --password --title="Введите пароль sudo")
    if [ -z "$PASSWORD" ]; then
        zenity --error --text="Пароль не был введен. Скрипт завершен." --title="Ошибка"
        exit 1
    fi
    echo "$PASSWORD" | sudo -S echo "" 2>/dev/null
    if [ $? -ne 0 ]; then
        zenity --error --text="Неверный пароль. Скрипт завершен." --title="Ошибка"
        exit 1
    fi
fi

# backup
BACKUP_DIR="/tmp/install_backup"
sudo mkdir -p "$BACKUP_DIR"
start_time=$(date +%s)
backup_file() {
    local file="$1"
    if [ -f "$file" ]; then
        sudo cp "$file" "$BACKUP_DIR"
    fi
}

# Check if Bash supports associative arrays
if [[ ${BASH_VERSINFO[0]} -lt 4 ]]; then
    echo "This script requires Bash 4.0 or higher."
    exit 1
fi

# Associative arrays for storing texts in different languages
declare -A texts

# Fill the arrays with texts for each language
texts["en_root_check"]="This script must be run as root."
texts["ru_root_check"]="Этот скрипт должен быть запущен с правами root."
texts["en_ping_success"]="Internet connection established."
texts["ru_ping_success"]="Интернет соединение установлено."

texts["en_ping_fail"]="No internet connection! Please connect to the internet and run the script again."
texts["ru_ping_fail"]="Отсутствует интернет соединение! Пожалуйста, подключитесь к интернету и запустите скрипт снова."

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
texts["en_zswap_promt"]="Install ZSWAP?"
texts["ru_zswap_promt"]="Установить ZSWAP?"

texts["en_skip"]="Skipping..."
texts["ru_skip"]="Пропуск..."

texts["en_invalid_input"]="Invalid input. Please enter 'y' or 'n'."
texts["ru_invalid_input"]="Неправильный ввод. Пожалуйста, введите 'y' или 'n'."

texts["en_kernel_install"]="Starting kernel installation..."
texts["ru_kernel_install"]="Начинается установка ядра..."
texts["en_kernel_success"]="Kernel successfully installed."
texts["ru_kernel_success"]="Ядро успешно установлено."
texts["en_kernel_promt"]="Install optimized kernel?"
texts["ru_kernel_promt"]="Установить оптимизированное ядро?"

texts["en_reboot_promt"]="Reboot to apply changes?"
texts["ru_reboot_promt"]="Перезагрузить для применения изменений?"
texts["en_reboot_required"]="Reboot is required."
texts["ru_reboot_required"]="Обязательно перезагрузите."

texts["en_fix_install"]="Starting microstutters fix installation..."
texts["ru_fix_install"]="Начинается установка исправление микрозаиканий..."
texts["en_fix_success"]="Microstutters fix successfully installed."
texts["ru_fix_success"]="Исправление микрозаиканий успешно установлено."
texts["en_fix_promt"]="Install microstutters fix?"
texts["ru_fix_promt"]="Установить исправление микрозаиканий?"

texts["en_hz_install"]="Starting Overclocking to 70Hz installation..."
texts["ru_hz_install"]="Начинается установка разгона дисплея до 70Hz..."
texts["en_hz_success"]="Overclocking to 70Hz successfully installed."
texts["ru_hz_success"]="Разгон до 70Hz успешно установлен."
texts["en_hz_promt"]="Overclock the display to 70Hz?"
texts["ru_hz_promt"]="Разогнать дисплей до 70Hz?"

texts["en_batt_install"]="Starting to prioritize power efficiency..."
texts["ru_batt_install"]="Начинается установка приоритета энергоэффективности..."
texts["en_batt_success"]="Power efficiency prioritization successfully installed."
texts["ru_batt_success"]="Приоритет энергоэффективности успешно установлен."
texts["en_batt_promt"]="Prioritize power efficiency?"
texts["ru_batt_promt"]="Установить приоритет энергоэффективности?"

texts["en_audio_install"]="Starting to install the sound driver fix..."
texts["ru_audio_install"]="Начинается установка фикса звукового драйвера..."
texts["en_audio_success"]="Sound driver fix successfully installed."
texts["ru_audio_success"]="Фикс звукового драйвера успешно установлен."
texts["en_audio_promt"]="Install sound driver fix?(only if there are problems!)"
texts["ru_audio_promt"]="Установить фикс звукового драйвера?(только при проблемах!)"

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
texts["en_daem_irq"]="irqbalance successfully installed."
texts["ru_daem_irq"]="irqbalance успешно установлен."

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

# Start of the main script
green_msg "$(print_text script_continue)"
clear
steamos_version=$(cat /etc/os-release | grep -i version_id | cut -d "=" -f2 | cut -d "." -f1,2)
MODEL=$(cat /sys/class/dmi/id/board_name)
BIOS_VERSION=$(cat /sys/class/dmi/id/bios_version)
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
"
if [[ "$MODEL" != "Jupiter" && "$MODEL" != "Galileo" ]]; then
    red_msg "$(print_text copable)"
    sleep 5
    exit 1
fi
green_msg "$(print_text optimization_start)"
# pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf &>/dev/null
sudo steamos-readonly disable &>/dev/null
sudo pacman-key --init &>/dev/null
sudo pacman-key --populate &>/dev/null
sudo pacman -Sy &>/dev/null
sudo pacman -S --noconfirm sed &>/dev/null
sudo pacman -S --noconfirm sed &>/dev/null
green_msg "$(print_text pacman_keys)"

# yet-tweak
sudo chmod 775 ./scripts/yet-tweak.sh
sudo ./scripts/yet-tweak.sh
green_msg "$(print_text yet_mglru)"
green_msg "$(print_text yet_io)"
green_msg "$(print_text yet_ov)"
green_msg "$(print_text yet_un)"

# daemon install
green_msg "$(print_text tweaks_install)"
sudo rm /home/deck/daemon-install.sh &>/dev/null
cp ./scripts/daemon-install.sh /home/deck/daemon-install.sh
sudo chmod 775 /home/deck/daemon-install.sh
sudo /home/deck/daemon-install.sh
green_msg "$(print_text daem_anan)"
green_msg "$(print_text daem_irq)"

# tweaks enable
sudo mkdir -p /home/deck/.local/tweak/
sudo rm /home/deck/.local/tweak/SDOC-TWEAKS.sh &>/dev/null
sudo cp ./home/deck/.local/tweak/SDOC-TWEAKS.sh /home/deck/.local/tweak/SDOC-TWEAKS.sh
sudo rm /etc/systemd/system/tweak.service &>/dev/null
sudo cp ./etc/systemd/system/tweak.service /etc/systemd/system/tweak.service
sudo chmod 777 /home/deck/.local/tweak/SDOC-TWEAKS.sh

# Enable ZSWAP function
zswap_en() {
    while true; do
        tput setaf 3
        read -p "$(print_text zswap_promt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            red_msg "$(print_text zswap_enable)"
            sudo pacman -R --noconfirm holo-zram-swap zram-generator &>/dev/null
            backup_file /etc/systemd/zram-generator.conf &>/dev/null
            backup_file /usr/lib/systemd/zram-generator.conf &>/dev/null
            sudo rm /etc/systemd/zram-generator.conf &>/dev/null
            sudo rm /usr/lib/systemd/zram-generator.conf &>/dev/null
            sudo echo "# ZSWAP" >> /home/deck/.local/tweak/SDOC-TWEAKS.sh
            sudo echo "write /sys/module/zswap/parameters/enabled 1" >> /home/deck/.local/tweak/SDOC-TWEAKS.sh
            sudo echo "write /sys/module/zswap/parameters/compressor lz4" >> /home/deck/.local/tweak/SDOC-TWEAKS.sh
            sudo echo "write /sys/module/zswap/parameters/zpool z3fold" >> /home/deck/.local/tweak/SDOC-TWEAKS.sh
            sudo echo "write /sys/module/zswap/parameters/max_pool_percent 25" >> /home/deck/.local/tweak/SDOC-TWEAKS.sh
            green_msg "$(print_text zswap_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
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
        read -p "$(print_text kernel_promt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            red_msg "$(print_text kernel_install)"
            sudo pacman -U --noconfirm ./packages/linux-neptune-68-SDKERNEL.pkg.tar.zst &>/dev/null
            sudo pacman -U --noconfirm ./packages/linux-neptune-68-headers-SDKERNEL.pkg.tar.zst &>/dev/null
            sudo pacman -R --noconfirm linux-neptune-611 &>/dev/null
            sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
            green_msg "$(print_text kernel_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            green_msg "$(print_text skip)"
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

# FRAMETIME FIX LCD
fix() {
    while true; do
        tput setaf 3
        read -p "$(print_text fix_promt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text fix_install)"
            sudo sed -i "s/ENABLE_GAMESCOPE_WSI=1/ENABLE_GAMESCOPE_WSI=0/g" /usr/bin/gamescope-session &>/dev/null
            green_msg "$(print_text fix_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
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
        read -p "$(print_text hz_promt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
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
        read -p "$(print_text batt_promt) [Y/n]: " answer
        tput sgr0
        answer=${answer:-y}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text batt_install)"
            if grep "usbhid.jspoll=1" /etc/default/grub &>/dev/null; then
                echo 1 > /dev/null
            else
                sudo sed -i 's/\bGRUB_CMDLINE_LINUX_DEFAULT="\b/&amd_pstate=active /' /etc/default/grub &>/dev/null
                sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
            fi
            sudo rm /etc/systemd/system/energy.service &>/dev/null
            sudo cp ./etc/systemd/system/energy.service /etc/systemd/system/energy.service
            sudo rm /etc/systemd/system/energy.timer &>/dev/null
            sudo cp ./etc/systemd/system/energy.timer /etc/systemd/system/energy.timer
            sudo systemctl enable --now energy.timer &>/dev/null
            green_msg "$(print_text batt_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            sudo sed -i 's/\bGRUB_CMDLINE_LINUX_DEFAULT="\b/&amd_pstate=disable /' /etc/default/grub &>/dev/null
            sudo grub-mkconfig -o /boot/efi/EFI/steamos/grub.cfg &>/dev/null
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
        read -p "$(print_text reboot_promt) [Y/n]: " answer
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

# audio fix
audio() {
    while true; do
        tput setaf 3
        read -p "$(print_text audio_promt) [y/N]: " answer
        tput sgr0
        answer=${answer:-n}
        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            green_msg "$(print_text audio_install)"
            sudo sed -i "s/main/3.5/g" /etc/pacman.conf &>/dev/null
            sudo pacman -S --noconfirm steamdeck-dsp &>/dev/null
            sudo sed -i "s/3.5/main/g" /etc/pacman.conf &>/dev/null
            green_msg "$(print_text audio_success)"
            break
        elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
            break
        else
            red_msg "$(print_text invalid_input)"
        fi
    done
}

# call zswap function
zswap_en

# start tweaks
sudo systemctl daemon-reload &>/dev/null
sudo systemctl enable --now tweak.service &>/dev/null

# kernel and audio fix
if [ $steamos_version = 3.7 ]; then
    kernel-3.7
    audio
fi

# battery
if [ "$steamos_version" = "3.7" ]; then
    if [ "$MODEL" = "Galileo" ]; then
        battery
    elif [ "$MODEL" = "Jupiter" ] && [ "$BIOS_VERSION" = "F7A0131" ]; then
        battery
    fi
fi

# FRAMETIME FIX LCD
if [ "$MODEL" = "Jupiter" ] && { [ "$steamos_version" = "3.6" ] || [ "$steamos_version" = "3.7" ]; }; then
    fix
fi

# vulkan fix
if { [ "$steamos_version" = "3.6" ] || [ "$steamos_version" = "3.7" ]; }; then
    sudo pacman -U --noconfirm ./packages/vulkan-radeon-SDWEAK.pkg.tar.zst &>/dev/null
    sudo pacman -S --noconfirm lib32-vulkan-radeon &>/dev/null
fi

# 70Hz LCD
if [ "$MODEL" = "Jupiter" ] && { [ "$steamos_version" = "3.7" ]; }; then
    hz
fi

# clean tmp files
sudo rm /home/deck/daemon-install.sh &>/dev/null
sudo rm -r /home/deck/cachyos-ananicy-rules-git &>/dev/null

# great job
green_msg "$(print_text tweaks_applied)"
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
green_msg "$(print_text se) $elapsed_time $(print_text sec)"

# reboot
rebooot
