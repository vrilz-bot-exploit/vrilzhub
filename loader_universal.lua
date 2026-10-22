-- ============================================================
-- VRILZHUB LOADER — RIDE A PET (CLEAN)
-- ============================================================

local CONFIG = {
    GameId = 124216119978534,
    FeaturesURL = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/features_rideapet.lua",
    UIURL = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/ui_rideapet.lua",
}

-- Cek game
if game.PlaceId ~= CONFIG.GameId then
    local WS = game:GetService("Workspace")
    if not WS:FindFirstChild("RenderedEggs") then
        warn("[VRILZHUB] Bukan game Ride a Pet, abort")
        return
    end
end

print("[VRILZHUB] Loading...")

-- ═══════════════════════════════════════════════════════════════
-- NUKE: hapus ScreenGui lama yang bikin window ganda
-- (Jalan sebelum & sesudah load, biar bersih total)
-- ═══════════════════════════════════════════════════════════════
local function NukeOldUI()
    local hui = (gethui and gethui()) or game:GetService("CoreGui")
    local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")

    local function scan(parent)
        if not parent then return end
        for _, g in ipairs(parent:GetChildren()) do
            if g:IsA("ScreenGui") then
                -- Skip GUI bawaan Roblox
                local keepNames = {
                    RobloxGui = true, RobloxPromptGui = true, ShortcutBar = true,
                    ScreenshotsCarousel = true, CaptureManager = true, CaptureOverlay = true,
                    TeleportEffectGui = true, PlayerList = true, ExperienceChat = true,
                    HeadsetDisconnectedDialog = true, PurchasePromptApp = true,
                    InExperienceInterventionApp = true, InGameFullscreenTitleBarScreen = true,
                    ImmersiveBrandedAds = true, RewardedVideoAdPlayer = true,
                    SystemScrim = true, _FullscreenTestGui = true, _DeviceTestGui = true,
                    MomentsCreationFlow = true, RobloxNetworkPauseNotification = true,
                    BackpackGui = true, RewardFX = true, HalloweenFade = true,
                    GraveFx = true, TopbarCenteredClipped = true, TopbarStandardClipped = true,
                    TopbarStandard = true, TopbarCentered = true, Main = true,
                    Reusable = true, Create = true, SamplePack = true, Onboarding = true,
                    Menu = true, EggBreaking = true, AdminPollUI = true, ChoiceGui = true,
                    HalloweenGui = true, HalloweenRace = true, Cmdr = true,
                    OnboardingSpotlight = true, Loading = true, EggChaseVignette = true,
                    EggDeliveryFlash = true,
                }
                if keepNames[g.Name] then
                    continue
                end

                -- Cek apakah isinya UI lama (ada MainFrame besar)
                local isOldUI = false
                for _, d in ipairs(g:GetDescendants()) do
                    if d:IsA("Frame") and d.Name == "MainFrame" and d.Size.X.Offset > 400 then
                        isOldUI = true
                        break
                    end
                end

                if isOldUI then
                    pcall(function() g:Destroy() end)
                    print("[NUKE] Destroyed old UI: " .. g.Name)
                end
            end
        end
    end

    scan(hui)
    scan(pg)
end

-- Nuke SEBELUM load (bersihin sisa run sebelumnya)
NukeOldUI()
task.wait(0.2)

-- ═══════════════════════════════════════════════════════════════
-- LOADER
-- ═══════════════════════════════════════════════════════════════
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

-- ═══════════════════════════════════════════════════════════════
-- LOAD FEATURES
-- ═══════════════════════════════════════════════════════════════
print("[VRILZHUB] Loading features...")
local Features = loadScript(CONFIG.FeaturesURL, "features")
if not Features then return end

-- ═══════════════════════════════════════════════════════════════
-- LOAD UI BARU
-- ═══════════════════════════════════════════════════════════════
print("[VRILZHUB] Loading UI...")
local UI = loadScript(CONFIG.UIURL, "ui")
if not UI then return end

-- ═══════════════════════════════════════════════════════════════
-- INIT
-- ═══════════════════════════════════════════════════════════════
local Shared = {}

_G.VRILZ_Features = Features
_G.VRILZ_Shared = Shared

UI.Init(Shared)

-- ═══════════════════════════════════════════════════════════════
-- NUKE LAGI SETELAH UI MUNCUL (buat hapus kalau ada yang nyempil)
-- ═══════════════════════════════════════════════════════════════
task.delay(3, NukeOldUI)
task.delay(6, NukeOldUI)

print("[VRILZHUB] SUCCESS! Ride a Pet loaded.")
