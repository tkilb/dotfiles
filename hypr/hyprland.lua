--------------------------------------------------------------------------------
-- Hyprland Lua Configuration
-- Migrated from legacy hyprlang (hyprland.conf)
-- Documentation: https://wiki.hypr.land/Configuring/Start/
--------------------------------------------------------------------------------

------------------
---- MONITORS ----
------------------

-- Default monitor fallback
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

-- External monitor
hl.monitor({
    output   = "DP-2",
    mode     = "preferred",
    position = "0x0",
    scale    = "auto",
})

-- Built-in display
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "1920x0",
    scale    = 1.88,
})


---------------------
---- MY PROGRAMS ----
---------------------

local fileManager      = "nemo"
local lockScreen       = "hyprlock"
local launcher         = "wofi --show drun"
-- local launcher      = "wofi --show drun --gtk-dark"
local screenshotRegion = "hyprshot -m region"
local terminal         = "kitty"
local browser          = "zen"


-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    hl.exec_cmd("xdg-mime default zen.desktop x-scheme-handler/http")
    hl.exec_cmd("xdg-mime default zen.desktop x-scheme-handler/https")
    hl.exec_cmd("xdg-mime default zen.desktop text/html")
    hl.exec_cmd("waybar & swaync & hypridle & hyprpaper")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Nordzy-hyprcursors-white")
hl.env("XCURSOR_THEME", "Nordzy-hyprcursors-white")
hl.env("GTK_THEME", "Adwaita-dark")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("BROWSER", "zen")
hl.env("HYPRSHOT_DIR", (os.getenv("HOME") or "") .. "/Pictures/Screenshots")


-----------------------
----- PERMISSIONS -----
-----------------------

-- hl.config({
--     ecosystem = {
--         enforce_permissions = true,
--     },
-- })
-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        no_focus_fallback = true,
        gaps_in           = 2,
        gaps_out          = 2,
        border_size       = 2,

        col = {
            active_border   = "rgba(458588ff)",
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = "rgba(1a1a1aee)",
        },

        blur = {
            enabled  = true,
            size     = 3,
            passes   = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = false,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = false,
    },

    input = {
        kb_layout          = "us",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "altwin:ctrl_win",
        kb_rules           = "",
        numlock_by_default = true,
        follow_mouse       = 1,
        sensitivity        = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local MAIN_MOD       = "CTRL + ALT"
local MAIN_MOD_SHIFT = "CTRL + ALT + SHIFT"
local RIGHT_CORNER   = "SHIFT + CTRL + ALT"

-- Applications & Windows
hl.bind(MAIN_MOD .. " + slash",     hl.dsp.exec_cmd(terminal))
hl.bind(RIGHT_CORNER .. " + L",     hl.dsp.exec_cmd(lockScreen))
hl.bind("CTRL + Q",                 hl.dsp.window.close())
hl.bind(RIGHT_CORNER .. " + Q",     hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch exit"))
hl.bind(MAIN_MOD .. " + Y",         hl.dsp.exec_cmd(fileManager))
hl.bind(RIGHT_CORNER .. " + S",     hl.dsp.exec_cmd(screenshotRegion))
hl.bind(MAIN_MOD .. " + backslash", hl.dsp.layout("togglesplit"))
-- hl.bind(MAIN_MOD .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(RIGHT_CORNER .. " + F",     hl.dsp.window.fullscreen())
hl.bind("ALT + SPACE",              hl.dsp.exec_cmd(launcher))
-- hl.bind(MAIN_MOD .. " + P",      hl.dsp.window.pseudo())
-- hl.bind(MAIN_MOD .. " + J",      hl.dsp.layout("togglesplit"))

-- Navigation & Window Movement Scripts
hl.bind(RIGHT_CORNER .. " + tab", hl.dsp.exec_cmd("sh -c '~/.dotfiles/hypr/scripts/movefocus.sh l r-1'"))
hl.bind(MAIN_MOD .. " + tab",     hl.dsp.exec_cmd("sh -c '~/.dotfiles/hypr/scripts/movefocus.sh r r+1'"))
-- hl.bind("ALT + up",            hl.dsp.focus({ direction = "up" }))
-- hl.bind("ALT + down",          hl.dsp.focus({ direction = "down" }))
hl.bind(MAIN_MOD .. " + T",       hl.dsp.exec_cmd("sh -c '~/.dotfiles/hypr/scripts/movewindow.sh r r+1'"))
hl.bind(MAIN_MOD .. " + R",       hl.dsp.exec_cmd("sh -c '~/.dotfiles/hypr/scripts/movewindow.sh l r-1'"))

-- Switch and move workspaces (Colemak-DH home row layout: H->1, ,->2, .->3, N->4, E->5, I->6)
local workspace_keys = {
    { key = "H",      ws = 1 },
    { key = "comma",  ws = 2 },
    { key = "period", ws = 3 },
    { key = "N",      ws = 4 },
    { key = "E",      ws = 5 },
    { key = "I",      ws = 6 },
}

for _, mapping in ipairs(workspace_keys) do
    hl.bind(MAIN_MOD .. " + " .. mapping.key,       hl.dsp.focus({ workspace = mapping.ws }))
    hl.bind(MAIN_MOD_SHIFT .. " + " .. mapping.key, hl.dsp.window.move({ workspace = mapping.ws }))
end

-- Assign specific apps to specific workspaces (focus follows window)
hl.bind(MAIN_MOD .. " + A", hl.dsp.exec_cmd("sh -c '~/.dotfiles/hypr/scripts/arrange.sh'"))

-- Power profile switching (cycle through profiles)
hl.bind(MAIN_MOD .. " + P", hl.dsp.exec_cmd([[sh -c 'current=$(powerprofilesctl get); case $current in balanced) powerprofilesctl set power-saver;; power-saver) powerprofilesctl set performance;; performance) powerprofilesctl set balanced;; esac; notify-send "$(powerprofilesctl get)"']]))

-- Move/resize windows with mouse dragging
hl.bind(MAIN_MOD .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(MAIN_MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { repeating = true, locked = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { repeating = true, locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { repeating = true, locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set +5%"),                         { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"),                          { repeating = true, locked = true })

-- Media player controls (playerctl)
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

hl.window_rule({
    name      = "bambustudio-workspace",
    match     = { class = "BambuStudio" },
    workspace = 1,
})


-----------------------
---- SPECIAL LOGIC ----
-----------------------

-- Ignore F24 key (sent as dummy by QMK) to prevent "387u" appearing in terminal
hl.bind("F24",         hl.dsp.exec_cmd("true"))
hl.bind("SHIFT + F24", hl.dsp.exec_cmd("true"))
