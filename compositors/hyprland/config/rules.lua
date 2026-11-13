-- Window rules adapted from end-4

-- File dialogs & popups (float + center)
local dialog_titles = {
  "^(Open File)(.*)$",
  "^(Select a File)(.*)$",
  "^(Choose wallpaper)(.*)$",
  "^(Open Folder)(.*)$",
  "^(Save As)(.*)$",
  "^(Library)(.*)$",
  "^(File Upload)(.*)$",
  "^(.*)(wants to save)$",
  "^(.*)(wants to open)$",
}

for _, pat in ipairs(dialog_titles) do
  hl.window_rule({ match = { title = pat }, float = true })
  hl.window_rule({ match = { title = pat }, center = true })
end

-- Utility windows
local float_utils = {
  "^(pavucontrol)$",
  "^(org.pulseaudio.pavucontrol)$",
  "^(nm-connection-editor)$",
  "^(Zotero)$",
}

for _, cls in ipairs(float_utils) do
  hl.window_rule({ match = { class = cls }, float = true })
  hl.window_rule({ match = { class = cls }, size = { "(monitor_w*0.45)", "(monitor_h*0.45)" } })
  hl.window_rule({ match = { class = cls }, center = true })
end

hl.window_rule({ match = { class = "org.freedesktop.impl.portal.desktop.kde" }, float = true })
hl.window_rule({ match = { class = "org.freedesktop.impl.portal.desktop.kde" }, size = { "(monitor_w*0.60)", "(monitor_h*0.65)" } })
hl.window_rule({ match = { class = ".*bluedevilwizard" }, float = true })
hl.window_rule({ match = { class = "^(blueberry\\.py)$" }, float = true })

-- Google OAuth popup
hl.window_rule({ match = { class = "^(firefox)$", title = ".*(Google Аккаунты|Sign in - Claude).*" }, float = true })
hl.window_rule({ match = { class = "^(firefox)$", title = ".*(Google Аккаунты|Sign in - Claude).*" }, center = true })

-- Picture-in-Picture
local pip = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$"
hl.window_rule({ match = { title = pip }, float = true })
hl.window_rule({ match = { title = pip }, keep_aspect_ratio = true })
hl.window_rule({ match = { title = pip }, move = { "(monitor_w*0.73)", "(monitor_h*0.72)" } })
hl.window_rule({ match = { title = pip }, size = { "(monitor_w*0.25)", "(monitor_h*0.25)" } })
hl.window_rule({ match = { title = pip }, pin = true })

-- Screen sharing indicator
hl.window_rule({ match = { title = ".*is sharing (a window|your screen).*" }, float = true })
hl.window_rule({ match = { title = ".*is sharing (a window|your screen).*" }, pin = true })
hl.window_rule({ match = { title = ".*is sharing (a window|your screen).*" }, move = { "(monitor_w*.5-window_w*.5)", "(monitor_h-window_h-12)" } })

-- Hide sensitive windows from screen share
hl.window_rule({ match = { class = "cheating-daddy" }, no_screen_share = true })
hl.window_rule({ match = { class = "cheating daddy" }, no_screen_share = true })
hl.window_rule({ match = { class = "Cheating Daddy" }, no_screen_share = true })
hl.window_rule({ match = { class = "electron" }, no_screen_share = true })
hl.window_rule({ match = { class = "xdg-settings-daemon" }, no_screen_share = true })
hl.window_rule({ match = { class = "xdg-settings-daemon" }, float = true })
hl.window_rule({ match = { class = "xdg-settings-daemon" }, pin = true })

-- Suppress focus stealing & unwanted maximize overrides (from end-4 custom)
hl.window_rule({ match = { class = ".*" }, suppress_event = "maximize activate activatefocus" })

-- Tearing for games
hl.window_rule({ match = { title = ".*\\.exe" }, immediate = true })
hl.window_rule({ match = { title = ".*minecraft.*" }, immediate = true })
