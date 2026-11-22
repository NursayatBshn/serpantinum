.pragma library

function getCategories() {
    return [
        { id: "all", name: "Все", icon: "󰌌" },
        { id: "windows", name: "Окна", icon: "󰖲" },
        { id: "apps", name: "Приложения", icon: "󰀻" },
        { id: "serpantinum", name: "Serpantinum", icon: "󰸉" },
        { id: "screenshot", name: "Скриншоты", icon: "󰹑" },
        { id: "workspaces", name: "Воркспейсы", icon: "󰍹" },
        { id: "media", name: "Медиа", icon: "󰝚" },
        { id: "system", name: "Система", icon: "󰒓" }
    ];
}

function getKeybinds() {
    return [
        // Окна и навигация
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Фокус окна",
            desc: "Перемещение фокуса между окнами в четырех направлениях",
            keys: [["SUPER", "← / → / ↑ / ↓"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Переместить окно",
            desc: "Сдвиг активного окна в сетке тайлинга",
            keys: [["SUPER", "SHIFT", "← / → / ↑ / ↓"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Изменить размер окна",
            desc: "Плавное сужение или расширение границ окна на 50px",
            keys: [["SUPER", "CTRL", "SHIFT", "Стрелки"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Соотношение сплита",
            desc: "Уменьшить (-0.1) или увеличить (+0.1) долю окна в сплите",
            keys: [["SUPER", ";"], ["SUPER", "'"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Полноэкранный режим",
            desc: "Переключение окна на весь экран (Fullscreen toggle)",
            keys: [["SUPER", "F"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Максимизировать окно",
            desc: "Развернуть окно внутри рабочих границ (Maximize toggle)",
            keys: [["SUPER", "D"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Плавающий режим (Float)",
            desc: "Открепить окно от тайлинговой сетки в плавающее",
            keys: [["SUPER", "ALT", "Space"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Закрепить поверх всех (Pin)",
            desc: "Окно остается видимым поверх всех рабочих пространств",
            keys: [["SUPER", "P"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Закрыть активное окно",
            desc: "Корректное закрытие текущего сфокусированного окна",
            keys: [["SUPER", "Q"], ["ALT", "F4"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Принудительно убить (Kill)",
            desc: "Экстренное завершение зависшего окна через hyprctl kill",
            keys: [["SUPER", "SHIFT", "ALT", "Q"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Перемещение мышью",
            desc: "Зажать клавишу и левую кнопку мыши для перетаскивания окна",
            keys: [["SUPER", "ЛКМ"]]
        },
        {
            category: "windows",
            categoryName: "Окна и навигация",
            categoryIcon: "󰖲",
            title: "Изменение размера мышью",
            desc: "Зажать клавишу и правую кнопку мыши для масштабирования",
            keys: [["SUPER", "ПКМ"]]
        },

        // Приложения
        {
            category: "apps",
            categoryName: "Приложения",
            categoryIcon: "󰀻",
            title: "Терминал Kitty",
            desc: "Быстрый запуск основного терминала окружения",
            keys: [["SUPER", "Enter"], ["SUPER", "T"]]
        },
        {
            category: "apps",
            categoryName: "Приложения",
            categoryIcon: "󰀻",
            title: "Файловый менеджер Dolphin",
            desc: "Открыть проводник файлов и директорий",
            keys: [["SUPER", "E"]]
        },
        {
            category: "apps",
            categoryName: "Приложения",
            categoryIcon: "󰀻",
            title: "Браузер Firefox",
            desc: "Запуск основного интернет-браузера",
            keys: [["SUPER", "W"]]
        },
        {
            category: "apps",
            categoryName: "Приложения",
            categoryIcon: "󰀻",
            title: "Автокликер (Sober Roblox)",
            desc: "Включить или выключить автокликер",
            keys: [["F8"]]
        },
        {
            category: "apps",
            categoryName: "Приложения",
            categoryIcon: "󰀻",
            title: "Редактор VSCodium",
            desc: "Запуск среды разработки и редактирования кода",
            keys: [["SUPER", "C"]]
        },
        {
            category: "apps",
            categoryName: "Приложения",
            categoryIcon: "󰀻",
            title: "Системный монитор btop",
            desc: "Терминальный диспетчер процессов, CPU, GPU и памяти",
            keys: [["CTRL", "SHIFT", "Esc"]]
        },

        // Панели Serpantinum
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Меню приложений (Launcher)",
            desc: "Полноэкранный умный поиск и запуск программ",
            keys: [["SUPER"], ["SUPER", "Tab"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Горячие клавиши (Cheatsheet)",
            desc: "Интерактивная шпаргалка всех сочетаний клавиш окружения",
            keys: [["SUPER", "/"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Буфер обмена (Clipboard)",
            desc: "История скопированного текста, картинок и сниппетов",
            keys: [["SUPER", "V"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Выбор обоев (Wallpapers)",
            desc: "Каталог обоев с автогенерацией темы Matugen",
            keys: [["CTRL", "SUPER", "T"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Медиаплеер Serpantinum",
            desc: "Боковая панель с обложкой, текстом песен и эквалайзером",
            keys: [["SUPER", "M"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Панель управления системой",
            desc: "Быстрые переключатели, батарея, монитор питания и датчики",
            keys: [["SUPER", "A"], ["SUPER", "B"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Настройки сети (Network)",
            desc: "Подключение к Wi-Fi сетям, Ethernet и режим полета",
            keys: [["SUPER", "N"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Календарь и часы (Dashboard)",
            desc: "Виджет календаря, даты, погоды и событий",
            keys: [["SUPER", "G"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Микшер звука (Volume)",
            desc: "Управление громкостью выходов, микрофонов и приложений",
            keys: [["CTRL", "SUPER", "V"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Настройки Serpantinum (Guide)",
            desc: "Центр управления темами, доком, панелью и виджетами",
            keys: [["SUPER", "I"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Скрыть панель (Autohide)",
            desc: "Включить / отключить автоматическое скрытие верхней панели",
            keys: [["SUPER", "J"]]
        },
        {
            category: "serpantinum",
            categoryName: "Serpantinum Shell",
            categoryIcon: "󰸉",
            title: "Перезагрузить оболочку",
            desc: "Мягкий перезапуск всех панелей и виджетов Serpantinum",
            keys: [["CTRL", "SUPER", "R"]]
        },

        // Скриншоты и захват экрана
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Скриншот области (end-4)",
            desc: "Интерактивное выделение региона с меню действий",
            keys: [["SUPER", "SHIFT", "S"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Поиск по картинке",
            desc: "Выделение области экрана и мгновенный поиск в Google Lens",
            keys: [["SUPER", "SHIFT", "A"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Распознавание текста (OCR)",
            desc: "Оптическое считывание текста с экрана прямо в буфер обмена",
            keys: [["SUPER", "SHIFT", "X"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Запись видео области",
            desc: "Захват экрана в видеофайл MP4/MKV для выделенной зоны",
            keys: [["SUPER", "SHIFT", "R"], ["SUPER", "ALT", "R"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Запись полного экрана",
            desc: "Запись видео всего рабочего стола со звуком",
            keys: [["SUPER", "SHIFT", "ALT", "R"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Быстрый снимок в буфер",
            desc: "Снимок активного монитора через grim сразу в буфер обмена",
            keys: [["Print"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Сохранить снимок в файл",
            desc: "Автосохранение снимка монитора в папку ~/Изображения/Screenshots",
            keys: [["SHIFT", "Print"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Снимок Serpantinum",
            desc: "Встроенный снимок всего экрана через панель Serpantinum",
            keys: [["SUPER", "Print"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Снимок с редактором",
            desc: "Снимок экрана и открытие графического редактора пометок",
            keys: [["SUPER", "SHIFT", "Print"]]
        },
        {
            category: "screenshot",
            categoryName: "Скриншоты и захват",
            categoryIcon: "󰹑",
            title: "Пипетка цвета (Color Picker)",
            desc: "Определение HEX-кода пикселя на экране в буфер обмена",
            keys: [["SUPER", "SHIFT", "C"]]
        },

        // Рабочие столы (Воркспейсы)
        {
            category: "workspaces",
            categoryName: "Рабочие столы",
            categoryIcon: "󰍹",
            title: "Перейти на рабочий стол",
            desc: "Мгновенное переключение на указанный рабочий стол 1..10",
            keys: [["SUPER", "1 .. 9, 0"]]
        },
        {
            category: "workspaces",
            categoryName: "Рабочие столы",
            categoryIcon: "󰍹",
            title: "Переместить окно на стол",
            desc: "Отправить текущее окно на указанный рабочий стол 1..10",
            keys: [["SUPER", "ALT", "1 .. 9, 0"]]
        },
        {
            category: "workspaces",
            categoryName: "Рабочие столы",
            categoryIcon: "󰍹",
            title: "Предыдущий / следующий стол",
            desc: "Циклическое переключение между соседними рабочими столами",
            keys: [["CTRL", "SUPER", "← / →"], ["SUPER", "PageUp / PageDn"]]
        },
        {
            category: "workspaces",
            categoryName: "Рабочие столы",
            categoryIcon: "󰍹",
            title: "Прокрутка рабочих столов",
            desc: "Переключение столов колесом мыши при зажатом Super",
            keys: [["SUPER", "Колесо мыши"]]
        },
        {
            category: "workspaces",
            categoryName: "Рабочие столы",
            categoryIcon: "󰍹",
            title: "Открыть Scratchpad",
            desc: "Показать или скрыть специальный скрытый рабочий стол",
            keys: [["SUPER", "S"], ["SUPER", "Боковая 1"]]
        },
        {
            category: "workspaces",
            categoryName: "Рабочие столы",
            categoryIcon: "󰍹",
            title: "Окно в Scratchpad",
            desc: "Спрятать активное окно в специальное скрытое пространство",
            keys: [["SUPER", "ALT", "S"]]
        },

        // Мультимедиа и PhantomPlayer
        {
            category: "media",
            categoryName: "Мультимедиа и плеер",
            categoryIcon: "󰝚",
            title: "Воспроизведение / Пауза",
            desc: "Универсальное управление активным медиаплеером (playerctl)",
            keys: [["SUPER", "Space"], ["Клавиша Play/Pause"]]
        },
        {
            category: "media",
            categoryName: "Мультимедиа и плеер",
            categoryIcon: "󰝚",
            title: "Следующий / предыдущий трек",
            desc: "Переключение музыкальных треков вперед или назад",
            keys: [["Клавиши Prev / Next"]]
        },
        {
            category: "media",
            categoryName: "Мультимедиа и плеер",
            categoryIcon: "󰝚",
            title: "PhantomPlayer: След. трек",
            desc: "Следующая композиция в PhantomPlayer или запуск плеера",
            keys: [["CTRL", "Space"], ["Боковая 2"]]
        },
        {
            category: "media",
            categoryName: "Мультимедиа и плеер",
            categoryIcon: "󰝚",
            title: "PhantomPlayer: Видимость",
            desc: "Показать или скрыть интерфейс PhantomPlayer",
            keys: [["CTRL", "SHIFT", "Space"], ["CTRL", "ALT", "P"]]
        },
        {
            category: "media",
            categoryName: "Мультимедиа и плеер",
            categoryIcon: "󰝚",
            title: "PhantomPlayer: Стоп",
            desc: "Остановить воспроизведение музыки",
            keys: [["CTRL", "SHIFT", "E"], ["Колесо (клик)"]]
        },

        // Система и оборудование
        {
            category: "system",
            categoryName: "Система и питание",
            categoryIcon: "󰒓",
            title: "Заблокировать экран",
            desc: "Мгновенный переход на экран блокировки Serpantinum",
            keys: [["SUPER", "L"], ["Кнопка питания"]]
        },
        {
            category: "system",
            categoryName: "Система и питание",
            categoryIcon: "󰒓",
            title: "Спящий режим (Suspend)",
            desc: "Перевести ноутбук/компьютер в режим энергосбережения",
            keys: [["SUPER", "SHIFT", "L"]]
        },
        {
            category: "system",
            categoryName: "Система и питание",
            categoryIcon: "󰒓",
            title: "Меню питания",
            desc: "Вызов диалога завершения сеанса, перезагрузки и выключения",
            keys: [["CTRL", "ALT", "Del"]]
        },
        {
            category: "system",
            categoryName: "Система и питание",
            categoryIcon: "󰒓",
            title: "Яркость подсветки",
            desc: "Плавная регулировка подсветки экрана функциональными клавишами",
            keys: [["Fn", "Яркость + / -"]]
        },
        {
            category: "system",
            categoryName: "Система и питание",
            categoryIcon: "󰒓",
            title: "Громкость звука",
            desc: "Аппаратное изменение уровня громкости динамиков",
            keys: [["Fn", "Громкость + / -"]]
        },
        {
            category: "system",
            categoryName: "Система и питание",
            categoryIcon: "󰒓",
            title: "Заглушить звук / микрофон",
            desc: "Быстрое выключение аудиовыхода или отключение микрофона",
            keys: [["Fn", "Mute / MicMute"]]
        }
    ];
}
