# Nordzy Cursors Setup for Hyprland (hyprcursor)

## Prerequisites
- Hyprland with hyprcursor support (v0.54.1+ with hyprcursor 0.1.13+)
- Arch Linux with AUR helper (yay)

## Installation Steps

### 1. Install the hyprcursor theme package

```bash
yay -S nordzy-hyprcursors
```

This installs 4 variants to `/usr/share/icons/`:
- `Nordzy-hyprcursors` (default)
- `Nordzy-hyprcursors-lefthand`
- `Nordzy-hyprcursors-white`
- `Nordzy-hyprcursors-white-lefthand`

### 2. Set the environment variable

Add to `~/.profile` (sourced before Hyprland starts):

```bash
export HYPRCURSOR_THEME="Nordzy-hyprcursors"
```

**Important:** Do NOT use `env =` in hyprland.conf - it only affects child processes, not Hyprland itself.

### 3. Restart Hyprland

Fully exit and restart your Hyprland session:
```bash
# Exit Hyprland (e.g., ALT+SHIFT+Q or however you configured it)
# Then restart:
start-hyprland
```

### 4. Verify

Check the theme is loaded:
```bash
ls /usr/share/icons/Nordzy-hyprcursors/
# Should show: hyprcursors/  manifest.hl
```

## Switching Variants

To use a different variant, change the env variable in `~/.profile`:

```bash
export HYPRCURSOR_THEME="Nordzy-hyprcursors-lefthand"
# or
export HYPRCURSOR_THEME="Nordzy-hyprcursors-white"
# or
export HYPRCURSOR_THEME="Nordzy-hyprcursors-white-lefthand"
```

Then restart Hyprland.

## Troubleshooting

1. **Cursor not changing:** Make sure you restarted Hyprland (not just reloaded config)
2. **Wrong cursor size:** The theme includes its own size, but you can check with `echo $HYPRCURSOR_SIZE`
3. **Check logs:** `hyprctl rollinglog | grep -i cursor`

## Links

- Theme: https://github.com/guillaumeboehm/Nordzy-cursors
- Hyprcursor docs: https://wiki.hyprland.org/Hypr-Ecosystem/hyprcursor/
