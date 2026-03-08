#!/bin/bash

# Ping a reliable server (Google DNS) and get average latency
PING_HOST="8.8.8.8"
PING_RESULT=$(ping -c 1 -W 1000 $PING_HOST 2>/dev/null | grep 'time=' | sed 's/.*time=\([0-9.]*\).*/\1/')

if [ -n "$PING_RESULT" ]; then
  # Round to whole number
  PING_MS=$(printf "%.0f" $PING_RESULT)
  
  # Color based on latency
  if [ $PING_MS -lt 50 ]; then
    COLOR=0xFF98971A  # Green - good
  elif [ $PING_MS -lt 100 ]; then
    COLOR=0xFFD79921  # Yellow - okay
  else
    COLOR=0xFFCC241D  # Red - poor
  fi
  
  sketchybar --set $NAME label="${PING_MS}ms" icon.color=$COLOR
else
  # No connection
  sketchybar --set $NAME label="--" icon.color=0xFFCC241D
fi
