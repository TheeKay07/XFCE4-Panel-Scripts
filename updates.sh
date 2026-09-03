#!/bin/bash

if [ -f "/usr/share/icons/Papirus-Dark/16x16/panel/software-update-available.svg" ]; then
    ICON_UPDATE="/usr/share/icons/Papirus-Dark/16x16/panel/software-update-available.svg"
    ICON_OK="/usr/share/icons/Papirus-Dark/16x16/panel/state-ok.svg"

elif [ -f "/usr/share/icons/Adwaita/scalable/status/software-update-available-symbolic.svg" ]; then
    ICON_UPDATE="/usr/share/icons/Adwaita/scalable/status/software-update-available-symbolic.svg"
    ICON_OK="/usr/share/icons/Adwaita/scalable/status/emblem-ok-symbolic.svg"

else
    ICON_UPDATE="/usr/share/icons/AdwaitaLegacy/16x16/legacy/software-update-available.png"
    ICON_OK="/usr/share/icons/AdwaitaLegacy/16x16/legacy/system-software-update.png"
fi


CACHE_FILE="/tmp/updates_void"

find /tmp -name "updates_void" -mmin +30 -delete 2>/dev/null


if [ ! -f "$CACHE_FILE" ]; then
    (
        xbps-install -Mun 2>/dev/null |
        grep -cE '^[^[:space:]].*[[:space:]](install|update|remove)[[:space:]]' \
        > "$CACHE_FILE"
    ) &
fi


updates=$(cat "$CACHE_FILE" 2>/dev/null || echo 0)

[[ "$updates" =~ ^[0-9]+$ ]] || updates=0


if [ "$updates" -gt 0 ]; then

    echo "<img>$ICON_UPDATE</img>"
    echo "<txt><span foreground='white'>&#160;&#160;$updates&#160;&#160;Updates</span></txt>"

    # Click → update the system
    echo "<click>xfce4-terminal -e 'bash -c \"sudo xbps-install -Su; rm -f /tmp/updates_void; exec bash\"'</click>"

    echo "<tool>Void Linux: $updates updates available</tool>"

else

    echo "<img>$ICON_OK</img>"
    echo "<txt><span foreground='white'>&#160;&#160;0&#160;&#160;Updates</span></txt>"

    echo "<click>rm -f /tmp/updates_void</click>"

    echo "<tool>Void Linux: Up to date</tool>"
fi
