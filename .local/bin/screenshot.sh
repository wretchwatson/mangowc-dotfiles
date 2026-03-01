#!/bin/bash

SAVE_DIR="/home/ridvan/Resimler"
FILE_NAME="$(date +%Y%m%d_%H%M%S).png"
FULL_PATH="$SAVE_DIR/$FILE_NAME"

mkdir -p "$SAVE_DIR"

if [ "$1" == "full" ]; then
    grim "$FULL_PATH"
    notify-send "Ekran Görüntüsü" "Tüm ekran kaydedildi: $FILE_NAME"
elif [ "$1" == "area" ]; then
    # Use -g "$(slurp)" and handle the case where the user cancels (slurp exits with non-zero)
    GEOM=$(slurp)
    if [ -z "$GEOM" ]; then
        exit 0
    fi
    grim -g "$GEOM" - | tee "$FULL_PATH" | wl-copy
    notify-send "Ekran Görüntüsü" "Seçilen alan kaydedildi ve panoya kopyalandı."
fi
