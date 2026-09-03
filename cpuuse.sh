#!/bin/bash
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "<txt><span foreground='white'>    $(printf "%.1f" "$cpu_usage")%   </span></txt>"
