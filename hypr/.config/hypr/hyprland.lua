-- Hyprland 0.57 (Lua config), riced Evangelion-style. Lives in ~/dotfiles/hypr (stowed).
-- SUPER is the WM key. Alt is left alone: tmux owns Alt binds (M-c, M-n, M-p, M-w...).
-- Colours come from themes/current (nerv or unit01); switch with `eva-theme nerv|unit01`.

local HOME = os.getenv("HOME")
local theme = dofile(HOME .. "/.config/hypr/themes/current/theme.lua")

local mod      = "SUPER"
local terminal = "alacritty"
local launcher = "wofi --show drun"
local browser  = "google-chrome"
local settings = "env XDG_CURRENT_DESKTOP=GNOME gnome-control-center"

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.on("hyprland.start", function()
    -- Tell systemd this is a graphical session: portals (dark mode, screen share, file pickers) need it
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE XCURSOR_THEME XCURSOR_SIZE QT_QPA_PLATFORMTHEME &&systemctl --user start hyprland-session.target")
    hl.exec_cmd("waybar")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    -- What GNOME used to provide
    hl.exec_cmd("systemctl --user start gnome-keyring-daemon.socket gnome-keyring-daemon.service hyprpolkitagent.service")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("nm-applet --indicator")
    -- GTK settings (EVA theme, icons, cursor, fonts, dark) for X11/XWayland apps; eva-theme rewrites + SIGHUPs it
    hl.exec_cmd("xsettingsd -c " .. HOME .. "/.config/xsettingsd/xsettingsd.conf")
    -- eva-wifi stays resident (hidden) so SUPER+SHIFT+W / the bar open it in ~100 ms
    hl.exec_cmd("eva-wifi --daemon")
    hl.exec_cmd("wl-paste --watch cliphist store")
    -- MAGI control centre and overview stay resident (hidden) so they open instantly
    hl.exec_cmd("magi --daemon")
    hl.exec_cmd("magi-overview --daemon")
    -- The MAGI scratchpad terminal waits, hidden, on its special workspace
    hl.exec_cmd(terminal .. " --class magi-scratch -e tmux new-session -A -s magi")
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
-- one cursor everywhere: Hyprland, GTK (gsettings), XWayland and Qt all use Adwaita
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("HYPRCURSOR_THEME", "Adwaita")
-- Qt apps take their palette and fonts from the EVA GTK theme
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

hl.config({
    general = {
        gaps_in = 3,
        gaps_out = 6,
        border_size = 3,
        col = {
            -- slowly rotating border on the focused window
            active_border   = { colors = { theme.accent, theme.accent2, theme.accent, theme.accent3, theme.accent }, angle = 45 },
            inactive_border = theme.inactive,
        },
        resize_on_border = true,
        layout = "dwindle",
    },
    -- Straight edges, like the statusline. Light blur behind translucent windows (Alacritty),
    -- kept cheap for the Intel UHD 620: small kernel, 2 passes, no xray.
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 0.93,
        dim_inactive = true,
        dim_strength = 0.06,
        shadow = { enabled = true, range = 14, render_power = 3, color = 0xaa000000 },
        blur = { enabled = true, size = 6, passes = 2, new_optimizations = true, xray = false, noise = 0.02, vibrancy = 0.2 },
    },
    animations = { enabled = true },
    dwindle = { preserve_split = true },
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        background_color = theme.base,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = true },
    },
})

