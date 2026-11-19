#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
    echo "Пожалуйста, запустите скрипт с правами root: sudo $0"
    exit 1
fi

REPO_DIR="/home/nursayat/Documents/MyProjects/serpantinum"
THEME_SRC="$REPO_DIR/config/sddm/themes/material-you"
THEME_DEST="/usr/share/sddm/themes/material-you"

echo "==> 1. Установка темы SDDM Material You..."
mkdir -p "$THEME_DEST"
cp -r "$THEME_SRC/." "$THEME_DEST/"
chmod -R 755 "$THEME_DEST"

echo "==> 2. Установка шрифтов Google Sans..."
if [ -d "$THEME_SRC/font" ]; then
    mkdir -p /usr/share/fonts/TTF
    cp -f "$THEME_SRC/font/"*.ttf /usr/share/fonts/TTF/ 2>/dev/null || true
    fc-cache -f /usr/share/fonts >/dev/null 2>&1 || true
fi

echo "==> 3. Настройка конфигурации SDDM..."
mkdir -p /etc/sddm.conf.d

cat << 'CONF' > /etc/sddm.conf.d/10-material-you.conf
[Theme]
Current=material-you
ThemeDir=/usr/share/sddm/themes
CursorTheme=Bibata-Modern-Classic

[General]
InputMethod=
CONF

# Enable sddm if not enabled
systemctl enable sddm.service 2>/dev/null || true

echo "==> Готово! Тема Serpantinum Material You успешно установлена в SDDM."
echo "Проверить экран входа без выхода из системы можно командой:"
echo "  sddm-greeter-qt6 --test-mode --theme /usr/share/sddm/themes/material-you"
