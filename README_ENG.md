# SDWEAK
[RUSSIAN README](README.md)

Make Steam Deck Great Again

## Installation
Be sure to uninstall Cryo Utility if you have them installed before installing.

```bash
git clone https://github.com/Taskerer/SDWEAK.git && cd SDWEAK && sudo ./install.sh
```

## Features
SDWEAK tunes SteamOS for maximum performance and fixes critical bugs in SteamOS that Valve doesn't fix.

* Tweaking **sysctl** parameters.
* **SUPER** optimized **Linux kernel**.
* Fixes for **microstaters** and terrible frametime.
* LCD screen up to **70Hz**(on SteamOS 3.7 and higher).
* Power efficiency priority, autonomy increases to **+19%** without FPS loss(BETA)
* **ZRAM** to **ZSWAP** replacement
* Installing **ananicy-cpp** and rules for it
* Disabling **unnecessary** services
* Fine-tuning of system parameter

## Description of optional improvements
The ideal installation configuration is set by default.
* **ZSWAP** - is a kernel feature called zswap that provides a compressed RAM cache for swap pages. Pages that would otherwise be offloaded to disk are instead compressed and stored in a memory pool in RAM.
When the pool is full or RAM is exhausted, the last page used is decompressed and written to the paging file or hard disk partition as if it had not been captured at all. Once this page is unloaded to the swap file or partition, the compressed version in the pool will be released.
* **Frametime fix(OLED)** - fixes terrible frametime caused by Valve's crooked code in SteamOS 3.6 and above. BUT HDR will not work (looking for a way to fix this)
* **Frametime fix(LCD)** - fixes terrible frametime caused by Valve's crooked code in SteamOS 3.6 and above, with no issues unlike OLED.
* **LCD screen up to 70Hz** - increases the frequency of LCD display up to 70Hz. Only for SteamOS 3.7 and higher.
* **Power efficiency priority** - greatly reduces overall consumption, autonomy gain reaches +19%, BUT single staters may appear in demanding games (this will be fixed in the future).
* **SUPER optimized Linux kernel** - installing an improved Linux kernel on all fronts (VERY recommended)

## Recommendations
Recommendations for improving Steam Deck performance beyond SDWEAK
* [Decky-Undervolt](https://github.com/totallynotbakadestroyer/Decky-Undervolt) plugin for efficient CPU undervolting directly from the system(Available in Decky Loader Store)
* **Undervolting GPU in BIOS**
* **Memory overclock to 6400MT/s on Steam Deck LCD**
* **Lowering memory timings in BIOS**

## Thanks
* A HUGE THANK YOU to our [community](https://t.me/steamdeckoverclock) on Telegram for constant tests, ideas and development help! The development of new features has been and will be happening there. I will be glad to every new tester!
* [Ktweak](https://github.com/tytydraco/KTweak) - for a useful skeleton for sysctl tweaks.
* [Ananicy-cpp](https://gitlab.com/ananicy-cpp/ananicy-cpp) - for a beautiful demon.
* [Ananicy-cpp-rules](https://github.com/CachyOS/ananicy-rules) - for the ever-expanding list of rules for a multitude of games and programs.

## Contact me
* Create an **issue** describing your problem
* Text me on telegram **@biddbb**.
* Write in our [Telegram group](https://t.me/steamdeckoverclock) your problem, we will be happy to help you out
## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.
## License

[MIT](https://choosealicense.com/licenses/mit/)
