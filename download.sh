#!/bin/bash

# Установка переменных
PREFIX="$HOME"
DESKTOP_DIR="$HOME/Desktop"
APP_DIR="$PREFIX/SDWEAK"
ZIP_URL="https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip"

# Очистка предыдущих файлов
cd "$PREFIX" || exit 1
rm -rf "$APP_DIR" "$APP_DIR.zip"

# Загрузка и распаковка
wget "$ZIP_URL" -O SDWEAK.zip || {
  zenity --error --text="Не удалось скачать SDWEAK!" --width=300
  exit 1
}

unzip SDWEAK.zip || {
  zenity --error --text="Не удалось распаковать архив!" --width=300
  exit 1
}

rm -rf "$APP_DIR"
mv SDWEAK "$APP_DIR"
rm SDWEAK.zip

# Создание ярлыка запуска
cat <<EOF >"$DESKTOP_DIR/SDWeak.desktop"
[Desktop Entry]
Name=SDWeak
Exec=$APP_DIR/install.sh
Icon=system-software-update
Terminal=true
Type=Application
StartupNotify=false
EOF
chmod +x "$DESKTOP_DIR/SDWeak.desktop"

# Создание ярлыка удаления
cat <<EOF >"$DESKTOP_DIR/SDWeakUninstall.desktop"
[Desktop Entry]
Name=Uninstall SDWeak
Exec=$APP_DIR/uninstall.sh
Icon=edit-delete
Terminal=true
Type=Application
StartupNotify=false
EOF
chmod +x "$DESKTOP_DIR/SDWeakUninstall.desktop"

# Уведомление об успешной установке
zenity --info --text="SDWEAK успешно загружен и установлен!" --width=300
