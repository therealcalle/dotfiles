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

# Rofi theme override — inherits bisexual theme, just narrows it for power menu
rofi_theme='
@theme "~/.config/rofi/bisexual.rasi"
window {
    width: 220px;
}
inputbar {
    enabled: false;
}
listview {
    lines: 5;
    fixed-height: true;
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
