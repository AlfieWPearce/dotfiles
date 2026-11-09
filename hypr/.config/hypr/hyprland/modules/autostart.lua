require("hyprland/modules/variables")

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
	-- Special Workspaces
	-- Special:magic
	--hl.exec_cmd("obsidian", { workspace = "special:magic silent" })
	--hl.exec_cmd("kitty nvim ~/Obsidian\\ Vault", { workspace = "special:magic silent" })
	--	hl.exec_cmd("nm-connection-editor", { workspace = "special:magic silent" })
	--	hl.exec_cmd(calculator, { workspace = "special:magic silent" })
	--	hl.exec_cmd("blueman-manager", { workspace = "special:magic silent" })
	--  hl.exec_cmd("pavucontrol",          { workspace = "special:magic silent"})
	-- Special:music
	--hl.exec_cmd("easyeffects", { workspace = "special:music silent" })
	hl.exec_cmd(music, { workspace = "special:music silent" })
  hl.exec_cmd("cava -p ~/.config/cava/quickshell.conf")
	--hl.exec_cmd(radio, { workspace = "special:music silent" })
	-- Network
	hl.exec_cmd("nm-applet")
	-- Pomodoro timer
	-- hl.exec_cmd("waybar_timer serve")
	--Way bar
	-- hl.exec_cmd("waybar")
  hl.exec_cmd("qs")
	-- App Switcher
	hl.exec_cmd("snappy-switcher --daemon")
	-- Background
	hl.exec_cmd("hyprpaper")
  -- Widgets
  -- hl.exec_cmd("eww daemon")
  -- hl.exec_cmd("eww open photo_frame_laptop")
  -- hl.exec_cmd("eww open photo_frame_external")
	-- Notifications
	-- hl.exec_cmd("swaync") --Using systemd
	-- Pop ups
	hl.exec_cmd("swayosd-server")
	hl.exec_cmd("mpd-mpris")
	-- hl.exec_cmd("~/.local/bin/battery-watch.sh") --Using systemd
	-- Automount external drives
	hl.exec_cmd("udiskie")
	-- Idle locking
	hl.exec_cmd("hypridle")
	-- Screenshare
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
	-- authentication
	-- hl.exec_cmd("systemctl --user start hyprpolkitagent")
	hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")

  hl.exec_cmd("qs -p ~/.config/quickshell/quicksheet")

  -- hl.exec_cmd("kando")
end)
