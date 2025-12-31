#!/bin/bash

# Connecting a file with translations
source ./packages/lang.sh

# Connect a common script with functions and variables
source ./scripts/common.sh

# Root check
check_root
sudo steamos-readonly disable

# Set up logging
sudo rm -f "$HOME/SDWEAK-install.log"
LOG_FILE="$HOME/SDWEAK-install.log"

# Select_lang [ru|en]
choose_language() {
  clear
  sleep 0.3
  green_msg "Please select your language / Пожалуйста, выберите язык:"
  red_msg "1. Русский"
  red_msg "2. English"
  read -p "Enter the needed number / Введите нужную цифру: " choice
  case $choice in
  1) selected_lang="ru" ;;
  2) selected_lang="en" ;;
  *) red_msg "Неверный выбор. По умолчанию выбран Русский."; selected_lang="ru" ;;
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
  sleep 10
  exit 1
fi

# Checking access to Valve's server
if curl --speed-limit 3 --speed-time 2 --max-time 30 https://steamdeck-packages.steamos.cloud/archlinux-mirror/core-main/os/x86_64/sed-4.9-3-x86_64.pkg.tar.zst --output /dev/null &>/dev/null; then
  green_msg "$(print_text server_success)"
else
  err_msg "$(print_text server_fail)"
  sleep 10
  exit 1
fi

# Validation of checksums of binary files
files=(
  "./packages/linux-charcoal-611-headers-6.11.11.valve26-3-x86_64.pkg.tar.zst"
  "./packages/linux-charcoal-611-6.11.11.valve26-3-x86_64.pkg.tar.zst"
  "./packages/cachyos-ananicy-rules-git-latest-plus-SDWEAK.pkg.tar.zst"
  "./packages/gamescope-3.16.14.5-1-SDWEAK.pkg.tar.zst"
  "./packages/vulkan-radeon-24.3.0-SDWEAK.pkg.tar.zst"
)
checksums=(
  "beb9ebf803f1dba93cfc5ecd3e2ffa7ebbf4521db9226eba95708efde932b588"
  "cf31e0f26e9588d22b0c6febbadf84336813c6d3c8e5129c1dbb4652210649b6"
  "77340e7e86ad598ea42a19224ff9dd0c0c63ddd023d8b9e11eada2c8a2c3d6f6"
  "c1250cb3ad97f296204e29b6f359dc6bd91c4cd0dc515cb0e8fd5f9e11616295"
  "10f7cc049a6eaaa37f48a0ebfe309614a7959bf3818c5790e8c365506eec2772"
)
for i in "${!files[@]}"; do
  file="${files[i]}"
  [[ -f "$file" ]] || { err_msg "$(print_text integrity_fail)"; sleep 10; exit 1; }
  [[ $(sha256sum "$file" | awk '{print $1}') == "${checksums[i]}" ]] \
    || { err_msg "$(print_text integrity_fail)"; sleep 10; exit 1; }
done

# Function for checking the availability of files
check_file() {
  local file_path="$1"
  if [[ ! -f "$file_path" ]]; then
    err_msg "$(print_text integrity_fail)"
    sleep 10
    exit 1
  fi
}

# --- Main ---
check_file "./packages/lang.sh"
start_time=$(date +%s)
clear
{
log "DATE: $DATE"
log "SDWEAK $SDWEAK_VERSION"
log "STEAMOS: $steamos_version"
log "MODEL: $MODEL"
log "BIOS: $BIOS_VERSION"
} >>"$LOG_FILE" 2>&1
# Logo
print_logo

# Compatibility check
if [[ "$MODEL" != "Jupiter" && "$MODEL" != "Galileo" ]]; then
  err_msg "$(print_text compatible)"
  sleep 10
  exit 1
fi
if [ "$steamos_version" != "3.7" ]; then
  err_msg "$(print_text old_steamos)"
  sleep 10
  exit 1
fi

# -- Start --
green_msg "$(print_text installation_start)"
sudo systemctl enable --now sshd >>"$LOG_FILE" 2>&1

# Pacman
sudo sed -i "s/Required DatabaseOptional/TrustAll/g" /etc/pacman.conf &>/dev/null
log "PACMAN INIT" >>"$LOG_FILE" 2>&1
sudo rm -rf /home/.steamos/offload/var/cache/pacman/pkg/{*,.*} &>/dev/null
sudo rm -rf /etc/pacman.d/gnupg &>/dev/null
sudo pacman-key --init >>"$LOG_FILE" 2>&1
sudo pacman-key --populate >>"$LOG_FILE" 2>&1
if ! sudo pacman -Sy >>"$LOG_FILE" 2>&1; then
  err_msg "$(print_text error_sys)"
  sleep 10
  exit 1
