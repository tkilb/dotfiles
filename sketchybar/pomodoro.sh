#!/bin/bash

# Pomodoro timer script for SketchyBar
# Timer duration in seconds (25 minutes)
TIMER_DURATION=1500
STATE_FILE="/tmp/sketchybar_pomodoro_state"
PID_FILE="/tmp/sketchybar_pomodoro_pid"

get_state() {
  if [ -f "$STATE_FILE" ]; then
    cat "$STATE_FILE"
  else
    echo "stopped"
  fi
}

get_remaining() {
  if [ -f "$STATE_FILE" ]; then
    local state=$(cat "$STATE_FILE")
    local remaining=$(echo "$state" | cut -d: -f2)
    echo "$remaining"
  else
    echo "$TIMER_DURATION"
  fi
}

start_timer() {
  local remaining=$(get_remaining)
  local state=$(get_state | cut -d: -f1)
  
  if [ "$state" = "running" ]; then
    return
  fi
  
  echo "running:$remaining" > "$STATE_FILE"
  
  # Background timer process
  (
    while [ $remaining -gt 0 ]; do
      sleep 1
      remaining=$((remaining - 1))
      
      # Check if we should stop
      current_state=$(cat "$STATE_FILE" 2>/dev/null | cut -d: -f1)
      if [ "$current_state" != "running" ]; then
        exit 0
      fi
      
      echo "running:$remaining" > "$STATE_FILE"
      
      # Update SketchyBar
      local minutes=$((remaining / 60))
      sketchybar --set pomodoro label="🍅 ${minutes}m"
    done
    
    # Timer complete
    echo "stopped" > "$STATE_FILE"
    sketchybar --set pomodoro label="🍅 0m"
    
    # Alert user
    osascript -e 'display notification "Time to take a break!" with title "Pomodoro Complete" sound name "Glass"'
    afplay /System/Library/Sounds/Glass.aiff
    
  ) &
  
  echo $! > "$PID_FILE"
  
  # Initial display
  local minutes=$((remaining / 60))
  sketchybar --set pomodoro label="🍅 ${minutes}m"
}

pause_timer() {
  local state=$(get_state | cut -d: -f1)
  
  if [ "$state" = "running" ]; then
    local remaining=$(get_remaining)
    echo "paused:$remaining" > "$STATE_FILE"
    
    # Kill background timer
    if [ -f "$PID_FILE" ]; then
      kill $(cat "$PID_FILE") 2>/dev/null
      rm "$PID_FILE"
    fi
    
    local minutes=$((remaining / 60))
    sketchybar --set pomodoro label="⏸ ${minutes}m"
  elif [ "$state" = "paused" ]; then
    start_timer
  fi
}

clear_timer() {
  # Stop timer
  if [ -f "$PID_FILE" ]; then
    kill $(cat "$PID_FILE") 2>/dev/null
    rm "$PID_FILE"
  fi
  
  # Reset state
  rm -f "$STATE_FILE"
  echo "stopped:$TIMER_DURATION" > "$STATE_FILE"
  
  # Reset display
  sketchybar --set pomodoro label="🍅 25m"
}

init_timer() {
  if [ ! -f "$STATE_FILE" ]; then
    echo "stopped:$TIMER_DURATION" > "$STATE_FILE"
  fi
  
  local state=$(get_state | cut -d: -f1)
  local remaining=$(get_remaining)
  local minutes=$((remaining / 60))
  
  if [ "$state" = "paused" ]; then
    sketchybar --set pomodoro label="⏸ ${minutes}m"
  else
    sketchybar --set pomodoro label="🍅 ${minutes}m"
  fi
}

case "$1" in
  start)
    start_timer
    ;;
  pause)
    pause_timer
    ;;
  toggle)
    pause_timer
    ;;
  clear)
    clear_timer
    ;;
  init)
    init_timer
    ;;
  *)
    echo "Usage: $0 {start|pause|toggle|clear|init}"
    exit 1
    ;;
esac
