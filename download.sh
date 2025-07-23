#!/bin/bash

PREFIX=$HOME

cd $PREFIX
rm -rf SDWEAK SDWEAK.zip
wget https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip
unzip SDWEAK.zip

# Create a desktop icons
rm -rf "$HOME"/Desktop/SDWeakUninstall.desktop 2>/dev/null
echo '#!/usr/bin/env xdg-open
[Desktop Entry]
Name=Uninstall CryoUtilities
Exec=bash ${PREFIX}/SDWEAK/uninstall.sh
Icon=delete
Terminal=false
Type=Application
StartupNotify=false' >"$HOME"/Desktop/SDWeakUninstall.desktop
chmod +x "$HOME"/Desktop/SDWeakUninstall.desktop

rm -rf "$HOME"/Desktop/SDWeak.desktop 2>/dev/null
echo "#!/usr/bin/env xdg-open
[Desktop Entry]
Name=CryoUtilities
Exec=bash ${PREFIX}/SDWEAK/install.sh
Icon=steamdeck-gaming-return
Terminal=false
Type=Application
StartupNotify=false" >"$HOME"/Desktop/CryoUtilities.desktop
chmod +x "$HOME"/Desktop/CryoUtilities.desktop

zenity --info --text="Download of SDWEAK has been completed!" --width=300