fi
log "SED INSTALL" >>"$LOG_FILE" 2>&1
sudo pacman -S --noconfirm sed &>/dev/null
if ! sudo pacman -S --noconfirm sed >>"$LOG_FILE" 2>&1; then
  err_msg "$(print_text error_sys)"
  sleep 10
  exit 1
fi

# Yet-tweak
check_file "./scripts/yet-tweak.sh"
sudo chmod 775 ./scripts/yet-tweak.sh &>/dev/null
sudo --preserve-env=HOME ./scripts/yet-tweak.sh
green_msg "$(print_text yet_mglru)"
green_msg "$(print_text yet_input)"
green_msg "$(print_text yet_services)"

# Ananicy-cpp
green_msg "$(print_text ananicy_install)"
check_file "./scripts/daemon-install.sh"
sudo chmod 775 ./scripts/daemon-install.sh &>/dev/null
sudo --preserve-env=HOME ./scripts/daemon-install.sh
green_msg "$(print_text daemon_ananicy)"

# Sysctl Tweaks
sudo rm -f $HOME/.local/tweak/SDWEAK.sh &>/dev/null
sudo rm -rf $HOME/.local/tweak/ &>/dev/null
sudo rm -f /etc/systemd/system/tweak.service &>/dev/null
sudo mkdir -p $HOME/.local/tweak/ &>/dev/null
check_file "./packages/SDWEAK.sh"
sudo cp -f ./packages/SDWEAK.sh $HOME/.local/tweak/SDWEAK.sh &>/dev/null
check_file "./packages/tweak.service"
sudo cp -f ./packages/tweak.service /etc/systemd/system/tweak.service &>/dev/null
sudo chmod 777 $HOME/.local/tweak/SDWEAK.sh &>/dev/null

# I/O schedulers
sudo rm -f /etc/udev/rules.d/60-ioschedulers.rules &>/dev/null
check_file "./packages/60-ioschedulers.rules"
sudo cp ./packages/60-ioschedulers.rules /etc/udev/rules.d/60-ioschedulers.rules &>/dev/null
green_msg "$(print_text sysfs_optimization)"

# ZRAM Tweaks
sudo pacman -S --noconfirm --needed holo-zram-swap zram-generator &>/dev/null
check_file "./packages/zram-generator.conf"
sudo cp -f ./packages/zram-generator.conf /usr/lib/systemd/zram-generator.conf &>/dev/null
sudo systemctl restart systemd-zram-setup@zram0 &>/dev/null
green_msg "$(print_text zram_conf)"

# Frametime fix
frametime_fix() {
  while true; do
    tput setaf 3
    read -p "$(print_text frametime_fix_prompt) [y/N]: " answer
    tput sgr0
    answer=${answer:-n}
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      red_msg "$(print_text frametime_fix_install)"
      sudo pacman -U --noconfirm ./packages/gamescope-3.16.14.5-1-SDWEAK.pkg.tar.zst >>"$LOG_FILE" 2>&1
      sudo pacman -U --noconfirm ./packages/vulkan-radeon-24.3.0-SDWEAK.pkg.tar.zst >>"$LOG_FILE" 2>&1
      sudo pacman -S --noconfirm --needed lib32-vulkan-radeon >>"$LOG_FILE" 2>&1
      green_msg "$(print_text frametime_fix_success)"
      break
    elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
      green_msg "$(print_text skip)"
      sudo pacman -S --noconfirm gamescope vulkan-radeon &>/dev/null
      sudo pacman -S --noconfirm --needed lib32-vulkan-radeon >>"$LOG_FILE" 2>&1
      break
    else
      red_msg "$(print_text invalid_input)"
    fi
  done
}

# Overclock LCD to 70Hz
display_overclock() {
  while true; do
    tput setaf 3
    read -p "$(print_text display_overclock_prompt) [y/N]: " answer
    tput sgr0
    answer=${answer:-n}
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      if ! grep -q "68, 69," "$LUA_PATH"; then
        sudo sed -z -i.bak "s/$ORIGINAL_STRING/$MODIFIED_STRING/" "$LUA_PATH"
      fi
      green_msg "$(print_text display_overclock_success)"
      break
    elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
      green_msg "$(print_text skip)"
      LUA_BAK_PATH="${LUA_PATH}.bak"
      if [ -f "$LUA_BAK_PATH" ]; then
        sudo mv "$LUA_BAK_PATH" "$LUA_PATH"
      else
        sudo sed -z -i "s/$MODIFIED_STRING/$ORIGINAL_STRING/" "$LUA_PATH"
      fi
      break
    else
      red_msg "$(print_text invalid_input)"
    fi
  done
}

