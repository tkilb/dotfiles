#!/bin/sh

# Get memory statistics from vm_stat
# Page size is typically 4096 bytes on macOS
PAGE_SIZE=$(pagesize)

# Get memory info
VM_STAT=$(vm_stat)

# Extract values (vm_stat outputs in pages)
PAGES_FREE=$(echo "$VM_STAT" | awk '/Pages free/ {gsub(/\./, "", $3); print $3}')
PAGES_ACTIVE=$(echo "$VM_STAT" | awk '/Pages active/ {gsub(/\./, "", $3); print $3}')
PAGES_INACTIVE=$(echo "$VM_STAT" | awk '/Pages inactive/ {gsub(/\./, "", $3); print $3}')
PAGES_WIRED=$(echo "$VM_STAT" | awk '/Pages wired down/ {gsub(/\./, "", $4); print $4}')
PAGES_COMPRESSED=$(echo "$VM_STAT" | awk '/Pages occupied by compressor/ {gsub(/\./, "", $5); print $5}')

# Calculate memory in GB
MEMORY_USED=$(echo "scale=1; ($PAGES_ACTIVE + $PAGES_WIRED + $PAGES_COMPRESSED) * $PAGE_SIZE / 1024 / 1024 / 1024" | bc)
MEMORY_FREE=$(echo "scale=1; $PAGES_FREE * $PAGE_SIZE / 1024 / 1024 / 1024" | bc)
MEMORY_TOTAL=$(sysctl -n hw.memsize | awk '{print $1/1024/1024/1024}')

# Calculate percentage
MEMORY_PERCENT=$(echo "scale=0; ($MEMORY_USED / $MEMORY_TOTAL) * 100" | bc)

# Choose icon based on usage
if [ "$MEMORY_PERCENT" -ge 90 ]; then
  ICON="󰘚"
  ICON_COLOR="0xFFCC241D"  # Red
elif [ "$MEMORY_PERCENT" -ge 70 ]; then
  ICON="󰘚"
  ICON_COLOR="0xFFD79921"  # Yellow
else
  ICON="󰘚"
  ICON_COLOR="0xFF98971A"  # Green
fi

# Update the bar item
sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$ICON_COLOR" \
  label="${MEMORY_USED}"
