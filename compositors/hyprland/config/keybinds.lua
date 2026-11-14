local mainMod = _G.mainMod or "SUPER"
local terminal = _G.terminal or "kitty"
local fileManager = _G.fileManager or "dolphin"
local browser = _G.browser or "firefox"
local codeEditor = _G.codeEditor or "vscodium"

-- Gestures & Mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Window focus & move (end-4 style)
hl.bind(mainMod .. " + Left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + Left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + Up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + Down", hl.dsp.window.move({ direction = "d" }))

-- Window resize & split ratio (end-4 style)
hl.bind(mainMod .. " + CTRL + SHIFT + Left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + Right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + Up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + SHIFT + Down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + Semicolon", hl.dsp.layout("splitratio -0.1"), { repeating = true })
hl.bind(mainMod .. " + Apostrophe", hl.dsp.layout("splitratio +0.1"), { repeating = true })

-- Window state (end-4 style)
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind("ALT + F4", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind(mainMod .. " + D", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
hl.bind(mainMod .. " + ALT + Space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pin())

-- Apps (end-4 style)
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind("CTRL + ALT + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(codeEditor))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("serpantinum msg toggle settings"))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("kitty -e btop"))

-- Serpantinum shell panels (mapped to end-4 habits)
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("serpantinum msg toggle launcher"), { release = true })
hl.bind("SUPER + SUPER_R", hl.dsp.exec_cmd("serpantinum msg toggle launcher"), { release = true })
hl.bind(mainMod .. " + Tab", hl.dsp.exec_cmd("serpantinum msg toggle launcher"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("serpantinum msg toggle clipboard"))
hl.bind("CTRL + " .. mainMod .. " + T", hl.dsp.exec_cmd("serpantinum msg toggle wallpaper"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("serpantinum msg toggle music"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("serpantinum msg toggle system"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("serpantinum msg toggle system"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("serpantinum msg toggle network"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("serpantinum msg toggle calendar"))
hl.bind("CTRL + " .. mainMod .. " + V", hl.dsp.exec_cmd("serpantinum msg toggle volume"))
hl.bind(mainMod .. " + J", hl.dsp.exec_cmd("serpantinum msg bar autohide"))
hl.bind("CTRL + " .. mainMod .. " + R", hl.dsp.exec_cmd("serpantinum reload"))
hl.bind(mainMod .. " + Slash", hl.dsp.exec_cmd("serpantinum msg toggle cheatsheet"))
hl.bind(mainMod .. " + question", hl.dsp.exec_cmd("serpantinum msg toggle cheatsheet"))

-- Screenshots, OCR, Search, Record & Color picker (end-4)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("/home/nursayat/.local/bin/end4-region screenshot"), { locked = true })
hl.bind(mainMod .. " + SHIFT + A", hl.dsp.exec_cmd("/home/nursayat/.local/bin/end4-region search"), { locked = true })
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("/home/nursayat/.local/bin/end4-region ocr"), { locked = true })
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("serpantinum screenshot --record"), { locked = true })
hl.bind(mainMod .. " + ALT + R", hl.dsp.exec_cmd("serpantinum screenshot --record"), { locked = true })
hl.bind(mainMod .. " + SHIFT + ALT + R", hl.dsp.exec_cmd("serpantinum screenshot --record --full"), { locked = true })
hl.bind("Print", hl.dsp.exec_cmd("grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\" - | wl-copy"), { locked = true })
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("mkdir -p \"$(xdg-user-dir PICTURES)/Screenshots\" && grim -o \"$(hyprctl activeworkspace -j | jq -r '.monitor')\" \"$(xdg-user-dir PICTURES)/Screenshots/Screenshot_$(date '+%Y-%m-%d_%H.%M.%S').png\""), { locked = true })
hl.bind("SUPER + Print", hl.dsp.exec_cmd("serpantinum screenshot --full"), { locked = true })
hl.bind("SUPER + SHIFT + Print", hl.dsp.exec_cmd("serpantinum screenshot --edit"), { locked = true })
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker -a"))

-- Session & Hardware keys
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("serpantinum lock"), { locked = true })
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("serpantinum lock"), { repeating = true, locked = true })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("serpantinum suspend"), { locked = true })
hl.bind("CTRL + ALT + Delete", hl.dsp.exec_cmd("serpantinum msg toggle system"))

hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("serpantinum brightness lower"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("serpantinum brightness raise"), { locked = true })

hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("serpantinum volume mic-toggle"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("serpantinum volume mute-toggle"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("serpantinum volume lower"), { repeating = true, locked = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("serpantinum volume raise"), { repeating = true, locked = true })

-- Workspaces (end-4 style: SUPER + 1..0, SUPER + ALT + 1..0, scroll/arrows)
for i = 1, 10 do
  local ws = tostring(i)
  local key = tostring(i % 10)
  hl.bind(mainMod .. " + " .. key, hl.dsp.exec_cmd("serpantinum msg workspace " .. ws))
  hl.bind(mainMod .. " + ALT + " .. key, hl.dsp.exec_cmd("serpantinum msg workspace " .. ws .. " move"))
end

hl.bind("CTRL + " .. mainMod .. " + Left", hl.dsp.focus({ workspace = "r-1" }))
hl.bind("CTRL + " .. mainMod .. " + Right", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + Page_Up", hl.dsp.focus({ workspace = "r-1" }))
hl.bind(mainMod .. " + Page_Down", hl.dsp.focus({ workspace = "r+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))

-- Scratchpad (end-4 style)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("special"))
hl.bind(mainMod .. " + mouse:275", hl.dsp.workspace.toggle_special("special"))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({ workspace = "special:special", follow = false }))

-- PhantomPlayer MPRIS keybinds (from end-4 custom config)
hl.bind("mouse:276", hl.dsp.exec_cmd("playerctl --player=PhantomPlayer next || /home/nursayat/Documents/MyProjects/PhantomPlayer/phantom-trigger.sh"))
hl.bind("CTRL + Space", hl.dsp.exec_cmd("playerctl --player=PhantomPlayer next || /home/nursayat/Documents/MyProjects/PhantomPlayer/phantom-trigger.sh"))
hl.bind("mouse:274", hl.dsp.exec_cmd("playerctl --player=PhantomPlayer stop"))
hl.bind("CTRL + SHIFT + E", hl.dsp.exec_cmd("playerctl --player=PhantomPlayer stop"))
hl.bind("CTRL + SHIFT + Space", hl.dsp.exec_cmd("/home/nursayat/Documents/MyProjects/PhantomPlayer/phantom-toggle.sh"))
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd("/home/nursayat/Documents/MyProjects/PhantomPlayer/phantom-toggle.sh"))