# Power efficiency priority
power_efficiency() {
  while true; do
    tput setaf 3
    read -p "$(print_text power_efficiency_prompt) [y/N]: " answer
    tput sgr0
    answer=${answer:-n}
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      red_msg "$(print_text power_efficiency_install)"
      sudo sed -i -E '/^GRUB_CMDLINE_LINUX_DEFAULT=/ {
                s/(amd_pstate=)[^ "]*//g
                s/(=")(.*")/\1amd_pstate=active \2/
                s/  +/ /g
                s/" /"/}' "$GRUB"
      sudo rm -f /etc/systemd/system/energy.service &>/dev/null
      check_file "./packages/energy.service"
      sudo cp ./packages/energy.service /etc/systemd/system/energy.service &>/dev/null
      sudo rm -f /etc/systemd/system/energy.timer &>/dev/null
      check_file "./packages/energy.timer"
      sudo cp ./packages/energy.timer /etc/systemd/system/energy.timer &>/dev/null
      sudo systemctl daemon-reload &>/dev/null
      sudo systemctl enable --now energy.timer &>/dev/null
      green_msg "$(print_text power_efficiency_success)"
      break
    elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
      green_msg "$(print_text skip)"
      sudo systemctl disable energy.timer &>/dev/null
      sudo rm -f /etc/systemd/system/energy.service &>/dev/null
      sudo rm -f /etc/systemd/system/energy.timer &>/dev/null
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
    read -p "$(print_text sdkernel_prompt) [Y/n]: " answer
    tput sgr0
    answer=${answer:-y}
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      red_msg "$(print_text sdkernel_install)"
      log "SDKERNEL INSTALL" >>"$LOG_FILE" 2>&1
      sudo pacman -R --noconfirm linux-neptune-611 >>"$LOG_FILE" 2>&1
      sudo pacman -U --noconfirm ./packages/linux-charcoal-611-6.11.11.valve26-3-x86_64.pkg.tar.zst >>"$LOG_FILE" 2>&1
      sudo pacman -R --noconfirm linux-neptune-611-headers >>"$LOG_FILE" 2>&1
      sudo pacman -U --noconfirm ./packages/linux-charcoal-611-headers-6.11.11.valve26-3-x86_64.pkg.tar.zst >>"$LOG_FILE" 2>&1
      sudo grub-mkconfig -o "$GRUB_CFG" &>/dev/null
      check_file "./packages/thp-shrinker.conf"
      sudo rm -f /usr/lib/tmpfiles.d/thp-shrinker.conf &>/dev/null
      sudo cp -f ./packages/thp-shrinker.conf /usr/lib/tmpfiles.d/thp-shrinker.conf &>/dev/null
      green_msg "$(print_text sdkernel_success)"
      if [[ "$MODEL" = "Galileo" || ( "$MODEL" = "Jupiter" && ( "$BIOS_VERSION" = "F7A0131" || "$BIOS_VERSION" = "F7A0133" ) ) ]]; then
        power_efficiency
      fi
      break
    elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
      green_msg "$(print_text skip)"
      sudo pacman -S --noconfirm linux-neptune-611 >>"$LOG_FILE" 2>&1
      sudo pacman -R --noconfirm linux-neptune-611-headers >>"$LOG_FILE" 2>&1
      sudo rm -f /usr/lib/tmpfiles.d/thp-shrinker.conf &>/dev/null
      break
    else
      red_msg "$(print_text invalid_input)"
    fi
  done
}

# AMDGPU optimization
gpu_optimization() {
  while true; do
    tput setaf 3
    read -p "$(print_text gpu_optimization_prompt) [Y/n]: " answer
    tput sgr0
    answer=${answer:-y}
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      # Changing amdgpu parameters
      echo "options gpu_sched sched_policy=0" | sudo tee /etc/modprobe.d/amdgpu.conf &>/dev/null
      echo "options amdgpu mes=1 moverate=128 uni_mes=1 lbpw=0 mes_kiq=1" | sudo tee -a /etc/modprobe.d/amdgpu.conf &>/dev/null
      green_msg "$(print_text gpu_optimization_success)"
      break
    elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
      green_msg "$(print_text skip)"
      sudo rm -f /etc/modprobe.d/amdgpu.conf &>/dev/null
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
      sleep 5
      break
    else
      red_msg "$(print_text invalid_input)"
    fi
  done
}

# SDKERNEL and Frametime fix
sdkernel

# display overclock LCD
if [ "$MODEL" = "Jupiter" ]; then
  frametime_fix
  display_overclock
fi

# GPU optimization
gpu_optimization

sudo systemctl daemon-reload &>/dev/null
sudo systemctl enable --now tweak.service &>/dev/null
sudo mkinitcpio -P &>/dev/null
sudo grub-mkconfig -o "$GRUB_CFG" &>/dev/null

# Clean tmp files
red_msg "$(print_text sdweak_success)"
sleep 3
end_time=$(date +%s)
elapsed_time=$((end_time - start_time))
green_msg "$(print_text installation_time) $elapsed_time $(print_text seconds)"
log "COMPLETE" >>"$LOG_FILE" 2>&1
sleep 1

# reboot
sys-reboot
