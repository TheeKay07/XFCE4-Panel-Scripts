#!/bin/bash
total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
avail_kb=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
used_mb=$(( (total_kb - avail_kb) / 1024 ))

if [ "$used_mb" -lt 1024 ]; then
    display_mem="${used_mb} MB"
else
    display_mem=$(awk "BEGIN {printf \"%.1f GB\", $used_mb/1024}")
fi
echo "<txt><span foreground='white'>    $display_mem </span></txt>"
