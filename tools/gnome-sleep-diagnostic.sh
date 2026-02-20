#!/bin/bash
# Gnome Sleep Issue Diagnostic Script for Arch Linux
# Run this script after experiencing the unwanted sleep behavior

echo "=========================================="
echo "GNOME SLEEP DIAGNOSTIC REPORT"
echo "Generated: $(date)"
echo "=========================================="
echo ""

echo "=== 1. GNOME POWER SETTINGS ==="
echo "AC timeout (0 = never):"
gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 2>/dev/null || echo "  Not available"
echo "Battery timeout (0 = never):"
gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 2>/dev/null || echo "  Not available"
echo "Automatic suspend:"
gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 2>/dev/null || echo "  Not available"
echo ""

echo "=== 2. GNOME SESSION IDLE SETTINGS ==="
echo "Idle delay (seconds):"
gsettings get org.gnome.desktop.session idle-delay 2>/dev/null || echo "  Not available"
echo ""

echo "=== 3. SYSTEMD LOGIND CONFIGURATION ==="
echo "Current logind settings:"
systemctl show systemd-logind.service | grep -E "(IdleAction|HandleLidSwitch|HandleSuspendKey)" || echo "  Unable to read"
echo ""
echo "logind.conf contents:"
grep -v "^#" /etc/systemd/logind.conf | grep -v "^$" || echo "  All defaults (file not modified)"
echo ""

echo "=== 4. RECENT SLEEP/WAKE EVENTS ==="
echo "Last 20 sleep/suspend/wake events:"
journalctl -b --no-pager | grep -i -E "(sleep|suspend|wake|resumed)" | tail -20 || echo "  No events found"
echo ""

echo "=== 5. SYSTEMD-LOGIND RECENT ACTIVITY ==="
echo "Last 30 lines from logind:"
journalctl -b -u systemd-logind --no-pager | tail -30 || echo "  Unable to read journal"
echo ""

echo "=== 6. POWER MANAGEMENT INHIBITORS ==="
echo "Current inhibitors (things preventing sleep):"
systemd-inhibit --list 2>/dev/null || echo "  Unable to list inhibitors"
echo ""

echo "=== 7. SWAP/HIBERNATE STATUS ==="
echo "Swap status:"
swapon --show || echo "  No swap enabled"
echo ""
echo "Hibernate available:"
systemctl status systemd-hibernate.service 2>/dev/null | grep -i active || echo "  Not configured"
echo ""

echo "=== 8. POWER PROFILES ==="
if command -v powerprofilesctl &> /dev/null; then
    echo "Current power profile:"
    powerprofilesctl get
    echo "Available profiles:"
    powerprofilesctl list
else
    echo "  powerprofilesctl not available"
fi
echo ""

echo "=== 9. UPOWER INFORMATION ==="
if command -v upower &> /dev/null; then
    echo "System power status:"
    upower -d | grep -A 10 "Daemon:" || echo "  Unable to query upower"
else
    echo "  upower not available"
fi
echo ""

echo "=== 10. CHECKING FOR WAKE TIMERS ==="
echo "RTC wake alarms:"
cat /sys/class/rtc/rtc0/wakealarm 2>/dev/null || echo "  No wake alarm set"
echo ""
echo "Checking /proc for wake-enabled devices:"
grep enabled /proc/acpi/wakeup 2>/dev/null || echo "  /proc/acpi/wakeup not available"
echo ""

echo "=========================================="
echo "DIAGNOSTIC COMPLETE"
echo "=========================================="
echo ""
echo "NEXT STEPS:"
echo "1. Review the settings above, particularly sections 1-3"
echo "2. To disable auto-suspend, run:"
echo "   gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0"
echo "3. To disable systemd idle action, edit /etc/systemd/logind.conf:"
echo "   Add or uncomment: IdleAction=ignore"
echo "   Then: sudo systemctl restart systemd-logind"
echo ""
echo "To monitor in real-time when issue occurs:"
echo "   journalctl -f"
