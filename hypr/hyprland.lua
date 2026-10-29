-- Hyprland Lua config
-- Wiki: https://wiki.hypr.land/Configuring/Start/


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "1920x1080@144hz",
    position = "auto",
    scale    = "1",
})


---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"
local fileManager = "dolphin"
local menu        = "hyprlauncher"
local rofiCmd     = "pkill rofi || rofi -show drun -show-icons -theme ~/.config/rofi/spotlight.rasi"
local ipc = "noctalia msg "


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1")


-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function ()
    hl.exec_cmd(terminal)
    hl.exec_cmd("noctalia")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 7,
        gaps_out = 12,

        border_size = 0,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = true,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 24,
        rounding_power = 2,

        active_opacity   = 0.9,
        inactive_opacity = 0.8,

        screen_shader = "/home/mahmoud/.config/hypr/shaders/color.frag",

        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 10,
            color        = 0xee1a1a1a,
        },

        -- إعدادات التمويه السائل والعميق المحاكي لـ macOS
        blur = {
            enabled           = true,
            size              = 10,
            passes            = 4,
            new_optimizations = true,
            vibrancy          = 0.2,       -- حيوية الألوان خلف زجاج الماك
            brightness        = 1.1,       -- لمعان خفيف وإضاءة زجاجية
        },
    },

    animations = {
        enabled = true,
    },
})


----------------------
---- ANIMATIONS  -----
----------------------

hl.curve("smooth",       { type = "bezier", points = { { 0.22, 1 },   { 0.1, 1.1 } } })
hl.curve("quick",        { type = "bezier", points = { { 0.15, 0.85 }, { 0.25, 1.0 } } })
hl.curve("overshot",     { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.08 } } })
hl.curve("linearish",    { type = "bezier", points = { { 0.3, 0.0 },  { 0.7, 1.0 } } })
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 },   { 0.32, 1 } } })

-- Windows
hl.animation({ leaf = "windows",     enabled = true, speed = 4, bezier = "smooth", style = "popin 95%" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 4, bezier = "smooth", style = "popin 85%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3, bezier = "quick",  style = "popin 90%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3, bezier = "quick" })

-- Workspaces
hl.animation({ leaf = "workspaces",       enabled = true, speed = 5, bezier = "smooth", style = "slidefade 20%" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3, bezier = "smooth", style = "slidefadevert 5%" })

-- Layers
hl.animation({ leaf = "layers",        enabled = true, speed = 3, bezier = "quick",     style = "fade" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 3, bezier = "quick",     style = "popin 95%" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 3, bezier = "quick",     style = "popin 95%" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 3, bezier = "linearish" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 3, bezier = "linearish" })

-- Fade
hl.animation({ leaf = "fade", enabled = true, speed = 4, bezier = "smooth" })


----------------
---- LAYOUT ----
----------------

hl.config({ dwindle   = { preserve_split = true } })
hl.config({ master    = { new_status = "master" } })
hl.config({ scrolling = { fullscreen_on_one_column = false } })


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo   = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,ara",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:alt_shift_toggle",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


-----------------------
---- LAYER RULES  -----
-----------------------

hl.layer_rule({ name = "blur-dock",   match = { namespace = "^nwg-dock$" },   blur = true, ignore_alpha = 0.2 })

hl.layer_rule({
    name  = "noctalia",
    match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
    no_anim      = true,
    ignore_alpha = 0.5,
    blur         = true,
    blur_popups  = true,
})

hl.window_rule({
    name  = "noctalia-settings",
    match = { class = "dev.noctalia.Noctalia" },
    float = true,
    size  = { 1080, 920 },
})



---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(
    [[mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png]]
))
hl.bind("CTRL + Print", hl.dsp.exec_cmd(
    [[mkdir -p ~/Pictures/Screenshots && grim -g "$(slurp)" ~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png]]
))

-- Apps
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + F1", hl.dsp.exec_cmd("/home/mahmoud/.local/bin/toggle-shader.sh"))

-- Noctalia
hl.bind(mainMod .. " + Super_L",
    hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"), { release = true })
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher hold"))

-- Brightness / volume
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"))

-- Launchers
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(rofiCmd))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(rofiCmd))

-- Wallpaper
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("waypaper"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("waypaper --random"))

-- Window management
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen())

-- Focus direction
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces: SUPER + 1..9, SUPER + 0 = workspace 10
-- Move active window: SUPER + SHIFT + number
for i = 1, 10 do
    local key = tostring(i % 10)

    hl.bind(mainMod .. " + " .. key,
        hl.dsp.focus({ workspace = i }))

    hl.bind(mainMod .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i }))
end

-- Previous / next workspace
hl.bind(mainMod .. " + PAGE_UP",
    hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + PAGE_DOWN",
    hl.dsp.focus({ workspace = "e+1" }))

-- Previous workspace
hl.bind(mainMod .. " + TAB",
    hl.dsp.focus({ workspace = "previous" }))

-- Scroll through workspaces while holding SUPER
hl.bind(mainMod .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" }))

-- Window management
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.window.fullscreen())

-- Toggle floating
hl.bind(mainMod .. " + V",
    hl.dsp.window.float({ action = "toggle" }))

-- HyprMod managed settings
require("hyprland-gui")




