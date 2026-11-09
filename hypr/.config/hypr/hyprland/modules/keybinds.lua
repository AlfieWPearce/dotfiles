-- Set programs that you use

require("hyprland/modules/variables")

-- Apps
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
-- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind("XF86HomePage", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + " .. altMod .. " + E", hl.dsp.exec_cmd(altFileManager))
hl.bind("XF86Favorites", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(financeManager))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(codeEditor))
hl.bind(mainMod .. " + " .. altMod .. " + C", hl.dsp.exec_cmd(altCodeEditor))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu))
hl.bind("XF86Search", hl.dsp.exec_cmd(menu))
hl.bind("menu", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(email))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("qs ipc call quicknote toggle"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(notification))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(systemMon))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("kitty ani-cli"))
hl.bind("XF86Calculator", hl.dsp.exec_cmd(calculator))

hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd("qs -p ~/.config/quickshell/quicksheet ipc call quicksheet toggle"))

hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("~/.local/bin/localport.sh"))

-- QS dashboard
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(dashboard))

-- Dashboard pages
-- hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(dashboard_home))
-- hl.bind(mainMod .. " + K", hl.dsp.exec_cmd(dashboard_kanban))
-- hl.bind(mainMod .. " + SHIFT + K", hl.dsp.exec_cmd(dashboard_settings))

-- hl.bind(mainMod .. "SHIFT + D", hl.dsp.exec_cmd(define))

--Screen Capturing
hl.bind("Print", hl.dsp.exec_cmd(screenshot))
-- hl.bind("F + Print", hl.dsp.exec_cmd(fullScreenshot))

-- hl.bind(mainMod .. " + " .. altMod .. " + Print", hl.dsp.exec_cmd(screenrecord))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(fullScreenrecord))

-- Windows
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + " .. altMod .. " + F", hl.dsp.exec_cmd("pkill waybar"))
hl.bind(mainMod .. " + " .. altMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only
-- hl.bind(mainMod .. " + X", hl.dsp.exec_cmd(privacy))
-- Window split ratio
hl.bind(mainMod .. " + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(mainMod .. " + Apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })

-- AppSwitcher
hl.bind("ALT + Tab", hl.dsp.exec_cmd("snappy-switcher next"))
hl.bind("ALT + SHIFT + Tab", hl.dsp.exec_cmd("snappy-switcher prev"))

-- hl.bind("CTRL + Space", hl.dsp.global("kando:main-menu"))

-- Looks
-- hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(scripts .. "/theme-menu.sh"))

-- Zoom
local function zoomfunction(value)
	local zoomvalue = hl.get_config("cursor:zoom_factor")
	if (zoomvalue + value) > 3.0 then
		hl.config({ cursor = { zoom_factor = 3.0 } })
	elseif (zoomvalue + value) < 1.0 then
		hl.config({ cursor = { zoom_factor = 1.0 } })
	else
		hl.config({ cursor = { zoom_factor = zoomvalue + value } })
	end
end
hl.bind(mainMod .. " + Minus", function()
	zoomfunction(-0.3)
end, { repeating = true, description = "Misc: Zoom out" })
hl.bind(mainMod .. " + Equal", function()
	zoomfunction(0.3)
end, { repeating = true, description = "Misc: Zoom in" })
--# Zoom with keypad
hl.bind("SUPER + code:82", function()
	zoomfunction(-0.3)
end, { repeating = true })
hl.bind("SUPER + code:86", function()
	zoomfunction(0.3)
end, { repeating = true })

-- Utils
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(scripts .. "/reload.sh"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd(powermenu))
-- hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + ALTMOD + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + " .. altMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end
--# keypad numbers
for i = 1, 10 do
	local numpadkey = { 87, 88, 89, 83, 84, 85, 79, 80, 81, 90 }
	hl.bind(mainMod .. " + code:" .. numpadkey[i], function()
		hl.dispatch(hl.dsp.focus({ workspace = i }))
	end)
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + M", hl.dsp.workspace.toggle_special("music"))
-- Alternate music (radio)
hl.bind(mainMod .. " + " .. altMod .. " + M", hl.dsp.exec_cmd(radio))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Audio controls
-- wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ &&
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
	{ locked = true, repeating = true }
)
-- wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- &&
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
	{ locked = true, repeating = true }
)
-- wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle &&
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(" swayosd-client --output-volume mute-toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)

-- Brightness controls
-- brightnessctl -e4 -n2 set 5%+ &&
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd("swayosd-client --brightness raise"),
	{ locked = true, repeating = true }
)
-- brightnessctl -e4 -n2 set 5%- &&
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd("swayosd-client --brightness lower"),
	{ locked = true, repeating = true }
)

-- Talk more to swayosd
hl.bind("Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"))

-- Media controls
--playerctl next
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("swayosd-client --playerctl next"), { locked = true })
--Playerctl pause-play
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("pause", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"))
