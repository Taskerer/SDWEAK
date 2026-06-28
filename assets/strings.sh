declare -A texts

texts["en_ping_success"]="Internet connection established."
texts["ru_ping_success"]="Интернет-соединение установлено."
texts["en_ping_fail"]="No Internet connection. Please connect and run the script again."
texts["ru_ping_fail"]="Нет интернет-соединения. Подключитесь к сети и запустите скрипт снова."

texts["en_integrity_fail"]="SDWEAK integrity check failed — files are corrupted or missing. Reinstall SDWEAK."
texts["ru_integrity_fail"]="Проверка целостности SDWEAK не пройдена — файлы повреждены или отсутствуют. Переустановите SDWEAK."

texts["en_compatible"]="SDWEAK supports Steam Deck only (LCD / OLED)."
texts["ru_compatible"]="SDWEAK поддерживает только Steam Deck (LCD / OLED)."

texts["en_old_steamos"]="SDWEAK only supports SteamOS 3.8"
texts["ru_old_steamos"]="SDWEAK поддерживает только SteamOS 3.8"

texts["en_readonly_fail"]="Failed to disable read-only filesystem. Cannot continue."
texts["ru_readonly_fail"]="Не удалось отключить файловую систему только для чтения. Продолжение невозможно."

texts["en_installation_start"]="Starting SDWEAK installation..."
texts["ru_installation_start"]="Начинается установка SDWEAK..."

texts["en_skip"]="Skipping."
texts["ru_skip"]="Пропуск."

texts["en_invalid_input"]="Invalid input. Enter 'y' or 'n'."
texts["ru_invalid_input"]="Неверный ввод. Введите 'y' или 'n'."

texts["en_usbhid_success"]="USB controller polling rate increased to 1000 Hz."
texts["ru_usbhid_success"]="Частота опроса USB-контроллеров увеличена до 1000 Гц."

texts["en_scx_success"]="LAVD scheduler (scx) enabled."
texts["ru_scx_success"]="Планировщик LAVD (scx) включён."
texts["en_scx_warning"]="Could not confirm the LAVD scheduler is active. Check the log file."
texts["ru_scx_warning"]="Не удалось подтвердить активность планировщика LAVD. Проверьте лог-файл."

texts["en_sysctl_success"]="Sysfs/sysctl performance tweaks installed."
texts["ru_sysctl_success"]="Установлены sysfs/sysctl твики производительности."

texts["en_zram_conf"]="Optimized ZRAM configuration applied."
texts["ru_zram_conf"]="Применена улучшенная конфигурация ZRAM."

texts["en_gpu_optimization_success"]="Optimized GPU driver settings applied."
texts["ru_gpu_optimization_success"]="Применены улучшенные настройки драйвера GPU."

texts["en_frametime_fix_prompt"]="Install a fix for uneven frametime when using FPS limiting via QAM? (BETA)"
texts["ru_frametime_fix_prompt"]="Установить исправление неровного фреймтайма при лимите FPS через боковое меню Steam? (БЕТА)"
texts["en_frametime_fix_install"]="Installing a fix for uneven frametime..."
texts["ru_frametime_fix_install"]="Установка фикса фреймтайма.."
texts["en_frametime_fix_success"]="Fix for uneven frametime has been successfully installed."
texts["ru_frametime_fix_success"]="Фикс фреймтайма установлен."

texts["en_display_overclock_prompt"]="Unlock 70 Hz as the maximum display refresh rate?"
texts["ru_display_overclock_prompt"]="Разблокировать 70 Гц как максимальную частоту дисплея?"
texts["en_display_overclock_success"]="Maximum display refresh rate unlocked at 70 Hz."
texts["ru_display_overclock_success"]="Максимальная частота дисплея разблокирована до 70 Гц."

texts["en_power_efficiency_prompt"]="Set CPU power efficiency priority?"
texts["ru_power_efficiency_prompt"]="Установить приоритет энергоэффективности для CPU?"
texts["en_power_efficiency_install"]="Applying CPU power efficiency priority..."
texts["ru_power_efficiency_install"]="Установка приоритета энергоэффективности..."
texts["en_power_efficiency_success"]="CPU power efficiency priority successfully applied."
texts["ru_power_efficiency_success"]="Приоритет энергоэффективности для CPU успешно установлен."

