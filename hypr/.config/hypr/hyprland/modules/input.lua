hl.config({
    input = {
        kb_layout  = "gb",

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Workspace
hl.gesture({
    fingers = 4,
    direction = "horizontal",
    action = "workspace"
})

-- Window movement
hl.gesture({
    fingers = 3,
    direction = "swipe",
    action = "move"
})

-- Fullscreen
hl.gesture({
    fingers = 3,
    direction = "pinchin",
    action = "fullscreen"
})

-- Floating
hl.gesture({
    fingers = 3,
    direction = "pinchout",
    action = "float"
})