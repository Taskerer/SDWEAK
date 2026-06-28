<p align="center"><a href="https://github.com/Taskerer/SDWEAK" target="_blank"><img src="assets/logo.png" width="200" alt="SDWEAK Logo"></a></p>
<p align="center">
<a href="https://t.me/steamdeckoverclock"><img src="https://img.shields.io/badge/SteamDeckOC-Telegram-white.svg?style=for-the-badge&logo=telegram&logoColor=white&labelColor=222" alt="Join Our Telegram Group"></a>
<a href="https://github.com/Taskerer/SDWEAK/releases"><img src="https://img.shields.io/github/downloads/Taskerer/SDWEAK/total?style=for-the-badge&logoColor=white&labelColor=222" alt="Total Downloads"></a>
<a href="https://github.com/Taskerer/SDWEAK/releases"><img src="https://img.shields.io/github/v/release/Taskerer/SDWEAK?label=Release&style=for-the-badge&logo=github&logoColor=white&labelColor=222" alt="Latest Stable Version"></a>
<a href="LICENSE"><img src="https://img.shields.io/badge/MIT-white?style=for-the-badge&label=License&labelColor=222" alt="License"></a>
</p>

<h3>🇷🇺 Русский · 🇬🇧 <a href="README_ENG.md">English</a></h3>

## **Что даёт SDWEAK?**
- Повышение **минимального**, **среднего** и **максимального FPS**
- Улучшение **плавности**, **отклика** и **времени кадра**
- Снижение количества **статтеров** и **микрофризов**
- Более стабильная работа при нехватке ОЗУ
- Улучшение **планирования процессов**
- В целом — повышение отзывчивости системы и улучшение игрового опыта


> ⚠️ **Примечание:** прирост производительности зависит от конкретной игры.

## 🚀 **Установка**

> **Важно:** перед установкой обязательно удалите **Cryo Utility**, если он был установлен ранее.  
> **Только для SteamOS 3.8**!
> Обновления **SDWEAK** можно устанавливать поверх старой версии. После обновления **SteamOS** необходимо **поверх** устанавливать **SDWEAK**.

### **Шаги установки**:

1. Перейдите в **режим рабочего стола**.
2. Откройте **Konsole**.
3. Установите пароль `sudo` (если ещё не сделали это):

   ```bash
   passwd
   ```
4. Скачайте [установочный ярлык](https://raw.githubusercontent.com/Taskerer/SDWEAK/refs/heads/main/SDWEAK-installer.desktop):  
   Клик правой кнопкой по ссылке → **Сохранить как...** и сохраните на рабочий стол (при использовании Firefox удалите .download в конце файла).  
   Затем откройте файл двойным кликом и начнется установка.

## 🔄 **Обновление**
1. Перейдите в **режим рабочего стола**.
2. Двойным кликом запустите ранее скачанный ярлык **"Install SDWEAK"** (SDWEAK-installer.desktop).
Скрипт автоматически установит последнюю версию поверх текущей.

## 🗑️ **Удаление**

Если возникли проблемы — пожалуйста, сообщите о них!

1. Перейдите в **режим рабочего стола**.
2. Запустите ярлык **"Uninstall SDWEAK"** на рабочем столе.

## ⚙️ **Опциональные функции**

> 💡 Оптимальная конфигурация уже выбрана по умолчанию. Можете просто нажимать Enter.
> Часть функций актуальна только для Steam Deck LCD и недоступна на OLED.

- **Исправление неровного фреймтайма при использовании ограничения FPS через QAM. (БЕТА)**  
  Устраняет микрофризы и скачки фреймтайма при использовании лимита FPS через QAM (боковое меню Steam).

- **Разгон экрана до 70 Гц. (Только для Steam Deck LCD)**  
  Поднимает частоту обновления экрана до 70Hz. Полезно для ограничения 35FPS(70Hz) и для использования ограничения 70FPS(70Hz) в нетребовательных проектах.

- **Приоритет энергоэффективности CPU.**  
  Устанавливает для CPU приоритет минимальной частоты без потери FPS.  
  Улучшает автономность, но возможны одиночные статтеры.

> ⚠️ В процессорозависимых играх (с упором на CPU) функция может снизить производительность.

> 💡 В играх, требовательных к видеокарте (GPU), наоборот — даст улучшение FPS или увеличит время работы от батареи.

- **Оптимизации драйвера GPU**  
  Настройка параметров драйвера GPU.
  Улучшает производительность и планирование процессов GPU.


## 💜 **Поддержка проекта**

Если вам нравится SDWEAK и вы хотите поддержать его развитие:

- 💳 [Поддержать через Tinkoff](https://www.tinkoff.ru/cf/8HHVDNi8VMS)
- 💬 Для альтернативных способов — пишите в Telegram **[@noncatt](https://t.me/noncatt)**

**Спасибо за использование SDWEAK!**

## 🛠️ **Дополнительные рекомендации**

Дополнительные способы повысить производительность Steam Deck:

- 🔧 [Гайд по разгону и оптимизации Steam Deck](http://deckoc.notion.site/STEAM-DECK-RUS-76e43eacaf8b400ab130692d2d099a02?pvs=4)
- ⭐ [Overclock Manager](https://github.com/Taskerer/Overclock-Manager) — "мультитул" для удобного разгона и андервольтинга Steam Deck.
- ⚡ [Decky-Undervolt](https://github.com/totallynotbakadestroyer/Decky-Undervolt) — плагин для эффективного андервольтинга CPU прямо из системы (доступен в Decky Loader Store)
- 🎮 [Моды ECLIPSE](https://t.me/kf4fr/850467) — значительное улучшение производительности под конкретные игры

## 🙏 **Благодарности**

- 💬 **Спасибо** нашему [сообществу в Telegram](https://t.me/steamdeckoverclock) за идеи, тесты и помощь!  
  Разработка происходит именно там — присоединяйтесь!
- [Ktweak](https://github.com/tytydraco/KTweak) — основа для sysctl-твиков

## 💬 **Обратная связь**

- Откройте **issue** с описанием вашей проблемы
- Напишите в Telegram: **[@noncatt](https://t.me/noncatt)**
- Или в нашу [группу](https://t.me/steamdeckoverclock) — мы всегда рады помочь

## 🤝 **Вклад в развитие**

Pull requests приветствуются!  
Перед серьёзными изменениями откройте issue для обсуждения.

## 📄 **Лицензия**

[MIT License](https://choosealicense.com/licenses/mit/)
