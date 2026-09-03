#!/bin/bash
temp=$(sensors | grep -E 'Core 0|Package id 0' | awk '{print $4}' | head -1 | tr -d '+°C')
itemp=$(printf "%.0f" "$temp")

if [ "$itemp" -lt 60 ]; then
    COLOR="green" 
elif [ "$itemp" -lt 75 ]; then
    COLOR="yellow"
else
    COLOR="red"
fi


echo "<txt><span foreground='white'> </span> <span foreground='$COLOR'>$itemp°C</span></txt>"
