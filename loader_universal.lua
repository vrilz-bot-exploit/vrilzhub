if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(math.random())

local routes = {
    [124216119978534] = {
        "RideAPet",
        "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/features_rideapet.lua",
        "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/ui_rideapet.lua",
    },
    [10766972131] = {
        "Throw Food",
        "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/features_bikeforegg.lua",
        "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/ui_bikeforegg.lua",
    },
    [118517641508250] = {
        "Mount Soreya",
        "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/features_soreya.lua",
        "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/ui_soreya.lua",
    },
}

local route = routes[game.PlaceId] or routes[game.GameId]
if not route then return end

local genv = (getgenv and getgenv()) or _G
local state = genv.VRILZ_State or { loaded = {} }
genv.VRILZ_State = state
if state.loaded[route[1]] then return end

local function load(url)
    local ok, src = pcall(game.HttpGet, game, url)
    if not ok or not src then return nil end
    local fn = loadstring(src)
    if not fn then return nil end
    local ok2, res = pcall(fn)
    return ok2 and res or nil
end

local Shared = {}
_G.VRILZ_Shared = Shared
_G.VRILZ_UI_Shared = Shared

local Features = load(route[2])
if not Features then return end

local UI = load(route[3])
if not UI then return end

_G.VRILZ_Features = Features
pcall(UI.Init, Shared)

state.loaded[route[1]] = true
print("[VRILZHUB] Loaded:", route[1])
