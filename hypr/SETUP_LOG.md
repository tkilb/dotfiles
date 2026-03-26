# Hyprland Dark Mode Setup

Created: 2026-03-21

## Overview

Configure dark mode for GTK4/libadwaita applications in Hyprland (Zen Browser, Nemo, etc.)

## Software Installed

```bash
sudo pacman -S gnome-themes-extra
```

Provides the Adwaita-dark GTK theme.

## Configuration Changes

### Dotfiles (`~/.dotfiles/hypr/hyprland.conf`)

Added environment variable (line ~35):

```ini
env = GTK_THEME,Adwaita-dark
```

### System Settings (gsettings)

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```

This is the primary setting that enables dark mode for GTK4/libadwaita applications.

## Summary - Replicate This Setup

1. **Install theme:**

   ```bash
   sudo pacman -S gnome-themes-extra
   ```

2. **Add to hyprland.conf:**

   ```ini
   env = GTK_THEME,Adwaita-dark
   ```

3. **Set dark mode preference:**

   ```bash
   gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
   ```

4. **Reload Hyprland** (ALT+SHIFT+Q)

## Notes

- GTK4/libadwaita apps read the `color-scheme` gsettings key
- The `GTK_THEME` env var helps with older GTK apps
- No legacy GTK2/GTK3 config files needed

Install hyprcursor via pacman
