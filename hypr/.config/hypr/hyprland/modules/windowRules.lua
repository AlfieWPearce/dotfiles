
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
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



-- Rofi
hl.layer_rule({
    name = "rofi-popup",
    match = { namespace = "rofi"},
    animation = "slide bottom",
    dim_around = true
})

-- Photo-Widget
hl.layer_rule({
  match = { namespace = "gtk-layer-shell" },
  no_anim = false
})

-- Satty
hl.window_rule({match = {class = "^(com.gabm.satty)$"}, float = true})
hl.window_rule({match = {class = "^(com.gabm.satty)$"}, pin = true})

-- MPV
hl.window_rule({match = {class = "^(mpv)$"}, float = true})
hl.window_rule({match = {class = "^(mpv)$"}, center = true})
hl.window_rule({match = {class = "^(mpv)$"}, size = {"(monitor_w*0.70)", "(monitor_h*0.70)"}})

-- PiP
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true})
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, keep_aspect_ratio = true})
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, move = {"(monitor_w*0.73)", "(monitor_h*0.72)"} })
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, size = {"(monitor_w*0.25)", "(monitor_h*0.25)"} })
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, float = true})
hl.window_rule({match = {title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$" }, pin = true})

-- Quickshell Dynamic Island
hl.layer_rule({
  name = "quickshell-island",
  match = { namespace = "quickshell" },
  no_anim = true
}) 

-- Kando
-- ~/.config/hypr/hyprland.lua
hl.window_rule({
  name = "kando",
  match = {
      class = "menu.kando.Kando",
      title = "Kando Menu"
  },
  no_blur = true,
  opaque = true,
  move = {0, 0},
  rounding = 0,
  size = { "100%", "100%" },
  border_size = 0,
  no_anim = true,
  float = true,
  pin = true
})
--
-- QS dashboard
hl.window_rule({
  match = {
    class = "^(org\\.quickshell)$",
    title = "^(Dashboard)$"
  },
  float = true,
  pin = true,
  move = {"monitor_w*0.5-window_w*0.5", "0"},
  border = none
})
