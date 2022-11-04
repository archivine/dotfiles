#!/bin/sh

entries="Logout\nSuspend\nReboot\nShutdown"

selected=$(echo -e $entries|wofi -i --height 260 --width 240 --style ~/.config/wofi/powermenu/style.css --dmenu --cache-file /dev/null | awk '{print tolower($2)}')

case $selected in
  logout)
    exit;;
  suspend)
    exec systemctl suspend;;
  reboot)
    exec systemctl reboot;;
  shutdown)
    exec systemctl poweroff -i;;
esac
