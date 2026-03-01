#!/bin/bash

# Options
OFF="⏻  Kapat"
REBOOT="🔄  Yeniden Başlat"
SLEEP="💤  Uyut"
LOGOUT="🚪  Çıkış"
LOCK="🔒  Kilitle"

# Show menu
SELECTION="$(printf "$LOCK\n$LOGOUT\n$SLEEP\n$REBOOT\n$OFF" | fuzzel --dmenu --lines 5 --width 25 -p "Güç Menüsü: ")"

case "$SELECTION" in
    "$OFF")
        systemctl poweroff
        ;;
    "$REBOOT")
        systemctl reboot
        ;;
    "$SLEEP")
        systemctl suspend
        ;;
    "$LOGOUT")
        mmsg -q
        ;;
    "$LOCK")
        # Ensure a locker is installed if you use this, or leave as placeholder
        loginctl lock-session
        ;;
esac
