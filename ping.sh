#!/bin/bash

HOST="8.8.8.8"

OUTPUT=$(ping -c 1 -W 1 "$HOST" 2>/dev/null)
PING=$(echo "$OUTPUT" | sed -n 's/.*time=\([0-9.]*\).*/\1/p')

if [ -z "$PING" ]; then
    echo "<txt><span foreground='red'>DOWN</span></txt>"
    exit 1
fi

PING_INT=${PING%.*}

if [ "$PING_INT" -lt 50 ]; then
    COLOR="green"
elif [ "$PING_INT" -lt 100 ]; then
    COLOR="yellow"
elif [ "$PING_INT" -lt 180 ]; then
    COLOR="orange"
else
    COLOR="red"
fi

echo "<txt><span foreground='$COLOR'>   ${PING_INT} ms </span></txt>"
