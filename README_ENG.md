# SDWEAK
[RUSSIAN README](README.md)

## Installation
**For SteamOS 3.7+ only!!!**
Before installation, be sure to remove Cryo Utilities if it was previously installed.

The new version can be installed over the old one. After updating SteamOS, you must reinstall SDWEAK.

1. Switch to Desktop Mode
2. Open Konsole
3. Set a sudo password (if you haven’t done so already):
```bash
passwd
```
4. Disable Read-Only:
```bash
sudo steamos-readonly disable
```
5. Enter the command to install SDWEAK:
```bash
rm -f SDWEAK.zip && wget https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip && rm -rf SDWEAK && unzip SDWEAK.zip && cd SDWEAK && sudo --preserve-env=HOME ./install.sh
```
## Uninstallation
If you encounter any issues, please report them!
1. Switch to Desktop Mode
2. Open Konsole
3. Disable Read-Only:
```bash
sudo steamos-readonly disable
```
4. Enter the command to uninstall SDWEAK:
```bash
rm -f SDWEAK.zip && wget https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip && rm -rf SDWEAK && unzip SDWEAK.zip && cd SDWEAK && sudo --preserve-env=HOME ./uninstall.sh
```
## DONAT
If you enjoy SDWEAK, you can also support the project's further development via the link below. Thank you for using it!
* [DonationAlerts](https://www.donationalerts.com/r/biddbb) (all countries)
* [Tinkoff](https://www.tinkoff.ru/cf/8HHVDNi8VMS) (only Russia)

## What are the benefits?
Increases minimum, maximum, and average FPS. Improves smoothness, responsiveness, and frame timing. Reduces stutters and micro-freezes. Enhances system performance under heavy RAM load. Significantly improves process scheduling. Overall, optimizes system performance for a better gaming experience.

NOTE: Actual gains vary by game.

## Optional Features Description
The ideal installation configuration is enabled by default.
* **Frametime fix(LCD)** - fixes terrible frame timing and micro-freezes on LCD displays. Significantly improves in-game smoothness.
* **LCD screen up to 70Hz** - overclocks the LCD screen to 70Hz.
* **Optimized Linux kernel** - installation of an optimized Linux kernel. Configuration tuning (primarily reducing overhead). TCP stack optimization. THP Shrinker for Transparent HugePages optimization. Plus a dozen other minor but system-wide performance improvements.
* **Power efficiency priority(BETA)** - installation of CPU power efficiency priority to improve battery life. When this function is enabled, the CPU always tries to use the minimum possible frequency without worsening FPS. This can significantly improve battery life, but may cause occasional stutters, which is why the function currently has BETA status. Therefore, if you mainly play recent demanding AAA games, it is recommended to keep this function disabled (N). Otherwise, if you play AA and low-demand games, you can enable this function.
NOTE: This function is only available with the optimized Linux kernel installed.
* **GPU Optimization** - adjusts the amdgpu driver settings, giving a boost.

## Recommendations
Recommendations for improving Steam Deck performance beyond SDWEAK
* [My guide](http://deckoc.notion.site/STEAM-DECK-RUS-76e43eacaf8b400ab130692d2d099a02?pvs=4) to overclocking and optimizing Steam Deck.
* [Decky-Undervolt](https://github.com/totallynotbakadestroyer/Decky-Undervolt) plugin for efficient CPU undervolting directly from the system(Available in Decky Loader Store)
* [ECLIPSE mods](https://t.me/kf4fr/600631) for specific games. They significantly improve performance and FPS, making unplayable games comfortable to complete.

## Thanks
* A HUGE THANK YOU to our [community](https://t.me/steamdeckoverclock) on Telegram for constant tests, ideas and development help! The development of new features has been and will be happening there. I will be glad to every new tester!
* [Ktweak](https://github.com/tytydraco/KTweak) - for a useful skeleton for sysctl tweaks.
* [Ananicy-cpp](https://gitlab.com/ananicy-cpp/ananicy-cpp) - for a beautiful demon.
* [Ananicy-cpp-rules](https://github.com/CachyOS/ananicy-rules) - for the ever-expanding list of rules for a multitude of games and programs.
* To the CachyOS team for their contributions to the Linux community.

## Contact me
* Create an **issue** describing your problem.
* Text me on telegram **@biddbb**.
* Write in our [Telegram group](https://t.me/steamdeckoverclock) your problem, we will be happy to help you out.
## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.
## License

[MIT](https://choosealicense.com/licenses/mit/)
