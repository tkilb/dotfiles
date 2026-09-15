# Rofi Configuration & Theming Guide

This runbook documents the Rofi setup for Hyprland on Arch Linux, including how to modify themes, adjust layouts, configure keybindings, test changes, and perform rollbacks.

---

## 1. Quick Reference & Documentation Links

- **Official Rofi Documentation**: [davatorium.github.io/rofi](https://davatorium.github.io/rofi/)
- **Official Repository**: [github.com/davatorium/rofi](https://github.com/davatorium/rofi)
- **Theme Specification (RASI format)**: [man rofi-theme(5)](https://man.archlinux.org/man/rofi-theme.5)
- **Rofi Command Line Options**: [man rofi(1)](https://man.archlinux.org/man/rofi.1)

---

## 2. File Locations & Symlinks

| Component            | Path                             | Description                                |
| :------------------- | :------------------------------- | :----------------------------------------- |
| **Source Config**    | `~/.dotfiles/rofi/config.rasi`   | Main Rofi configuration and minimal theme  |
| **System Symlink**   | `~/.config/rofi/config.rasi`     | Target symlink managed via dotfiles linker |
| **Hyprland Keybind** | `~/.dotfiles/hypr/hyprland.lua`  | Hotkey binding (`ALT + SPACE`)             |
| **Dotfile Linker**   | `~/.dotfiles/linker/linker.yaml` | Machine-specific dotfile symlink registry  |

---

## 3. How Rofi Theming Works (`.rasi` format)

Rofi uses the **RASI (Rofi Advanced Style Information)** format, which is structurally similar to CSS.

### Structural Hierarchy

```
window
 └── mainbox
      ├── inputbar
      │    ├── prompt ("")
      │    └── entry (text field)
      └── listview
           └── element (per search result)
                ├── element-icon
                └── element-text
```

### Color & Property Variables

All palette definitions are placed at the root `* { ... }` block in `config.rasi`:

- `bg-primary`: Outer window background (Gruvbox `#282828e6` with alpha channel).
- `bg-secondary`: Surface background for input box and active pills (`#3c3836`).
- `bg-selected`: Subtle highlight background for the active element (`#45858833`).
- `fg-primary`: Standard text color (`#ebdbb2`).
- `accent`: Hyprland-matching active border color (`#458588` blue).

---

## 4. Common Customization Tasks

### A. Changing the Window Size or Position

Edit the `window` block in `~/.dotfiles/rofi/config.rasi`:

```rasi
window {
    width:      520px;       /* Set pixel width or percentage (e.g. 30%) */
    location:   center;      /* center, north, south, east, west, northwest, etc. */
    border:     2px solid;
    border-radius: 10px;    /* Matches Hyprland decoration.rounding */
}
```

### B. Adjusting Visible Items & Columns

Edit the `listview` block in `~/.dotfiles/rofi/config.rasi`:

```rasi
listview {
    lines:      8;          /* Number of rows shown without scrolling */
    columns:    1;          /* Set to 2 or 3 for grid layouts */
    spacing:    4px;        /* Spacing between items */
}
```

### C. Changing the Hotkey or Launch Modes

In `~/.dotfiles/hypr/hyprland.lua`:

- Custom launcher with browser search fallback: `rofi -show launcher -modes "launcher:~/.config/rofi/scripts/launcher.sh"`
- Standard desktop application launcher: `rofi -show drun`
- To show all binaries: `rofi -show run`
- To show active windows: `rofi -show window`
- Combined multi-mode: `rofi -show combi -combi-modi "drun,run"`

### D. Launcher Script Behavior (`scripts/launcher.sh`)

- **Application matching**: Scans `.desktop` entries across user and system XDG directories.
- **Search Fallback**: If an unlisted query or search phrase is submitted, it opens a Google search in your default browser (`zen`) and switches focus to Hyprland workspace 2.
- **Direct URLs / Localhost**: If the input is a URL, domain, or localhost/IP address, it navigates directly to the target address.

---

## 5. Testing & Debugging

You can test changes immediately without restarting Hyprland:

```bash
# Launch Rofi desktop search directly in terminal
rofi -show drun

# Test with a temporary custom theme file
rofi -show drun -theme /path/to/test_theme.rasi

# Dump current resolved configuration for troubleshooting
rofi -dump-config
```
