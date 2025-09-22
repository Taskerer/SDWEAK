#!/bin/bash

# Sets variables
PREFIX="$HOME"
DESKTOP_DIR="$HOME/Desktop"
APP_DIR="$PREFIX/SDWEAK"
ZIP_URL="https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip"

# Clearing previous files
cd "$PREFIX" || exit 1
rm -rf "$APP_DIR" "$APP_DIR.zip"
rm -f "$DESKTOP_DIR/SDWEAK-uninstaller.desktop"

# Downloading and unpacking
wget "$ZIP_URL" -O SDWEAK.zip || {
  zenity --error --text="Failed to download SDWEAK!" --width=300
  exit 1
}

unzip SDWEAK.zip -d "$PREFIX" || {
  zenity --error --text="Failed to unpack the archive!" --width=300
  exit 1
}
rm -f SDWEAK.zip

# Creating a delete shortcut
cat <<EOF >"$DESKTOP_DIR/SDWEAK-uninstaller.desktop"
[Desktop Entry]
Categories=Settings
Exec=pkexec env HOME="$HOME" bash -c 'cd $APP_DIR; ./uninstall.sh'
Icon=delete
Name=Uninstall SDWEAK
StartupNotify=false
Terminal=true
Type=Application
EOF
chmod +x "$DESKTOP_DIR/SDWEAK-uninstaller.desktop"

# Install SDWEAK
clear
cd $APP_DIR
sudo --preserve-env=HOME ./install.sh