-- Motion: quick and snappy; the border colours rotate forever
hl.curve("snappy", { type = "bezier", points = { {0.2, 0.9}, {0.1, 1.0} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.animation({ leaf = "global",      enabled = true, speed = 4,  bezier = "snappy" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3,  bezier = "snappy", style = "popin 90%" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 3,  bezier = "snappy", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "snappy", style = "slidevert" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 60, bezier = "linear", style = "loop" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

------------------------------------------------------------------ keys

-- Apps and windows
hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + Space",  hl.dsp.exec_cmd(launcher))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd(browser))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + F",      hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mod .. " + V",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + P",      hl.dsp.window.pseudo())
hl.bind(mod .. " + S",      hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + Escape", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mod .. " + SHIFT + E", hl.dsp.exit())

-- Focus with hjkl and arrows; move windows with SHIFT
local dirs = { h = "left", j = "down", k = "up", l = "right" }
for key, dir in pairs(dirs) do
    hl.bind(mod .. " + " .. key,         hl.dsp.focus({ direction = dir }))
    hl.bind(mod .. " + " .. dir,         hl.dsp.focus({ direction = dir }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
end

-- Resize with CTRL + hjkl
local step = 40
hl.bind(mod .. " + CTRL + h", hl.dsp.window.resize({ x = -step, y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + l", hl.dsp.window.resize({ x = step,  y = 0, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + k", hl.dsp.window.resize({ x = 0, y = -step, relative = true }), { repeating = true })
hl.bind(mod .. " + CTRL + j", hl.dsp.window.resize({ x = 0, y = step,  relative = true }), { repeating = true })

-- Workspaces 1-9; previous with Tab
for i = 1, 9 do
    hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
    hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(mod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))
-- Double-tap SUPER on its own: back to the previous workspace (like Alt+L in tmux)
hl.bind("Super_L", hl.dsp.exec_cmd("super-double-tap"), { release = true })

-- MAGI scratchpad: SUPER + ` drops it down over everything, again to hide.
-- SUPER + SHIFT + ` sends the focused window into it.
hl.bind(mod .. " + grave",         hl.dsp.workspace.toggle_special("magi"))
hl.bind(mod .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:magi" }))
hl.window_rule({
    name = "magi-scratch", match = { class = "^magi-scratch$" },
    workspace = "special:magi silent", float = true, size = "monitor_w*0.7 monitor_h*0.65", center = true,
})

-- WINDOW MODE: SUPER + A ("arrange") to enter. (A bare SUPER tap was too easy to hit by
-- habit from GNOME, and then typed letters became window commands.)
-- Inside it plain keys work, no chords: h j k l focus, H J K L move, arrows resize,
-- 1-9 workspace, f fullscreen, v float, q close, ` scratchpad. Esc / Enter leaves.
hl.bind(mod .. " + A", hl.dsp.submap("window"))
hl.define_submap("window", function()
    for key, dir in pairs(dirs) do
        hl.bind(key,              hl.dsp.focus({ direction = dir }))
        hl.bind("SHIFT + " .. key, hl.dsp.window.move({ direction = dir }))
    end
    hl.bind("left",  hl.dsp.window.resize({ x = -step, y = 0, relative = true }), { repeating = true })
    hl.bind("right", hl.dsp.window.resize({ x = step,  y = 0, relative = true }), { repeating = true })
    hl.bind("up",    hl.dsp.window.resize({ x = 0, y = -step, relative = true }), { repeating = true })
    hl.bind("down",  hl.dsp.window.resize({ x = 0, y = step,  relative = true }), { repeating = true })
    for i = 1, 9 do hl.bind(tostring(i), hl.dsp.focus({ workspace = i })) end
    hl.bind("f",     hl.dsp.window.fullscreen({ action = "toggle" }))
    hl.bind("v",     hl.dsp.window.float({ action = "toggle" }))
    hl.bind("q",     hl.dsp.window.close())
    hl.bind("grave", hl.dsp.workspace.toggle_special("magi"))
    hl.bind("escape",  hl.dsp.submap("reset"))
    hl.bind("Return",  hl.dsp.submap("reset"))
    hl.bind(mod .. " + A", hl.dsp.submap("reset"))
end)

-- Mouse: SUPER + drag to move, SUPER + right-drag to resize
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Settings GNOME used to show; eva-bluetooth picker for Bluetooth (blueman-applet stays for pairing prompts)
hl.bind(mod .. " + SHIFT + B", hl.dsp.exec_cmd("eva-bluetooth"))
hl.bind(mod .. " + SHIFT + W", hl.dsp.exec_cmd("eva-wifi"))
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(settings .. " sound"))

-- MAGI control centre (network, bluetooth, sound, display, power, theme); files
hl.bind(mod .. " + SHIFT + Space", hl.dsp.exec_cmd("magi"))
hl.bind(mod .. " + E",             hl.dsp.exec_cmd("nautilus --new-window"))
hl.bind(mod .. " + O",             hl.dsp.exec_cmd("magi-overview"))
-- ranger in Alacritty (SUPER+SHIFT+E stays "exit Hyprland")
hl.bind(mod .. " + R",             hl.dsp.exec_cmd(terminal .. " --class eva-files -e ranger"))

-- Wallpapers, theme, clipboard
hl.bind(mod .. " + W",         hl.dsp.exec_cmd("wall-next"))
hl.bind(mod .. " + SHIFT + T", hl.dsp.exec_cmd("eva-theme toggle"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | wofi --dmenu | cliphist decode | wl-copy"))

-- Screenshots (grim + slurp): region to clipboard, whole screen to a file
hl.bind("Print",         hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd('grim ~/Pictures/screenshot-$(date +%F-%H%M%S).png'))

-- Volume, brightness, media keys
local lr = { locked = true, repeating = true }
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), lr)
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), lr)
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), lr)
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), lr)
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

------------------------------------------------------------------ rules

-- Ignore apps asking to maximize themselves
hl.window_rule({ name = "suppress-maximize", match = { class = ".*" }, suppress_event = "maximize" })
-- Settings windows float, centred
hl.window_rule({ name = "float-settings", match = { class = "^(org.gnome.Settings|blueman-manager|nm-connection-editor)$" }, float = true, center = true, size = "60% 70%" })
-- eva-wifi / eva-bluetooth / magi / magi-overview are layer-shell overlays (gtk4-layer-shell,
-- see eva_layer.py and the layer rules below). These three window rules only apply in the
-- fallback, when gtk4-layer-shell is missing or EVA_NO_LAYER=1 makes them plain windows.
-- Pickers: top-right under the bar; they draw their own 1px accent frame
hl.window_rule({ name = "eva-pickers", match = { class = "^(eva-wifi|eva-bluetooth)$" }, float = true, pin = true, size = "520 600", move = "monitor_w-526 32", border_size = 0, no_anim = true, no_shadow = true })
-- MAGI control centre centred; overview a large centred panel
hl.window_rule({ name = "magi", match = { class = "^magi$" }, float = true, pin = true, center = true, size = "880 600", border_size = 0, no_anim = true })
hl.window_rule({ name = "magi-overview", match = { class = "^magi-overview$" }, float = true, pin = true, center = true, size = "monitor_w*0.8 monitor_h*0.84", border_size = 0, no_anim = true })
-- ranger (SUPER+R, magi TOOLS): a floating, centred terminal file manager
hl.window_rule({ name = "eva-files", match = { class = "^eva-files$" }, float = true, center = true, size = "monitor_w*0.62 monitor_h*0.66" })
-- Nautilus tiles like any app; its small dialogs (properties, rename, compress) float
hl.window_rule({ name = "nautilus-tile", match = { class = "^org.gnome.Nautilus$" }, tile = true })
hl.window_rule({ name = "nautilus-dialogs", match = { class = "^org.gnome.Nautilus$", title = "^(Properties|.* Properties|Rename.*|Compress.*|Confirm.*|Create New Folder)$" }, float = true, center = true })
-- GTK portal file chooser (Chrome / Electron upload and save dialogs): float, centred, roomy
hl.window_rule({ name = "file-chooser", match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-gnome)$" }, float = true, center = true, size = "1000 680" })

-- Blur the bar and notifications
hl.layer_rule({ name = "blur-bar",  match = { namespace = "^waybar$" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ name = "blur-mako", match = { namespace = "^notifications$" }, blur = true, ignore_alpha = 0.2 })
-- EVA overlays: blurred glass behind their 93-95% backgrounds; no slide-in (they toggle
-- instantly and draw their own frame). Their click-outside "scrim" (1% alpha) stays unblurred.
hl.layer_rule({ name = "eva-overlays", match = { namespace = "^(eva-wifi|eva-bluetooth|magi|magi-overview)$" }, blur = true, ignore_alpha = 0.2, no_anim = true })
hl.layer_rule({ name = "eva-scrims",   match = { namespace = "^(eva-wifi|eva-bluetooth|magi|magi-overview)-scrim$" }, no_anim = true })
