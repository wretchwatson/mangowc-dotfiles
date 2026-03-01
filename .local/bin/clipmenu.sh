#!/bin/bash

# Fuzzel ile kopyalama geçmişini göster
SELECTION=$(cliphist list | fuzzel --dmenu --width 50 --lines 15 -p "Panoya Kopyala: ")

# Eğer bir seçim yapıldıysa, onu panoya koy
if [ ! -z "$SELECTION" ]; then
    echo "$SELECTION" | cliphist decode | wl-copy
    notify-send "Pano" "Seçilen içerik panoya kopyalandı."
fi
