# SDWEAK
[ENGLISH README](README_ENG.md)

**Сделайте Steam Deck снова великим!**

## Установка
Перед установкой обязательно удалите Cryo Utility, если он у вас был установлен ранее.

```bash
wget https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip && rm -rf SDWEAK && unzip SDWEAK.zip && rm SDWEAK.zip && cd SDWEAK && sudo ./install.sh
```

## Удаление
Если у вас возникли какие-то проблемы, пожалуйста сообщите о них!

```bash
wget https://github.com/Taskerer/SDWEAK/releases/latest/download/SDWEAK.zip && rm -rf SDWEAK && unzip SDWEAK.zip && rm SDWEAK.zip && cd SDWEAK && sudo ./uninstall.sh
```
## Донат
* [DonationAlerts](https://www.donationalerts.com/r/biddbb) (все страны)
* [Tinkoff](https://www.tinkoff.ru/cf/8HHVDNi8VMS) (только Россия)

## Фишки
SDWEAK настраивает SteamOS на максимальную производительность и исправляет критические баги в SteamOS, которые Valve не исправляет.

* Твики **sysctl** параметров.
* **СУПЕР** оптимизированное **ядро Linux**.
* Исправление **микрофризов** и ужасного фреймтайма.
* Разгон экрана LCD до **70Hz**(для SteamOS 3.7 и выше).
* Приоритет **энергоэффективности**, прирост автономности до **+19%** без понижения ФПС (**BETA**).
* Установка **ananicy-cpp** и правил для него.
* Отключение **ненужных** сервисов.
* Тонкая настройка параметров системы.

## Описание опциональных фишек
По умолчанию установлена идеальная конфигурация установки.
* **Исправление фреймтайма(LCD)** - исправляет ужасный фреймтайм, вызванный кривым кодом Valve в SteamOS 3.6 и выше.
* **Разгон экрана LCD до 70Hz** - разгоняет LCD экран до 70 Гц. Только для SteamOS 3.7 и выше.
* **Приоритет энергоэффективности** - значительно снижает общее потребление, прирост автономности до +19%, НО в требовательных играх могут появляться одиночные фризы (это будет исправлено в будущем).
* **СУПЕР оптимизированное ядро Linux** - установка улучшенного по всем параметрам ядра Linux (ОЧЕНЬ рекомендуется).

## Рекомендации
Рекомендации по улучшению производительности Steam Deck помимо SDWEAK
* [Мой гайд](http://deckoc.notion.site/STEAM-DECK-RUS-76e43eacaf8b400ab130692d2d099a02?pvs=4) по разгону и оптимизации Steam Deck.
* [Decky-Undervolt](https://github.com/totallynotbakadestroyer/Decky-Undervolt) плагин для эффективного андервольтинга CPU прямо из системы (доступен в Decky Loader Store)

## Благодарности
* **ОГРОМНОЕ СПАСИБО** нашему [сообществу](https://t.me/steamdeckoverclock) в телеграм за постоянные тесты, идеи и помощь в разработке! Там происходила и будет происходить разработка новых функций. Буду рад каждому новому тестеру!
* [Ktweak](https://github.com/tytydraco/KTweak) - за удобный "скелет" для sysctl твиков
* [Ananicy-cpp](https://gitlab.com/ananicy-cpp/ananicy-cpp) - за прекрасный демон.
* [Ananicy-cpp-rules](https://github.com/CachyOS/ananicy-rules) - за постоянно расширяющийся список правил для множества игр и программ.

## Обратная связь
* Создайте **issue** с полным описанием вашей проблемы.
* Напишите мне в telegram ник **@biddbb**
* Напишите в нашу [телеграм группу](https://t.me/steamdeckoverclock) с полным описанием вашей проблемы. Мы с радостью поможем вам.
## Вклад в развитие
Pull requests приветствуются. Для серьезных изменений, пожалуйста, сначала откройте issue чтобы обсудить, что вы хотите изменить.
## Лицензия
[MIT](https://choosealicense.com/licenses/mit/)
