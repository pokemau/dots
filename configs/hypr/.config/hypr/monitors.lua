-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

local config_dir = os.getenv("HOME") .. "/..config/hypr/"

local file, err = io.open(config_dir .. "monitors.txt", "r")

local monitor_state = "0"

if not file then
  print("[LUA-MONITOR] Error opening file: " .. tostring(err))
else
  monitor_state = file:read("*all"):gsub("%s+", "")
  file:close()
end

hl.monitor({
    output   = "HDMI-A-1",
    mode     = "1920x1080@144",
    position = "1920x0",
    scale    = "1",
})

if monitor_state == "1" then
  hl.monitor({
    output = "eDP-1",
    disabled = true
  })
else
  hl.monitor({
    output = "eDP-1",
    mode = "1920x1200@60",
    position = "0x0",
    scale = "1",
    disabled = false
  })
end

