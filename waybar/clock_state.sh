#!/bin/bash
STATE_FILE="/tmp/waybar_clock_expanded"
if [ "$1" == "toggle" ]; then
    if [ -f "$STATE_FILE" ]; then
        rm "$STATE_FILE"
    else
        touch "$STATE_FILE"
    fi
    pkill -RTMIN+10 waybar
elif [ "$1" == "check" ]; then
    if [ -f "$STATE_FILE" ]; then
        exit 0
    else
        exit 1
    fi
fi
