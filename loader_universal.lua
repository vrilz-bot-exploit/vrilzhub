-- ============================================================
-- VRILZHUB LOADER — RIDE A PET v2
-- Repo: vrilz-bot-exploit/vrilzhub
-- ============================================================

local CONFIG = {
    GameId = 124216119978534, -- Ride a Pet
    FeaturesURL = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/features_rideapet.lua",
    UIURL = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/ui_rideapet.lua",
}

-- ============================================================
-- CEK GAME
-- ============================================================
if game.PlaceId ~= CONFIG.GameId then
    local WS = game:GetService("Workspace")
    if not WS:FindFirstChild("RenderedEggs") then
        warn("[VRILZHUB] Bukan game Ride a Pet, abort")
        return
    end
end

print("[VRILZHUB] Loading...")

-- ============================================================
-- ⭐ BUAT SHARED GLOBAL (BIAR UI & FEATURES SHARE TABLE YANG SAMA)
-- ============================================================
local env = getgenv and getgenv() or _G

env.Shared = {
    -- Auto
    AutoSteal_Enabled = false,
    AutoMutation_Enabled = false,
    AutoReturn_Enabled = false,
    AutoFarm_Enabled = false,
    AutoHatch_Enabled = false,
    AutoRidePet_Enabled = false,
    AutoEquipBest_Enabled = false,

    -- ESP
    ESP_Eggs_Enabled = false,
    ESP_EggName_Enabled = false,
    ESP_EggLuck_Enabled = false,
    ESP_Pets_Enabled = false,
    ESP_PetName_Enabled = false,
    ESP_PetCash_Enabled = false,
    ESP_PetSpeed_Enabled = false,

    -- Speed
    Speed_Enabled = false,
    Speed_Value = 100,

    -- Misc
    InstantPickup_Enabled = false,
    SelectedEgg = "Cherub",
    RarityNotifThreshold = "Legendary",
    SelectedRarities = {
        ["None"] = true,
        ["Common"] = false,
        ["Uncommon"] = false,
        ["Rare"] = false,
        ["Epic"] = false,
        ["Legendary"] = false,
        ["Mythic"] = false,
        ["Divine"] = false,
        ["Ethereal"] = false,
        ["Secret"] = false,
    },

    -- State
    EggsInMap = {},
    EggPredictions = {},
}

-- ============================================================
-- LOADER
-- ============================================================
local function loadScript(url, name)
    local ok, source = pcall(function() return game:HttpGet(url) end)
    if not ok or not source then
        warn("[VRILZHUB] Gagal load " .. name)
        return nil
    end
    local fn, err = loadstring(source)
    if not fn then
        warn("[VRILZHUB] Gagal compile " .. name .. ": " .. tostring(err))
        return nil
    end
    local ok2, result = pcall(fn)
    if not ok2 then
        warn("[VRILZHUB] Gagal execute " .. name .. ": " .. tostring(result))
        return nil
    end
    print("[VRILZHUB] " .. name .. " loaded OK")
    return result
end

-- ============================================================
-- LOAD FEATURES
-- ============================================================
print("[VRILZHUB] Loading features...")
local Features = loadScript(CONFIG.FeaturesURL, "features")
if not Features then return end
env.Features = Features

-- ============================================================
-- LOAD UI
-- ============================================================
print("[VRILZHUB] Loading UI...")
local UI = loadScript(CONFIG.UIURL, "ui")
if not UI then return end
env.UI = UI

-- ============================================================
-- INIT — PAKE env.Shared yang SAMA
-- ============================================================
Features.Init(env.Shared)
UI.Init(env.Shared)

print("[VRILZHUB] SUCCESS! Ride a Pet loaded.")
print("[VRILZHUB] Shared table:", env.Shared)
print("[VRILZHUB] Features:", env.Features)
print("[VRILZHUB] UI:", env.UI)
