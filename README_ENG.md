# SDWEAK

📄 [RUSSIAN README](README.md)

## Installation
> **Important:** Before installation, be sure to uninstall **Cryo Utility** if it was previously installed.
> SDWEAK updates can be installed over the old version. After updating **SteamOS**, it is recommended to reinstall SDWEAK over the old version as well.

### Installation steps:

1. Switch to **desktop mode**.
2. Open **Konsole**.
3. Set a `sudo` password (if you haven't already done so):

   ```bash
   passwd
   ```
4. Download the [installation shortcut](https://raw.githubusercontent.com/Taskerer/SDWEAK/refs/heads/main/SDWEAK-installer.desktop):  
   Right-click on the link → **Save as...** and save it to your desktop (if using Firefox, delete .download at the end of the file).  
   Then double-click the file to start the installation.

## Update
1. Switch to **desktop mode**.
2. Double-click the previously downloaded shortcut “Install SDWEAK” (SDWEAK-installer.desktop).
The script will automatically install the latest version over the current one.

## Uninstallation

If you encounter any problems, please let us know!

1. Switch to **desktop mode**.
2. Run the `Uninstall SDWEAK` shortcut on the desktop.

## Support the project

If you like SDWEAK and want to support its development:

- 💳 [Support via Tinkoff](https://www.tinkoff.ru/cf/8HHVDNi8VMS)

Thank you for using SDWEAK!

## What does SDWEAK offer?
- Increased **minimum**, **average**, and **maximum FPS**
- Improved **smoothness**, **response**, and **frame time**
- Reduction in the number of **stutters** and **microfreezes**
- More stable performance when RAM is low
- Improving **process planning**
- Overall improvement in system responsiveness and gaming experience

> ⚠️ **Note:** Performance gains vary depending on the specific game.

## Optional features

> The optimal configuration is used by default.
> Some features are only available on Steam Deck LCD and will not be available on Steam Deck OLED.
> Some features are only available on SteamOS 3.7 and will not be available on SteamOS 3.8.

- **Fixes uneven frame rates when using FPS limiting via QAM. Only for SteamOS 3.7 and LCD (BETA)**  
  Eliminates micro-freezes and frame rate spikes caused by FPS limiting via QAM (Steam side menu).

- **Overclocking the screen to 70 Hz. (LCD)**  
  Increases the screen refresh rate to 70Hz. Useful for limiting 35FPS(70Hz) and for using the 70FPS(70Hz) limit in undemanding projects.

- **Optimized Linux kernel. Only for SteamOS 3.7**  
  Includes many improvements:

- Disabling overhead in the configuration (including disabling mitigation)
- Adding THP Shrinker
- And a number of less significant but useful changes

- **CPU power efficiency priority. Only for SteamOS 3.7 (BETA)**
Sets the minimum frequency priority for the CPU without losing FPS.
Improves battery life, but single stutters are possible.

> It is recommended to **disable** this for heavy AAA games.  
> Can be enabled for AA and light games.
> Requires an **optimized kernel**.

- **GPU driver optimization**
Adjusts GPU driver settings.
Improves performance and GPU process scheduling.

## Recommendations

Additional ways to improve Steam Deck performance:

- 🔧 [Guide to overclocking and optimizing Steam Deck](http://deckoc.notion.site/STEAM-DECK-RUS-76e43eacaf8b400ab130692d2d099a02?pvs=4)
- ⭐ [Overclock Manager](https://github.com/Taskerer/Overclock-Manager) — a “multitool” for convenient overclocking and undervolting of Steam Deck.
- ⚡ [Decky-Undervolt](https://github.com/totallynotbakadestroyer/Decky-Undervolt) — a plugin for effective CPU undervolting directly from the system (available in the Decky Loader Store)
- 🎮 [ECLIPSE Mods](https://t.me/kf4fr/850467) — significant performance improvements for specific games

## Thanks

- 💬 **Thank you** to our [Telegram community](https://t.me/steamdeckoverclock) for their ideas, testing, and assistance!
Development takes place there — please join us!
- [Ktweak](https://github.com/tytydraco/KTweak) — the basis for sysctl tweaks
- [Ananicy-cpp](https://gitlab.com/ananicy-cpp/ananicy-cpp) — priority management daemon
- [Ananicy-cpp-rules](https://github.com/CachyOS/ananicy-rules) — a set of rules for many games
- The **CachyOS** team — for their contribution to the Linux community

## Feedback

- Open an **issue** describing your problem
- Write to Telegram: **@noncatt**
- Or to our [group](https://t.me/steamdeckoverclock) — we are always happy to help

## Contribute

Pull requests are welcome!  
Before making any major changes, open an issue for discussion.

## License

[MIT License](https://choosealicense.com/licenses/mit/)