texts["en_sdweak_success"]="SDWEAK installed successfully! Thanks for using it — if you'd like to support the project, you'll find a link in the GitHub repo."
texts["ru_sdweak_success"]="SDWEAK успешно установлен! Спасибо, что пользуешься — если захочешь поддержать проект, ссылка есть в репозитории на GitHub."

texts["en_installation_time"]="Installation completed in"
texts["ru_installation_time"]="Установка завершена за"
texts["en_seconds"]="seconds."
texts["ru_seconds"]="секунд."

texts["en_reboot_prompt"]="Reboot now to apply all changes?"
texts["ru_reboot_prompt"]="Перезагрузить сейчас для применения всех изменений?"
texts["en_reboot_required"]="Reboot is required to complete the installation!"
texts["ru_reboot_required"]="Для завершения установки необходима перезагрузка!"



texts["en_uninstall_start"]="Starting SDWEAK uninstallation..."
texts["ru_uninstall_start"]="Начинается удаление SDWEAK..."

texts["en_usbhid_reverted"]="USB controller polling rate restored to default."
texts["ru_usbhid_reverted"]="Частота опроса USB-контроллеров возвращена к стандартной."

texts["en_scx_reverted"]="LAVD scheduler disabled, stock scheduler restored."
texts["ru_scx_reverted"]="Планировщик LAVD отключён, восстановлен стоковый планировщик."

texts["en_sysctl_reverted"]="Sysfs/sysctl performance tweaks removed."
texts["ru_sysctl_reverted"]="Sysfs/sysctl твики производительности удалены."

texts["en_zram_reverted"]="Stock ZRAM configuration restored."
texts["ru_zram_reverted"]="Восстановлена стоковая конфигурация ZRAM."

texts["en_gpu_reverted"]="GPU driver settings restored to stock."
texts["ru_gpu_reverted"]="Настройки драйвера GPU возвращены к стоковым."

texts["en_frametime_reverted"]="Stock gamescope/vulkan-radeon packages restored."
texts["ru_frametime_reverted"]="Восстановлены стоковые пакеты gamescope/vulkan-radeon."

texts["en_display_reverted"]="Maximum display refresh rate restored to stock (60 Hz)."
texts["ru_display_reverted"]="Максимальная частота дисплея возвращена к стоковой (60 Гц)."

texts["en_power_efficiency_reverted"]="Power efficiency priority disabled."
texts["ru_power_efficiency_reverted"]="Приоритет энергоэффективности отключён."

texts["en_uninstall_success"]="SDWEAK has been removed. The system is restored to stock settings."
texts["ru_uninstall_success"]="SDWEAK удалён. Система возвращена к стоковым настройкам."

texts["en_uninstall_time"]="Uninstallation completed in"
texts["ru_uninstall_time"]="Удаление завершено за"

texts["en_valve_check_start"]="Checking access to Valve package server..."
texts["ru_valve_check_start"]="Проверка доступа к серверу пакетов Valve..."
texts["en_valve_check_success"]="Valve package server is accessible."
texts["ru_valve_check_success"]="Сервер пакетов Valve доступен."
texts["en_valve_check_fail"]="No access to Valve package server. Your ISP may have blocked Valve's servers. Try switching to another network or using a VPN."
texts["ru_valve_check_fail"]="Нет доступа к серверу пакетов Valve. Провайдер мог заблокировать серверы Valve. Попробуйте другую сеть или VPN."
texts["en_valve_check_prompt"]="Continue anyway? pacman operations may fail without Valve server access."
texts["ru_valve_check_prompt"]="Всё равно продолжить? Операции pacman могут завершиться ошибкой без доступа к серверу Valve."
texts["en_valve_check_warn"]="Warning: continuing without Valve server access. Some steps may fail."
texts["ru_valve_check_warn"]="Внимание: продолжаем без доступа к серверу Valve. Часть шагов может завершиться с ошибкой."
texts["en_valve_check_abort"]="Uninstallation aborted: no access to Valve package server."
texts["ru_valve_check_abort"]="Удаление прервано: нет доступа к серверу пакетов Valve."
