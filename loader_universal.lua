-- ============================================================
-- VRILZHUB UNIVERSAL LOADER — CRAZY
-- ============================================================

print("[VRILZHUB] CRAZY")

local CONFIG = {
    RideAPet = {
        GameId = 124216119978534,
        FeaturesURL = "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/features_rideapet.lua",
        UIURL = "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/ui_rideapet.lua",
    },
    Throw Food = {
        GameId = 10766972131,    
FeaturesURL = "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/features_bikeforegg.lua",
        UIURL = "https://raw.githubusercontent.com/anakpungut014-sys/projectvh/refs/heads/main/ui_bikeforegg.lua",
    }
}

local targetScript = nil

if game.PlaceId == CONFIG.RideAPet.GameId then
    targetScript = CONFIG.RideAPet
elseif game.PlaceId == CONFIG.BikeForEgg.GameId then
    targetScript = CONFIG.BikeForEgg
else
    warn("[VRILZHUB] Game tidak didukung! Script dihentikan.")
    return
end

local function loadScript(url)
    local ok, source = pcall(function() return game:HttpGet(url) end)
    if not ok or not source then return nil end
    
    local fn, err = loadstring(source)
    if not fn then return nil end
    
    local ok2, result = pcall(fn)
    if not ok2 then return nil end
    
    return result
end

local Features = loadScript(targetScript.FeaturesURL)
if not Features then return end

local UI = loadScript(targetScript.UIURL)
if not UI then return end

local Shared = {}

_G.VRILZ_Features = Features
_G.VRILZ_Shared = Shared

UI.Init(Shared)
