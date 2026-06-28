#!/bin/bash
# SDWEAK Installer — https://github.com/Taskerer/SDWEAK

set -euo pipefail

# Configuration
readonly APP_NAME="SDWEAK"
readonly APP_DIR="$HOME/SDWEAK"
readonly DESKTOP_DIR="${XDG_DESKTOP_DIR:-$(xdg-user-dir DESKTOP 2>/dev/null || echo "$HOME/Desktop")}"
readonly ZIP_URL="https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip"
TMP_ZIP="$(mktemp /tmp/sdweak-XXXXXX.zip)"
readonly TMP_ZIP

# Helpers
die() {
    zenity --error --title="$APP_NAME Installer" --text="$*" --width=360 2>/dev/null \
        || echo -e "\nERROR: $*" >&2
    exit 1
}
step() { echo "[ $APP_NAME ] $*"; }

# Cleanup on any exit
cleanup() { rm -f "$TMP_ZIP"; }
trap cleanup EXIT

# Network check
step "Checking internet connection..."
if ! wget -q --spider --timeout=10 https://github.com 2>/dev/null; then
    die "No internet connection detected.\nPlease check your network and try again."
fi

# Remove previous installation
step "Removing previous installation (if any)..."
rm -rf "$APP_DIR"
rm -f "$DESKTOP_DIR/SDWEAK-uninstaller.desktop"

# Download ZIP
step "Downloading $APP_NAME..."
wget -q --show-progress --timeout=60 -O "$TMP_ZIP" "$ZIP_URL" \
    || die "Download failed.\nCheck your internet connection and try again."

# Extract archive
step "Extracting $APP_NAME..."
unzip -q "$TMP_ZIP" -d "$HOME" \
    || die "Extraction failed — the archive may be corrupted.\nPlease try downloading again."

[[ -d "$APP_DIR" ]] \
    || die "Extraction completed but '$APP_DIR' was not created.\nThe archive structure may be wrong."

[[ -f "$APP_DIR/install.sh" ]] \
    || die "install.sh not found in '$APP_DIR' — the archive may be incomplete."

chmod +x "$APP_DIR/install.sh"

# Create uninstaller shortcut
step "Creating uninstaller shortcut on Desktop..."
cat > "$DESKTOP_DIR/SDWEAK-uninstaller.desktop" <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Uninstall SDWEAK
Comment=Remove SDWEAK
Categories=Settings
Exec=pkexec env HOME="$HOME" bash -c 'cd "$APP_DIR" && ./uninstall.sh'
Icon=delete
StartupNotify=false
Terminal=true
EOF
chmod +x "$DESKTOP_DIR/SDWEAK-uninstaller.desktop"

# Run installer
step "Running $APP_NAME installer..."
cd "$APP_DIR"
sudo --preserve-env=HOME ./install.sh
