#!/bin/sh
#
# rofi-powermenu.sh — um power-menu usando rofi

OPTIONS="Lock\nSuspend\nReboot\nShutdown\nLog Out"

CHOICE=$(printf "$OPTIONS" \
  | rofi -dmenu \
         -i \
         -p "⏻ Power:" \
         -lines 5 \
         -no-sort \
         -theme ~/.config/rofi/config.rasi)

case "$CHOICE" in
  "Lock")           hyprlock ;;
  "Suspend")        systemctl suspend-then-hibernate ;;
  "Reboot")         reboot ;;
  "Shutdown")       poweroff ;;
  "Log Out")        hyprctl dispatch exit ;;
  *)                exit 1 ;;
esac

