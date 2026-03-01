#!/bin/bash

# Wallpaper dizini
WALLPAPER_DIR="/home/ridvan/.local/share/wallpaper"

# Dosyaları listele ve Fuzzel ile seçtir
# Sadece dosya adlarını gösteriyoruz
SELECTION=$(ls "$WALLPAPER_DIR" | fuzzel --dmenu --width 40 --lines 15 -p "Duvar Kağıdı Seç: ")

# Eğer bir seçim yapıldıysa, swww ile uygula
if [ ! -z "$SELECTION" ]; then
    swww img "$WALLPAPER_DIR/$SELECTION" --transition-type grow --transition-pos center --transition-duration 2
    notify-send "Duvar Kağıdı" "Yeni duvar kağıdı uygulandı: $SELECTION"
fi
