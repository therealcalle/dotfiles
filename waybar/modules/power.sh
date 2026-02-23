#!/bin/bash
# ╔════════════════════════════════════════╗
# ║  Power Menu - Rofi (Bisexual Theme)   ║
# ╚════════════════════════════════════════╝

# Options
LOCK="  Lock"
LOGOUT="󰍃  Logout"
SUSPEND="󰤄  Suspend"
REBOOT="  Reboot"
SHUTDOWN="  Shutdown"

options="${LOCK}\n${LOGOUT}\n${SUSPEND}\n${REBOOT}\n${SHUTDOWN}"

# Rofi theme override for bi color scheme
rofi_theme='
window {
    width: 200px;
    background-color: #151020;
    border: 2px solid #b07cd8;
    border-radius: 12px;
    padding: 8px;
}
listview {
    lines: 5;
    fixed-height: true;
    spacing: 4px;
    background-color: transparent;
}
element {
    padding: 8px 12px;
    border-radius: 8px;
    background-color: transparent;
    text-color: #e0d6f0;
}
element selected {
    background-color: #2a2145;
    text-color: #b07cd8;
}
inputbar {
    enabled: false;
}
'

chosen=$(echo -e "$options" | rofi -dmenu -p "Power" -theme-str "$rofi_theme" -no-fixed-num-lines)

case "$chosen" in
    "$LOCK")
        # Adjust to your preferred screen locker
        hyprlock || swaylock -f -c 151020 || loginctl lock-session
        ;;
    "$LOGOUT")
        hyprctl dispatch exit
        ;;
    "$SUSPEND")
        systemctl suspend
        ;;
    "$REBOOT")
        systemctl reboot
        ;;
    "$SHUTDOWN")
        systemctl poweroff
        ;;
esac
