# SDWEAK

📄 [RUSSIAN README](README.md)

## Installation

> **Important:** Before installing, be sure to remove **Cryo Utilities** if it was previously installed.  
> Updates can be installed over an existing version. After a **SteamOS** update, it's recommended to reinstall SDWEAK.

### Installation Steps:

1. Switch to **Desktop Mode**.
2. Open **Konsole**.
3. Set a `sudo` password (if you haven’t already):

   ```bash
   passwd
   ```

4. Download the [installation shortcut](https://raw.githubusercontent.com/klen/SDWEAK/refs/heads/main/InstallSDWEAK.desktop):  
   Right-click the link → **Save As...**  
   Then double-click the file and install it.

5. After installation, launch the `SDWeak` shortcut from the desktop.

---

## Uninstallation

If you encounter issues — please report them!

1. Switch to **Desktop Mode**.
2. Launch the `Uninstall SDWeak` shortcut from the desktop.

---

## Updating

1. Run the previously downloaded `SDWeakInstall` shortcut.  
   The script will install the latest version over the current one.
2. After the update, run the `SDWeak` shortcut again.

---

## Donate

If you enjoy SDWEAK and want to support its development:

- 💳 [Support via Tinkoff](https://www.tinkoff.ru/cf/8HHVDNi8VMS)

Thank you for using SDWEAK!

---

## What does SDWEAK do?

- Increases **minimum**, **average**, and **maximum FPS**
- Improves **smoothness**, **responsiveness**, and **frame timing**
- Reduces **stutters** and **micro-freezes**
- More stable system behavior under heavy memory usage
- Significantly improves **process scheduling**
- Overall — boosts system responsiveness and improves the gaming experience

> ⚠️ **Note:** Actual performance gains vary by game.

---

## Optional Features

> The default installation includes an optimal configuration.

- **Frametime fix (LCD)**  
  Eliminates micro-freezes and severe frame timing issues on LCD. Greatly improves game smoothness.

- **LCD overclock to 70Hz**  
  Overclocks the LCD screen refresh rate to 70Hz.

- **Optimized Linux kernel**  
  Includes numerous enhancements:

  - Reduced overhead in configuration
  - TCP stack tuning
  - THP Shrinker for Transparent HugePages
  - Plus a dozen minor but system-wide improvements

- **Power efficiency priority (BETA)**  
  Enables CPU power efficiency mode to extend battery life.  
  The CPU aims to use the lowest possible frequency without affecting FPS.  
  Can significantly improve autonomy, but may cause rare stutters.

  > Recommended to **disable** this feature for demanding AAA games.  
  > Safe to **enable** for AA and low-demand games.  
  > **Requires** the optimized kernel to be enabled.

- **GPU Optimization (BETA)**  
  Adjusts GPU driver parameters for performance improvements.

---

## Recommendations

Additional tips to enhance Steam Deck performance:

- 🔧 [My overclocking & optimization guide](http://deckoc.notion.site/STEAM-DECK-RUS-76e43eacaf8b400ab130692d2d099a02?pvs=4)
- ⚡ [Decky-Undervolt](https://github.com/totallynotbakadestroyer/Decky-Undervolt) — a plugin for undervolting CPU directly from the system (available in Decky Loader Store)
- 🎮 [ECLIPSE mods](https://t.me/kf4fr/850467) — targeted game tweaks that can significantly boost performance and FPS

---

## Thanks

- 💬 A **huge thank you** to our [Telegram community](https://t.me/steamdeckoverclock) for testing, ideas, and development support!  
  All new features are developed and discussed there — join us!
- [Ktweak](https://github.com/tytydraco/KTweak) — for the sysctl tuning base
- [Ananicy-cpp](https://gitlab.com/ananicy-cpp/ananicy-cpp) — for the great CPU scheduler daemon
- [Ananicy-cpp-rules](https://github.com/CachyOS/ananicy-rules) — for the extensive game rule set
- The **CachyOS** team — for contributions to the Linux community

---

## Feedback

- Create an **issue** describing your problem
- Message me on Telegram: **@biddbb**
- Or write in our [Telegram group](https://t.me/steamdeckoverclock) — we're happy to help!

---

## Contributing

Pull requests are welcome!  
For major changes, please open an issue first to discuss what you'd like to do.

---

## License

[MIT License](https://choosealicense.com/licenses/mit/)
