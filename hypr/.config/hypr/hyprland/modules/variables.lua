local config = {}

-- Apps
terminal = "kitty"
fileManager = "kitty yazi"
financeManager = "cd ~/projects/ledger2 && source .venv/bin/activate && python3 main.py & disown && quit"
altFileManager = "thunar"
menu = "rofi -show combi"
-- menu = "./.config/rofi/launchers/type-6/launcher.sh"
-- Dashboard commands
dashboard = "qs ipc call dashboard toggle"
dashboard_home = "qs ipc call dashboard home"
dashboard_kanban = "qs ipc call dashboard kanban"
dashboard_settings = "qs ipc call dashboard settings"
powermenu = "pidof hyprlock || hyprlock"
-- powermenu      = "./.config/rofi/powermenu/type-4/powermenu.sh"
browser = "firefox"
music = "kitty rmpc"
radio = "kitty pyradio" --Alt music
email = "thunderbird"
notification = "swaync-client -t -swb"
codeEditor = "kitty nvim"
altCodeEditor = "code"
systemMon = "kitty btop"
calculator = "qalculate-gtk"

define = "~/.local/bin/define-word"

privacy = "eww active-windows | grep privacy && eww close privacy || eww open privacy"

screenshot = 'grim -g "$(slurp)" - | satty -f -'
fullScreenshot = "grim - | satty -f -"

screenrecord = "wf-recorder -f ~/Videos/recording.mp4"
fullScreenrecord = '$HOME/.config/hypr/hyprland/scripts/toggle-recording.sh'

-- Keybindings
mainMod = "SUPER"
altMod = "ALT"

-- Paths
wallpaper = "/mnt/shared/Wallpapers/wolf.jpg"
user = "alfiepearce"
scripts = "~/.config/hypr/hyprland/scripts"

return config
