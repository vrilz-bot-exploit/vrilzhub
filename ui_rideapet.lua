-- ============================================================
-- VRILZHUB UI — RIDE A PET v2.4 (AUTO-DETECT PC & MOBILE)
-- PC: 800x580 | Mobile: 88% x 78% viewport
-- ============================================================

local UI = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
-- Ambil Features dari _G (biar bisa akses fungsi Hatch Luck)
local function getFeatures()
    return _G.VRILZ_Features
end

-- ====== AUTO-DETECT MOBILE ======
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ====== UI CONFIG ======
local UI_CONFIG = {
    MOBILE = {
    WIN_W = 620,
    WIN_H = 720,
    -- Note: di HP viewport < 452px, ini otomatis di-clamp jadi viewport.X - 32

    SIDEBAR_W = 64,     -- dari 58 → 64 (biar icon tab gak kejepit)
    TAB_H = 42,         -- dari 38 → 42
    TAB_ICON = 18,      -- dari 16 → 18
    TAB_SHOW_LABEL = false,
    CARD_HEADER = 32,   -- dari 30 → 32
    CARD_PAD_TOP = 10,
    CARD_PAD_BOT = 12,
    CARD_PAD_SIDE = 12,
    CARD_GAP = 8,
    TOGGLE_H = 36,      -- dari 34 → 36
    TOGGLE_W = 48,      -- dari 46 → 48
    TOGGLE_KNOB = 19,
    DROPDOWN_H = 40,    -- dari 38 → 40
    DROPDOWN_ITEM = 32,
    DROPDOWN_POPUP_W = 160,   -- dari 140 → 160 (biar teks gak kepotong)
    ACTION_H = 34,
    FONT_TITLE = 12,
    FONT_LABEL = 12,    -- dari 11 → 12
    FONT_MUTED = 10,    -- dari 9 → 10
    FONT_SMALL = 10,
    FONT_MED = 12,
    FONT_LARGE = 14,
    HEADER_H = 40,      -- dari 36 → 40
    SEARCH_H = 30,
    NOTIF_W = 280,      -- dari 260 → 280
    NOTIF_H = 48,
    OPEN_BTN = 52,
    CHAT_MSG_H = 46,
    CHAT_AVATAR = 22,
    CHAT_FONT = 11,
    CHAT_NAME_FONT = 10,
    CHAT_INPUT_H = 34,
    CHAT_SEND_W = 48,
    CHAT_BUBBLE_PAD = 8,
    CHAT_MAX_MSG = 100,
    CHAT_SHOW_AVATAR = false,
    CHAT_PANEL_H = 340,
},
    PC = {
        WIN_W = 800, WIN_H = 580,
        SIDEBAR_W = 152, TAB_H = 46, TAB_ICON = 17, TAB_SHOW_LABEL = true,
        CARD_HEADER = 36, CARD_PAD_TOP = 12, CARD_PAD_BOT = 14, CARD_PAD_SIDE = 16,
        CARD_GAP = 9, TOGGLE_H = 34, TOGGLE_W = 48, TOGGLE_KNOB = 18,
        DROPDOWN_H = 38, DROPDOWN_ITEM = 30, DROPDOWN_POPUP_W = 180, ACTION_H = 34,
        FONT_TITLE = 12, FONT_LABEL = 12, FONT_MUTED = 10, FONT_SMALL = 10,
        FONT_MED = 12, FONT_LARGE = 15,
        HEADER_H = 52, SEARCH_H = 34, NOTIF_W = 380, NOTIF_H = 52, OPEN_BTN = 56,
        -- LIVE CHAT
        CHAT_MSG_H = 54, CHAT_AVATAR = 30, CHAT_FONT = 12, CHAT_NAME_FONT = 11,
        CHAT_INPUT_H = 40, CHAT_SEND_W = 76, CHAT_BUBBLE_PAD = 12,
        CHAT_MAX_MSG = 200, CHAT_SHOW_AVATAR = true, CHAT_PANEL_H = 420,
    },
}

-- ====== KEY SYSTEM URL (dipindah ke atas biar ChatClient bisa akses) ======
local KEY_SYSTEM_URL = "https://key-system.vrilzwops.workers.dev"

local CFG = IS_MOBILE and UI_CONFIG.MOBILE or UI_CONFIG.PC

-- ====== EGG NAMES (WAJIB SAMA DENGAN NAMA DI GAME) ======
local EggNames = {
    "Cherub Egg", "Volcanic Egg", "Blackhole Egg", "Solaris Egg", "Galaxy Egg",
    "Crystal Egg", "Golden Egg", "Glass Egg", "Skull Egg", "Sinister Egg",
    "Soul Egg", "Dominus Egg", "Slime Egg", "Flower Egg", "Leaf Egg",
    "Stone Egg", "Easter Egg", "Cracked Egg", "Ice Egg", "Tidal Egg",
    "Bloom Egg", "Aurora Egg", "White Egg", "Brown Egg",
    -- Tambahan dari GameData:
    "Flaming Egg", "Mushroom Egg", "Asteroid Egg", "Giant Egg",
    "Diamond Egg", "Dragon Egg",
    -- ⭐ BARU:
    "Seraph Egg", "Halloween Egg"
}

-- ====== RARITY ======
local RarityList = {
    "None",
    "Common", "Uncommon", "Rare", "Epic",
    "Legendary", "Mythic", "Divine", "Ethereal", "Secret"
}
local RarityColors = {
    None = Color3.fromRGB(150, 150, 155),
    Common = Color3.fromRGB(150, 150, 155),
    Uncommon = Color3.fromRGB(150, 150, 155),
    Rare = Color3.fromRGB(150, 150, 155),
    Epic = Color3.fromRGB(150, 150, 155),
    Legendary = Color3.fromRGB(150, 150, 155),
    Mythic = Color3.fromRGB(150, 150, 155),
    Divine = Color3.fromRGB(150, 150, 155),
    Ethereal = Color3.fromRGB(150, 150, 155),
    Secret = Color3.fromRGB(150, 150, 155),
}

-- ====== THEME ======
local Themes = {
    Brutal = {
        BG = Color3.fromRGB(7, 8, 11), Surface = Color3.fromRGB(13, 14, 18),
        Surface2 = Color3.fromRGB(20, 20, 24), Surface3 = Color3.fromRGB(28, 28, 33),
        Stroke = Color3.fromRGB(255, 126, 20), Text = Color3.fromRGB(248, 249, 252),
        Muted = Color3.fromRGB(158, 162, 172), Accent = Color3.fromRGB(255, 126, 20),
        Accent2 = Color3.fromRGB(255, 170, 55), Accent3 = Color3.fromRGB(255, 210, 120),
        Success = Color3.fromRGB(70, 230, 140), Error = Color3.fromRGB(255, 75, 85),
    },
    Ice = {
        BG = Color3.fromRGB(5, 10, 20), Surface = Color3.fromRGB(10, 20, 35),
        Surface2 = Color3.fromRGB(15, 30, 50), Surface3 = Color3.fromRGB(20, 40, 65),
        Stroke = Color3.fromRGB(150, 220, 255), Text = Color3.fromRGB(240, 250, 255),
        Muted = Color3.fromRGB(150, 200, 240), Accent = Color3.fromRGB(50, 150, 255),
        Accent2 = Color3.fromRGB(150, 220, 255), Accent3 = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Fire = {
        BG = Color3.fromRGB(20, 5, 0), Surface = Color3.fromRGB(35, 10, 5),
        Surface2 = Color3.fromRGB(50, 15, 5), Surface3 = Color3.fromRGB(65, 20, 10),
        Stroke = Color3.fromRGB(255, 100, 50), Text = Color3.fromRGB(255, 240, 230),
        Muted = Color3.fromRGB(220, 170, 150), Accent = Color3.fromRGB(255, 100, 50),
        Accent2 = Color3.fromRGB(255, 200, 50), Accent3 = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Pink = {
        BG = Color3.fromRGB(20, 5, 15), Surface = Color3.fromRGB(35, 10, 25),
        Surface2 = Color3.fromRGB(50, 15, 35), Surface3 = Color3.fromRGB(65, 20, 45),
        Stroke = Color3.fromRGB(255, 105, 180), Text = Color3.fromRGB(255, 240, 250),
        Muted = Color3.fromRGB(230, 170, 210), Accent = Color3.fromRGB(255, 105, 180),
        Accent2 = Color3.fromRGB(255, 182, 220), Accent3 = Color3.fromRGB(255, 220, 245),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Green = {
        BG = Color3.fromRGB(5, 20, 10), Surface = Color3.fromRGB(10, 35, 20),
        Surface2 = Color3.fromRGB(15, 50, 30), Surface3 = Color3.fromRGB(20, 65, 40),
        Stroke = Color3.fromRGB(50, 255, 120), Text = Color3.fromRGB(240, 255, 245),
        Muted = Color3.fromRGB(170, 230, 190), Accent = Color3.fromRGB(50, 255, 120),
        Accent2 = Color3.fromRGB(150, 255, 180), Accent3 = Color3.fromRGB(200, 255, 220),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
    Blue = {
        BG = Color3.fromRGB(5, 10, 25), Surface = Color3.fromRGB(10, 20, 45),
        Surface2 = Color3.fromRGB(15, 30, 65), Surface3 = Color3.fromRGB(20, 40, 85),
        Stroke = Color3.fromRGB(50, 150, 255), Text = Color3.fromRGB(240, 245, 255),
        Muted = Color3.fromRGB(170, 200, 240), Accent = Color3.fromRGB(50, 150, 255),
        Accent2 = Color3.fromRGB(150, 200, 255), Accent3 = Color3.fromRGB(220, 235, 255),
        Success = Color3.fromRGB(50, 255, 150), Error = Color3.fromRGB(255, 50, 80),
    },
        Mustard = {
        BG = Color3.fromRGB(30, 25, 5), Surface = Color3.fromRGB(45, 38, 10),
        Surface2 = Color3.fromRGB(60, 50, 15), Surface3 = Color3.fromRGB(75, 62, 20),
        Stroke = Color3.fromRGB(230, 190, 50), Text = Color3.fromRGB(255, 250, 230),
        Muted = Color3.fromRGB(200, 180, 130), Accent = Color3.fromRGB(230, 190, 50),
        Accent2 = Color3.fromRGB(255, 220, 90), Accent3 = Color3.fromRGB(255, 240, 150),
        Success = Color3.fromRGB(150, 230, 100), Error = Color3.fromRGB(255, 80, 80),
    },
    Olive = {
        BG = Color3.fromRGB(20, 25, 10), Surface = Color3.fromRGB(35, 45, 20),
        Surface2 = Color3.fromRGB(50, 65, 30), Surface3 = Color3.fromRGB(65, 80, 40),
        Stroke = Color3.fromRGB(140, 170, 60), Text = Color3.fromRGB(245, 250, 235),
        Muted = Color3.fromRGB(180, 200, 140), Accent = Color3.fromRGB(140, 170, 60),
        Accent2 = Color3.fromRGB(180, 210, 90), Accent3 = Color3.fromRGB(210, 235, 140),
        Success = Color3.fromRGB(100, 220, 120), Error = Color3.fromRGB(255, 80, 80),
    },
}

local CurrentTheme = "Brutal"
local C = Themes[CurrentTheme]

local ThemeWidgets = {}
local function registerTheme(widget, key, property)
    table.insert(ThemeWidgets, {widget = widget, key = key, property = property})
end

local function applyTheme(themeName)
    CurrentTheme = themeName
    C = Themes[themeName]
    for _, item in ipairs(ThemeWidgets) do
        pcall(function()
            item.widget[item.property] = C[item.key]
        end)
    end
end


-- ============================================================
-- TITLE SYSTEM v2 — OWNER + PREMIUM CUSTOM TITLE + SAVE
-- ============================================================
local OWNER_USERID = 5126297278
local TITLE_GUI_NAME = "VRILZ_TitleTag"
local titleGuiRef = nil
local titleLoopRunning = false

-- ═══════════════════════════════════════════
-- SAVE/LOAD TITLE (pake writefile/readfile)
-- ═══════════════════════════════════════════
local TITLE_SAVE_FILE = "vrilz_title.txt"

local function saveCustomTitle(title)
    if writefile then
        pcall(function()
            writefile(TITLE_SAVE_FILE, title or "")
        end)
    end
    -- Simpen juga ke _G biar cepet akses
    _G.VRILZ_CustomTitle = title
end

local function loadCustomTitle()
    -- Cek _G dulu
    if _G.VRILZ_CustomTitle then
        return _G.VRILZ_CustomTitle
    end
    
    -- Cek file
    if readfile and isfile then
        local ok, exists = pcall(isfile, TITLE_SAVE_FILE)
        if ok and exists then
            local okRead, content = pcall(readfile, TITLE_SAVE_FILE)
            if okRead and content then
                content = content:gsub("^%s+", ""):gsub("%s+$", "")
                if content ~= "" then
                    _G.VRILZ_CustomTitle = content
                    return content
                end
            end
        end
    end
    
    return nil
end

local function clearCustomTitle()
    _G.VRILZ_CustomTitle = nil
    if delfile and isfile then
        local ok, exists = pcall(isfile, TITLE_SAVE_FILE)
        if ok and exists then
            pcall(delfile, TITLE_SAVE_FILE)
        end
    end
end

-- ═══════════════════════════════════════════
-- CEK APAKAH USER BISA CUSTOM TITLE
-- ═══════════════════════════════════════════
local function canCustomTitle()
    -- Owner = selalu bisa
    if LocalPlayer.UserId == OWNER_USERID then
        return true
    end
    
    -- Cek key type = PREMIUM
    if Shared and Shared.KeyType then
        local kt = tostring(Shared.KeyType):upper()
        if kt == "PREMIUM" or kt == "OWNER" or kt == "VIP" then
            return true
        end
    end
    
    return false
end

-- ═══════════════════════════════════════════
-- GET TITLE TEXT
-- ═══════════════════════════════════════════
local function getTitleText()
    -- Owner
    if LocalPlayer.UserId == OWNER_USERID then
        local custom = _G.VRILZ_CustomTitle
        if custom and custom ~= "" then
            return "[👑 " .. custom .. "]"
        end
        return "[👑 OWNER]"
    end
    
    -- Premium user — cek custom title
    if canCustomTitle() then
        local custom = _G.VRILZ_CustomTitle
        if custom and custom ~= "" then
            return "[👑 " .. custom .. "]"
        end
    end
    
    -- Default
    return "[VH COMMUNITY]"
end

local function getTitleColors()
    -- Owner ATAU Premium = rainbow
    if LocalPlayer.UserId == OWNER_USERID or canCustomTitle() then
        return {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 127, 0),
            Color3.fromRGB(255, 255, 0),
            Color3.fromRGB(0, 255, 0),
            Color3.fromRGB(0, 255, 255),
            Color3.fromRGB(0, 0, 255),
            Color3.fromRGB(139, 0, 255),
            Color3.fromRGB(255, 0, 255),
        }
    else
        return {
            Color3.fromRGB(255, 0, 0),
            Color3.fromRGB(255, 255, 255),
        }
    end
end

local function removeTitle()
    if titleGuiRef then
        pcall(function() titleGuiRef:Destroy() end)
        titleGuiRef = nil
    end
end

local function buildTitle()
    removeTitle()

    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = TITLE_GUI_NAME
    bb.Size = UDim2.fromOffset(220, 32)
    bb.StudsOffset = Vector3.new(0, 2.8, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 500
    bb.Adornee = head
    bb.Parent = head
    titleGuiRef = bb

    local lbl = Instance.new("TextLabel")
    lbl.Name = "TitleLabel"
    lbl.Size = UDim2.fromScale(1, 1)
    lbl.BackgroundTransparency = 1
    lbl.Text = getTitleText()
    lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.TextStrokeTransparency = 0.2
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 15
    lbl.TextScaled = false
    lbl.TextWrapped = false
    lbl.Parent = bb

    -- Animasi rainbow
    if not titleLoopRunning then
        titleLoopRunning = true
        task.spawn(function()
            local idx = 1
            while titleLoopRunning do
                task.wait(0.12)
                if not Shared.ShowTitle then
                    idx = 1
                    continue
                end
                local colors = getTitleColors()
                if titleGuiRef and titleGuiRef.Parent then
                    local label = titleGuiRef:FindFirstChild("TitleLabel")
                    if label then
                        label.TextColor3 = colors[idx]
                    end
                end
                idx = idx + 1
                if idx > #colors then idx = 1 end
            end
        end)
    end
end

local function refreshTitle()
    if Shared.ShowTitle then
        buildTitle()
    else
        removeTitle()
    end
end

-- Auto refresh pas karakter respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1)
    refreshTitle()
end)

-- Expose function biar UI bisa panggil
_G.VRILZ_RefreshTitle = refreshTitle

-- ====== NOTIFICATION ======
local NotifHolder = nil

local function setupNotifHolder(parent)
    NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotifHolder"
    NotifHolder.AnchorPoint = Vector2.new(0.5, 0)
    NotifHolder.Position = UDim2.new(0.5, 0, 0, 20)
    NotifHolder.Size = UDim2.fromOffset(420, 320)
    NotifHolder.BackgroundTransparency = 1
    NotifHolder.ZIndex = 500
    NotifHolder.Parent = parent
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Top
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = NotifHolder
end

-- ============================================================
-- 🌠 PREMIUM METEOR GLOW NOTIFICATION v3
-- Meteor jatuh dari atas + text auto-fit (gak pernah keluar)
-- ============================================================
local function notify(text, type)
    if not NotifHolder then return end
    type = type or "info"

    -- ═══ WARNA PER TYPE (NO GREEN) ═══
    local color, glowColor, icon, gradientTop, gradientBot
    if type == "success" then
        color = Color3.fromRGB(80, 180, 255)          -- biru cyan (bukan ijo)
        glowColor = Color3.fromRGB(120, 220, 255)
        icon = "✓"
        gradientTop = Color3.fromRGB(18, 40, 65)
        gradientBot = Color3.fromRGB(8, 16, 28)
    elseif type == "error" then
        color = Color3.fromRGB(255, 90, 100)
        glowColor = Color3.fromRGB(255, 40, 70)
        icon = "✕"
        gradientTop = Color3.fromRGB(62, 24, 28)
        gradientBot = Color3.fromRGB(22, 8, 10)
    elseif type == "warning" then
        color = Color3.fromRGB(255, 200, 80)
        glowColor = Color3.fromRGB(255, 160, 30)
        icon = "!"
        gradientTop = Color3.fromRGB(60, 46, 16)
        gradientBot = Color3.fromRGB(22, 18, 8)
    else
        color = Color3.fromRGB(170, 130, 255)         -- ungu buat info
        glowColor = Color3.fromRGB(200, 160, 255)
        icon = "✦"
        gradientTop = Color3.fromRGB(35, 22, 60)
        gradientBot = Color3.fromRGB(14, 10, 26)
    end

    -- ═══ UKURAN KECIL ═══
    local isMob = IS_MOBILE
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    local maxW = isMob and math.min(vp.X - 40, 230) or 270
    local notifW = math.clamp(maxW, 190, 290)
    local notifH = isMob and 46 or 52

    -- ═══ MAIN CONTAINER ═══
    local notif = Instance.new("Frame")
    notif.Size = UDim2.fromOffset(notifW, notifH)
    notif.BackgroundColor3 = gradientBot
    notif.BorderSizePixel = 0
    notif.ZIndex = 501
    notif.ClipsDescendants = true        -- ⭐ meteor kepotong di dalam card
    notif.Parent = NotifHolder

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = notif

    -- ═══ GRADIENT BODY ═══
    local bodyGradient = Instance.new("UIGradient")
    bodyGradient.Rotation = 115
    bodyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, gradientTop),
        ColorSequenceKeypoint.new(0.5, gradientBot),
        ColorSequenceKeypoint.new(1, gradientBot),
    })
    bodyGradient.Parent = notif

    -- ═══ NEON STROKE ═══
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 1.5
    stroke.Transparency = 0.12
    stroke.Parent = notif

    -- ═══ TOP GLOSS ═══
    local gloss = Instance.new("Frame")
    gloss.Size = UDim2.new(1, -16, 0, 1)
    gloss.Position = UDim2.fromOffset(8, 1)
    gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gloss.BackgroundTransparency = 0.75
    gloss.BorderSizePixel = 0
    gloss.ZIndex = 503
    gloss.Parent = notif
    local glc = Instance.new("UICorner")
    glc.CornerRadius = UDim.new(1, 0)
    glc.Parent = gloss

    -- ═══ METEOR LAYER (di dalam card, di belakang konten) ═══
    local meteorLayer = Instance.new("Frame")
    meteorLayer.Name = "MeteorLayer"
    meteorLayer.Size = UDim2.fromScale(1, 1)
    meteorLayer.BackgroundTransparency = 1
    meteorLayer.ZIndex = 502
    meteorLayer.ClipsDescendants = true
    meteorLayer.Parent = notif

    -- ═══ ICON ═══
    local iconSize = isMob and 26 or 30
    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.fromOffset(iconSize, iconSize)
    iconBg.Position = UDim2.new(0, isMob and 8 or 10, 0.5, 0)
    iconBg.AnchorPoint = Vector2.new(0, 0.5)
    iconBg.BackgroundColor3 = color
    iconBg.BorderSizePixel = 0
    iconBg.ZIndex = 505
    iconBg.Parent = notif
    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(1, 0)
    ic.Parent = iconBg

    local iconGrad = Instance.new("UIGradient")
    iconGrad.Rotation = 135
    iconGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(1, glowColor),
    })
    iconGrad.Parent = iconBg

    local iconGlow = Instance.new("Frame")
    iconGlow.Size = UDim2.new(1, 6, 1, 6)
    iconGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    iconGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    iconGlow.BackgroundColor3 = glowColor
    iconGlow.BackgroundTransparency = 0.7
    iconGlow.BorderSizePixel = 0
    iconGlow.ZIndex = 504
    iconGlow.Parent = iconBg
    local igc = Instance.new("UICorner")
    igc.CornerRadius = UDim.new(1, 0)
    igc.Parent = iconGlow

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.fromScale(1, 1)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLbl.Font = Enum.Font.GothamBlack
    iconLbl.TextSize = isMob and 14 or 16
    iconLbl.ZIndex = 506
    iconLbl.Parent = iconBg

    -- ═══ TEXT LABEL (AUTO-FIT) ═══
    local textX = (isMob and 8 or 10) + iconSize + (isMob and 7 or 9)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -(textX + (isMob and 7 or 10)), 1, -4)
    label.Position = UDim2.fromOffset(textX, 2)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(248, 250, 255)
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextWrapped = true
    label.TextTruncate = Enum.TextTruncate.None
    label.ZIndex = 505
    label.Parent = notif

    local baseSize = isMob and 11 or 12
    local minSize = isMob and 8 or 9
    label.TextSize = baseSize

    local function autoFit()
        local fitSize = baseSize
        label.TextSize = fitSize
        local safety = 20
        while not label.TextFits and fitSize > minSize and safety > 0 do
            fitSize = fitSize - 1
            label.TextSize = fitSize
            safety = safety - 1
            task.wait()
        end
        if not label.TextFits and fitSize <= minSize then
            label.TextTruncate = Enum.TextTruncate.AtEnd
        end
    end
    task.defer(autoFit)

    -- ═══ METEOR DI DALAM CARD (horizontal streak) ═══
    local function spawnInnerMeteor()
        if not notif.Parent or not meteorLayer.Parent then return end

        local meteor = Instance.new("Frame")
        meteor.Name = "InnerMeteor"
        meteor.AnchorPoint = Vector2.new(0.5, 0.5)
        meteor.BackgroundColor3 = glowColor
        meteor.BorderSizePixel = 0
        meteor.ZIndex = 502

        -- Ukuran meteor kecil (di dalam card)
        local headSize = math.random(4, 6)
        meteor.Size = UDim2.fromOffset(headSize, headSize)
        local yPos = math.random(15, 85) / 100
        meteor.Position = UDim2.fromScale(-0.1, yPos)
        meteor.Parent = meteorLayer

        local mc = Instance.new("UICorner")
        mc.CornerRadius = UDim.new(1, 0)
        mc.Parent = meteor

        -- Head glow (halo kecil)
        local headGlow = Instance.new("Frame")
        headGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        headGlow.Position = UDim2.fromScale(0.5, 0.5)
        headGlow.Size = UDim2.fromOffset(headSize * 2.5, headSize * 2.5)
        headGlow.BackgroundColor3 = glowColor
        headGlow.BackgroundTransparency = 0.6
        headGlow.BorderSizePixel = 0
        headGlow.ZIndex = 501
        headGlow.Parent = meteor
        local hgc = Instance.new("UICorner")
        hgc.CornerRadius = UDim.new(1, 0)
        hgc.Parent = headGlow

        -- TRAIL memanjang (ke kiri, karena meteor gerak ke kanan)
        local trail = Instance.new("Frame")
        trail.AnchorPoint = Vector2.new(1, 0.5)
        trail.Position = UDim2.fromScale(0.5, 0.5)
        trail.Size = UDim2.fromOffset(math.random(35, 60), 2)
        trail.BackgroundColor3 = color
        trail.BackgroundTransparency = 0.25
        trail.BorderSizePixel = 0
        trail.ZIndex = 501
        trail.Parent = meteor

        local trailGrad = Instance.new("UIGradient")
        trailGrad.Rotation = 0
        trailGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.4, 0.15),
            NumberSequenceKeypoint.new(1, 0),
        })
        trailGrad.Parent = trail

        -- Spark kecil di trail
        for i = 1, math.random(2, 4) do
            local spark = Instance.new("Frame")
            spark.AnchorPoint = Vector2.new(0.5, 0.5)
            spark.Position = UDim2.new(1, math.random(-30, -8), 0.5, math.random(-2, 2))
            spark.Size = UDim2.fromOffset(math.random(2, 3), math.random(2, 3))
            spark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            spark.BackgroundTransparency = 0.4
            spark.BorderSizePixel = 0
            spark.ZIndex = 501
            spark.Parent = meteor
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(1, 0)
            sc.Parent = spark
        end

        -- Animasi: geser dari kiri ke kanan (di dalam card)
        local duration = math.random(90, 140) / 100
        TweenService:Create(meteor, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Position = UDim2.fromScale(1.1, yPos),
        }):Play()

        -- Fade out di ujung kanan
        task.delay(duration * 0.85, function()
            if meteor.Parent then
                TweenService:Create(meteor, TweenInfo.new(duration * 0.15), {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(trail, TweenInfo.new(duration * 0.15), {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(headGlow, TweenInfo.new(duration * 0.15), {
                    BackgroundTransparency = 1,
                }):Play()
            end
        end)

        task.delay(duration + 0.1, function()
            if meteor then meteor:Destroy() end
        end)
    end

    -- Spawn meteor berkala (di dalam card)
    task.spawn(function()
        task.wait(0.2)
        spawnInnerMeteor()
        while notif.Parent do
            task.wait(math.random(8, 16) / 10)
            if not notif.Parent then break end
            spawnInnerMeteor()
        end
    end)

    -- ═══ ANIMASI MASUK: SLIDE DARI KANAN (halus) ═══
    notif.Position = UDim2.new(0.5, notifW + 10, 0, 0)
    TweenService:Create(notif, TweenInfo.new(0.32, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(0, 0),
    }):Play()

    -- Icon pulse
    task.spawn(function()
        while notif.Parent do
            task.wait(1.4)
            if not notif.Parent then break end
            TweenService:Create(iconGlow, TweenInfo.new(0.5), {BackgroundTransparency = 0.85}):Play()
            task.wait(0.5)
            TweenService:Create(iconGlow, TweenInfo.new(0.5), {BackgroundTransparency = 0.65}):Play()
        end
    end)

    -- ═══ ANIMASI HILANG: FADE + SLIDE KECIL KE KANAN (no flying out) ═══
    task.delay(3.5, function()
        if not notif.Parent then return end

        TweenService:Create(notif, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.fromOffset(30, 0),          -- geser dikit aja
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(notifW * 0.9, notifH),  -- mengecil dikit
        }):Play()

        TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
        TweenService:Create(label, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TweenService:Create(iconLbl, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TweenService:Create(iconBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(iconGlow, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(gloss, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()

        task.wait(0.4)
        if notif then notif:Destroy() end
    end)
end

-- ====== CARD (RIPPLE SAJA) ======
local function makeCard(parent, title, layoutOrder)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = C.Surface
    card.BorderSizePixel = 0
    card.ClipsDescendants = true
    card.LayoutOrder = layoutOrder or 1
    card.ZIndex = 1
    card.Parent = parent
    registerTheme(card, "Surface", "BackgroundColor3")
    card.BackgroundTransparency = 0.55

    -- Layered card depth: soft shadow + glossy surface.
    local cardShadow = Instance.new("Frame")
    cardShadow.Name = "CardShadow"
    cardShadow.Size = UDim2.new(1, 8, 1, 10)
    cardShadow.Position = UDim2.fromOffset(0, 5)
    cardShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    cardShadow.BackgroundTransparency = 0.48
    cardShadow.BorderSizePixel = 0
    cardShadow.ZIndex = 0
    cardShadow.Parent = card
    local cardShadowCorner = Instance.new("UICorner")
    cardShadowCorner.CornerRadius = UDim.new(0, 14)
    cardShadowCorner.Parent = cardShadow

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 13)
    corner.Parent = card

    local cardGradient = Instance.new("UIGradient")
    cardGradient.Rotation = 90
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 25, 29)),
        ColorSequenceKeypoint.new(0.55, C.Surface),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 11, 14)),
    })

    local gloss = Instance.new("Frame")
    gloss.Name = "Gloss"
    gloss.Size = UDim2.new(1, -18, 0, 1)
    gloss.Position = UDim2.fromOffset(9, 1)
    gloss.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    gloss.BackgroundTransparency = 0.86
    gloss.BorderSizePixel = 0
    gloss.ZIndex = 2
    gloss.Parent = card
    local glossCorner = Instance.new("UICorner")
    glossCorner.CornerRadius = UDim.new(1, 0)
    glossCorner.Parent = gloss

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1.6
    stroke.Transparency = 0.22
    stroke.Parent = card
    registerTheme(stroke, "Accent", "Color")
  
    -- Header
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, CFG.CARD_HEADER)
    headerFrame.BackgroundColor3 = C.Surface2
    headerFrame.BorderSizePixel = 0
    headerFrame.ZIndex = 2
    headerFrame.Parent = card
    registerTheme(headerFrame, "Surface2", "BackgroundColor3")
    headerFrame.BackgroundTransparency = 0.45

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Rotation = 0
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 34, 39)),
        ColorSequenceKeypoint.new(0.55, C.Surface2),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
    })

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 13)
    headerCorner.Parent = headerFrame

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(8, 8)
    dot.Position = UDim2.new(0, 12, 0.5, -4)
    dot.BackgroundColor3 = C.Accent
    dot.BorderSizePixel = 0
    dot.ZIndex = 3
    dot.Parent = headerFrame

    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    registerTheme(dot, "Accent", "BackgroundColor3")

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -30, 1, 0)
    titleLabel.Position = UDim2.fromOffset(26, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = C.Text
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = CFG.FONT_TITLE
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 3
    titleLabel.Parent = headerFrame
    registerTheme(titleLabel, "Text", "TextColor3")

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, CFG.CARD_HEADER)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    content.Parent = card

    local contentPad = Instance.new("UIPadding")
    contentPad.PaddingTop = UDim.new(0, CFG.CARD_PAD_TOP)
    contentPad.PaddingBottom = UDim.new(0, CFG.CARD_PAD_BOT)
    contentPad.PaddingLeft = UDim.new(0, CFG.CARD_PAD_SIDE)
    contentPad.PaddingRight = UDim.new(0, CFG.CARD_PAD_SIDE)
    contentPad.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, CFG.CARD_GAP)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    return card, content
end

-- ====== TOGGLE ======
local function makeToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, CFG.TOGGLE_H)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 3
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -(CFG.TOGGLE_W + 12), 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.Text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = CFG.FONT_LABEL
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = frame
    registerTheme(label, "Text", "TextColor3")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(CFG.TOGGLE_W + 6, IS_MOBILE and 28 or 26)
    btn.Position = UDim2.new(1, -CFG.TOGGLE_W, 0.5, -(IS_MOBILE and 13 or 12))
    btn.BackgroundColor3 = default and C.Accent or C.Surface3
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.ZIndex = 4
    btn.Parent = frame
    registerTheme(btn, default and "Accent" or "Surface3", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = btn

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = default and C.Accent or Color3.fromRGB(80, 82, 90)
    btnStroke.Thickness = 1
    btnStroke.Transparency = 0.15
    btnStroke.Parent = btn
    if default then registerTheme(btnStroke, "Accent", "Color") end

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(CFG.TOGGLE_KNOB, CFG.TOGGLE_KNOB)
    knob.Position = default and UDim2.new(1, -(CFG.TOGGLE_KNOB + 3), 0.5, -CFG.TOGGLE_KNOB/2) or UDim2.new(0, 3, 0.5, -CFG.TOGGLE_KNOB/2)
    knob.BackgroundColor3 = Color3.new(1, 1, 1)
    knob.BorderSizePixel = 0
    knob.ZIndex = 5
    knob.Parent = btn

    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = state and C.Accent or C.Surface3
        }):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -(CFG.TOGGLE_KNOB + 3), 0.5, -CFG.TOGGLE_KNOB/2) or UDim2.new(0, 3, 0.5, -CFG.TOGGLE_KNOB/2)
        }):Play()
        if callback then callback(state) end
    end)
end

-- ====== DROPDOWN GLOBAL ======
_G.VRILZ_DropdownLayer = nil
_G.VRILZ_DropdownCloseOverlay = nil
_G.VRILZ_DropdownActive = nil

local function setupDropdownLayer(parent)
    _G.VRILZ_DropdownLayer = Instance.new("Frame")
    _G.VRILZ_DropdownLayer.Name = "DropdownLayer"
    _G.VRILZ_DropdownLayer.Size = UDim2.fromScale(1, 1)
    _G.VRILZ_DropdownLayer.BackgroundTransparency = 1
    _G.VRILZ_DropdownLayer.ZIndex = 2000
    _G.VRILZ_DropdownLayer.Parent = parent

    _G.VRILZ_DropdownCloseOverlay = Instance.new("TextButton")
    _G.VRILZ_DropdownCloseOverlay.Size = UDim2.fromScale(1, 1)
    _G.VRILZ_DropdownCloseOverlay.BackgroundTransparency = 1
    _G.VRILZ_DropdownCloseOverlay.Text = ""
    _G.VRILZ_DropdownCloseOverlay.ZIndex = 1999
    _G.VRILZ_DropdownCloseOverlay.Visible = false
    _G.VRILZ_DropdownCloseOverlay.Parent = _G.VRILZ_DropdownLayer

    _G.VRILZ_DropdownCloseOverlay.MouseButton1Click:Connect(function()
        if _G.VRILZ_DropdownActive and _G.VRILZ_DropdownActive.close then
            _G.VRILZ_DropdownActive.close()
        end
        _G.VRILZ_DropdownActive = nil
        _G.VRILZ_DropdownCloseOverlay.Visible = false
    end)
end

-- ============================================================
-- ⭐ STARFIELD HELPER — Bintang kelap-kelip untuk background opsi
-- ============================================================
local function attachStarfield(parentFrame, starCount, color)
    starCount = starCount or 5
    color = color or Color3.fromRGB(255, 255, 255)

    local starLayer = Instance.new("Frame")
    starLayer.Name = "StarfieldLayer"
    starLayer.Size = UDim2.fromScale(1, 1)
    starLayer.BackgroundTransparency = 1
    starLayer.ClipsDescendants = true
    starLayer.ZIndex = parentFrame.ZIndex - 1
    starLayer.Parent = parentFrame

    for i = 1, starCount do
        local star = Instance.new("Frame")
        local sz = math.random(1, 2)
        star.Name = "Star_" .. i
        star.Size = UDim2.fromOffset(sz, sz)
        star.Position = UDim2.fromScale(math.random(5, 95) / 100, math.random(5, 95) / 100)
        star.BackgroundColor3 = color
        star.BackgroundTransparency = math.random(40, 80) / 100
        star.BorderSizePixel = 0
        star.ZIndex = parentFrame.ZIndex - 1
        star.Parent = starLayer

        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(1, 0)
        sc.Parent = star

        -- Animasi kelap-kelip (twinkle)
        task.spawn(function()
            local baseTrans = star.BackgroundTransparency
            task.wait(math.random(0, 200) / 100)
            while star.Parent and starLayer.Parent do
                TweenService:Create(star, TweenInfo.new(math.random(30, 80) / 100, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = math.max(0, baseTrans - 0.6)
                }):Play()
                task.wait(math.random(40, 100) / 100)
                if not star.Parent then break end
                TweenService:Create(star, TweenInfo.new(math.random(50, 120) / 100, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = baseTrans
                }):Play()
                task.wait(math.random(60, 180) / 100)
            end
        end)
    end

    return starLayer
end

local function makeDropdownGlobal(anchorFrame, items, default, onSelect)
    local isOpen = false
    local selectedValue = default or items[1] or "Choose..."

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
    container.BackgroundColor3 = C.Surface3
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Parent = anchorFrame
    registerTheme(container, "Surface3", "BackgroundColor3")
    container.BackgroundTransparency = 0.55

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 9)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = container
    registerTheme(stroke, "Accent", "Color")

    local selectedLbl = Instance.new("TextLabel")
    selectedLbl.Size = UDim2.new(1, -44, 1, 0)
    selectedLbl.Position = UDim2.fromOffset(12, 0)
    selectedLbl.BackgroundTransparency = 1
    selectedLbl.Text = selectedValue
    selectedLbl.TextColor3 = C.Text
    selectedLbl.Font = Enum.Font.GothamSemibold
    selectedLbl.TextSize = CFG.FONT_LABEL
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
    selectedLbl.ZIndex = 4
    selectedLbl.Parent = container
    registerTheme(selectedLbl, "Text", "TextColor3")

    -- Real chevron: draw the two strokes instead of using a glyph.
    -- This guarantees the icon can never render as a square/tofu character.
    local arrow = Instance.new("Frame")
    arrow.Name = "DropdownChevron"
    arrow.Size = UDim2.fromOffset(IS_MOBILE and 20 or 22, IS_MOBILE and 16 or 18)
    arrow.Position = UDim2.new(1, -(IS_MOBILE and 27 or 29), 0.5, -(IS_MOBILE and 8 or 9))
    arrow.BackgroundTransparency = 1
    arrow.BorderSizePixel = 0
    arrow.ZIndex = 4
    arrow.Parent = container

    local chevronL = Instance.new("Frame")
    chevronL.Name = "Left"
    chevronL.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    chevronL.Position = UDim2.new(0.5, -(IS_MOBILE and 7 or 8), 0.5, -1)
    chevronL.BackgroundColor3 = C.Accent2
    chevronL.BorderSizePixel = 0
    chevronL.Rotation = 45
    chevronL.ZIndex = 5
    chevronL.Parent = arrow
    registerTheme(chevronL, "Accent2", "BackgroundColor3")

    local chevronR = Instance.new("Frame")
    chevronR.Name = "Right"
    chevronR.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    chevronR.Position = UDim2.new(0.5, 1, 0.5, -1)
    chevronR.BackgroundColor3 = C.Accent2
    chevronR.BorderSizePixel = 0
    chevronR.Rotation = -45
    chevronR.ZIndex = 5
    chevronR.Parent = arrow
    registerTheme(chevronR, "Accent2", "BackgroundColor3")

    local listFrame = Instance.new("ScrollingFrame")
    local popupWidth = CFG.DROPDOWN_POPUP_W
    listFrame.Size = UDim2.fromOffset(popupWidth, 0)
    listFrame.BackgroundColor3 = C.Surface2
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = C.Accent
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Visible = false
    listFrame.ZIndex = 2001
    listFrame.Parent = _G.VRILZ_DropdownLayer
    registerTheme(listFrame, "Surface2", "BackgroundColor3")

    local listShadow = Instance.new("Frame")
    listShadow.Name = "DropdownShadow"
    listShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    listShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
    listShadow.Size = UDim2.new(1, 10, 1, 10)
    listShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    listShadow.BackgroundTransparency = 0.35
    listShadow.BorderSizePixel = 0
    listShadow.ZIndex = 2000
    listShadow.Visible = false
    listShadow.Parent = listFrame
    local listShadowCorner = Instance.new("UICorner")
    listShadowCorner.CornerRadius = UDim.new(0, 12)
    listShadowCorner.Parent = listShadow

    local listGradient = Instance.new("UIGradient")
    listGradient.Rotation = 90
    listGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 31, 36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16)),
    })
    listGradient.Parent = listFrame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = C.Accent
    listStroke.Transparency = 0.2
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    registerTheme(listStroke, "Accent", "Color")

    local listTopGlow = Instance.new("Frame")
    listTopGlow.Size = UDim2.new(1, -18, 0, 2)
    listTopGlow.Position = UDim2.fromOffset(9, 1)
    listTopGlow.BackgroundColor3 = C.Accent2
    listTopGlow.BackgroundTransparency = 0.08
    listTopGlow.BorderSizePixel = 0
    listTopGlow.ZIndex = 2003
    listTopGlow.Parent = listFrame
    local listTopCorner = Instance.new("UICorner")
    listTopCorner.CornerRadius = UDim.new(1, 0)
    listTopCorner.Parent = listTopGlow
    registerTheme(listTopGlow, "Accent2", "BackgroundColor3")

    local popupHighlight = Instance.new("Frame")
    popupHighlight.Size = UDim2.new(1, -16, 0, 1)
    popupHighlight.Position = UDim2.fromOffset(8, 4)
    popupHighlight.BackgroundColor3 = Color3.new(1, 1, 1)
    popupHighlight.BackgroundTransparency = 0.88
    popupHighlight.BorderSizePixel = 0
    popupHighlight.ZIndex = 2003
    popupHighlight.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 4)
    listPad.PaddingLeft = UDim.new(0, 4)
    listPad.PaddingRight = UDim.new(0, 4)
    listPad.Parent = listFrame

    local itemHeight = CFG.DROPDOWN_ITEM
    local maxH = math.min(#items * (itemHeight + 2) + 10, IS_MOBILE and 126 or 148)

    local function closeList()
        isOpen = false
        chevronL.Rotation = 45
        chevronR.Rotation = -45
        local w = listFrame.Size.X.Offset
        TweenService:Create(listFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromOffset(w, 0)}):Play()
        task.delay(0.2, function()
            if not isOpen then listFrame.Visible = false end
        end)
        if _G.VRILZ_DropdownCloseOverlay then
            _G.VRILZ_DropdownCloseOverlay.Visible = false
        end
        _G.VRILZ_DropdownActive = nil
    end

    local function openList()
        if _G.VRILZ_DropdownActive and _G.VRILZ_DropdownActive.close then
            _G.VRILZ_DropdownActive.close()
        end

        isOpen = true
        listFrame.Visible = true
        chevronL.Rotation = -45
        chevronR.Rotation = 45

        -- Compact popover: jangan selebar field/window.
        local width = math.min(CFG.DROPDOWN_POPUP_W, math.max(140, container.AbsoluteSize.X - 12))
        listFrame.Size = UDim2.fromOffset(width, 0)

        local containerAbsX = container.AbsolutePosition.X
        local containerAbsY = container.AbsolutePosition.Y
        local containerAbsW = container.AbsoluteSize.X
        local containerAbsH = container.AbsoluteSize.Y
        local viewport = workspace.CurrentCamera.ViewportSize
        local screenW = viewport.X
        local screenH = viewport.Y
        local spaceBelow = screenH - (containerAbsY + containerAbsH + 8)
        local realMaxH = math.min(maxH, math.max(spaceBelow, 90))

        -- Tetap tepat di bawah dropdown, rata kanan dengan tombol <>.
        local popupRight = math.min(screenW - 8, containerAbsX + containerAbsW)
        local popupLeft = math.max(8, popupRight - width)
        listFrame.Position = UDim2.fromOffset(popupLeft, containerAbsY + containerAbsH + 6)

        TweenService:Create(listFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(width, realMaxH)
        }):Play()

        if _G.VRILZ_DropdownCloseOverlay then
            _G.VRILZ_DropdownCloseOverlay.Visible = true
        end

        _G.VRILZ_DropdownActive = {
            close = closeList,
            listFrame = listFrame,
            container = container
        }
    end

    container.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if isOpen then closeList() else openList() end
        end
    end)

        for i, item in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, -8, 0, itemHeight)
        opt.Position = UDim2.fromOffset(4, 0)
        opt.BackgroundColor3 = C.Surface3
        opt.Text = ""
        opt.AutoButtonColor = false
        opt.ZIndex = 2002
        opt.LayoutOrder = i
        opt.ClipsDescendants = true
        opt.Parent = listFrame
        registerTheme(opt, "Surface3", "BackgroundColor3")

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 8)
        optCorner.Parent = opt

        -- ⭐ BACKGROUND GRADIENT
        local optGradient = Instance.new("UIGradient")
        optGradient.Rotation = 90
        optGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Surface3),
            ColorSequenceKeypoint.new(0.5, C.Surface2),
            ColorSequenceKeypoint.new(1, C.Surface3),
        })
        optGradient.Parent = opt

        -- ⭐ BINTANG KELAP-KELIP DI BACKGROUND
        attachStarfield(opt, 5, C.Accent2)

        local optStroke = Instance.new("UIStroke")
        optStroke.Color = C.Accent
        optStroke.Thickness = 1
        optStroke.Transparency = 1
        optStroke.Parent = opt

        -- ⭐ LABEL NAMA dengan gradient shimmer
        local nameLbl = Instance.new("TextLabel")
        nameLbl.Name = "OptionName"
        nameLbl.Size = UDim2.new(1, -12, 1, 0)
        nameLbl.Position = UDim2.fromOffset(8, 0)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = item
        nameLbl.TextColor3 = C.Text
        nameLbl.Font = Enum.Font.GothamBold
        nameLbl.TextSize = CFG.FONT_LABEL
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
        nameLbl.ZIndex = 2003
        nameLbl.Parent = opt
        registerTheme(nameLbl, "Text", "TextColor3")

        -- ⭐ EFEK GRADIENT DI NAMA
        local nameGradient = Instance.new("UIGradient")
        nameGradient.Rotation = 0
        nameGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Text),
            ColorSequenceKeypoint.new(0.5, C.Accent2),
            ColorSequenceKeypoint.new(1, C.Text),
        })
        nameGradient.Parent = nameLbl

        -- ⭐ SHIMMER (cahaya bergerak di nama)
        task.spawn(function()
            local offset = 0
            while nameLbl.Parent and opt.Parent do
                offset = offset + 0.04
                if offset > 1 then offset = 0 end
                nameGradient.Offset = Vector2.new(offset, 0)
                task.wait(0.05)
            end
        end)

        if item == selectedValue then
            opt.BackgroundColor3 = C.Accent
            nameLbl.TextColor3 = Color3.new(1, 1, 1)
            nameLbl.TextStrokeColor3 = C.Accent2
            nameLbl.TextStrokeTransparency = 0.3
            optStroke.Transparency = 0.15
            nameGradient.Enabled = false
        end

        opt.MouseEnter:Connect(function()
            if item ~= selectedValue then
                TweenService:Create(opt, TweenInfo.new(0.15), {BackgroundColor3 = C.Surface2}):Play()
                nameLbl.TextColor3 = C.Accent2
                nameLbl.TextStrokeColor3 = C.Accent
                nameLbl.TextStrokeTransparency = 0.4
            end
            TweenService:Create(optStroke, TweenInfo.new(0.15), {Transparency = item == selectedValue and 0.15 or 0.45}):Play()
        end)
        opt.MouseLeave:Connect(function()
            if item ~= selectedValue then
                TweenService:Create(opt, TweenInfo.new(0.15), {BackgroundColor3 = C.Surface3}):Play()
                nameLbl.TextColor3 = C.Text
                nameLbl.TextStrokeTransparency = 1
            end
            TweenService:Create(optStroke, TweenInfo.new(0.15), {Transparency = item == selectedValue and 0.15 or 1}):Play()
        end)

        opt.MouseButton1Click:Connect(function()
            selectedValue = item
            selectedLbl.Text = item
            closeList()
            if onSelect then onSelect(item) end
        end)
    end
    
    return container
end

-- ====== DROPDOWN MULTI-SELECT (NONE LOGIC) ======
local function makeDropdownMulti(anchorFrame, items, sharedTable, itemColors, onChanged)
    local isOpen = false

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
    container.BackgroundColor3 = C.Surface3
    container.BorderSizePixel = 0
    container.ZIndex = 3
    container.Parent = anchorFrame
    registerTheme(container, "Surface3", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.6
    stroke.Parent = container
    registerTheme(stroke, "Accent", "Color")

    local selectedLbl = Instance.new("TextLabel")
    selectedLbl.Size = UDim2.new(1, -44, 1, 0)
    selectedLbl.Position = UDim2.fromOffset(12, 0)
    selectedLbl.BackgroundTransparency = 1
    selectedLbl.Text = "..."
    selectedLbl.TextColor3 = C.Text
    selectedLbl.Font = Enum.Font.GothamSemibold
    selectedLbl.TextSize = CFG.FONT_LABEL
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
    selectedLbl.ZIndex = 4
    selectedLbl.Parent = container
    registerTheme(selectedLbl, "Text", "TextColor3")

    -- Draw the rarity chevron from two small strokes so it never becomes a square/tofu glyph.
    local arrow = Instance.new("Frame")
    arrow.Name = "RarityChevron"
    arrow.Size = UDim2.fromOffset(IS_MOBILE and 20 or 22, IS_MOBILE and 16 or 18)
    arrow.Position = UDim2.new(1, -(IS_MOBILE and 27 or 29), 0.5, -(IS_MOBILE and 8 or 9))
    arrow.BackgroundTransparency = 1
    arrow.BorderSizePixel = 0
    arrow.ZIndex = 4
    arrow.Parent = container

    local arrowL = Instance.new("Frame")
    arrowL.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    arrowL.Position = UDim2.new(0.5, -(IS_MOBILE and 7 or 8), 0.5, -1)
    arrowL.BackgroundColor3 = C.Accent
    arrowL.BorderSizePixel = 0
    arrowL.Rotation = 45
    arrowL.ZIndex = 5
    arrowL.Parent = arrow
    registerTheme(arrowL, "Accent", "BackgroundColor3")

    local arrowR = Instance.new("Frame")
    arrowR.Size = UDim2.fromOffset(IS_MOBILE and 8 or 9, 2)
    arrowR.Position = UDim2.new(0.5, 1, 0.5, -1)
    arrowR.BackgroundColor3 = C.Accent
    arrowR.BorderSizePixel = 0
    arrowR.Rotation = -45
    arrowR.ZIndex = 5
    arrowR.Parent = arrow
    registerTheme(arrowR, "Accent", "BackgroundColor3")

    local listFrame = Instance.new("ScrollingFrame")
    local popupWidth = CFG.DROPDOWN_POPUP_W
    listFrame.Size = UDim2.fromOffset(popupWidth, 0)
    listFrame.BackgroundColor3 = C.Surface2
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = C.Accent
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Visible = false
    listFrame.ZIndex = 2001
    listFrame.Parent = _G.VRILZ_DropdownLayer
    registerTheme(listFrame, "Surface2", "BackgroundColor3")

    local listGradient = Instance.new("UIGradient")
    listGradient.Rotation = 90
    listGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 31, 36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 16)),
    })
    listGradient.Parent = listFrame

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 10)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = C.Accent
    listStroke.Transparency = 0.2
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    registerTheme(listStroke, "Accent", "Color")

    local listShadow = Instance.new("Frame")
    listShadow.Name = "DropdownShadow"
    listShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    listShadow.Position = UDim2.new(0.5, 0, 0.5, 6)
    listShadow.Size = UDim2.new(1, 10, 1, 10)
    listShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    listShadow.BackgroundTransparency = 0.35
    listShadow.BorderSizePixel = 0
    listShadow.ZIndex = 2000
    listShadow.Visible = false
    listShadow.Parent = listFrame
    local listShadowCorner = Instance.new("UICorner")
    listShadowCorner.CornerRadius = UDim.new(0, 12)
    listShadowCorner.Parent = listShadow

    local popupHighlight = Instance.new("Frame")
    popupHighlight.Size = UDim2.new(1, -16, 0, 1)
    popupHighlight.Position = UDim2.fromOffset(8, 4)
    popupHighlight.BackgroundColor3 = Color3.new(1, 1, 1)
    popupHighlight.BackgroundTransparency = 0.88
    popupHighlight.BorderSizePixel = 0
    popupHighlight.ZIndex = 2003
    popupHighlight.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 4)
    listPad.PaddingBottom = UDim.new(0, 4)
    listPad.PaddingLeft = UDim.new(0, 4)
    listPad.PaddingRight = UDim.new(0, 4)
    listPad.Parent = listFrame

    local itemHeight = CFG.DROPDOWN_ITEM
    local maxH = math.min(#items * (itemHeight + 2) + 10, IS_MOBILE and 126 or 148)

    local optionButtons = {}

    local function updateLabel()
        local selected = {}
        for _, r in ipairs(items) do
            if sharedTable[r] then table.insert(selected, r) end
        end
        if #selected == 0 then
            selectedLbl.Text = "Select Rarity..."
        elseif #selected == 1 and selected[1] == "None" then
            selectedLbl.Text = "None"
        elseif #selected <= 2 then
            selectedLbl.Text = table.concat(selected, ", ")
        else
            selectedLbl.Text = #selected .. " rarity is selected"
        end
    end

    local function updateButtonVisual(item)
        local opt = optionButtons[item]
        if not opt then return end
        local on = sharedTable[item] == true
        opt.chk.Text = on and "✓" or "○"
        opt.bg.BackgroundColor3 = on and C.Surface2 or C.Surface3

        -- ⭐ JANGAN override TextColor3 — biarkan gradient shimmer yang urus
        -- Cuma update stroke buat highlight selected
        if on then
            opt.txt.TextStrokeColor3 = C.Accent
            opt.txt.TextStrokeTransparency = 0.4
        else
            opt.txt.TextStrokeTransparency = 1
        end
    end

    local function closeList()
        isOpen = false
        arrowL.Rotation = 45
        arrowR.Rotation = -45
        local w = listFrame.Size.X.Offset
        TweenService:Create(listFrame, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromOffset(w, 0)}):Play()
        task.delay(0.2, function()
            if not isOpen then listFrame.Visible = false end
        end)
        if _G.VRILZ_DropdownCloseOverlay then
            _G.VRILZ_DropdownCloseOverlay.Visible = false
        end
        _G.VRILZ_DropdownActive = nil
    end

    local function openList()
        if _G.VRILZ_DropdownActive and _G.VRILZ_DropdownActive.close then
            _G.VRILZ_DropdownActive.close()
        end

        isOpen = true
        listFrame.Visible = true
        arrowL.Rotation = -45
        arrowR.Rotation = 45

        -- Compact popover: jangan selebar field/window.
        local width = math.min(CFG.DROPDOWN_POPUP_W, math.max(140, container.AbsoluteSize.X - 12))
        listFrame.Size = UDim2.fromOffset(width, 0)

        local containerAbsX = container.AbsolutePosition.X
        local containerAbsY = container.AbsolutePosition.Y
        local containerAbsW = container.AbsoluteSize.X
        local containerAbsH = container.AbsoluteSize.Y
        local viewport = workspace.CurrentCamera.ViewportSize
        local screenW = viewport.X
        local screenH = viewport.Y
        local spaceBelow = screenH - (containerAbsY + containerAbsH + 8)
        local realMaxH = math.min(maxH, math.max(spaceBelow, 90))

        -- Tetap tepat di bawah dropdown, rata kanan dengan tombol <>.
        local popupRight = math.min(screenW - 8, containerAbsX + containerAbsW)
        local popupLeft = math.max(8, popupRight - width)
        listFrame.Position = UDim2.fromOffset(popupLeft, containerAbsY + containerAbsH + 6)

        TweenService:Create(listFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(width, realMaxH)
        }):Play()

        if _G.VRILZ_DropdownCloseOverlay then
            _G.VRILZ_DropdownCloseOverlay.Visible = true
        end

        _G.VRILZ_DropdownActive = {
            close = closeList,
            listFrame = listFrame,
            container = container
        }
    end

    container.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if isOpen then closeList() else openList() end
        end
    end)

        for i, item in ipairs(items) do
        local opt = Instance.new("TextButton")
        opt.Size = UDim2.new(1, -8, 0, itemHeight)
        opt.Position = UDim2.fromOffset(4, 0)
        opt.BackgroundColor3 = C.Surface3
        opt.Text = ""
        opt.AutoButtonColor = false
        opt.ZIndex = 2002
        opt.LayoutOrder = i
        opt.ClipsDescendants = true
        opt.Parent = listFrame
        registerTheme(opt, "Surface3", "BackgroundColor3")

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 5)
        optCorner.Parent = opt

        -- ⭐ BACKGROUND GRADIENT
        local optGradient = Instance.new("UIGradient")
        optGradient.Rotation = 90
        optGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Surface3),
            ColorSequenceKeypoint.new(0.5, C.Surface2),
            ColorSequenceKeypoint.new(1, C.Surface3),
        })
        optGradient.Parent = opt

        -- ⭐ BINTANG KELAP-KELIP
        attachStarfield(opt, 5, C.Accent2)

        local chk = Instance.new("TextLabel")
        chk.Size = UDim2.fromOffset(24, itemHeight)
        chk.Position = UDim2.fromOffset(8, 0)
        chk.BackgroundTransparency = 1
        chk.Text = sharedTable[item] and "✓" or "○"
        chk.TextColor3 = C.Accent
        chk.Font = Enum.Font.GothamBold
        chk.TextSize = 14
        chk.ZIndex = 2003
        chk.Parent = opt

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, -40, 1, 0)
        txt.Position = UDim2.fromOffset(36, 0)
        txt.BackgroundTransparency = 1
        txt.Text = item
        txt.TextColor3 = C.Text
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = CFG.FONT_LABEL
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.TextTruncate = Enum.TextTruncate.AtEnd
        txt.ZIndex = 2003
        txt.Parent = opt

        -- ⭐ EFEK GRADIENT DI NAMA
        local txtGradient = Instance.new("UIGradient")
        txtGradient.Rotation = 0
        txtGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, C.Text),
            ColorSequenceKeypoint.new(0.5, C.Accent2),
            ColorSequenceKeypoint.new(1, C.Text),
        })
        txtGradient.Parent = txt

        -- ⭐ SHIMMER
        task.spawn(function()
            local offset = 0
            while txt.Parent and opt.Parent do
                offset = offset + 0.04
                if offset > 1 then offset = 0 end
                txtGradient.Offset = Vector2.new(offset, 0)
                task.wait(0.05)
            end
        end)

        if sharedTable[item] then
            opt.BackgroundColor3 = C.Surface2
            txt.TextColor3 = C.Accent2
            txt.TextStrokeColor3 = C.Accent
            txt.TextStrokeTransparency = 0.4
        end

        optionButtons[item] = {bg = opt, chk = chk, txt = txt}

        -- ⭐ HOVER EFFECT (glow + nama nyala) — TAMBAH INI
        opt.MouseEnter:Connect(function()
            if not sharedTable[item] then
                TweenService:Create(opt, TweenInfo.new(0.15), {BackgroundColor3 = C.Surface2}):Play()
                txt.TextStrokeColor3 = C.Accent
                txt.TextStrokeTransparency = 0.4
            end
        end)

        opt.MouseLeave:Connect(function()
            if not sharedTable[item] then
                TweenService:Create(opt, TweenInfo.new(0.15), {BackgroundColor3 = C.Surface3}):Play()
                txt.TextStrokeTransparency = 1
            end
        end)

        opt.MouseButton1Click:Connect(function()
            local isNone = (item == "None")

            if isNone then
                if sharedTable["None"] then
                    local anyOther = false
                    for _, r in ipairs(items) do
                        if r ~= "None" and sharedTable[r] then anyOther = true break end
                    end
                    if not anyOther then return end
                    sharedTable["None"] = false
                    updateButtonVisual("None")
                else
                    for _, r in ipairs(items) do
                        if r ~= "None" then sharedTable[r] = false end
                    end
                    sharedTable["None"] = true
                    for _, r in ipairs(items) do updateButtonVisual(r) end
                end
            else
                sharedTable[item] = not sharedTable[item]
                if sharedTable[item] then
                    if sharedTable["None"] then
                        sharedTable["None"] = false
                        updateButtonVisual("None")
                    end
                else
                    local anyOn = false
                    for _, r in ipairs(items) do
                        if r ~= "None" and sharedTable[r] then anyOn = true break end
                    end
                    if not anyOn then
                        sharedTable["None"] = true
                        updateButtonVisual("None")
                    end
                end
                updateButtonVisual(item)
            end

            updateLabel()
            if onChanged then onChanged(sharedTable) end
        end)
    end

    updateLabel()
    return container
end

-- ============================================================
-- 🌌 LIGHTS EFFECT LAYER v3 — REALISTIC METEOR SHOWER
-- ============================================================
local function buildLightsEffectLayer(mainFrame)
    local layer = Instance.new("Frame")
    layer.Name = "LightsEffectLayer"
    layer.Size = UDim2.fromScale(1, 1)
    layer.Position = UDim2.fromScale(0, 0)
    layer.BackgroundTransparency = 1
    layer.ClipsDescendants = true
    layer.ZIndex = 4
    layer.Active = false
    layer.Parent = mainFrame

    local layerCorner = Instance.new("UICorner")
    layerCorner.CornerRadius = UDim.new(0, 18)
    layerCorner.Parent = layer

    local active = true
    layer.Destroying:Connect(function()
        active = false
    end)

    -- ══════════════════════════════════════════
    -- BACKGROUND SPACE GRADIENT (deep space)
    -- ══════════════════════════════════════════
    local spaceBg = Instance.new("Frame")
    spaceBg.Name = "SpaceBG"
    spaceBg.Size = UDim2.fromScale(1, 1)
    spaceBg.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
    spaceBg.BackgroundTransparency = 0.85
    spaceBg.BorderSizePixel = 0
    spaceBg.ZIndex = 4
    spaceBg.Parent = layer

    local spaceBgCorner = Instance.new("UICorner")
    spaceBgCorner.CornerRadius = UDim.new(0, 18)
    spaceBgCorner.Parent = spaceBg

    local spaceGrad = Instance.new("UIGradient")
    spaceGrad.Rotation = 135
    spaceGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 12, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(3, 5, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(1, 2, 8)),
    })
    spaceGrad.Parent = spaceBg

    -- ══════════════════════════════════════════
    -- STARFIELD — bintang kedap-kedip (twinkle)
    -- ══════════════════════════════════════════
    local starfield = Instance.new("Frame")
    starfield.Name = "Starfield"
    starfield.Size = UDim2.fromScale(1, 1)
    starfield.BackgroundTransparency = 1
    starfield.ClipsDescendants = true
    starfield.ZIndex = 5
    starfield.Parent = layer

    local starColors = {
        Color3.fromRGB(255, 255, 255),   -- putih
        Color3.fromRGB(180, 220, 255),   -- biru muda
        Color3.fromRGB(255, 220, 180),   -- kuning lembut
        Color3.fromRGB(200, 180, 255),   -- ungu
        Color3.fromRGB(255, 180, 220),   -- pink lembut
    }
    local starCount = IS_MOBILE and 45 or 70

    for i = 1, starCount do
        local star = Instance.new("Frame")
        local sz = math.random(1, 3)
        star.Name = "Star_" .. i
        star.Size = UDim2.fromOffset(sz, sz)
        star.Position = UDim2.fromScale(math.random(0, 1000) / 1000, math.random(0, 1000) / 1000)
        star.BackgroundColor3 = starColors[math.random(1, #starColors)]
        star.BackgroundTransparency = math.random(40, 85) / 100
        star.BorderSizePixel = 0
        star.ZIndex = 6
        star.Parent = starfield

        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(1, 0)
        sc.Parent = star

        -- Glow halo tipis di sekitar bintang
        local starGlow = Instance.new("Frame")
        starGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        starGlow.Position = UDim2.fromScale(0.5, 0.5)
        starGlow.Size = UDim2.new(3, 0, 3, 0)
        starGlow.BackgroundColor3 = star.BackgroundColor3
        starGlow.BackgroundTransparency = 0.92
        starGlow.BorderSizePixel = 0
        starGlow.ZIndex = 5
        starGlow.Parent = star
        local sgc = Instance.new("UICorner")
        sgc.CornerRadius = UDim.new(1, 0)
        sgc.Parent = starGlow

        -- Twinkle animation
        local baseTrans = star.BackgroundTransparency
        local baseGlowTrans = starGlow.BackgroundTransparency
        local minTrans = math.max(0, baseTrans - 0.55)
        local minGlowTrans = math.max(0, baseGlowTrans - 0.10)

        task.spawn(function()
            task.wait(math.random(0, 400) / 100)  -- delay random awal
            while star.Parent and active do
                local upDur = math.random(50, 120) / 100
                local downDur = math.random(60, 140) / 100

                TweenService:Create(star, TweenInfo.new(upDur, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = minTrans
                }):Play()
                TweenService:Create(starGlow, TweenInfo.new(upDur, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = minGlowTrans
                }):Play()

                task.wait(upDur + math.random(0, 80) / 100)

                TweenService:Create(star, TweenInfo.new(downDur, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = baseTrans
                }):Play()
                TweenService:Create(starGlow, TweenInfo.new(downDur, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = baseGlowTrans
                }):Play()

                task.wait(downDur + math.random(0, 200) / 100)
            end
        end)
    end

    -- ══════════════════════════════════════════
    -- SATELIT muter di orbit (2 satelit)
    -- ══════════════════════════════════════════
    local function createSatellite(radiusPct, speed, startAngle, color)
        local orbitCenter = Instance.new("Frame")
        orbitCenter.Name = "SatelliteOrbit"
        orbitCenter.AnchorPoint = Vector2.new(0.5, 0.5)
        orbitCenter.Position = UDim2.fromScale(0.5, 0.5)
        orbitCenter.Size = UDim2.fromScale(1, 1)
        orbitCenter.BackgroundTransparency = 1
        orbitCenter.ZIndex = 6
        orbitCenter.Parent = layer

        -- Satelit body
        local sat = Instance.new("Frame")
        sat.Name = "Satellite"
        sat.AnchorPoint = Vector2.new(0.5, 0.5)
        sat.Size = UDim2.fromOffset(IS_MOBILE and 6 or 8, IS_MOBILE and 6 or 8)
        sat.BackgroundColor3 = color
        sat.BorderSizePixel = 0
        sat.ZIndex = 7
        sat.Parent = orbitCenter

        local satCorner = Instance.new("UICorner")
        satCorner.CornerRadius = UDim.new(1, 0)
        satCorner.Parent = sat

        -- Glow
        local satGlow = Instance.new("Frame")
        satGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        satGlow.Position = UDim2.fromScale(0.5, 0.5)
        satGlow.Size = UDim2.new(2.5, 0, 2.5, 0)
        satGlow.BackgroundColor3 = color
        satGlow.BackgroundTransparency = 0.75
        satGlow.BorderSizePixel = 0
        satGlow.ZIndex = 6
        satGlow.Parent = sat
        local sgc2 = Instance.new("UICorner")
        sgc2.CornerRadius = UDim.new(1, 0)
        sgc2.Parent = satGlow

        -- Panel satelit (2 strip tipis)
        local panelL = Instance.new("Frame")
        panelL.AnchorPoint = Vector2.new(1, 0.5)
        panelL.Position = UDim2.new(0.5, -3, 0.5, 0)
        panelL.Size = UDim2.fromOffset(6, 2)
        panelL.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
        panelL.BackgroundTransparency = 0.3
        panelL.BorderSizePixel = 0
        panelL.ZIndex = 7
        panelL.Parent = sat

        local panelR = Instance.new("Frame")
        panelR.AnchorPoint = Vector2.new(0, 0.5)
        panelR.Position = UDim2.new(0.5, 3, 0.5, 0)
        panelR.Size = UDim2.fromOffset(6, 2)
        panelR.BackgroundColor3 = Color3.fromRGB(200, 220, 255)
        panelR.BackgroundTransparency = 0.3
        panelR.BorderSizePixel = 0
        panelR.ZIndex = 7
        panelR.Parent = sat

        -- Animasi orbit
        task.spawn(function()
            local angle = startAngle or 0
            while sat.Parent and active do
                task.wait(0.03)
                angle = angle + speed
                if angle > math.pi * 2 then angle = angle - math.pi * 2 end

                -- Orbit ellipse
                local rx = radiusPct * 0.5
                local ry = radiusPct * 0.25
                local x = 0.5 + math.cos(angle) * rx
                local y = 0.5 + math.sin(angle) * ry
                sat.Position = UDim2.fromScale(x, y)

                -- Skala satelit
                local depth = math.sin(angle)
                local scale = 0.7 + (depth + 1) * 0.25
                local baseSize = IS_MOBILE and 6 or 8
                sat.Size = UDim2.fromOffset(baseSize * scale, baseSize * scale)
                sat.BackgroundTransparency = 0.3 - depth * 0.3
            end
        end)
    end

    -- 2 satelit muter
    createSatellite(0.85, 0.012, 0, Color3.fromRGB(180, 220, 255))
    createSatellite(0.70, -0.018, math.pi, Color3.fromRGB(255, 180, 200))

    -- ══════════════════════════════════════════
    -- METEOR JATUH (REALISTIS)
    -- ══════════════════════════════════════════
    local meteorColors = {
        Color3.fromRGB(255, 200, 120),  -- oranye api
        Color3.fromRGB(150, 220, 255),  -- biru ice
        Color3.fromRGB(255, 160, 200),  -- pink
        Color3.fromRGB(200, 180, 255),  -- ungu
    }

    local function spawnMeteor()
        if not active or not layer.Parent then return end

        local pickColor = meteorColors[math.random(1, #meteorColors)]
        
        -- Tentukan arah diagonal (Miring melintasi layar)
        local goRight = math.random() > 0.5
        local startX, endX
        
        if goRight then
            startX = math.random(-20, 10) / 100
            endX = startX + math.random(80, 120) / 100
        else
            startX = math.random(90, 120) / 100
            endX = startX - math.random(80, 120) / 100
        end

        local startY = -0.2
        local endY = 1.2

        -- Hitung sudut miring secara presisi buat ekornya
        local angleDeg = math.deg(math.atan2(endY - startY, endX - startX)) - 90

        -- ══════════════════════════════════════════
        -- 1. KEPALA METEOR (BOLA SEMPURNA)
        -- ══════════════════════════════════════════
        local meteor = Instance.new("Frame")
        meteor.Name = "MeteorHead"
        meteor.AnchorPoint = Vector2.new(0.5, 0.5)
        meteor.Size = UDim2.fromOffset(8, 8) -- Ukuran fix, dijamin bulat
        meteor.Position = UDim2.fromScale(startX, startY)
        meteor.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- Inti putih panas
        meteor.BorderSizePixel = 0
        meteor.ZIndex = 15
        meteor.Parent = layer

        local mc = Instance.new("UICorner")
        mc.CornerRadius = UDim.new(1, 0) -- 1,0 = Lingkaran sempurna
        mc.Parent = meteor

        -- Glow luar (halo cahaya)
        local headGlow = Instance.new("Frame")
        headGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        headGlow.Position = UDim2.fromScale(0.5, 0.5)
        headGlow.Size = UDim2.fromOffset(24, 24)
        headGlow.BackgroundColor3 = pickColor
        headGlow.BackgroundTransparency = 0.3
        headGlow.BorderSizePixel = 0
        headGlow.ZIndex = 14
        headGlow.Parent = meteor
        local hgc = Instance.new("UICorner")
        hgc.CornerRadius = UDim.new(1, 0)
        hgc.Parent = headGlow

        -- ══════════════════════════════════════════
        -- 2. EKOR KOMET MULTI-LAYER (REALISTIS)
        -- ══════════════════════════════════════════
        local trailHolder = Instance.new("Frame")
        trailHolder.AnchorPoint = Vector2.new(0.5, 0.5)
        trailHolder.Position = UDim2.fromScale(0.5, 0.5)
        trailHolder.Size = UDim2.fromOffset(1, 1)
        trailHolder.BackgroundTransparency = 1
        trailHolder.Rotation = angleDeg -- Ekor miring sesuai arah
        trailHolder.ZIndex = 10
        trailHolder.Parent = meteor

        local trailLength = math.random(100, 150)

        -- Layer 1: Ekor Luar (Besar & Transparan / Efek Gas)
        local outerTrail = Instance.new("Frame")
        outerTrail.AnchorPoint = Vector2.new(0.5, 1)
        outerTrail.Position = UDim2.new(0.5, 0, 0.5, 0)
        outerTrail.Size = UDim2.fromOffset(12, trailLength)
        outerTrail.BackgroundColor3 = pickColor
        outerTrail.BorderSizePixel = 0
        outerTrail.ZIndex = 11
        outerTrail.Parent = trailHolder
        
        local outerGrad = Instance.new("UIGradient")
        outerGrad.Rotation = 90
        outerGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),      -- Ujung ekor hilang total
            NumberSequenceKeypoint.new(0.5, 0.85), -- Tengah samar
            NumberSequenceKeypoint.new(1, 0.4),    -- Deket kepala terang
        })
        outerGrad.Parent = outerTrail

        -- Layer 2: Ekor Tengah (Warna Meteor / Inti Ekor)
        local midTrail = Instance.new("Frame")
        midTrail.AnchorPoint = Vector2.new(0.5, 1)
        midTrail.Position = UDim2.new(0.5, 0, 0.5, 0)
        midTrail.Size = UDim2.fromOffset(6, trailLength * 0.9)
        midTrail.BackgroundColor3 = pickColor
        midTrail.BorderSizePixel = 0
        midTrail.ZIndex = 12
        midTrail.Parent = trailHolder
        
        local midGrad = Instance.new("UIGradient")
        midGrad.Rotation = 90
        midGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.4, 0.6),
            NumberSequenceKeypoint.new(1, 0.1),
        })
        midGrad.Parent = midTrail

        -- Layer 3: Ekor Dalam (Putih Panas / Laser Core)
        local coreTrail = Instance.new("Frame")
        coreTrail.AnchorPoint = Vector2.new(0.5, 1)
        coreTrail.Position = UDim2.new(0.5, 0, 0.5, 0)
        coreTrail.Size = UDim2.fromOffset(2, trailLength * 0.7)
        coreTrail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        coreTrail.BorderSizePixel = 0
        coreTrail.ZIndex = 13
        coreTrail.Parent = trailHolder
        
        local coreGrad = Instance.new("UIGradient")
        coreGrad.Rotation = 90
        coreGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 0),
        })
        coreGrad.Parent = coreTrail

        -- Percikan Api (Sparks) yang berjatuhan
        for s = 1, math.random(4, 7) do
            local spark = Instance.new("Frame")
            spark.AnchorPoint = Vector2.new(0.5, 0.5)
            spark.Position = UDim2.new(0.5, math.random(-6, 6), 0.5, -math.random(10, trailLength - 10))
            spark.Size = UDim2.fromOffset(math.random(1, 3), math.random(1, 3))
            spark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            spark.BackgroundTransparency = math.random(10, 50) / 100
            spark.BorderSizePixel = 0
            spark.ZIndex = 12
            spark.Parent = trailHolder
            local spc = Instance.new("UICorner")
            spc.CornerRadius = UDim.new(1, 0)
            spc.Parent = spark
        end

        -- ══════════════════════════════════════════
        -- 3. ANIMASI JATUH
        -- ══════════════════════════════════════════
        local duration = math.random(150, 250) / 100 -- 1.5 - 2.5 detik
        
        -- Gerak mulus ke titik ujung
        TweenService:Create(meteor, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Position = UDim2.fromScale(endX, endY),
        }):Play()

        -- Fade Out pas mendekati ujung layar
        task.delay(duration * 0.8, function()
            if meteor.Parent then
                TweenService:Create(meteor, TweenInfo.new(duration * 0.2, Enum.EasingStyle.Quad), {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(headGlow, TweenInfo.new(duration * 0.2, Enum.EasingStyle.Quad), {
                    BackgroundTransparency = 1,
                }):Play()
                -- Fade out semua layer ekor secara barengan
                for _, child in ipairs(trailHolder:GetChildren()) do
                    if child:IsA("Frame") and child.Name ~= "Spark" then -- Spark udah transparan natural
                        local targetTrans = child.BackgroundTransparency + 0.3
                        TweenService:Create(child, TweenInfo.new(duration * 0.2), {
                            BackgroundTransparency = targetTrans
                        }):Play()
                    end
                end
            end
        end)

        -- Hapus objek
        task.delay(duration + 0.2, function()
            if meteor then meteor:Destroy() end
        end)
    end

    -- Loop spawn meteor
    task.spawn(function()
        task.wait(1.5)
        while active do
            spawnMeteor()
            if math.random() < 0.3 then
                task.wait(math.random(10, 30) / 100)
                spawnMeteor()
            end
            task.wait(math.random(150, 350) / 100)  -- 1.5-3.5 detik
        end
    end)

    -- ══════════════════════════════════════════
    -- AMBIENT SHADOW (vignette atas & bawah)
    -- ══════════════════════════════════════════
    local topShadow = Instance.new("Frame")
    topShadow.Size = UDim2.new(1, 0, 0, 60)
    topShadow.Position = UDim2.fromScale(0, 0)
    topShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    topShadow.BackgroundTransparency = 0.7
    topShadow.BorderSizePixel = 0
    topShadow.ZIndex = 4
    topShadow.Parent = layer

    local topShadowGrad = Instance.new("UIGradient")
    topShadowGrad.Rotation = 90
    topShadowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1),
    })
    topShadowGrad.Parent = topShadow

    local botShadow = Instance.new("Frame")
    botShadow.Size = UDim2.new(1, 0, 0, 60)
    botShadow.Position = UDim2.new(0, 0, 1, -60)
    botShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    botShadow.BackgroundTransparency = 0.7
    botShadow.BorderSizePixel = 0
    botShadow.ZIndex = 4
    botShadow.Parent = layer

    local botShadowGrad = Instance.new("UIGradient")
    botShadowGrad.Rotation = -90
    botShadowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(1, 1),
    })
    botShadowGrad.Parent = botShadow

    return layer
end

-- ============================================================
-- ⚡ LIGHTNING EFFECT LAYER v4 — Rapi, gak numpuk, tetap bagus
-- ============================================================
local function buildLightningEffectLayer(mainFrame)
    local layer = Instance.new("Frame")
    layer.Name = "LightningEffectLayer"
    layer.Size = UDim2.fromScale(1, 1)
    layer.Position = UDim2.fromScale(0, 0)
    layer.BackgroundTransparency = 1
    layer.ClipsDescendants = true
    layer.ZIndex = 7
    layer.Active = false
    layer.Parent = mainFrame

    local layerCorner = Instance.new("UICorner")
    layerCorner.CornerRadius = UDim.new(0, 18)
    layerCorner.Parent = layer

    local lightningActive = true
    layer.Destroying:Connect(function()
        lightningActive = false
    end)

    -- ══════════════════════════════════════════
    -- LOCK: cegah petir numpuk. Cuma 1 sambaran pada satu waktu.
    -- ══════════════════════════════════════════
    local currentBoltHolder = nil

    -- ══════════════════════════════════════════
    -- HELPER: 1 segmen garis petir miring
    -- ══════════════════════════════════════════
    local function makeSegment(parent, p1, p2, thickness, color, transparency, zIndex)
        local dx = (p2.x - p1.x) * 1000
        local dy = (p2.y - p1.y) * 1000
        local length = math.sqrt(dx * dx + dy * dy)
        local angle = math.deg(math.atan2(dy, dx))
        local midX = (p1.x + p2.x) / 2
        local midY = (p1.y + p2.y) / 2

        local seg = Instance.new("Frame")
        seg.AnchorPoint = Vector2.new(0.5, 0.5)
        seg.Position = UDim2.fromScale(midX, midY)
        seg.Size = UDim2.fromOffset(length, thickness)
        seg.Rotation = angle
        seg.BackgroundColor3 = color
        seg.BackgroundTransparency = transparency
        seg.BorderSizePixel = 0
        seg.ZIndex = zIndex
        seg.Parent = parent

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(1, 0)
        c.Parent = seg

        return seg
    end

    -- ══════════════════════════════════════════
    -- HELPER: generate zig-zag path
    -- ══════════════════════════════════════════
    local function generateBoltPath(startX, startY, endY, segments, jitter)
        local path = { {x = startX, y = startY} }
        for i = 1, segments do
            local t = i / segments
            local py = startY + (endY - startY) * t
            local px = startX + math.random(-jitter, jitter) / 100
            px = math.clamp(px, 0.03, 0.97)
            py = math.clamp(py, 0.03, 0.97)
            table.insert(path, {x = px, y = py})
        end
        return path
    end

    -- ══════════════════════════════════════════
    -- SPAWN 1 PETIR (dijamin cuma 1 aktif)
    -- ══════════════════════════════════════════
    local function spawnLightningBolt()
        if not lightningActive or not layer.Parent then return end

        -- ⭐ Kalau masih ada petir aktif → hapus dulu (anti numpuk)
        if currentBoltHolder and currentBoltHolder.Parent then
            currentBoltHolder:Destroy()
            currentBoltHolder = nil
        end

        -- ═══ Posisi petir ═══
        local startX = math.random(20, 80) / 100
        local startY = 0.03
        local endY = math.random(55, 85) / 100
        local endX = math.clamp(startX + math.random(-15, 15) / 100, 0.05, 0.95)

        local boltHolder = Instance.new("Frame")
        boltHolder.Name = "LightningBolt"
        boltHolder.Size = UDim2.fromScale(1, 1)
        boltHolder.BackgroundTransparency = 1
        boltHolder.ClipsDescendants = true
        boltHolder.ZIndex = 8
        boltHolder.Parent = layer
        currentBoltHolder = boltHolder

        local allFrames = {}
        local RED_CORE  = Color3.fromRGB(255, 30, 30)
        local RED_GLOW  = Color3.fromRGB(255, 80, 80)
        local WHITE_HOT = Color3.fromRGB(255, 230, 230)
        local DARK_RED  = Color3.fromRGB(180, 0, 0)

        -- Jalur utama
        local mainSegments = math.random(6, 8)
        local mainPath = generateBoltPath(startX, startY, endY, mainSegments, 5)

        for i = 1, #mainPath - 1 do
            local p1 = mainPath[i]
            local p2 = mainPath[i + 1]

            table.insert(allFrames, makeSegment(boltHolder, p1, p2, math.random(10, 13), RED_GLOW, 0.5, 8))
            table.insert(allFrames, makeSegment(boltHolder, p1, p2, math.random(5, 7), RED_CORE, 0.15, 9))
            table.insert(allFrames, makeSegment(boltHolder, p1, p2, 3, RED_CORE, 0, 10))
            table.insert(allFrames, makeSegment(boltHolder, p1, p2, 1.2, WHITE_HOT, 0, 11))

            -- Cabang (cuma 40% chance, biar gak terlalu banyak)
            if math.random() < 0.4 then
                local branchStart = p1
                local branchLenY = math.random(10, 20) / 100
                local branchLenX = math.random(-15, 15) / 100
                local branchEnd = {
                    x = math.clamp(branchStart.x + branchLenX, 0.03, 0.97),
                    y = math.clamp(branchStart.y + branchLenY, 0.03, 0.98)
                }

                local subSegs = math.random(2, 3)
                local branchPath = { branchStart }
                for s = 1, subSegs do
                    local st = s / subSegs
                    local sx = branchStart.x + (branchEnd.x - branchStart.x) * st + math.random(-4, 4) / 100
                    local sy = branchStart.y + (branchEnd.y - branchStart.y) * st + math.random(-2, 2) / 100
                    sx = math.clamp(sx, 0.03, 0.97)
                    sy = math.clamp(sy, 0.03, 0.98)
                    table.insert(branchPath, {x = sx, y = sy})
                end

                for bs = 1, #branchPath - 1 do
                    local bp1 = branchPath[bs]
                    local bp2 = branchPath[bs + 1]
                    table.insert(allFrames, makeSegment(boltHolder, bp1, bp2, math.random(4, 5), RED_GLOW, 0.65, 8))
                    table.insert(allFrames, makeSegment(boltHolder, bp1, bp2, 1.5, RED_CORE, 0.1, 9))
                end
            end
        end

        -- Impact glow di titik bawah
        local impactX = mainPath[#mainPath].x
        local impactY = mainPath[#mainPath].y

        local impact = Instance.new("Frame")
        impact.AnchorPoint = Vector2.new(0.5, 0.5)
        impact.Position = UDim2.fromScale(impactX, impactY)
        impact.Size = UDim2.fromOffset(28, 28)
        impact.BackgroundColor3 = RED_GLOW
        impact.BackgroundTransparency = 0.4
        impact.BorderSizePixel = 0
        impact.ZIndex = 9
        impact.Parent = boltHolder
        local ic = Instance.new("UICorner")
        ic.CornerRadius = UDim.new(1, 0)
        ic.Parent = impact
        table.insert(allFrames, impact)

        local impactCore = Instance.new("Frame")
        impactCore.AnchorPoint = Vector2.new(0.5, 0.5)
        impactCore.Position = UDim2.fromScale(impactX, impactY)
        impactCore.Size = UDim2.fromOffset(10, 10)
        impactCore.BackgroundColor3 = WHITE_HOT
        impactCore.BorderSizePixel = 0
        impactCore.ZIndex = 11
        impactCore.Parent = boltHolder
        local icc = Instance.new("UICorner")
        icc.CornerRadius = UDim.new(1, 0)
        icc.Parent = impactCore
        table.insert(allFrames, impactCore)

        -- ═══ Animasi flicker (4 tahap) ═══
        for _, f in ipairs(allFrames) do
            local origTrans = f.BackgroundTransparency
            f.BackgroundTransparency = 1
            task.delay(0.01, function()
                if f.Parent then
                    TweenService:Create(f, TweenInfo.new(0.04, Enum.EasingStyle.Linear), {
                        BackgroundTransparency = origTrans
                    }):Play()
                end
            end)
        end

        task.delay(0.08, function()
            if not boltHolder.Parent then return end
            for _, f in ipairs(allFrames) do
                if f.Parent then
                    f.BackgroundTransparency = math.min(0.85, f.BackgroundTransparency + 0.5)
                end
            end
        end)

        task.delay(0.16, function()
            if not boltHolder.Parent then return end
            for _, f in ipairs(allFrames) do
                if f.Parent then
                    f.BackgroundTransparency = math.max(0, f.BackgroundTransparency - 0.4)
                end
            end
        end)

        task.delay(0.28, function()
            for _, f in ipairs(allFrames) do
                if f.Parent then
                    TweenService:Create(f, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = 1
                    }):Play()
                end
            end
        end)

        -- Cleanup (dan reset currentBoltHolder)
        task.delay(0.85, function()
            if boltHolder and boltHolder.Parent then
                boltHolder:Destroy()
            end
            if currentBoltHolder == boltHolder then
                currentBoltHolder = nil
            end
        end)
    end

    -- ══════════════════════════════════════════
    -- LOOP SPAWN — 1 sambaran, jeda 3-6 detik
    -- ══════════════════════════════════════════
    task.spawn(function()
        task.wait(2) -- delay awal
        while lightningActive do
            -- ⭐ Cuma spawn kalau gak ada petir aktif (anti numpuk)
            if not currentBoltHolder then
                spawnLightningBolt()
            end

            -- ⭐ Jeda 3-6 detik sebelum cek lagi
            task.wait(math.random(300, 600) / 100)
        end
    end)

    return layer
end

-- ====== FPS WINDOW ======
local function buildFPSWindow(parent)
    local fpsWin = Instance.new("Frame")
    fpsWin.Name = "FPSWindow"
    fpsWin.Size = UDim2.fromOffset(IS_MOBILE and 160 or 180, IS_MOBILE and 64 or 70)
    fpsWin.Position = UDim2.fromOffset(20, 90)
    fpsWin.BackgroundColor3 = C.Surface
    fpsWin.BackgroundTransparency = 0.1
    fpsWin.BorderSizePixel = 0
    fpsWin.Visible = false
    fpsWin.ZIndex = 60
    fpsWin.Parent = parent
    registerTheme(fpsWin, "Surface", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = fpsWin

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1.5
    stroke.Transparency = 0.3
    stroke.Parent = fpsWin
    registerTheme(stroke, "Accent", "Color")

    local fpsLbl = Instance.new("TextLabel")
    fpsLbl.Size = UDim2.new(1, -20, 0, 24)
    fpsLbl.Position = UDim2.fromOffset(10, 8)
    fpsLbl.BackgroundTransparency = 1
    fpsLbl.Text = "FPS: --"
    fpsLbl.TextColor3 = C.Text
    fpsLbl.Font = Enum.Font.GothamBold
    fpsLbl.TextSize = IS_MOBILE and 12 or 14
    fpsLbl.TextXAlignment = Enum.TextXAlignment.Left
    fpsLbl.ZIndex = 61
    fpsLbl.Parent = fpsWin
    registerTheme(fpsLbl, "Text", "TextColor3")

    local pingLbl = Instance.new("TextLabel")
    pingLbl.Size = UDim2.new(1, -20, 0, 20)
    pingLbl.Position = UDim2.fromOffset(10, IS_MOBILE and 30 or 34)
    pingLbl.BackgroundTransparency = 1
    pingLbl.Text = "PING: --"
    pingLbl.TextColor3 = C.Accent2
    pingLbl.Font = Enum.Font.GothamBold
    pingLbl.TextSize = IS_MOBILE and 11 or 12
    pingLbl.TextXAlignment = Enum.TextXAlignment.Left
    pingLbl.ZIndex = 61
    pingLbl.Parent = fpsWin
    registerTheme(pingLbl, "Accent2", "TextColor3")

    local frames, last = 0, os.clock()
    RunService.RenderStepped:Connect(function()
        frames = frames + 1
        local elapsed = os.clock() - last
        if elapsed >= 0.5 then
            local fps = math.floor(frames / elapsed)
            local ping = 0
            pcall(function()
                ping = math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            fpsLbl.Text = "FPS: " .. fps
            pingLbl.Text = "PING: " .. ping .. "ms"
            frames = 0
            last = os.clock()
        end
    end)

    return fpsWin
end

-- ===== WEBHOOK SAVE/LOAD =====
local WEBHOOK_SAVE_FILE = "vrilz_webhook.txt"

local function saveWebhookURL(url)
    _G.VRILZ_WebhookURL = url
    if writefile then
        pcall(writefile, WEBHOOK_SAVE_FILE, url or "")
    end
end

local function loadWebhookURL()
    if _G.VRILZ_WebhookURL then
        return _G.VRILZ_WebhookURL
    end
    if readfile and isfile then
        local ok, exists = pcall(isfile, WEBHOOK_SAVE_FILE)
        if ok and exists then
            local okRead, content = pcall(readfile, WEBHOOK_SAVE_FILE)
            if okRead and content then
                content = content:gsub("^%s+", ""):gsub("%s+$", "")
                if content ~= "" then
                    _G.VRILZ_WebhookURL = content
                    return content
                end
            end
        end
    end
    return nil
end

-- ============================================================
-- LIVE CHAT CLIENT (global via Cloudflare Worker + D1)
-- ============================================================
_G.VRILZ_ChatClient = _G.VRILZ_ChatClient or {
    listeners = {},
    lastTs = 0,
    polling = false,
}
local ChatClient = _G.VRILZ_ChatClient

local function getChatHttpRequest()
    return (syn and syn.request)
        or (http and http.request)
        or (http_request)
        or (request)
end

local function chatHttpJSON(url, method, bodyTable)
    local HttpService = game:GetService("HttpService")
    local ok, res = pcall(function()
        local req = getChatHttpRequest()
        if req then
            local opts = {
                Url = url,
                Method = method,
                Headers = {["Content-Type"] = "application/json"},
            }
            if bodyTable then opts.Body = HttpService:JSONEncode(bodyTable) end
            return req(opts)
        end
        if method == "POST" then
            return {
                StatusCode = 200,
                Body = HttpService:PostAsync(url, HttpService:JSONEncode(bodyTable), Enum.HttpContentType.ApplicationJson)
            }
        else
            return {StatusCode = 200, Body = HttpService:GetAsync(url)}
        end
    end)
    if not ok or not res then return nil end
    local okDecode, data = pcall(function()
        return HttpService:JSONDecode(res.Body or res.body or "")
    end)
    if not okDecode then return nil end
    return data
end

function ChatClient.onMessage(cb)
    table.insert(ChatClient.listeners, cb)
end

function ChatClient.send(text)
    if type(text) ~= "string" then return false, "invalid" end
    text = text:gsub("[\n\r]", " "):sub(1, 200)
    if text == "" then return false, "empty" end

    local data = chatHttpJSON(
        KEY_SYSTEM_URL:gsub("/$", "") .. "/api/chat/send",
        "POST",
        {
            userId = LocalPlayer.UserId,
            username = LocalPlayer.Name,
            displayName = LocalPlayer.DisplayName,
            text = text,
        }
    )
    if data and data.success then return true end
    return false, (data and data.message) or "network error"
end

function ChatClient.pollOnce()
    local url = KEY_SYSTEM_URL:gsub("/$", "") .. "/api/chat/poll?since=" .. tostring(ChatClient.lastTs)
    local data = chatHttpJSON(url, "GET", nil)
    if not data or not data.success or type(data.messages) ~= "table" then return end

    for _, m in ipairs(data.messages) do
        local ts = tonumber(m.ts or 0)
        if ts > ChatClient.lastTs then ChatClient.lastTs = ts end
        local msg = {
            userId = tonumber(m.i or 0),
            username = tostring(m.u or "?"),
            displayName = tostring(m.d or m.u or "?"),
            text = tostring(m.t or ""),
            time = os.date("%H:%M", math.floor(ts / 1000)),
            ts = ts,
        }
        table.insert(Shared.LiveChat_Messages, msg)
        while #Shared.LiveChat_Messages > Shared.LiveChat_MaxMessages do
            table.remove(Shared.LiveChat_Messages, 1)
        end
        for _, cb in ipairs(ChatClient.listeners) do
            task.spawn(cb, msg)
        end
    end
end

function ChatClient.start()
    if ChatClient.polling then return end
    ChatClient.polling = true
    task.spawn(function()
        while ChatClient.polling do
            pcall(ChatClient.pollOnce)
            task.wait(Shared.LiveChat_PollInterval or 1.5)
        end
    end)
end

-- ============================================================
-- 🎮 GRAPHICS ENGINE — FPS BOOST + 4K HD MODE
-- ============================================================
local GFX = {
    FPSEnabled = false,
    HDEnabled = false,
    Original = {},
    Created = {},
    LoopThread = nil,
    TextureBackup = {},
    HiddenParts = {},
}

local function gfx_save(obj, prop)
    local ok, val = pcall(function() return obj[prop] end)
    if ok then table.insert(GFX.Original, {obj = obj, prop = prop, value = val}) end
end

local function gfx_restore()
    for _, item in ipairs(GFX.Original) do
        pcall(function() item.obj[item.prop] = item.value end)
    end
    GFX.Original = {}
end

local function gfx_add(inst)
    table.insert(GFX.Created, inst)
    return inst
end

local function gfx_cleanup()
    for _, inst in ipairs(GFX.Created) do
        pcall(function() if inst and inst.Parent then inst:Destroy() end end)
    end
    GFX.Created = {}
end

-- ===== FPS BOOST v4 — HIDE ALL VISUAL EFFECTS + REALISTIC COLOR =====
local function gfx_enableFPS()
    if GFX.FPSEnabled then return end
    GFX.FPSEnabled = true

    -- ═══════════════════════════════════════════════════════════
    -- 1. LIGHTING: MATIIN SHADOW (BIAR RINGAN)
    -- ═══════════════════════════════════════════════════════════
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function() Lighting.ShadowSoftness = 0 end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)

    -- ═══════════════════════════════════════════════════════════
    -- 2. HIDE SEMUA EFFECT OBJECTS (PARTICLE, BEAM, TRAIL, DLL)
    -- ═══════════════════════════════════════════════════════════
    local hidden = {}

    local function hideEffect(obj)
        if not obj or not obj.Parent then return end
        pcall(function()
            -- Simpan original state
            table.insert(GFX.HiddenParts, {
                obj = obj,
                enabled = obj.Enabled,
                transparency = obj.Transparency,
                visible = obj.Visible,
            })
        end)
        pcall(function() obj.Enabled = false end)
        pcall(function() obj.Transparency = 1 end)
        pcall(function() obj.Visible = false end)
        pcall(function() obj.Rate = 0 end)
        pcall(function() obj.Brightness = 0 end)
        pcall(function() obj.LightEmission = 0 end)
    end

    -- ═══ SCAN SEMUA EFFECT DI WORKSPACE ═══
    task.spawn(function()
        local function scanEffects()
            for _, obj in ipairs(Workspace:GetDescendants()) do
                -- Particle emitter
                if obj:IsA("ParticleEmitter") then
                    hideEffect(obj)
                -- Beam
                elseif obj:IsA("Beam") then
                    hideEffect(obj)
                -- Trail
                elseif obj:IsA("Trail") then
                    hideEffect(obj)
                -- Smoke
                elseif obj:IsA("Smoke") then
                    hideEffect(obj)
                -- Fire
                elseif obj:IsA("Fire") then
                    hideEffect(obj)
                -- Sparkles
                elseif obj:IsA("Sparkles") then
                    hideEffect(obj)
                -- Explosion (rare, tapi ada)
                elseif obj:IsA("Explosion") then
                    hideEffect(obj)
                -- Lightning
                elseif obj:IsA("Lightning") then
                    hideEffect(obj)
                -- PointLight
                elseif obj:IsA("PointLight") then
                    hideEffect(obj)
                -- SpotLight
                elseif obj:IsA("SpotLight") then
                    hideEffect(obj)
                -- SurfaceLight
                elseif obj:IsA("SurfaceLight") then
                    hideEffect(obj)
                end
            end
        end

        scanEffects()

        -- ═══ WATCH EFFECT BARU (muncul belakangan) ═══
        local conn = Workspace.DescendantAdded:Connect(function(obj)
            if not GFX.FPSEnabled then return end
            task.wait(0.05) -- delay biar object udah fully init
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail")
                or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")
                or obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
                hideEffect(obj)
            end
        end)
        table.insert(GFX.Connections, conn)

        -- ═══ HIDE PARTICLE/DEBRIS DI LIGHTING JUGA ═══
        for _, obj in ipairs(Lighting:GetDescendants()) do
            if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail") then
                hideEffect(obj)
            end
        end

        notify("✨ Effect hidden: " .. #GFX.HiddenParts, "info")
    end)

    -- ═══════════════════════════════════════════════════════════
    -- 3. HIDE DECALS / TEXTURES BERAT (opsional, biar makin ringan)
    -- ═══════════════════════════════════════════════════════════
    -- (skip, karena lu gak mau sentuh part penting)

    -- ═══════════════════════════════════════════════════════════
    -- 4. REALISTIC COLOR CORRECTION (GANTI ATMOSPHERE KERAS)
    -- ═══════════════════════════════════════════════════════════
    -- Simpan state asli
    gfx_save(Lighting, "Ambient")
    gfx_save(Lighting, "OutdoorAmbient")
    gfx_save(Lighting, "Brightness")
    gfx_save(Lighting, "ExposureCompensation")
    gfx_save(Lighting, "ColorShift_Top")
    gfx_save(Lighting, "ColorShift_Bottom")
    gfx_save(Lighting, "EnvironmentDiffuseScale")
    gfx_save(Lighting, "EnvironmentSpecularScale")
    gfx_save(Lighting, "ClockTime")
    gfx_save(Lighting, "GeographicLatitude")

    pcall(function()
        -- Warna natural, gak overbright, gak terlalu gelap
        Lighting.Ambient = Color3.fromRGB(70, 72, 78)           -- abu-abu natural
        Lighting.OutdoorAmbient = Color3.fromRGB(95, 100, 108)   -- outdoor lebih terang
        Lighting.Brightness = 1.35                              -- natural (bukan 2.5)
        Lighting.ExposureCompensation = 0                       -- netral
        Lighting.EnvironmentDiffuseScale = 0.5
        Lighting.EnvironmentSpecularScale = 0.5
        Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)        -- no weird tint
        Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
        Lighting.ClockTime = 14.5                               -- siang natural
        Lighting.GeographicLatitude = 0
    end)

    -- ═══ COLOR CORRECTION EFFECT (REALISTIS) ═══
    local oldCC = Lighting:FindFirstChild("VRILZ_FPS_CC")
    if oldCC then oldCC:Destroy() end

    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "VRILZ_FPS_CC"
    cc.Brightness = 0          -- netral
    cc.Contrast = 0.06         -- sedikit kontras biar gak flat
    cc.Saturation = 0.05       -- sedikit saturasi biar warna hidup
    cc.TintColor = Color3.fromRGB(255, 255, 255)  -- NO tint
    cc.Parent = Lighting
    gfx_add(cc)

    -- ═══ BLOOM TIPIS (biar gak flat banget) ═══
    local oldBloom = Lighting:FindFirstChild("VRILZ_FPS_Bloom")
    if oldBloom then oldBloom:Destroy() end

    local bloom = Instance.new("BloomEffect")
    bloom.Name = "VRILZ_FPS_Bloom"
    bloom.Intensity = 0.15     -- tipis (bukan 0.5)
    bloom.Size = 16
    bloom.Threshold = 1.2      -- cuma highlight yg glow
    bloom.Parent = Lighting
    gfx_add(bloom)

    -- ═══ HAPUS ATMOSPHERE YANG BERAT (fog, haze) ═══
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("Atmosphere") then
            gfx_save(obj, "Density")
            gfx_save(obj, "Haze")
            pcall(function()
                obj.Density = 0
                obj.Haze = 0
            end)
        end
    end

    -- ═══ HAPUS SUN RAYS / DOF (berat) ═══
    for _, obj in ipairs(Lighting:GetChildren()) do
        if obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then
            gfx_save(obj, "Enabled")
            pcall(function() obj.Enabled = false end)
        end
    end

    -- ═══════════════════════════════════════════════════════════
    -- 5. RE-APPLY LOOP (effect baru kadang muncul lagi)
    -- ═══════════════════════════════════════════════════════════
    if not GFX.LoopThread then
        GFX.LoopThread = task.spawn(function()
            while GFX.FPSEnabled do
                task.wait(3)
                -- Re-apply color
                pcall(function()
                    Lighting.GlobalShadows = false
                    Lighting.Brightness = 1.35
                    Lighting.ExposureCompensation = 0
                end)
                -- Re-hide effect yang muncul lagi
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("ParticleEmitter") or obj:IsA("Beam") or obj:IsA("Trail")
                        or obj:IsA("Smoke") or obj:IsA("Fire") then
                        if obj.Enabled ~= false then
                            pcall(function() obj.Enabled = false end)
                        end
                    end
                end
            end
        end)
    end

    notify("FPS Boost enabled ✅", "success")
end

local function gfx_disableFPS()
    if not GFX.FPSEnabled then return end
    GFX.FPSEnabled = false
    GFX.LoopThread = nil

    -- ═══ RESTORE LIGHTING ═══
    pcall(function() Lighting.GlobalShadows = true end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level10 end)

    -- ═══ RESTORE SEMUA EFFECT YANG DISEMBUNYIKAN ═══
    for _, item in ipairs(GFX.HiddenParts) do
        if item.obj and item.obj.Parent then
            pcall(function()
                if item.enabled ~= nil then item.obj.Enabled = item.enabled end
                if item.transparency ~= nil and item.obj:IsA("BasePart") then
                    item.obj.Transparency = item.transparency
                end
                if item.visible ~= nil then item.obj.Visible = item.visible end
            end)
        end
    end
    GFX.HiddenParts = {}

    -- ═══ DISCONNECT WATCHER ═══
    for _, conn in ipairs(GFX.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    GFX.Connections = {}

    -- ═══ RESTORE LIGHTING STATE ═══
    gfx_restore()

    -- ═══ HAPUS EFFECT TAMBAHAN ═══
    for _, name in ipairs({"VRILZ_FPS_CC", "VRILZ_FPS_Bloom"}) do
        local old = Lighting:FindFirstChild(name)
        if old then old:Destroy() end
    end

    notify("FPS Boost disabled", "info")
end

-- ===== 4K HD MODE =====
local function gfx_enableHD()
    if GFX.HDEnabled then return end
    GFX.HDEnabled = true

    -- Auto-disable FPS Boost
    if GFX.FPSEnabled then
        gfx_disableFPS()
        notify("⚠️ FPS Boost dimatiin (bentrok sama 4K HD)", "warning")
    end

    -- Render
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level10 end)
    pcall(function() settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04 end)
    pcall(function() settings().Rendering.AntiAliasing = Enum.AntiAliasingMode.MSAA_4x end)
    pcall(function() settings().Rendering.EagerBulkExecution = false end)
    pcall(function() workspace.StreamingTargetRadius = 1024 end)
    pcall(function() workspace.StreamingMinRadius = 256 end)

    -- Lighting
    gfx_save(Lighting, "GlobalShadows")
    gfx_save(Lighting, "EnvironmentDiffuseScale")
    gfx_save(Lighting, "EnvironmentSpecularScale")
    gfx_save(Lighting, "Ambient")
    gfx_save(Lighting, "OutdoorAmbient")
    gfx_save(Lighting, "Brightness")
    gfx_save(Lighting, "ClockTime")
    gfx_save(Lighting, "ExposureCompensation")
    gfx_save(Lighting, "FogEnd")
    gfx_save(Lighting, "FogStart")
    gfx_save(Lighting, "ShadowSoftness")
    pcall(function()
    Lighting.GlobalShadows = true
    Lighting.ShadowSoftness = 0.35
    Lighting.EnvironmentDiffuseScale = 0.6
    Lighting.EnvironmentSpecularScale = 0.6
    Lighting.Brightness = 1.4          -- natural, bukan 2.5
    Lighting.ExposureCompensation = 0  -- netral, gak overbright
    Lighting.ClockTime = 14.5
    Lighting.GeographicLatitude = 0
    Lighting.Ambient = Color3.fromRGB(70, 72, 82)
    Lighting.OutdoorAmbient = Color3.fromRGB(95, 100, 110)
    Lighting.FogEnd = 100000
    Lighting.FogStart = 0
end)
    pcall(function()
        gfx_save(Lighting, "Technology")
        Lighting.Technology = Enum.Technology.Future
    end)

    -- Post FX
    for _, name in ipairs({"VRILZ_HD_Bloom","VRILZ_HD_SunRays","VRILZ_HD_DOF",
                            "VRILZ_HD_ColorCorrection","VRILZ_HD_Atmosphere","VRILZ_HD_Sky"}) do
        local old = Lighting:FindFirstChild(name)
        if old then old:Destroy() end
    end

    local bloom = Instance.new("BloomEffect")
bloom.Name = "VRILZ_HD_Bloom"
bloom.Intensity = 0.5          -- dari 1.4 → 0.5 (halus)
bloom.Size = 20
bloom.Threshold = 1.1          -- cuma highlight yg glow, bukan semua
bloom.Parent = Lighting
gfx_add(bloom)

local sunRays = Instance.new("SunRaysEffect")
sunRays.Name = "VRILZ_HD_SunRays"
sunRays.Intensity = 0.08       -- dari 0.18 → 0.08 (tipis)
sunRays.Spread = 0.6
sunRays.Parent = Lighting
gfx_add(sunRays)

local dof = Instance.new("DepthOfFieldEffect")
dof.Name = "VRILZ_HD_DOF"
dof.FarIntensity = 0.12
dof.FocusDistance = 45
dof.InFocusRadius = 32
dof.NearIntensity = 0.04
dof.Parent = Lighting
gfx_add(dof)

local cc = Instance.new("ColorCorrectionEffect")
cc.Name = "VRILZ_HD_ColorCorrection"
cc.Brightness = 0              -- dari 0.03 → 0
cc.Contrast = 0.08             -- dari 0.18 → 0.08 (gak terlalu kontras)
cc.Saturation = 0.06           -- dari 0.15 → 0.06 (natural)
cc.TintColor = Color3.fromRGB(255, 255, 255)  -- netral, gak ada tint
cc.Parent = Lighting
gfx_add(cc)

local atmo = Instance.new("Atmosphere")
atmo.Name = "VRILZ_HD_Atmosphere"
atmo.Density = 0.12            -- dari 0.32 → 0.12 (tipis)
atmo.Offset = 0.1
atmo.Color = Color3.fromRGB(200, 202, 208)
atmo.Decay = Color3.fromRGB(108, 115, 128)
atmo.Glare = 0.05              -- dari 0.18 → 0.05 (gak silau)
atmo.Haze = 0.3                -- dari 1.3 → 0.3 (penting!)
atmo.Parent = Lighting
gfx_add(atmo)
    
    if not Lighting:FindFirstChildOfClass("Sky") then
        local sky = Instance.new("Sky")
        sky.Name = "VRILZ_HD_Sky"
        sky.SkyboxBk = "rbxassetid://159454299"
        sky.SkyboxDn = "rbxassetid://159454296"
        sky.SkyboxFt = "rbxassetid://159454293"
        sky.SkyboxLf = "rbxassetid://159454286"
        sky.SkyboxRt = "rbxassetid://159454300"
        sky.SkyboxUp = "rbxassetid://159454288"
        sky.SunAngularSize = 22
        sky.MoonAngularSize = 12
        sky.StarCount = 3500
        sky.Parent = Lighting
        gfx_add(sky)
    end

    -- Terrain
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            gfx_save(terrain, "WaterWaveSize")
            gfx_save(terrain, "WaterWaveSpeed")
            gfx_save(terrain, "WaterReflectance")
            gfx_save(terrain, "WaterTransparency")
            terrain.WaterWaveSize = 0.18
            terrain.WaterWaveSpeed = 12
            terrain.WaterReflectance = 0.18
            terrain.WaterTransparency = 0.08
        end
    end)

    -- Materials
    pcall(function()
        local ms = game:GetService("MaterialService")
        if ms then
            gfx_save(ms, "Use2022Materials")
            ms.Use2022Materials = true
        end
    end)

    -- Texture sharpen
    task.spawn(function()
        local count = 0
        for _, obj in ipairs(workspace:GetDescendants()) do
            if count >= 800 then break end
            if obj:IsA("Texture") then
                pcall(function()
                    table.insert(GFX.TextureBackup, {obj = obj, u = obj.StudsPerTileU, v = obj.StudsPerTileV})
                    obj.StudsPerTileU = obj.StudsPerTileU * 0.6
                    obj.StudsPerTileV = obj.StudsPerTileV * 0.6
                end)
                count = count + 1
            elseif obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
                count = count + 1
            end
        end
    end)

    -- Continuous re-apply
    if not GFX.LoopThread then
GFX.LoopThread = task.spawn(function()
    while GFX.HDEnabled do
        task.wait(2)
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level10 end)
        pcall(function()
            Lighting.GlobalShadows = true
            Lighting.EnvironmentDiffuseScale = 0.6
            Lighting.EnvironmentSpecularScale = 0.6
            Lighting.Brightness = 1.4
            Lighting.ExposureCompensation = 0
        end)
        pcall(function() workspace.StreamingTargetRadius = 1024 end)
    end
end)
    end

    notify("🎮 4K HD Mode: ON", "success")
end

local function gfx_disableHD()
    if not GFX.HDEnabled then return end
    GFX.HDEnabled = false
    GFX.LoopThread = nil

    gfx_cleanup()

    for _, item in ipairs(GFX.TextureBackup) do
        pcall(function()
            if item.obj and item.obj.Parent then
                item.obj.StudsPerTileU = item.u
                item.obj.StudsPerTileV = item.v
            end
        end)
    end
    GFX.TextureBackup = {}

    gfx_restore()

    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level06 end)

    notify("🎮 4K HD Mode: OFF", "info")
end

-- ============================================================
-- BUILD EVENT TAB (HALLOWEEN) — PAKE DROPDOWN MULTI
-- ============================================================
-- ============================================================
-- BUILD EVENT TAB (HALLOWEEN) — RARITY-BASED
-- ============================================================
local function buildEventTab(eventLeft, eventRight, makeCard, makeToggle, makeDropdownMulti, notify)
    local C_local = C

    -- Scan candy types from workspace
    local function scanCandyTypes()
        local set = {}
        local f = game:GetService("Workspace"):FindFirstChild("HalloweenCandy")
        if f then
            for _, c in ipairs(f:GetChildren()) do
                if c:IsA("BasePart") then set[c.Name] = true end
            end
        end
        pcall(function()
            for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if obj:IsA("BasePart") then
                    local n = obj.Name
                    if n:match("^Candy_%d+$") or n:lower():find("candy") then
                        set[n] = true
                    end
                end
            end
        end)
        if next(set) == nil then
            set["Candy_01"] = true
            set["Candy_02"] = true
            set["Candy_03"] = true
            set["Candy_04"] = true
        end
        local list = {}
        for name, _ in pairs(set) do table.insert(list, name) end
        table.sort(list)
        return list
    end

    local candyTypes = scanCandyTypes()

    -- ═══════════════════════════════════════════
    -- ═══ KOLOM KIRI ═══
    -- ═══════════════════════════════════════════
    local eventCard, eventContent = makeCard(eventLeft, "🎃 AUTO HALLOWEEN", 1)

    makeToggle(eventContent, "Auto Claim Candy", false, function(v)
        local F = getFeatures()
        if F and F.getHalloweenState then F.getHalloweenState().Enabled = v end
        if v then notify("Halloween Auto: ON", "success")
        else notify("Halloween Auto: OFF", "info") end
    end)

    makeToggle(eventContent, "Auto Yin Ritual", false, function(v)
        Shared.YinRitual_Enabled = v
        local F = getFeatures()
        if F and F.setYinRitualEnabled then F.setYinRitualEnabled(v) end
        if v then notify("🔮 Yin Ritual: ON", "success")
        else notify("🔮 Yin Ritual: OFF", "info") end
    end)

    makeToggle(eventContent, "Auto Obby (Talk + Finish)", false, function(v)
        if v then
            notify("🏃 Auto Obby: ON - Starting...", "success")
            task.spawn(function()
                local F = getFeatures()
                if F and F.startAutoObby then
                    F.startAutoObby()
                end
            end)
        else
            notify("🏃 Auto Obby: OFF", "info")
        end
    end)

    local eventNote = Instance.new("TextLabel")
    eventNote.Size = UDim2.new(1, 0, 0, 32)
    eventNote.BackgroundTransparency = 1
    eventNote.Text = "Flow: collect all highest-rarity candy first\n(Legendary → Epic → Rare → Common)"
    eventNote.TextColor3 = C_local.Muted
    eventNote.Font = Enum.Font.GothamSemibold
    eventNote.TextSize = CFG.FONT_MUTED
    eventNote.TextWrapped = true
    eventNote.TextXAlignment = Enum.TextXAlignment.Left
    eventNote.TextYAlignment = Enum.TextYAlignment.Top
    eventNote.LayoutOrder = 10
    eventNote.ZIndex = 3
    eventNote.Parent = eventContent
    registerTheme(eventNote, "Muted", "TextColor3")

    -- ═══════════════════════════════════════════
    -- ═══ KOLOM KANAN ═══
    -- ═══════════════════════════════════════════
    local eventCandyCard, eventCandyContent = makeCard(eventRight, "🍬 CANDY SELECT", 1)

    -- TP Method section
    local tpMethodLbl = Instance.new("TextLabel")
    tpMethodLbl.Size = UDim2.new(1, 0, 0, 16)
    tpMethodLbl.BackgroundTransparency = 1
    tpMethodLbl.Text = "TP Method:"
    tpMethodLbl.TextColor3 = C_local.Muted
    tpMethodLbl.Font = Enum.Font.GothamBold
    tpMethodLbl.TextSize = CFG.FONT_MUTED
    tpMethodLbl.TextXAlignment = Enum.TextXAlignment.Left
    tpMethodLbl.LayoutOrder = 11
    tpMethodLbl.ZIndex = 3
    tpMethodLbl.Parent = eventCandyContent
    registerTheme(tpMethodLbl, "Muted", "TextColor3")

    local isPrem = false
    if LocalPlayer.UserId == OWNER_USERID then
        isPrem = true
    elseif Shared and Shared.KeyType then
        local kt = tostring(Shared.KeyType):upper()
        if kt == "PREMIUM" or kt == "OWNER" or kt == "VIP" then
            isPrem = true
        end
    end

    if isPrem then
        local tpMethodHolder = Instance.new("Frame")
        tpMethodHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
        tpMethodHolder.BackgroundTransparency = 1
        tpMethodHolder.LayoutOrder = 12
        tpMethodHolder.ZIndex = 3
        tpMethodHolder.Parent = eventCandyContent

        local tpMethodList = {"TP GLIDE", "TP FAST", "TP VOID ⚡"}

        local currentMethod = "TP GLIDE"
        if Shared and Shared.TP_Method == "TP180" then
            currentMethod = "TP FAST"
        elseif Shared and Shared.TP_Method == "VOID" then
            currentMethod = "TP VOID ⚡"
        end

        makeDropdownGlobal(tpMethodHolder, tpMethodList, currentMethod, function(v)
            local F = getFeatures()
            if v:find("TP VOID") then
                if F and F.getHalloweenState then
                    F.getHalloweenState().TPMethod = "VOID"
                end
                Shared.TP_Method = "VOID"
                notify("⚡ TP Method: TP VOID (Instant)", "success")
            elseif v:find("TP FAST") then
                if F and F.getHalloweenState then
                    F.getHalloweenState().TPMethod = "TP180"
                end
                Shared.TP_Method = "TP180"
                notify("TP Method: TP FAST", "success")
            else
                if F and F.getHalloweenState then
                    F.getHalloweenState().TPMethod = "TP100"
                end
                Shared.TP_Method = "TP100"
                notify("TP Method: TP GLIDE", "info")
            end
        end)
    else
        local lockedFrame = Instance.new("Frame")
        lockedFrame.Size = UDim2.new(1, 0, 0, 60)
        lockedFrame.BackgroundColor3 = C_local.Surface3
        lockedFrame.BackgroundTransparency = 0.5
        lockedFrame.BorderSizePixel = 0
        lockedFrame.LayoutOrder = 12
        lockedFrame.ZIndex = 3
        lockedFrame.Parent = eventCandyContent
        registerTheme(lockedFrame, "Surface3", "BackgroundColor3")

        local lockedCorner = Instance.new("UICorner")
        lockedCorner.CornerRadius = UDim.new(0, 8)
        lockedCorner.Parent = lockedFrame

        local lockedStroke = Instance.new("UIStroke")
        lockedStroke.Color = C_local.Muted
        lockedStroke.Thickness = 1
        lockedStroke.Transparency = 0.6
        lockedStroke.Parent = lockedFrame

        local lockIcon = Instance.new("TextLabel")
        lockIcon.Size = UDim2.fromOffset(28, 28)
        lockIcon.Position = UDim2.fromOffset(10, 16)
        lockIcon.BackgroundTransparency = 1
        lockIcon.Text = "🔒"
        lockIcon.TextColor3 = C_local.Muted
        lockIcon.Font = Enum.Font.GothamBold
        lockIcon.TextSize = 18
        lockIcon.ZIndex = 4
        lockIcon.Parent = lockedFrame
        registerTheme(lockIcon, "Muted", "TextColor3")

        local lockTitle = Instance.new("TextLabel")
        lockTitle.Size = UDim2.new(1, -50, 0, 18)
        lockTitle.Position = UDim2.fromOffset(42, 14)
        lockTitle.BackgroundTransparency = 1
        lockTitle.Text = "TP FAST LOCKED"
        lockTitle.TextColor3 = C_local.Muted
        lockTitle.Font = Enum.Font.GothamBold
        lockTitle.TextSize = CFG.FONT_LABEL
        lockTitle.TextXAlignment = Enum.TextXAlignment.Left
        lockTitle.ZIndex = 4
        lockTitle.Parent = lockedFrame
        registerTheme(lockTitle, "Muted", "TextColor3")

        local lockDesc = Instance.new("TextLabel")
        lockDesc.Size = UDim2.new(1, -50, 0, 16)
        lockDesc.Position = UDim2.fromOffset(42, 32)
        lockDesc.BackgroundTransparency = 1
        lockDesc.Text = "Premium only"
        lockDesc.TextColor3 = C_local.Muted
        lockDesc.Font = Enum.Font.GothamSemibold
        lockDesc.TextSize = CFG.FONT_MUTED
        lockDesc.TextWrapped = false
        lockDesc.TextXAlignment = Enum.TextXAlignment.Left
        lockDesc.TextYAlignment = Enum.TextYAlignment.Top
        lockDesc.ZIndex = 4
        lockDesc.Parent = lockedFrame
        registerTheme(lockDesc, "Muted", "TextColor3")
    end

    -- Candy select label
    local eventCandyLbl = Instance.new("TextLabel")
    eventCandyLbl.Size = UDim2.new(1, 0, 0, 16)
    eventCandyLbl.BackgroundTransparency = 1
    eventCandyLbl.Text = "Pick candy to collect:"
    eventCandyLbl.TextColor3 = C_local.Muted
    eventCandyLbl.Font = Enum.Font.GothamSemibold
    eventCandyLbl.TextSize = CFG.FONT_MUTED
    eventCandyLbl.TextXAlignment = Enum.TextXAlignment.Left
    eventCandyLbl.ZIndex = 3
    eventCandyLbl.Parent = eventCandyContent
    registerTheme(eventCandyLbl, "Muted", "TextColor3")

    local candyTable = {}
    local F_init = getFeatures()
    local st = nil
    if F_init and F_init.getHalloweenState then
        st = F_init.getHalloweenState()
        for _, name in ipairs(candyTypes) do
            if st.CandyTypes[name] == nil then st.CandyTypes[name] = true end
            candyTable[name] = st.CandyTypes[name]
        end
    else
        for _, name in ipairs(candyTypes) do candyTable[name] = true end
    end

    if #candyTypes == 0 then
        candyTypes = {"Candy_01", "Candy_02", "Candy_03", "Candy_04"}
        for _, name in ipairs(candyTypes) do candyTable[name] = true end
    end

    local candyDropHolder = Instance.new("Frame")
    candyDropHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
    candyDropHolder.BackgroundTransparency = 1
    candyDropHolder.ZIndex = 3
    candyDropHolder.Parent = eventCandyContent

    makeDropdownMulti(candyDropHolder, candyTypes, candyTable, nil, function(t)
        local F = getFeatures()
        if F and F.getHalloweenState then
            local s = F.getHalloweenState()
            for name, on in pairs(t) do s.CandyTypes[name] = on end
        end
    end)

    -- ═══ STATUS CARD (kanan bawah) ═══
    local eventStatusCard, eventStatusContent = makeCard(eventRight, "📊 STATUS", 2)
    local eventStatusLbl = Instance.new("TextLabel")
    eventStatusLbl.Size = UDim2.new(1, 0, 0, 110)
    eventStatusLbl.BackgroundColor3 = C_local.Surface3
    eventStatusLbl.BackgroundTransparency = 0.3
    eventStatusLbl.BorderSizePixel = 0
    eventStatusLbl.Text = "Idle"
    eventStatusLbl.TextColor3 = C_local.Text
    eventStatusLbl.Font = Enum.Font.Code
    eventStatusLbl.TextSize = CFG.FONT_MUTED
    eventStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
    eventStatusLbl.TextYAlignment = Enum.TextYAlignment.Top
    eventStatusLbl.ZIndex = 3
    eventStatusLbl.Parent = eventStatusContent
    registerTheme(eventStatusLbl, "Text", "TextColor3")

    local esCorner = Instance.new("UICorner")
    esCorner.CornerRadius = UDim.new(0, 6)
    esCorner.Parent = eventStatusLbl

    local esPad = Instance.new("UIPadding")
    esPad.PaddingLeft = UDim.new(0, 8)
    esPad.PaddingTop = UDim.new(0, 6)
    esPad.Parent = eventStatusLbl

    task.spawn(function()
        while eventStatusLbl.Parent do
            task.wait(0.5)
            local F = getFeatures()
            local lines = {}

            if F and F.getHalloweenState then
                local s = F.getHalloweenState()
                table.insert(lines, "🎃 " .. (s.Status or "Idle"))
                table.insert(lines, string.format("   Claimed:%d Rare:%d",
                    s.Claimed or 0, s.RareClaimed or 0))
            end

            if F and F.getYinRitualState then
                local y = F.getYinRitualState()
                table.insert(lines, "🔮 " .. (y.Status or "Idle"))
                table.insert(lines, string.format("   Yin:%d Yang:%d Ritual:%d Reward:%d",
                    y.YinCount or 0, y.YangCount or 0, y.RitualCount or 0, y.RewardCount or 0))
            end

            eventStatusLbl.Text = table.concat(lines, "\n")
        end
    end)
end

-- ============================================================
-- BUILD INFINITY JUMP SECTION (dipisah biar gak exceed register limit)
-- ============================================================
local function buildInfinityJumpSection(speedContent, makeToggle, C, CFG, notify, registerTheme)
    -- Divider
    local infDivider = Instance.new("Frame")
    infDivider.Size = UDim2.new(1, 0, 0, 1)
    infDivider.BackgroundColor3 = C.Surface3
    infDivider.BorderSizePixel = 0
    infDivider.LayoutOrder = 4
    infDivider.ZIndex = 3
    infDivider.Parent = speedContent
    registerTheme(infDivider, "Surface3", "BackgroundColor3")

    -- Toggle Enable Infinity Jump
    makeToggle(speedContent, "Enable Infinity Jump", false, function(v)
        Shared.InfinityJump_Enabled = v
        local F = getFeatures()
        if F and F.setInfinityJumpEnabled then
            F.setInfinityJumpEnabled(v)
        end
        if v then
            notify("♾️ Infinity Jump: ON", "success")
        else
            notify("♾️ Infinity Jump: OFF", "info")
        end
    end)

    -- Label Height
    local infHeightLbl = Instance.new("TextLabel")
    infHeightLbl.Size = UDim2.new(1, 0, 0, 16)
    infHeightLbl.BackgroundTransparency = 1
    infHeightLbl.Text = "Jump Height: " .. (Shared.InfinityJump_Height or 50) .. " studs (max 50)"
    infHeightLbl.TextColor3 = C.Muted
    infHeightLbl.Font = Enum.Font.GothamSemibold
    infHeightLbl.TextSize = CFG.FONT_MUTED
    infHeightLbl.TextXAlignment = Enum.TextXAlignment.Left
    infHeightLbl.LayoutOrder = 5
    infHeightLbl.ZIndex = 3
    infHeightLbl.Parent = speedContent
    registerTheme(infHeightLbl, "Muted", "TextColor3")

    -- Slider BG
    local infSliderBg = Instance.new("Frame")
    infSliderBg.Size = UDim2.new(1, 0, 0, 8)
    infSliderBg.BackgroundColor3 = C.Surface3
    infSliderBg.BorderSizePixel = 0
    infSliderBg.LayoutOrder = 6
    infSliderBg.ZIndex = 3
    infSliderBg.Parent = speedContent
    registerTheme(infSliderBg, "Surface3", "BackgroundColor3")

    local infSliderBgCorner = Instance.new("UICorner")
    infSliderBgCorner.CornerRadius = UDim.new(1, 0)
    infSliderBgCorner.Parent = infSliderBg

    -- Slider Fill
    local infSliderFill = Instance.new("Frame")
    local initPct = ((Shared.InfinityJump_Height or 50) - 10) / (50 - 10)
    infSliderFill.Size = UDim2.new(math.clamp(initPct, 0, 1), 0, 1, 0)
    infSliderFill.BackgroundColor3 = C.Accent
    infSliderFill.BorderSizePixel = 0
    infSliderFill.ZIndex = 4
    infSliderFill.Parent = infSliderBg
    registerTheme(infSliderFill, "Accent", "BackgroundColor3")

    local infSliderFillCorner = Instance.new("UICorner")
    infSliderFillCorner.CornerRadius = UDim.new(1, 0)
    infSliderFillCorner.Parent = infSliderFill

    -- Slider click area
    local infSliderBtn = Instance.new("TextButton")
    infSliderBtn.Size = UDim2.new(1, 0, 1, 20)
    infSliderBtn.Position = UDim2.new(0, 0, 0.5, -10)
    infSliderBtn.BackgroundTransparency = 1
    infSliderBtn.Text = ""
    infSliderBtn.ZIndex = 5
    infSliderBtn.Parent = infSliderBg

    local draggingInf = false
    infSliderBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            draggingInf = true
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            draggingInf = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if draggingInf and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = UserInputService:GetMouseLocation().X
            local rel = math.clamp((mouseX - infSliderBg.AbsolutePosition.X) / infSliderBg.AbsoluteSize.X, 0, 1)
            local h = math.floor(10 + (50 - 10) * rel)
            Shared.InfinityJump_Height = h
            infSliderFill.Size = UDim2.new(rel, 0, 1, 0)
            infHeightLbl.Text = "Jump Height: " .. h .. " studs (max 50)"
            local F = getFeatures()
            if F and F.setInfinityJumpHeight then
                F.setInfinityJumpHeight(h)
            end
        end
    end)
end

-- ============================================================
-- EGG EXECUTOR GUI — FUNCTION TERPISAH
-- Dipanggil dari buildMainWindow biar gak exceed local register
-- ============================================================
local function buildEggExecutorGUI(screenGui)
    local EGG_X, EGG_Y = 1348, 256
    local MINI_W, MINI_H = 72, 72
    local MINI_X, MINI_Y = EGG_X, EGG_Y - MINI_H - 6
    local WIN_W, WIN_H = 580, 520
    local WIN_X, WIN_Y = 0.5, 0.5

    -- ═══ COLORS (Premium Dark Theme) ═══
    local COLOR_BG_MAIN    = Color3.fromRGB(8, 10, 18)
    local COLOR_SURFACE    = Color3.fromRGB(16, 18, 30)
    local COLOR_GLASS      = Color3.fromRGB(25, 28, 45)
    local COLOR_CYAN       = Color3.fromRGB(0, 240, 255)
    local COLOR_PURPLE     = Color3.fromRGB(180, 80, 255)
    local COLOR_GOLD       = Color3.fromRGB(255, 200, 50)
    local COLOR_TEXT       = Color3.fromRGB(255, 255, 255)
    local COLOR_TEXT_DIM   = Color3.fromRGB(140, 145, 170)

    local EggState = { WindowVisible = false, ActiveTab = "stats" }
    local EggCache = {}

    -- ═══ STATS TRACKER ═══
    local StealStats = { TotalSteals = 0, SessionStart = os.time(), StolenEggs = {} }

    local function recordSteal(eggName, rarity, weight)
        StealStats.TotalSteals = StealStats.TotalSteals + 1
        table.insert(StealStats.StolenEggs, { name = eggName or "?", rarity = rarity or "?", weight = weight or "?", time = os.time() })
        if #StealStats.StolenEggs > 50 then table.remove(StealStats.StolenEggs, 1) end
    end
    _G.VRILZ_EggExecutorRecordSteal = recordSteal

    -- Auto detect
    task.spawn(function()
        local lastHolding = nil
        while task.wait(0.5) do
            local holding, eggName = pcall(function()
                local char = LocalPlayer.Character
                if not char then return false, nil end
                local wooden = char:FindFirstChild("Wooden")
                if not wooden then return false, nil end
                local displayEgg = wooden:FindFirstChild("DisplayEgg")
                if not displayEgg then return false, nil end
                for _, c in ipairs(displayEgg:GetChildren()) do
                    if c:IsA("MeshPart") and not c.Name:lower():find("circle") then return true, c.Name end
                end
                return false, nil
            end)
            if holding and eggName and eggName ~= lastHolding then
                lastHolding = eggName
                local clean = eggName:gsub("_Model$", ""):gsub("_", " ")
                clean = clean:gsub("%s*Egg%s*$", "")
                clean = clean:gsub("^%l", string.upper) .. " Egg"
                local already = false
                for i = #StealStats.StolenEggs, math.max(1, #StealStats.StolenEggs - 3), -1 do
                    if StealStats.StolenEggs[i].name == clean and (os.time() - StealStats.StolenEggs[i].time) < 5 then already = true break end
                end
                if not already then recordSteal(clean, "?", "?") end
            elseif not holding then lastHolding = nil end
        end
    end)

    local function formatTime(s)
        local h = math.floor(s / 3600)
        local m = math.floor((s % 3600) / 60)
        local sec = s % 60
        if h > 0 then return string.format("%02d:%02d:%02d", h, m, sec) end
        return string.format("%02d:%02d", m, sec)
    end

    local old = screenGui:FindFirstChild("VRILZ_EggExecutor_New")
    if old then old:Destroy() end

    local eggScreen = Instance.new("ScreenGui")
    eggScreen.Name = "VRILZ_EggExecutor_New"
    eggScreen.ResetOnSpawn = false
    eggScreen.IgnoreGuiInset = true
    eggScreen.DisplayOrder = 600
    eggScreen.Parent = screenGui

    -- ═══ MINI PANEL ═══
    local mini = Instance.new("TextButton")
    mini.Name = "MiniPanel"
    mini.Position = UDim2.fromOffset(MINI_X, MINI_Y)
    mini.Size = UDim2.fromOffset(MINI_W, MINI_H)
    mini.BackgroundColor3 = COLOR_CYAN
    mini.Text = ""
    mini.BorderSizePixel = 0
    mini.AutoButtonColor = false
    mini.Parent = eggScreen

    local mCorner = Instance.new("UICorner"); mCorner.CornerRadius = UDim.new(0, 14); mCorner.Parent = mini
    local mGrad = Instance.new("UIGradient"); mGrad.Rotation = 90
    mGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLOR_CYAN), ColorSequenceKeypoint.new(1, COLOR_PURPLE)})
    mGrad.Parent = mini
    local mStroke = Instance.new("UIStroke"); mStroke.Color = Color3.new(1,1,1); mStroke.Thickness = 2; mStroke.Transparency = 0.5; mStroke.Parent = mini

    local chartFrame = Instance.new("Frame")
    chartFrame.Size = UDim2.fromOffset(40, 36); chartFrame.Position = UDim2.new(0.5, -20, 0.5, -18)
    chartFrame.BackgroundTransparency = 1; chartFrame.Parent = mini
    for i = 1, 3 do
        local bar = Instance.new("Frame")
        local h = i * 12
        bar.Size = UDim2.fromOffset(8, h); bar.Position = UDim2.fromOffset((i-1)*12, 36 - h)
        bar.BackgroundColor3 = Color3.new(1,1,1); bar.BorderSizePixel = 0; bar.Parent = chartFrame
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 3); bc.Parent = bar
    end

    -- ═══ BIG WINDOW ═══
    local win = Instance.new("Frame")
    win.Name = "BigWindow"
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.Position = UDim2.new(WIN_X, 0, WIN_Y, 150)
    win.Size = UDim2.fromOffset(WIN_W, WIN_H)
    win.BackgroundColor3 = COLOR_BG_MAIN
    win.BorderSizePixel = 0
    win.Visible = false
    win.Active = true
    win.ClipsDescendants = true
    win.Parent = eggScreen

    local wCorner = Instance.new("UICorner"); wCorner.CornerRadius = UDim.new(0, 16); wCorner.Parent = win
    local wStroke = Instance.new("UIStroke"); wStroke.Color = COLOR_CYAN; wStroke.Thickness = 2; wStroke.Transparency = 0.3; wStroke.Parent = win

  -- ═══════════════════════════════════════════════════════════
-- 🌌 PREMIUM GALAXY BACKGROUND v2 (Zodiac + 3D Stars + Nebula)
-- ═══════════════════════════════════════════════════════════
local bgFrame = Instance.new("Frame")
bgFrame.Size = UDim2.fromScale(1, 1)
bgFrame.BackgroundColor3 = Color3.fromRGB(2, 3, 12)
bgFrame.BorderSizePixel = 0
bgFrame.ZIndex = 0
bgFrame.ClipsDescendants = true
bgFrame.Parent = win
local bgCorner = Instance.new("UICorner"); bgCorner.CornerRadius = UDim.new(0, 16); bgCorner.Parent = bgFrame

-- Deep space gradient (lebih kaya warna)
local bgGrad = Instance.new("UIGradient")
bgGrad.Rotation = 135
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(8, 4, 24)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(18, 8, 42)),
    ColorSequenceKeypoint.new(0.55, Color3.fromRGB(4, 12, 32)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(22, 4, 28)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 2, 10)),
})
bgGrad.Parent = bgFrame

-- ═══ NEBULA CLOUDS (lebih banyak, warna premium) ═══
local nebulaColors = {
    Color3.fromRGB(120, 40, 180),  -- ungu
    Color3.fromRGB(30, 120, 200),  -- biru
    Color3.fromRGB(200, 40, 100),  -- pink
    Color3.fromRGB(40, 180, 160),  -- teal
    Color3.fromRGB(180, 100, 40),  -- amber
}
for i = 1, 6 do
    local nebula = Instance.new("Frame")
    local nSize = math.random(60, 140) / 100
    nebula.Size = UDim2.fromScale(nSize, nSize)
    nebula.Position = UDim2.fromScale(math.random(-30, 80)/100, math.random(-30, 80)/100)
    nebula.BackgroundColor3 = nebulaColors[math.random(1, #nebulaColors)]
    nebula.BackgroundTransparency = 0.88
    nebula.BorderSizePixel = 0
    nebula.ZIndex = 1
    nebula.Parent = bgFrame
    local nCorner = Instance.new("UICorner"); nCorner.CornerRadius = UDim.new(1, 0); nCorner.Parent = nebula
    local nGrad = Instance.new("UIGradient"); nGrad.Rotation = math.random(0, 360)
    nGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.5, 0.7),
        NumberSequenceKeypoint.new(1, 1),
    })
    nGrad.Parent = nebula

    -- Nebula drift animation (smooth pulsing)
    task.spawn(function()
        while nebula.Parent do
            task.wait(math.random(8, 15))
            local tgt = math.clamp(nebula.BackgroundTransparency + (math.random() - 0.5) * 0.1, 0.75, 0.95)
            TweenService:Create(nebula, TweenInfo.new(math.random(4, 8), Enum.EasingStyle.Sine), {
                BackgroundTransparency = tgt
            }):Play()
        end
    end)
end

-- ═══ PLANET PREMIUM (dengan ring) ═══
local planet = Instance.new("Frame")
planet.Size = UDim2.fromOffset(200, 200)
planet.Position = UDim2.fromOffset(-50, WIN_H - 110)
planet.BackgroundColor3 = Color3.fromRGB(25, 60, 130)
planet.BorderSizePixel = 0
planet.ZIndex = 2
planet.Parent = bgFrame
local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(1, 0); pCorner.Parent = planet

local pGrad = Instance.new("UIGradient")
pGrad.Rotation = 45
pGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 200, 255)),
    ColorSequenceKeypoint.new(0.4, Color3.fromRGB(50, 110, 200)),
    ColorSequenceKeypoint.new(0.7, Color3.fromRGB(20, 40, 100)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 10, 25)),
})
pGrad.Parent = planet

-- Planet glow
local pGlow = Instance.new("Frame")
pGlow.Size = UDim2.fromScale(1.15, 1.15)
pGlow.Position = UDim2.fromScale(-0.075, -0.075)
pGlow.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
pGlow.BackgroundTransparency = 0.75
pGlow.BorderSizePixel = 0
pGlow.ZIndex = 1
pGlow.Parent = planet
local pGlowCorner = Instance.new("UICorner"); pGlowCorner.CornerRadius = UDim.new(1, 0); pGlowCorner.Parent = pGlow

-- Saturn ring (miring)
local ring = Instance.new("Frame")
ring.AnchorPoint = Vector2.new(0.5, 0.5)
ring.Position = UDim2.fromScale(0.5, 0.5)
ring.Size = UDim2.fromScale(1.7, 0.35)
ring.BackgroundTransparency = 1
ring.BorderSizePixel = 0
ring.Rotation = -20
ring.ZIndex = 3
ring.Parent = planet
local ringC = Instance.new("UICorner"); ringC.CornerRadius = UDim.new(1, 0); ringC.Parent = ring
local ringStroke = Instance.new("UIStroke")
ringStroke.Color = Color3.fromRGB(180, 220, 255)
ringStroke.Thickness = 2.5
ringStroke.Transparency = 0.4
ringStroke.Parent = ring

-- ═══ STARFIELD — BINTANG PREMIUM (BESAR + 3D + KELAP-KELIP) ═══
local starLayer = Instance.new("Frame")
starLayer.Name = "PremiumStarfield"
starLayer.Size = UDim2.fromScale(1, 1)
starLayer.BackgroundTransparency = 1
starLayer.ZIndex = 3
starLayer.ClipsDescendants = true
starLayer.Parent = bgFrame

local starColors = {
    Color3.fromRGB(255, 255, 255),   -- putih
    Color3.fromRGB(180, 220, 255),   -- biru muda
    Color3.fromRGB(255, 220, 180),   -- kuning lembut
    Color3.fromRGB(200, 180, 255),   -- ungu
    Color3.fromRGB(255, 180, 220),   -- pink lembut
    Color3.fromRGB(160, 255, 220),   -- mint
}
local goldColor = Color3.fromRGB(255, 215, 100)
local stars = {}

for i = 1, 90 do
    -- ⭐ Bintang lebih besar (3-6px) biar keliatan jelas
    local sz = math.random(3, 6)
    local star = Instance.new("Frame")
    star.Name = "Star_" .. i
    star.AnchorPoint = Vector2.new(0.5, 0.5)
    star.Size = UDim2.fromOffset(sz, sz)
    star.Position = UDim2.fromScale(math.random(0, 1000)/1000, math.random(0, 1000)/1000)
    star.BackgroundColor3 = (i % 11 == 0) and goldColor or starColors[math.random(1, #starColors)]
    star.BackgroundTransparency = math.random(10, 55) / 100
    star.BorderSizePixel = 0
    star.ZIndex = 5
    star.Parent = starLayer

    local sCorner = Instance.new("UICorner"); sCorner.CornerRadius = UDim.new(1, 0); sCorner.Parent = star

    -- ⭐ 3D EFFECT: Shadow di bawah bintang (offset +2px)
    local starShadow = Instance.new("Frame")
    starShadow.AnchorPoint = Vector2.new(0.5, 0.5)
    starShadow.Position = UDim2.fromScale(0.5, 0.5)
    starShadow.Size = UDim2.fromOffset(sz + 1, sz + 1)
    starShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    starShadow.BackgroundTransparency = 0.5
    starShadow.BorderSizePixel = 0
    starShadow.ZIndex = 4
    starShadow.Parent = star
    local ssCorner = Instance.new("UICorner"); ssCorner.CornerRadius = UDim.new(1, 0); ssCorner.Parent = starShadow
    starShadow.Position = UDim2.new(0.5, 1.5, 0.5, 1.5)

    -- ⭐ Glow halo (2 layer, beda ukuran) buat 3D feel
    local glow1 = Instance.new("Frame")
    glow1.AnchorPoint = Vector2.new(0.5, 0.5)
    glow1.Position = UDim2.fromScale(0.5, 0.5)
    glow1.Size = UDim2.new(2.5, 0, 2.5, 0)
    glow1.BackgroundColor3 = star.BackgroundColor3
    glow1.BackgroundTransparency = 0.85
    glow1.BorderSizePixel = 0
    glow1.ZIndex = 3
    glow1.Parent = star
    local g1c = Instance.new("UICorner"); g1c.CornerRadius = UDim.new(1, 0); g1c.Parent = glow1

    local glow2 = Instance.new("Frame")
    glow2.AnchorPoint = Vector2.new(0.5, 0.5)
    glow2.Position = UDim2.fromScale(0.5, 0.5)
    glow2.Size = UDim2.new(1.6, 0, 1.6, 0)
    glow2.BackgroundColor3 = star.BackgroundColor3
    glow2.BackgroundTransparency = 0.7
    glow2.BorderSizePixel = 0
    glow2.ZIndex = 4
    glow2.Parent = star
    local g2c = Instance.new("UICorner"); g2c.CornerRadius = UDim.new(1, 0); g2c.Parent = glow2

    table.insert(stars, {
        frame = star, glow1 = glow1, glow2 = glow2, shadow = starShadow,
        baseSize = sz,
        baseTrans = star.BackgroundTransparency,
        baseGlow1 = glow1.BackgroundTransparency,
        baseGlow2 = glow2.BackgroundTransparency,
        speed = math.random(15, 50) / 100,
        offset = math.random() * math.pi * 2,
        pulseScale = math.random(15, 40) / 100,
    })
end

-- ⭐ Super smooth twinkle + 3D scale pulse loop
task.spawn(function()
    while win.Parent do
        task.wait(0.03)
        if not win.Visible then continue end
        local t = tick()
        for _, s in ipairs(stars) do
            if s.frame.Parent then
                -- Twinkle (transparency)
                local twinkle = math.sin(t * s.speed + s.offset)
                s.frame.BackgroundTransparency = math.clamp(s.baseTrans + twinkle * 0.4, 0, 1)
                s.glow1.BackgroundTransparency = math.clamp(s.baseGlow1 + twinkle * 0.08, 0, 1)
                s.glow2.BackgroundTransparency = math.clamp(s.baseGlow2 + twinkle * 0.12, 0, 1)

                -- ⭐ 3D scale pulse (bintang membesar-mengecil halus)
                local scale = 1 + twinkle * s.pulseScale * 0.3
                local newSize = s.baseSize * scale
                s.frame.Size = UDim2.fromOffset(newSize, newSize)

                -- ⭐ Shadow ikut geser dikit (efek 3D depth)
                s.shadow.Position = UDim2.new(0.5, 1.5 + twinkle * 1.2, 0.5, 1.5 + twinkle * 1.2)
            end
        end
    end
end)

-- ═══════════════════════════════════════════════════════════
-- ♈ ZODIAC CONSTELLATIONS (12 rasi bintang berputar)
-- ═══════════════════════════════════════════════════════════
local zodiacLayer = Instance.new("Frame")
zodiacLayer.Name = "ZodiacLayer"
zodiacLayer.Size = UDim2.fromScale(1, 1)
zodiacLayer.BackgroundTransparency = 1
zodiacLayer.ClipsDescendants = true
zodiacLayer.ZIndex = 6
zodiacLayer.Parent = bgFrame

-- Rasi bintang zodiak (koordinat relatif 0-1 dalam kotak kecil)
-- Setiap rasi = array titik {x, y} yang dihubungkan garis
local zodiacData = {
    -- ♈ Aries (2 bintang + ekor)
    { name = "Aries", points = {{0.2,0.4},{0.5,0.3},{0.8,0.5},{0.85,0.7}} },
    -- ♉ Taurus (V shape + tanduk)
    { name = "Taurus", points = {{0.15,0.3},{0.35,0.5},{0.5,0.6},{0.65,0.5},{0.85,0.3}} },
    -- ♊ Gemini (2 garis sejajar)
    { name = "Gemini", points = {{0.25,0.2},{0.25,0.8},{0.75,0.2},{0.75,0.8}} },
    -- ♋ Cancer (Y shape)
    { name = "Cancer", points = {{0.5,0.2},{0.5,0.5},{0.2,0.8},{0.8,0.8},{0.5,0.5}} },
    -- ♌ Leo (sickle)
    { name = "Leo", points = {{0.2,0.7},{0.3,0.4},{0.5,0.25},{0.7,0.3},{0.75,0.5},{0.6,0.7},{0.4,0.75}} },
    -- ♍ Virgo (W shape)
    { name = "Virgo", points = {{0.15,0.4},{0.35,0.7},{0.5,0.3},{0.65,0.7},{0.85,0.4}} },
    -- ♎ Libra (balance)
    { name = "Libra", points = {{0.2,0.3},{0.5,0.5},{0.8,0.3},{0.5,0.5},{0.5,0.8}} },
    -- ♏ Scorpio (S curve)
    { name = "Scorpio", points = {{0.15,0.3},{0.35,0.5},{0.55,0.6},{0.7,0.5},{0.85,0.7},{0.9,0.85}} },
    -- ♐ Sagittarius (arrow)
    { name = "Sagittarius", points = {{0.2,0.8},{0.4,0.6},{0.5,0.4},{0.7,0.3},{0.85,0.2},{0.65,0.45}} },
    -- ♑ Capricorn (triangle)
    { name = "Capricorn", points = {{0.3,0.2},{0.7,0.25},{0.6,0.7},{0.3,0.2},{0.4,0.75}} },
    -- ♒ Aquarius (waves)
    { name = "Aquarius", points = {{0.15,0.5},{0.3,0.35},{0.45,0.5},{0.6,0.35},{0.75,0.5},{0.9,0.35}} },
    -- ♓ Pisces (V with cross)
    { name = "Pisces", points = {{0.2,0.2},{0.4,0.6},{0.5,0.8},{0.6,0.6},{0.8,0.2},{0.5,0.4}} },
}

-- Helper: gambar garis antara 2 titik (relatif dalam frame)
local function drawZodiacLine(parentFrame, p1, p2, color, thickness, zIdx)
    local dx = (p2[1] - p1[1]) * parentFrame.AbsoluteSize.X
    local dy = (p2[2] - p1[2]) * parentFrame.AbsoluteSize.Y
    local length = math.sqrt(dx*dx + dy*dy)
    local angle = math.deg(math.atan2(dy, dx))
    
    local line = Instance.new("Frame")
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    line.Position = UDim2.fromScale((p1[1]+p2[1])/2, (p1[2]+p2[2])/2)
    line.Size = UDim2.fromOffset(length, thickness)
    line.Rotation = angle
    line.BackgroundColor3 = color
    line.BackgroundTransparency = 0.55
    line.BorderSizePixel = 0
    line.ZIndex = zIdx
    line.Parent = parentFrame
    
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(1, 0); c.Parent = line
    return line
end

-- Buat 4 grup zodiak di posisi berbeda, masing-masing muter pelan
local zodiacGroups = {}
local zodiacPositions = {
    {x = 0.12, y = 0.20, size = 0.18, rotSpeed = 0.015, color = Color3.fromRGB(140, 180, 255)},
    {x = 0.78, y = 0.15, size = 0.16, rotSpeed = -0.018, color = Color3.fromRGB(200, 160, 255)},
    {x = 0.82, y = 0.72, size = 0.20, rotSpeed = 0.012, color = Color3.fromRGB(255, 180, 220)},
    {x = 0.15, y = 0.75, size = 0.17, rotSpeed = -0.014, color = Color3.fromRGB(160, 220, 255)},
}

for gi, pos in ipairs(zodiacPositions) do
    local groupFrame = Instance.new("Frame")
    groupFrame.Name = "ZodiacGroup_" .. gi
    groupFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    groupFrame.Position = UDim2.fromScale(pos.x, pos.y)
    groupFrame.Size = UDim2.fromScale(pos.size, pos.size)
    groupFrame.BackgroundTransparency = 1
    groupFrame.ZIndex = 7
    groupFrame.Parent = zodiacLayer
    
    -- Pilih rasi acak (rotasi tiap grup)
    local zIdx = ((gi - 1) * 3 + 1) % #zodiacData + 1
    local zodiac = zodiacData[zIdx]
    
    -- Gambar garis antar titik
    local lines = {}
    for i = 1, #zodiac.points - 1 do
        local line = drawZodiacLine(groupFrame, zodiac.points[i], zodiac.points[i+1], pos.color, 1.5, 8)
        table.insert(lines, line)
    end
    
    -- Gambar bintang di setiap titik (lebih besar + glow)
    for _, pt in ipairs(zodiac.points) do
        local zstar = Instance.new("Frame")
        zstar.AnchorPoint = Vector2.new(0.5, 0.5)
        zstar.Position = UDim2.fromScale(pt[1], pt[2])
        zstar.Size = UDim2.fromOffset(4, 4)
        zstar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        zstar.BorderSizePixel = 0
        zstar.ZIndex = 9
        zstar.Parent = groupFrame
        local zc = Instance.new("UICorner"); zc.CornerRadius = UDim.new(1, 0); zc.Parent = zstar
        
        -- Glow halo
        local zGlow = Instance.new("Frame")
        zGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        zGlow.Position = UDim2.fromScale(0.5, 0.5)
        zGlow.Size = UDim2.new(3, 0, 3, 0)
        zGlow.BackgroundColor3 = pos.color
        zGlow.BackgroundTransparency = 0.7
        zGlow.BorderSizePixel = 0
        zGlow.ZIndex = 8
        zGlow.Parent = zstar
        local zgc = Instance.new("UICorner"); zgc.CornerRadius = UDim.new(1, 0); zgc.Parent = zstar
        zGlow.Parent = zstar
        local zgC = Instance.new("UICorner"); zgC.CornerRadius = UDim.new(1, 0); zgC.Parent = zGlow
        
        -- Twinkle
        task.spawn(function()
            while zstar.Parent do
                task.wait(math.random(10, 30)/10)
                if not zstar.Parent then break end
                TweenService:Create(zstar, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0.7
                }):Play()
                TweenService:Create(zGlow, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0.92
                }):Play()
                task.wait(0.9)
                TweenService:Create(zstar, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0
                }):Play()
                TweenService:Create(zGlow, TweenInfo.new(0.8, Enum.EasingStyle.Sine), {
                    BackgroundTransparency = 0.7
                }):Play()
            end
        end)
    end
    
    table.insert(zodiacGroups, {
        frame = groupFrame,
        rotSpeed = pos.rotSpeed,
        color = pos.color,
        name = zodiac.name,
    })
end

-- ⭐ Animasi zodiak: rotasi pelan + fade in/out (ganti rasi tiap 12 detik)
task.spawn(function()
    local t = 0
    while zodiacLayer.Parent do
        task.wait(0.04)
        t = t + 1
        if not win.Visible then continue end
        for _, zg in ipairs(zodiacGroups) do
            if zg.frame.Parent then
                zg.frame.Rotation = zg.frame.Rotation + zg.rotSpeed
                -- Fade in/out smooth (sinusoidal)
                local fade = (math.sin(t * 0.015 + zg.rotSpeed * 100) + 1) / 2
                zg.frame.BackgroundTransparency = 1
                -- Efek opacity via children (karena Frame transparan)
                for _, child in ipairs(zg.frame:GetDescendants()) do
                    if child:IsA("Frame") then
                        if child.BackgroundTransparency < 0.99 then
                            -- Simpan base transparency di attribute
                        end
                    end
                end
            end
        end
    end
end)

-- ═══ SHOOTING STARS (bintang jatuh kecil, cepat, elegan) ═══
task.spawn(function()
    while zodiacLayer.Parent do
        task.wait(math.random(40, 90) / 10)
        if not win.Visible then continue end
        
        local shoot = Instance.new("Frame")
        shoot.AnchorPoint = Vector2.new(0.5, 0.5)
        local startX = math.random(10, 90)
        shoot.Position = UDim2.fromScale(startX/100, -0.05)
        shoot.Size = UDim2.fromOffset(3, 3)
        shoot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        shoot.BorderSizePixel = 0
        shoot.ZIndex = 20
        shoot.Parent = zodiacLayer
        local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(1, 0); sc.Parent = shoot
        
        -- 🌟 PREMIUM TRAIL (3 layer: outer glow + mid + core)
        -- Outer glow
        local outerTrail = Instance.new("Frame")
        outerTrail.AnchorPoint = Vector2.new(0.5, 1)
        outerTrail.Position = UDim2.new(0.5, 0, 0.5, 0)
        outerTrail.Size = UDim2.fromOffset(12, 55)
        outerTrail.BackgroundColor3 = meteorColor
        outerTrail.BackgroundTransparency = 0.7
        outerTrail.BorderSizePixel = 0
        outerTrail.ZIndex = 22
        outerTrail.Parent = meteor
        local otc = Instance.new("UICorner"); otc.CornerRadius = UDim.new(1, 0); otc.Parent = outerTrail
        local otg = Instance.new("UIGradient")
        otg.Rotation = 90
        otg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0.85),
            NumberSequenceKeypoint.new(1, 0.4),
        })
        otg.Parent = outerTrail

        -- Mid trail
        local trail = Instance.new("Frame")
        trail.AnchorPoint = Vector2.new(0.5, 1)
        trail.Position = UDim2.new(0.5, 0, 0.5, 0)
        trail.Size = UDim2.fromOffset(5, 45)
        trail.BackgroundColor3 = meteorColor
        trail.BackgroundTransparency = 0.2
        trail.BorderSizePixel = 0
        trail.ZIndex = 23
        trail.Parent = meteor
        local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1, 0); tc.Parent = trail
        local tGrad = Instance.new("UIGradient")
        tGrad.Rotation = 90
        tGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.5),
            NumberSequenceKeypoint.new(1, 0),
        })
        tGrad.Parent = trail

        -- Core (putih panas)
        local coreTrail = Instance.new("Frame")
        coreTrail.AnchorPoint = Vector2.new(0.5, 1)
        coreTrail.Position = UDim2.new(0.5, 0, 0.5, 0)
        coreTrail.Size = UDim2.fromOffset(2, 38)
        coreTrail.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        coreTrail.BorderSizePixel = 0
        coreTrail.ZIndex = 24
        coreTrail.Parent = meteor
        local ctc = Instance.new("UICorner"); ctc.CornerRadius = UDim.new(1, 0); ctc.Parent = coreTrail
        local ctg = Instance.new("UIGradient")
        ctg.Rotation = 90
        ctg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.7, 0.3),
            NumberSequenceKeypoint.new(1, 0),
        })
        ctg.Parent = coreTrail
        
        local endX = startX + math.random(-40, 40)
        local duration = math.random(8, 14) / 10
        TweenService:Create(shoot, TweenInfo.new(duration, Enum.EasingStyle.Quad), {
            Position = UDim2.fromScale(endX/100, 1.05),
        }):Play()
        task.delay(duration * 0.8, function()
            if shoot.Parent then
                TweenService:Create(shoot, TweenInfo.new(duration * 0.2), {BackgroundTransparency = 1}):Play()
                TweenService:Create(trail, TweenInfo.new(duration * 0.2), {BackgroundTransparency = 1}):Play()
            end
        end)
        task.delay(duration + 0.1, function()
            if shoot then shoot:Destroy() end
        end)
    end
end)

    -- ═══════════════════════════════════════════════════════════
    -- ☄️ METEOR SYSTEM (3 METEOR, TABRAKAN, MELEDAK)
    -- ═══════════════════════════════════════════════════════════
    local meteorLayer = Instance.new("Frame")
    meteorLayer.Size = UDim2.fromScale(1, 1)
    meteorLayer.BackgroundTransparency = 1
    meteorLayer.ZIndex = 20
    meteorLayer.ClipsDescendants = true
    meteorLayer.Parent = win

    local activeMeteors = {}
    local MAX_METEORS = 4
    local SPAWN_INTERVAL = 3

    local function spawnMeteor()
        if #activeMeteors >= MAX_METEORS then return end

        local startX = math.random(10, 90)
        local startY = -10
        local targetX = math.random(10, 90)
        local targetY = math.random(20, 80)
        local speed = math.random(6, 12)
        
        local meteorColor = Color3.fromRGB(255, math.random(100, 200), math.random(0, 100))
        
        -- Meteor Head (Core)
        local meteor = Instance.new("Frame")
        meteor.Name = "Meteor"
        meteor.AnchorPoint = Vector2.new(0.5, 0.5)
        meteor.Size = UDim2.fromOffset(8, 8)
        meteor.Position = UDim2.fromScale(startX/100, startY/100)
        meteor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        meteor.BorderSizePixel = 0
        meteor.ZIndex = 25
        meteor.Parent = meteorLayer
        
        local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(1, 0); mc.Parent = meteor

        -- Glow
        local glow = Instance.new("Frame")
        glow.AnchorPoint = Vector2.new(0.5, 0.5)
        glow.Position = UDim2.fromScale(0.5, 0.5)
        glow.Size = UDim2.new(3, 0, 3, 0)
        glow.BackgroundColor3 = meteorColor
        glow.BackgroundTransparency = 0.5
        glow.BorderSizePixel = 0
        glow.ZIndex = 24
        glow.Parent = meteor
        local gc = Instance.new("UICorner"); gc.CornerRadius = UDim.new(1, 0); gc.Parent = glow

        -- Trail
        local trail = Instance.new("Frame")
        trail.AnchorPoint = Vector2.new(0.5, 1)
        trail.Position = UDim2.new(0.5, 0, 0.5, 0)
        trail.Size = UDim2.fromOffset(4, 40)
        trail.BackgroundColor3 = meteorColor
        trail.BackgroundTransparency = 0.2
        trail.BorderSizePixel = 0
        trail.ZIndex = 23
        trail.Parent = meteor
        local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1, 0); tc.Parent = trail
        
        local tGrad = Instance.new("UIGradient")
        tGrad.Rotation = 90
        tGrad.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)})
        tGrad.Parent = trail

        -- Sparks
        for i = 1, 3 do
            local spark = Instance.new("Frame")
            spark.AnchorPoint = Vector2.new(0.5, 0.5)
            spark.Size = UDim2.fromOffset(math.random(2, 4), math.random(2, 4))
            spark.BackgroundColor3 = meteorColor
            spark.BackgroundTransparency = 0.3
            spark.BorderSizePixel = 0
            spark.ZIndex = 22
            spark.Parent = meteorLayer
            local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(1, 0); sc.Parent = spark
            task.delay(math.random(1, 2), function() if spark then spark:Destroy() end end)
        end

        local meteorData = {
            frame = meteor,
            glow = glow,
            trail = trail,
            startPos = Vector2.new(startX, startY),
            targetPos = Vector2.new(targetX, targetY),
            progress = 0,
            speed = speed,
            color = meteorColor,
            exploded = false,
        }
        table.insert(activeMeteors, meteorData)

        -- Animasi Jatuh (Pakai RenderStepped)
        task.spawn(function()
            while meteor.Parent and not meteorData.exploded do
                task.wait(0.03)
                meteorData.progress = meteorData.progress + (0.03 * meteorData.speed)
                if meteorData.progress >= 1 then
                    meteorData.progress = 1
                end
                local p = meteorData.progress
                local currentX = meteorData.startPos.X + (meteorData.targetPos.X - meteorData.startPos.X) * p
                local currentY = meteorData.startPos.Y + (meteorData.targetPos.Y - meteorData.startPos.Y) * p
                meteor.Position = UDim2.fromScale(currentX/100, currentY/100)
                
                if meteorData.progress >= 1 and not meteorData.exploded then
                    meteorData.exploded = true
                                        -- 🔥 PREMIUM LEDAKAN (EXPLOSION EFFECT)
                    local explosionCenter = meteor.Position
                    
                    -- 🌟 Flash putih besar (double layer)
                    for f = 1, 2 do
                        local flash = Instance.new("Frame")
                        flash.AnchorPoint = Vector2.new(0.5, 0.5)
                        flash.Position = explosionCenter
                        flash.Size = UDim2.fromOffset(4, 4)
                        flash.BackgroundColor3 = f == 1 and Color3.fromRGB(255, 255, 255) or meteorColor
                        flash.BorderSizePixel = 0
                        flash.ZIndex = 30 + f
                        flash.Parent = meteorLayer
                        local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(1, 0); fc.Parent = flash
                        
                        TweenService:Create(flash, TweenInfo.new(0.35 + f*0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(100 + f*20, 100 + f*20),
                            BackgroundTransparency = 1,
                        }):Play()
                        task.delay(0.5, function() if flash then flash:Destroy() end end)
                    end
                    
                    -- 🌟 Cincin cahaya (2 ring)
                    for r = 1, 2 do
                        local shockRing = Instance.new("Frame")
                        shockRing.AnchorPoint = Vector2.new(0.5, 0.5)
                        shockRing.Position = explosionCenter
                        shockRing.Size = UDim2.fromOffset(8, 8)
                        shockRing.BackgroundTransparency = 1
                        shockRing.BorderSizePixel = 0
                        shockRing.ZIndex = 29
                        shockRing.Parent = meteorLayer
                        local src = Instance.new("UICorner"); src.CornerRadius = UDim.new(1, 0); src.Parent = shockRing
                        local srs = Instance.new("UIStroke")
                        srs.Color = r == 1 and Color3.fromRGB(255, 255, 255) or meteorColor
                        srs.Thickness = r == 1 and 2.5 or 1.5
                        srs.Transparency = 0
                        srs.Parent = shockRing
                        
                        TweenService:Create(shockRing, TweenInfo.new(0.6 + r*0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Size = UDim2.fromOffset(140 + r*40, 140 + r*40),
                        }):Play()
                        TweenService:Create(srs, TweenInfo.new(0.6 + r*0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                            Transparency = 1,
                            Thickness = 0,
                        }):Play()
                        task.delay(1, function() if shockRing then shockRing:Destroy() end end)
                    end
                
                    -- Shockwave Ring
                    local ring = Instance.new("Frame")
                    ring.AnchorPoint = Vector2.new(0.5, 0.5)
                    ring.Position = explosionCenter
                    ring.Size = UDim2.fromOffset(10, 10)
                    ring.BackgroundTransparency = 1
                    ring.BorderSizePixel = 0
                    ring.ZIndex = 29
                    ring.Parent = meteorLayer
                    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(1, 0); rc.Parent = ring
                    local rs = Instance.new("UIStroke"); rs.Color = meteorColor; rs.Thickness = 3; rs.Transparency = 0; rs.Parent = ring
                    
                    TweenService:Create(ring, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Size = UDim2.fromOffset(120, 120),
                    }):Play()
                    TweenService:Create(rs, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Transparency = 1,
                        Thickness = 0,
                    }):Play()
                    task.delay(0.55, function() if ring then ring:Destroy() end end)

                    -- Partikel ledakan
                    for i = 1, 12 do
                        local particle = Instance.new("Frame")
                        particle.AnchorPoint = Vector2.new(0.5, 0.5)
                        particle.Position = explosionCenter
                        particle.Size = UDim2.fromOffset(math.random(3, 6), math.random(3, 6))
                        particle.BackgroundColor3 = meteorColor
                        particle.BorderSizePixel = 0
                        particle.ZIndex = 28
                        particle.Parent = meteorLayer
                        local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(1, 0); pc.Parent = particle
                        
                        local angle = math.random(0, 360)
                        local distance = math.random(30, 80)
                        local targetX = explosionCenter.X.Offset + math.cos(math.rad(angle)) * distance
                        local targetY = explosionCenter.Y.Offset + math.sin(math.rad(angle)) * distance
                        
                        TweenService:Create(particle, TweenInfo.new(math.random(4, 8)/10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                            Position = UDim2.fromOffset(targetX, targetY),
                            Size = UDim2.fromOffset(1, 1),
                            BackgroundTransparency = 1,
                        }):Play()
                        task.delay(0.8, function() if particle then particle:Destroy() end end)
                    end

                    -- Hapus meteor
                    if meteor then meteor:Destroy() end
                    
                    -- Hapus dari list
                    for i, m in ipairs(activeMeteors) do
                        if m == meteorData then
                            table.remove(activeMeteors, i)
                            break
                        end
                    end
                end
            end
        end)
    end

    -- ☄️ Spawn meteor cepat (tabrakan tiap ~3 detik)
    task.spawn(function()
        task.wait(1.5)
        while win.Parent do
            if win.Visible and #activeMeteors < MAX_METEORS then
                -- Spawn 1-2 meteor sekaligus biar lebih hidup
                spawnMeteor()
                if math.random() < 0.5 then
                    task.wait(0.4)
                    if #activeMeteors < MAX_METEORS then
                        spawnMeteor()
                    end
                end
            end
            task.wait(SPAWN_INTERVAL)
        end
    end)

    -- ═══ HEADER (Premium) ═══
    local winHeader = Instance.new("Frame")
    winHeader.Size = UDim2.new(1, 0, 0, 64)
    winHeader.BackgroundColor3 = COLOR_SURFACE
    winHeader.BackgroundTransparency = 0.2
    winHeader.BorderSizePixel = 0
    winHeader.ZIndex = 10
    winHeader.Parent = win

    local whCorner = Instance.new("UICorner"); whCorner.CornerRadius = UDim.new(0, 16); whCorner.Parent = winHeader
    
    local headerShine = Instance.new("Frame")
    headerShine.Size = UDim2.new(0, 150, 1, 0)
    headerShine.Position = UDim2.new(-1, 0, 0, 0)
    headerShine.BackgroundColor3 = Color3.new(1,1,1)
    headerShine.BackgroundTransparency = 0.9
    headerShine.BorderSizePixel = 0
    headerShine.Rotation = 20
    headerShine.ZIndex = 11
    headerShine.Parent = winHeader

    task.spawn(function()
        while winHeader.Parent do
            task.wait(4)
            headerShine.Position = UDim2.new(-1, 0, 0, 0)
            TweenService:Create(headerShine, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {Position = UDim2.new(2, 0, 0, 0)}):Play()
            task.wait(1.4)
        end
    end)

    local accentLine = Instance.new("Frame"); accentLine.Size = UDim2.new(0, 4, 1, -20); accentLine.Position = UDim2.fromOffset(16, 10)
    accentLine.BackgroundColor3 = COLOR_CYAN; accentLine.BorderSizePixel = 0; accentLine.ZIndex = 12; accentLine.Parent = winHeader
    local alCorner = Instance.new("UICorner"); alCorner.CornerRadius = UDim.new(1, 0); alCorner.Parent = accentLine

    local winTitle = Instance.new("TextLabel")
    winTitle.Size = UDim2.new(1, -60, 0, 26); winTitle.Position = UDim2.fromOffset(32, 8)
    winTitle.BackgroundTransparency = 1; winTitle.Text = "🎨 EGG EXECUTOR"
    winTitle.TextColor3 = COLOR_CYAN; winTitle.Font = Enum.Font.GothamBlack; winTitle.TextSize = 20
    winTitle.TextXAlignment = Enum.TextXAlignment.Left; winTitle.ZIndex = 12; winTitle.Parent = winHeader
    
    local titleGrad = Instance.new("UIGradient")
    titleGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, COLOR_CYAN), ColorSequenceKeypoint.new(1, COLOR_PURPLE)})
    titleGrad.Parent = winTitle

    local winSub = Instance.new("TextLabel")
    winSub.Size = UDim2.new(1, -60, 0, 16); winSub.Position = UDim2.fromOffset(32, 34)
    winSub.BackgroundTransparency = 1; winSub.Text = "PREMIUM GALAXY DASHBOARD"
    winSub.TextColor3 = COLOR_TEXT_DIM; winSub.Font = Enum.Font.GothamBold; winSub.TextSize = 10
    winSub.TextXAlignment = Enum.TextXAlignment.Left; winSub.ZIndex = 12; winSub.Parent = winHeader

    local winClose = Instance.new("TextButton")
    winClose.Size = UDim2.fromOffset(32, 32); winClose.Position = UDim2.new(1, -48, 0.5, -16)
    winClose.BackgroundColor3 = Color3.fromRGB(180, 50, 50); winClose.BackgroundTransparency = 0.3
    winClose.Text = "✕"; winClose.TextColor3 = Color3.new(1, 1, 1); winClose.Font = Enum.Font.GothamBold
    winClose.TextSize = 18; winClose.BorderSizePixel = 0; winClose.ZIndex = 12; winClose.Parent = winHeader
    local wcCorner = Instance.new("UICorner"); wcCorner.CornerRadius = UDim.new(1, 0); wcCorner.Parent = winClose
    
    winClose.MouseEnter:Connect(function() TweenService:Create(winClose, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80), BackgroundTransparency = 0}):Play() end)
    winClose.MouseLeave:Connect(function() TweenService:Create(winClose, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 50, 50), BackgroundTransparency = 0.3}):Play() end)

    -- ═══ TAB BAR ═══
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, -32, 0, 44); tabBar.Position = UDim2.fromOffset(16, 74)
    tabBar.BackgroundColor3 = COLOR_GLASS; tabBar.BackgroundTransparency = 0.5
    tabBar.BorderSizePixel = 0; tabBar.ZIndex = 9; tabBar.Parent = win
    local tbCorner = Instance.new("UICorner"); tbCorner.CornerRadius = UDim.new(0, 12); tbCorner.Parent = tabBar

    local tabs = {
        {name = "Stats", icon = "📊", key = "stats"},
        {name = "Eggs", icon = "🥚", key = "eggs"},
        {name = "Avatar", icon = "👤", key = "avatar"},
    }
    local tabButtons = {}

    for i, tab in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Name = "Tab_" .. tab.key
        btn.Size = UDim2.new(1/3 - 0.02, 0, 1, -8); btn.Position = UDim2.new((i-1)/3 + 0.01, 0, 0, 4)
        btn.BackgroundColor3 = Color3.fromRGB(30, 35, 55)
        btn.BackgroundTransparency = 0.4
        btn.Text = ""
        btn.BorderSizePixel = 0
        btn.ZIndex = 10; btn.Parent = tabBar
        local btnCorner = Instance.new("UICorner"); btnCorner.CornerRadius = UDim.new(0, 8); btnCorner.Parent = btn
        
        local iconLbl = Instance.new("TextLabel")
        iconLbl.Size = UDim2.new(0, 24, 1, 0); iconLbl.Position = UDim2.fromOffset(10, 0)
        iconLbl.BackgroundTransparency = 1; iconLbl.Text = tab.icon; iconLbl.TextSize = 16
        iconLbl.ZIndex = 11; iconLbl.Parent = btn

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, -40, 1, 0); nameLbl.Position = UDim2.fromOffset(36, 0)
        nameLbl.BackgroundTransparency = 1; nameLbl.Text = tab.name; nameLbl.TextColor3 = COLOR_TEXT_DIM
        nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 12; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.ZIndex = 11; nameLbl.Parent = btn
        
        tabButtons[tab.key] = {btn = btn, icon = iconLbl, name = nameLbl}
    end

    -- ═══ CONTENT AREA ═══
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -32, 1, -140); content.Position = UDim2.fromOffset(16, 124)
    content.BackgroundTransparency = 1; content.ZIndex = 8; content.ClipsDescendants = true; content.Parent = win

    -- ═══ TAB: STATS ═══
    local statsTab = Instance.new("Frame")
    statsTab.Size = UDim2.fromScale(1, 1); statsTab.BackgroundTransparency = 1; statsTab.ZIndex = 9; statsTab.Parent = content

    local counterBg = Instance.new("Frame")
    counterBg.Size = UDim2.new(1, 0, 0, 120); counterBg.BackgroundColor3 = COLOR_GLASS
    counterBg.BackgroundTransparency = 0.3; counterBg.BorderSizePixel = 0; counterBg.ZIndex = 10; counterBg.Parent = statsTab
    local cbCorner = Instance.new("UICorner"); cbCorner.CornerRadius = UDim.new(0, 14); cbCorner.Parent = counterBg
    local cbStroke = Instance.new("UIStroke"); cbStroke.Color = COLOR_CYAN; cbStroke.Thickness = 1.5; cbStroke.Transparency = 0.4; cbStroke.Parent = counterBg
    local cbGrad = Instance.new("UIGradient"); cbGrad.Rotation = 90
    cbGrad.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 40, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 20, 35))})
    cbGrad.Parent = counterBg

    local totalLabel = Instance.new("TextLabel")
    totalLabel.Size = UDim2.fromScale(1, 0.5); totalLabel.Position = UDim2.fromScale(0, 0.1)
    totalLabel.BackgroundTransparency = 1; totalLabel.Text = "0"
    totalLabel.TextColor3 = COLOR_CYAN; totalLabel.TextStrokeColor3 = Color3.fromRGB(0, 100, 80)
    totalLabel.TextStrokeTransparency = 0.3; totalLabel.Font = Enum.Font.GothamBlack
    totalLabel.TextSize = 54; totalLabel.ZIndex = 11; totalLabel.Parent = counterBg

    local totalDesc = Instance.new("TextLabel")
    totalDesc.Size = UDim2.fromScale(1, 0.3); totalDesc.Position = UDim2.fromScale(0, 0.65)
    totalDesc.BackgroundTransparency = 1; totalDesc.Text = "TOTAL STOLEN EGGS"
    totalDesc.TextColor3 = COLOR_TEXT_DIM; totalDesc.Font = Enum.Font.GothamBold
    totalDesc.TextSize = 12; totalDesc.ZIndex = 11; totalDesc.Parent = counterBg

    local grid = Instance.new("Frame")
    grid.Size = UDim2.new(1, 0, 1, -130); grid.Position = UDim2.fromOffset(0, 130)
    grid.BackgroundTransparency = 1; grid.ZIndex = 10; grid.Parent = statsTab
    local gridLayout = Instance.new("UIGridLayout")
    gridLayout.CellSize = UDim2.new(0.5, -5, 0, 60); gridLayout.CellPadding = UDim2.fromOffset(10, 10)
    gridLayout.SortOrder = Enum.SortOrder.LayoutOrder; gridLayout.Parent = grid

    local function makeStatCard(icon, label, color)
        local card = Instance.new("Frame")
        card.BackgroundColor3 = COLOR_GLASS; card.BackgroundTransparency = 0.4
        card.BorderSizePixel = 0; card.ZIndex = 11
        local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 10); cc.Parent = card
                local cs = Instance.new("UIStroke"); cs.Color = color; cs.Thickness = 1.5; cs.Transparency = 0.3; cs.Parent = card
        -- ⭐ Inner glow (3D depth)
        local csInner = Instance.new("UIStroke")
        csInner.Color = Color3.fromRGB(255, 255, 255)
        csInner.Thickness = 0.5
        csInner.Transparency = 0.85
        csInner.Parent = card
        
        local iconLbl = Instance.new("TextLabel")
        iconLbl.Size = UDim2.fromOffset(32, 32); iconLbl.Position = UDim2.fromOffset(10, 14)
        iconLbl.BackgroundTransparency = 1; iconLbl.Text = icon; iconLbl.TextSize = 22
        iconLbl.ZIndex = 12; iconLbl.Parent = card

        local valLbl = Instance.new("TextLabel")
        valLbl.Name = "Value"; valLbl.Size = UDim2.new(1, -55, 0, 22); valLbl.Position = UDim2.fromOffset(50, 10)
        valLbl.BackgroundTransparency = 1; valLbl.Text = "0"; valLbl.TextColor3 = color
        valLbl.Font = Enum.Font.GothamBlack; valLbl.TextSize = 18; valLbl.TextXAlignment = Enum.TextXAlignment.Left
        valLbl.ZIndex = 12; valLbl.Parent = card

        local lblLbl = Instance.new("TextLabel")
        lblLbl.Size = UDim2.new(1, -55, 0, 14); lblLbl.Position = UDim2.fromOffset(50, 32)
        lblLbl.BackgroundTransparency = 1; lblLbl.Text = label; lblLbl.TextColor3 = COLOR_TEXT_DIM
        lblLbl.Font = Enum.Font.GothamBold; lblLbl.TextSize = 9; lblLbl.TextXAlignment = Enum.TextXAlignment.Left
        lblLbl.ZIndex = 12; lblLbl.Parent = card

        return card, valLbl
    end

    local rateCard, rateVal = makeStatCard("⚡", "STEAL/MIN", COLOR_GOLD); rateCard.Parent = grid
    local sessionCard, sessionVal = makeStatCard("⏱", "AKTIF", COLOR_CYAN); sessionCard.Parent = grid
    local rareCard, rareVal = makeStatCard("💎", "RARE EGGS", Color3.fromRGB(255, 100, 255)); rareCard.Parent = grid
    local avgCard, avgVal = makeStatCard("📈", "AVG/JAM", Color3.fromRGB(100, 200, 255)); avgCard.Parent = grid

    -- ═══ TAB: EGGS ═══
    local eggsTab = Instance.new("Frame")
    eggsTab.Size = UDim2.fromScale(1, 1); eggsTab.BackgroundTransparency = 1; eggsTab.Visible = false; eggsTab.ZIndex = 9; eggsTab.Parent = content

    local eggScroll = Instance.new("ScrollingFrame")
    eggScroll.Size = UDim2.fromScale(1, 1)
    eggScroll.BackgroundTransparency = 1; eggScroll.BorderSizePixel = 0; eggScroll.ScrollBarThickness = 4
    eggScroll.ScrollBarImageColor3 = COLOR_CYAN; eggScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    eggScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y; eggScroll.ZIndex = 10; eggScroll.Parent = eggsTab

    local eggListLayout = Instance.new("UIListLayout")
    eggListLayout.SortOrder = Enum.SortOrder.LayoutOrder; eggListLayout.Padding = UDim.new(0, 8); eggListLayout.Parent = eggScroll

    -- ═══ TAB: AVATAR (SUPER SMOOTH) ═══
    local avatarTab = Instance.new("Frame")
    avatarTab.Size = UDim2.fromScale(1, 1); avatarTab.BackgroundTransparency = 1; avatarTab.Visible = false; avatarTab.ZIndex = 9; avatarTab.Parent = content

    local viewportFrame = Instance.new("ViewportFrame")
    viewportFrame.Name = "AvatarPreview"; viewportFrame.Size = UDim2.fromScale(1, 1)
    viewportFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 20); viewportFrame.BackgroundTransparency = 0.1
    viewportFrame.BorderSizePixel = 0; viewportFrame.Ambient = Color3.fromRGB(150, 150, 170)
    viewportFrame.LightColor = Color3.new(1,1,1); viewportFrame.ZIndex = 10; viewportFrame.Parent = avatarTab

    local vpCorner = Instance.new("UICorner"); vpCorner.CornerRadius = UDim.new(0, 12); vpCorner.Parent = viewportFrame
    local vpStroke = Instance.new("UIStroke"); vpStroke.Color = COLOR_CYAN; vpStroke.Thickness = 2; vpStroke.Transparency = 0.3; vpStroke.Parent = viewportFrame

    local worldModel = Instance.new("WorldModel"); worldModel.Parent = viewportFrame
    local camera = Instance.new("Camera"); camera.FieldOfView = 30; camera.Parent = viewportFrame; viewportFrame.CurrentCamera = camera

    local avPlaceholder = Instance.new("TextLabel")
    avPlaceholder.Size = UDim2.fromScale(1, 1); avPlaceholder.BackgroundTransparency = 1
    avPlaceholder.Text = "👤 Loading avatar..."; avPlaceholder.TextColor3 = COLOR_CYAN
    avPlaceholder.Font = Enum.Font.GothamBold; avPlaceholder.TextSize = 16; avPlaceholder.ZIndex = 11; avPlaceholder.Parent = viewportFrame

    -- ⭐ SUPER SMOOTH AVATAR ROTATION
    local avatarClone = nil
    local isDraggingAv = false
    local dragStartX, dragStartY = 0, 0
    
    -- ⭐ TARGET vs CURRENT (Smooth Lerp)
    local targetRotX, targetRotY = 0, 0
    local currentRotX, currentRotY = 0, 0
    
    local currentZoom = -8.5
    local autoRotate = true
    local lastAutoRotateTime = tick()

    task.spawn(function()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local oldArch = char.Archivable
        char.Archivable = true
        local ok, clone = pcall(char.Clone, char)
        char.Archivable = oldArch

        if not ok or not clone then avPlaceholder.Text = "❌ Gagal clone avatar" return end
        clone.Name = "AvatarPreview_" .. LocalPlayer.Name

        for _, d in ipairs(clone:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("ModuleScript") then d:Destroy() end
            if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false end
        end
        clone.Parent = worldModel
        avatarClone = clone
        avPlaceholder:Destroy()

        local hrp = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("Torso") or clone:FindFirstChild("UpperTorso")
        if not hrp then avPlaceholder.Text = "❌ No body part" return end

        clone:PivotTo(CFrame.new(0, 0, 0))
        local targetPos = hrp.Position
        
        -- Setup Drag
        viewportFrame.Active = true
        viewportFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingAv = true
                dragStartX, dragStartY = input.Position.X, input.Position.Y
                targetRotX = currentRotX
                targetRotY = currentRotY
                autoRotate = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isDraggingAv and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local deltaX = input.Position.X - dragStartX
                local deltaY = input.Position.Y - dragStartY
                -- Update TARGET (bukan current) biar smooth
                targetRotY = targetRotY + (deltaX * 0.8)
                targetRotX = targetRotX + (deltaY * 0.5)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isDraggingAv = false
            end
        end)

        -- ⭐ SUPER SMOOTH LERP LOOP
        RunService.RenderStepped:Connect(function(dt)
            if not viewportFrame.Parent or not clone.Parent then return end
            if not avatarTab.Visible then return end
            
            -- Auto Rotate Smooth
            if autoRotate and not isDraggingAv then
                targetRotY = targetRotY + 30 * dt
            end

            -- Super Smooth Lerp (Biar gak patah-patah)
            local lerpSpeed = 15 * dt
            currentRotX = currentRotX + (targetRotX - currentRotX) * lerpSpeed
            currentRotY = currentRotY + (targetRotY - currentRotY) * lerpSpeed

            clone:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(math.rad(currentRotX), math.rad(currentRotY), 0))
            
            -- Kamera nyesuaiin zoom
            local targetPos = hrp.Position
            camera.CFrame = CFrame.lookAt(targetPos + Vector3.new(0, 1.5, currentZoom), targetPos + Vector3.new(0, 1, 0))
        end)
    end)

    -- Avatar Info & Controls Overlay
    local avatarInfo = Instance.new("Frame")
    avatarInfo.Size = UDim2.new(1, 0, 0, 60); avatarInfo.Position = UDim2.new(0, 0, 1, -60)
    avatarInfo.BackgroundColor3 = COLOR_GLASS; avatarInfo.BackgroundTransparency = 0.3
    avatarInfo.BorderSizePixel = 0; avatarInfo.ZIndex = 11; avatarInfo.Parent = avatarTab
    local aiCorner = Instance.new("UICorner"); aiCorner.CornerRadius = UDim.new(0, 12); aiCorner.Parent = avatarInfo

    local avatarName = Instance.new("TextLabel")
    avatarName.Size = UDim2.new(1, -20, 0, 20); avatarName.Position = UDim2.fromOffset(12, 8)
    avatarName.BackgroundTransparency = 1; avatarName.Text = "👤 " .. LocalPlayer.DisplayName
    avatarName.TextColor3 = COLOR_CYAN; avatarName.Font = Enum.Font.GothamBold; avatarName.TextSize = 14
    avatarName.ZIndex = 12; avatarName.Parent = avatarInfo

    local avatarSub = Instance.new("TextLabel")
    avatarSub.Size = UDim2.new(1, -20, 0, 16); avatarSub.Position = UDim2.fromOffset(12, 30)
    avatarSub.BackgroundTransparency = 1; avatarSub.Text = "User ID: " .. LocalPlayer.UserId .. "  ·  Drag to rotate"
    avatarSub.TextColor3 = COLOR_TEXT_DIM; avatarSub.Font = Enum.Font.GothamMedium; avatarSub.TextSize = 10
    avatarSub.ZIndex = 12; avatarSub.Parent = avatarInfo

    local zoomBtn = Instance.new("TextButton")
    zoomBtn.Size = UDim2.fromOffset(80, 24); zoomBtn.Position = UDim2.new(1, -170, 1, -40)
    zoomBtn.BackgroundColor3 = COLOR_SURFACE; zoomBtn.Text = "Auto-Rotate"
    zoomBtn.TextColor3 = COLOR_CYAN; zoomBtn.Font = Enum.Font.GothamBold; zoomBtn.TextSize = 10
    zoomBtn.ZIndex = 12; zoomBtn.Parent = avatarTab
    local zbCorner = Instance.new("UICorner"); zbCorner.CornerRadius = UDim.new(1, 0); zbCorner.Parent = zoomBtn
    local zbStroke = Instance.new("UIStroke"); zbStroke.Color = COLOR_CYAN; zbStroke.Transparency = 0.5; zbStroke.Parent = zoomBtn

    zoomBtn.MouseButton1Click:Connect(function()
        autoRotate = not autoRotate
        zoomBtn.Text = autoRotate and "Auto-Rotate" or "Manual"
        zoomBtn.TextColor3 = autoRotate and COLOR_CYAN or COLOR_GOLD
        zbStroke.Color = autoRotate and COLOR_CYAN or COLOR_GOLD
    end)

    local zoomSliderBg = Instance.new("Frame")
    zoomSliderBg.Size = UDim2.fromOffset(100, 4); zoomSliderBg.Position = UDim2.new(1, -170, 1, -12)
    zoomSliderBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80); zoomSliderBg.BorderSizePixel = 0
    zoomSliderBg.ZIndex = 12; zoomSliderBg.Parent = avatarTab
    local zsbCorner = Instance.new("UICorner"); zsbCorner.CornerRadius = UDim.new(1, 0); zsbCorner.Parent = zoomSliderBg

    local zoomFill = Instance.new("Frame")
    zoomFill.Size = UDim2.new(0.5, 0, 1, 0); zoomFill.BackgroundColor3 = COLOR_CYAN
    zoomFill.BorderSizePixel = 0; zoomFill.ZIndex = 13; zoomFill.Parent = zoomSliderBg
    local zfCorner = Instance.new("UICorner"); zfCorner.CornerRadius = UDim.new(1, 0); zfCorner.Parent = zoomFill

    local zoomDragging = false
    zoomSliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            zoomDragging = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            zoomDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if zoomDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local rel = math.clamp((input.Position.X - zoomSliderBg.AbsolutePosition.X) / zoomSliderBg.AbsoluteSize.X, 0, 1)
            zoomFill.Size = UDim2.new(rel, 0, 1, 0)
            currentZoom = -3 - (rel * 10)
        end
    end)

    -- ═══ TAB SWITCH & ANIMATION ═══
    local function switchTab(key)
        EggState.ActiveTab = key
        statsTab.Visible = (key == "stats")
        eggsTab.Visible = (key == "eggs")
        avatarTab.Visible = (key == "avatar")

        for k, data in pairs(tabButtons) do
            if k == key then
                TweenService:Create(data.btn, TweenInfo.new(0.3), {BackgroundColor3 = COLOR_CYAN, BackgroundTransparency = 0.1}):Play()
                data.name.TextColor3 = Color3.new(0,0,0)
                data.icon.TextColor3 = Color3.new(0,0,0)
            else
                TweenService:Create(data.btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30, 35, 55), BackgroundTransparency = 0.4}):Play()
                data.name.TextColor3 = COLOR_TEXT_DIM
                data.icon.TextColor3 = Color3.new(1,1,1)
            end
        end

        local targetTab = (key == "stats" and statsTab) or (key == "eggs" and eggsTab) or avatarTab
        if targetTab then
            targetTab.Position = UDim2.new(0, 20, 0, 0)
            TweenService:Create(targetTab, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        end

        if key == "eggs" then updateEggList() end
    end

    for key, data in pairs(tabButtons) do
        data.btn.MouseButton1Click:Connect(function()
            pcall(switchTab, key)
        end)
    end

    -- ═══ UPDATE STATS & EGG LIST ═══
    local updateEggList
    local updateStatsDisplay

    updateStatsDisplay = function()
        if not win.Parent then return end
        local activeTime = os.time() - StealStats.SessionStart
        local total = StealStats.TotalSteals
        totalLabel.Text = tostring(total); sessionVal.Text = formatTime(activeTime)

        local minutes = math.max(activeTime / 60, 1)
        rateVal.Text = string.format("%.1f", total / minutes)

        local rareCount = 0
        for _, e in ipairs(StealStats.StolenEggs) do
            local r = tostring(e.rarity):lower()
            if r:find("legendary") or r:find("mythic") or r:find("divine") or r:find("secret") or r:find("ethereal") then rareCount = rareCount + 1 end
        end
        rareVal.Text = tostring(rareCount)
        local perHour = total / math.max(activeTime / 3600, 0.01)
        avgVal.Text = string.format("%.0f", perHour)
    end

    updateEggList = function()
        for _, child in ipairs(eggScroll:GetChildren()) do
            if child:IsA("Frame") or child:IsA("TextLabel") then child:Destroy() end
        end
        local eggs = StealStats.StolenEggs
        local count = #eggs
        for i = count, 1, -1 do
            local e = eggs[i]
            local idx = count - i + 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, -8, 0, 42); row.BackgroundColor3 = COLOR_GLASS; row.BackgroundTransparency = 0.4
            row.BorderSizePixel = 0; row.LayoutOrder = idx; row.ZIndex = 11
            local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 8); rc.Parent = row

            local rarityColor = COLOR_TEXT_DIM
            local rl = tostring(e.rarity):lower()
            if rl:find("common") then rarityColor = Color3.fromRGB(180, 180, 180)
            elseif rl:find("uncommon") then rarityColor = Color3.fromRGB(100, 255, 100)
            elseif rl:find("rare") then rarityColor = Color3.fromRGB(100, 150, 255)
            elseif rl:find("epic") then rarityColor = Color3.fromRGB(200, 100, 255)
            elseif rl:find("legendary") then rarityColor = COLOR_GOLD
            elseif rl:find("mythic") then rarityColor = Color3.fromRGB(255, 100, 100)
            elseif rl:find("divine") then rarityColor = Color3.fromRGB(255, 200, 255)
            elseif rl:find("secret") then rarityColor = COLOR_CYAN
            elseif rl:find("ethereal") then rarityColor = Color3.fromRGB(200, 255, 255) end

            local stroke = Instance.new("UIStroke"); stroke.Color = rarityColor; stroke.Thickness = 1; stroke.Transparency = 0.5; stroke.Parent = row
            local numLbl = Instance.new("TextLabel"); numLbl.Size = UDim2.fromOffset(30, 42); numLbl.BackgroundTransparency = 1
            numLbl.Text = "#" .. idx; numLbl.TextColor3 = rarityColor; numLbl.Font = Enum.Font.GothamBlack; numLbl.TextSize = 12; numLbl.ZIndex = 12; numLbl.Parent = row

            local nameLbl = Instance.new("TextLabel"); nameLbl.Size = UDim2.new(0.6, -40, 0, 20); nameLbl.Position = UDim2.fromOffset(35, 4)
            nameLbl.BackgroundTransparency = 1; nameLbl.Text = "🥚 " .. e.name; nameLbl.TextColor3 = rarityColor
            nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 13; nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.TextTruncate = Enum.TextTruncate.AtEnd; nameLbl.ZIndex = 12; nameLbl.Parent = row

            local infoLbl = Instance.new("TextLabel"); infoLbl.Size = UDim2.new(0.6, -40, 0, 14); infoLbl.Position = UDim2.fromOffset(35, 24)
            infoLbl.BackgroundTransparency = 1; infoLbl.Text = e.rarity .. " · " .. e.weight; infoLbl.TextColor3 = Color3.fromRGB(150, 150, 180)
            infoLbl.Font = Enum.Font.GothamMedium; infoLbl.TextSize = 10; infoLbl.TextXAlignment = Enum.TextXAlignment.Left; infoLbl.ZIndex = 12; infoLbl.Parent = row

            local timeLbl = Instance.new("TextLabel"); timeLbl.Size = UDim2.fromOffset(80, 42); timeLbl.Position = UDim2.new(1, -90, 0, 0)
            timeLbl.BackgroundTransparency = 1; timeLbl.Text = os.date("%H:%M:%S", e.time); timeLbl.TextColor3 = Color3.fromRGB(120, 120, 150)
            timeLbl.Font = Enum.Font.GothamMedium; timeLbl.TextSize = 10; timeLbl.TextXAlignment = Enum.TextXAlignment.Right; timeLbl.ZIndex = 12; timeLbl.Parent = row

            row.Parent = eggScroll
        end
        task.defer(function() if eggScroll then eggScroll.CanvasSize = UDim2.new(0, 0, 0, eggListLayout.AbsoluteContentSize.Y + 10) end end)
        if count == 0 then
            local emptyLbl = Instance.new("TextLabel"); emptyLbl.Size = UDim2.new(1, 0, 0, 40); emptyLbl.BackgroundTransparency = 1
            emptyLbl.Text = "📭 Belum ada egg.\nAktifkan fitur steal!"; emptyLbl.TextColor3 = COLOR_TEXT_DIM
            emptyLbl.Font = Enum.Font.GothamMedium; emptyLbl.TextSize = 13; emptyLbl.ZIndex = 11; emptyLbl.Parent = eggScroll
        end
    end

    -- ═══ OPEN/CLOSE, DRAG, UPDATE LOOP ═══
    local function openWindow()
        EggState.WindowVisible = true; win.Visible = true
        win.Position = UDim2.new(WIN_X, 0, WIN_Y, 150)
        TweenService:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(WIN_X, 0, WIN_Y, 0)}):Play()
    end

    local function closeWindow()
        EggState.WindowVisible = false
        TweenService:Create(win, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.new(WIN_X, 0, WIN_Y, 150)}):Play()
        task.delay(0.3, function() if not EggState.WindowVisible then win.Visible = false end end)
    end

    winClose.MouseButton1Click:Connect(closeWindow)
    mini.MouseButton1Click:Connect(function() if EggState.WindowVisible then closeWindow() else openWindow() end end)

    local dragging = false
    local dragStart, startPos
    winHeader.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    task.spawn(function()
        while win.Parent do
            task.wait(1)
            if EggState.WindowVisible then pcall(updateStatsDisplay) end
        end
    end)

    task.spawn(function()
        while eggScroll.Parent do
            task.wait(1.5)
            if EggState.ActiveTab == "eggs" and EggState.WindowVisible then pcall(updateEggList) end
        end
    end)

    _G.VRILZ_EggExecutorRecordSteal = recordSteal
end

-- ============================================================
-- BUILD MAIN WINDOW
-- ============================================================
local function buildMainWindow(parent)
    local screenGui = parent
    local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)

    local winW, winH
if IS_MOBILE then
    local maxW = viewport.X - 8       -- ← cuma 4px kiri-kanan
    local maxH = viewport.Y - 20      -- ← cuma 10px atas-bawah
    winW = math.min(CFG.WIN_W, maxW)
    winH = math.min(CFG.WIN_H, maxH)
else
    winW = math.min(CFG.WIN_W, math.floor(viewport.X * 0.7))
    winH = math.min(CFG.WIN_H, math.floor(viewport.Y * 0.78))
end

    local main = Instance.new("Frame")
main.Name = "MainWindow"
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.5)
main.Size = UDim2.fromOffset(winW, winH)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BorderSizePixel = 0
main.ZIndex = 1
main.Parent = screenGui
registerTheme(main, "BG", "BackgroundColor3")

-- ⭐⭐⭐ FOTO ANIME BACKGROUND ⭐⭐⭐
local animeBg = Instance.new("ImageLabel")
animeBg.Name = "AnimeBackground"
animeBg.Size = UDim2.fromScale(1, 1)
animeBg.Position = UDim2.fromScale(0, 0)
animeBg.BackgroundTransparency = 1
-- ⭐⭐⭐ GITHUB IMAGE LOADER ⭐⭐⭐
local GITHUB_ANIME_URL = "https://raw.githubusercontent.com/vrilz-vd/anime/refs/heads/main/images%20(4).jpe"
local GITHUB_ANIME_CACHE = "vrilz_anime_bg_v4.png"

local function loadGithubImage()
    -- Cek apakah executor support getcustomasset
    if not (writefile and isfile and getcustomasset) then
        warn("[BG] Executor gak support getcustomasset")
        return nil
    end
    
    -- Cek cache dulu
    if isfile(GITHUB_ANIME_CACHE) then
        local ok, asset = pcall(getcustomasset, GITHUB_ANIME_CACHE)
        if ok and asset then
            print("[BG] ✅ Loaded dari cache")
            return asset
        end
    end
    
    -- Download dari GitHub
    print("[BG] Download dari GitHub...")
    local ok, content = pcall(function()
        return game:HttpGet(GITHUB_ANIME_URL)
    end)
    
    if not ok or not content then
        warn("[BG] ❌ Gagal download dari GitHub")
        return nil
    end
    
    -- Simpan ke file lokal
    pcall(writefile, GITHUB_ANIME_CACHE, content)
    
    -- Convert ke asset
    local ok2, asset = pcall(getcustomasset, GITHUB_ANIME_CACHE)
    if ok2 and asset then
        print("[BG] ✅ Loaded dari GitHub")
        return asset
    end
    
    warn("[BG] ❌ Gagal convert ke asset")
    return nil
end

-- Pasang ke ImageLabel
local bgAsset = loadGithubImage()
if bgAsset then
    animeBg.Image = bgAsset
else
    animeBg.Image = ""
    animeBg.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
end
-- ⭐⭐⭐ END GITHUB IMAGE LOADER ⭐⭐⭐
animeBg.ScaleType = Enum.ScaleType.Crop
animeBg.ZIndex = 1
animeBg.Parent = main
registerTheme(animeBg, "Accent", "ImageColor3")

local animeBgCorner = Instance.new("UICorner")
animeBgCorner.CornerRadius = UDim.new(0, 18)
animeBgCorner.Parent = animeBg

-- ⭐ Overlay gelap tipis biar teks kebaca
local animeOverlay = Instance.new("Frame")
animeOverlay.Name = "AnimeOverlay"
animeOverlay.Size = UDim2.fromScale(1, 1)
animeOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
animeOverlay.BackgroundTransparency = 0.4 -- 0.4 = gelap 40% (sesuaikan)
animeOverlay.BorderSizePixel = 0
animeOverlay.ZIndex = 2
animeOverlay.Active = false
animeOverlay.Parent = main

local animeOverlayCorner = Instance.new("UICorner")
animeOverlayCorner.CornerRadius = UDim.new(0, 18)
animeOverlayCorner.Parent = animeOverlay
-- ⭐⭐⭐ END FOTO ANIME ⭐⭐⭐
    -- Soft 3D shadow behind the window (visual only).
    local shadow = Instance.new("Frame")
    shadow.Name = "WindowShadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.new(1, 28, 1, 28)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.38
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 0
    shadow.Parent = main
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 24)
    shadowCorner.Parent = shadow

    local bevel = Instance.new("Frame")
    bevel.Name = "WindowBevel"
    bevel.Size = UDim2.new(1, -2, 1, -2)
    bevel.Position = UDim2.fromOffset(1, 1)
    bevel.BackgroundTransparency = 1
    bevel.BorderSizePixel = 0
    bevel.ZIndex = 1
    bevel.Parent = main
    local bevelCorner = Instance.new("UICorner")
    bevelCorner.CornerRadius = UDim.new(0, 21)
    bevelCorner.Parent = bevel
    local bevelStroke = Instance.new("UIStroke")
    bevelStroke.Color = Color3.fromRGB(255, 255, 255)
    bevelStroke.Thickness = 1
    bevelStroke.Transparency = 0.88
    bevelStroke.Parent = bevel

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = main

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 24, 29)),
        ColorSequenceKeypoint.new(0.45, C.BG),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(5, 6, 9)),
    })

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 2.6
    stroke.Transparency = 0.08
    stroke.Parent = main
    registerTheme(stroke, "Accent", "Color")

    -- HEADER
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, CFG.HEADER_H)
    header.BackgroundColor3 = C.Surface
    header.BorderSizePixel = 0
    header.ZIndex = 10
    header.Parent = main
    header.Active = true
    registerTheme(header, "Surface", "BackgroundColor3")
    header.BackgroundTransparency = 0.35

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 18)
    headerCorner.Parent = header

    local headerGlow = Instance.new("Frame")
    headerGlow.Size = UDim2.new(1, -24, 0, 2)
    headerGlow.Position = UDim2.new(0, 12, 1, -2)
    headerGlow.BackgroundColor3 = C.Accent
    headerGlow.BackgroundTransparency = 0.15
    headerGlow.BorderSizePixel = 0
    headerGlow.ZIndex = 12
    headerGlow.Parent = header
    local headerGlowCorner = Instance.new("UICorner")
    headerGlowCorner.CornerRadius = UDim.new(1, 0)
    headerGlowCorner.Parent = headerGlow
    registerTheme(headerGlow, "Accent", "BackgroundColor3")

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 14)
    headerFix.Position = UDim2.new(0, 0, 1, -14)
    headerFix.BackgroundTransparency = 1
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 10
    headerFix.Parent = header

   -- ⭐⭐⭐ VH LOGO 3D + PETIR MERAH ⭐⭐⭐
local logoHolder = Instance.new("Frame")
logoHolder.Name = "HeaderLogo"
logoHolder.Size = UDim2.fromOffset(IS_MOBILE and 32 or 38, IS_MOBILE and 32 or 38)
logoHolder.Position = UDim2.fromOffset(IS_MOBILE and 10 or 12, (CFG.HEADER_H - (IS_MOBILE and 32 or 38)) / 2)
logoHolder.BackgroundColor3 = Color3.fromRGB(15, 5, 5)
logoHolder.BackgroundTransparency = 1
logoHolder.ZIndex = 11
logoHolder.ClipsDescendants = true
logoHolder.Parent = header

local lhCorner = Instance.new("UICorner")
lhCorner.CornerRadius = UDim.new(0, 8)
lhCorner.Parent = logoHolder

-- Garis tepi menyala
local lhStroke = Instance.new("UIStroke")
lhStroke.Color = C.Accent
lhStroke.Thickness = 1.5
lhStroke.Transparency = 0.2
lhStroke.Parent = logoHolder

local textSizeVal = IS_MOBILE and 14 or 18

-- Efek 3D Shadow
local vhShadow = Instance.new("TextLabel")
vhShadow.Size = UDim2.fromScale(1, 1)
vhShadow.Position = UDim2.fromOffset(2, 2)
vhShadow.BackgroundTransparency = 1
vhShadow.Text = "VH"
vhShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
vhShadow.TextTransparency = 0.2
vhShadow.Font = Enum.Font.GothamBlack
vhShadow.TextSize = textSizeVal
vhShadow.ZIndex = 12
vhShadow.Parent = logoHolder

-- Efek 3D Depth (Warna Orange/Accent)
local vhDepth = Instance.new("TextLabel")
vhDepth.Size = UDim2.fromScale(1, 1)
vhDepth.Position = UDim2.fromOffset(1, 1)
vhDepth.BackgroundTransparency = 1
vhDepth.Text = "VH"
vhDepth.TextColor3 = C.Accent
vhDepth.Font = Enum.Font.GothamBlack
vhDepth.TextSize = textSizeVal
vhDepth.ZIndex = 13
vhDepth.Parent = logoHolder

-- Teks Utama Putih
local vhFace = Instance.new("TextLabel")
vhFace.Size = UDim2.fromScale(1, 1)
vhFace.BackgroundTransparency = 1
vhFace.Text = "VH"
vhFace.TextColor3 = Color3.fromRGB(255, 255, 255)
vhFace.Font = Enum.Font.GothamBlack
vhFace.TextSize = textSizeVal
vhFace.TextStrokeColor3 = C.Accent
vhFace.TextStrokeTransparency = 0
vhFace.ZIndex = 14
vhFace.Parent = logoHolder
registerTheme(vhFace, "Accent", "TextStrokeColor3")  -- ⭐ TAMBAH INI

-- ⚡ EFEK PETIR MERAH ⚡
local lightningHolder = Instance.new("Frame")
lightningHolder.Size = UDim2.fromScale(1, 1)
lightningHolder.BackgroundTransparency = 1
lightningHolder.ClipsDescendants = true
lightningHolder.ZIndex = 15
lightningHolder.Parent = logoHolder

task.spawn(function()
    while logoHolder.Parent do
        task.wait(math.random(10, 25) / 10) -- Jeda acak
        if not logoHolder.Parent then break end
        
        -- Bikin garis petir
        local bolt = Instance.new("Frame")
        bolt.AnchorPoint = Vector2.new(0.5, 0.5)
        bolt.Size = UDim2.fromOffset(1.5, math.random(8, 12))
        bolt.Position = UDim2.fromScale(math.random(20, 80)/100, math.random(20, 80)/100)
        bolt.Rotation = math.random(-45, 45)
        bolt.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- MERAH NYALA
        bolt.BorderSizePixel = 0
        bolt.ZIndex = 16
        bolt.Parent = lightningHolder
        
        -- Animasi kilat hilang
        task.wait(0.05)
        bolt.BackgroundTransparency = 1
        task.wait(0.05)
        if bolt then bolt:Destroy() end
    end
end)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 300, 0, 20)
    title.Position = UDim2.fromOffset(IS_MOBILE and 48 or 58, IS_MOBILE and 8 or 10)
    title.BackgroundTransparency = 1
    title.Text = "VRILZHUB"
    title.TextColor3 = C.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = IS_MOBILE and 13 or 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 11
    title.Parent = header
    registerTheme(title, "Text", "TextColor3")

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 300, 0, 14)
    subtitle.Position = UDim2.fromOffset(IS_MOBILE and 48 or 58, IS_MOBILE and 26 or 28)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Ride a Pet · v2.4"
    subtitle.TextColor3 = C.Muted
    subtitle.Font = Enum.Font.GothamSemibold
    subtitle.TextSize = IS_MOBILE and 9 or 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 11
    subtitle.Parent = header
    registerTheme(subtitle, "Muted", "TextColor3")

    -- PLAYER PROFILE CHIP
    local profile = Instance.new("Frame")
    profile.Name = "PlayerProfile"
    local headerGap = IS_MOBILE and 10 or 14
    local closeW = IS_MOBILE and 28 or 32
    local minW = IS_MOBILE and 28 or 32
    local closeRight = IS_MOBILE and 8 or 10
    local closeLeft = -(closeRight + closeW)
    local minLeft = closeLeft - headerGap - minW
    local profileRight = minLeft - headerGap

    profile.Size = UDim2.fromOffset(IS_MOBILE and 126 or 168, IS_MOBILE and 34 or 38)
    profile.AnchorPoint = Vector2.new(1, 0.5)
    profile.Position = UDim2.new(1, profileRight, 0.5, 0)
    profile.BackgroundColor3 = C.Surface2
    profile.BorderSizePixel = 0
    profile.ZIndex = 12
    profile.Parent = header
    registerTheme(profile, "Surface2", "BackgroundColor3")
    local profileCorner = Instance.new("UICorner")
    profileCorner.CornerRadius = UDim.new(1, 0)
    profileCorner.Parent = profile
    local profileStroke = Instance.new("UIStroke")
    profileStroke.Color = C.Accent
    profileStroke.Thickness = 1
    profileStroke.Transparency = 0.45
    profileStroke.Parent = profile
    registerTheme(profileStroke, "Accent", "Color")

    local profileAvatar = Instance.new("ImageLabel")
    profileAvatar.Size = UDim2.fromOffset(IS_MOBILE and 27 or 31, IS_MOBILE and 27 or 31)
    profileAvatar.Position = UDim2.fromOffset(4, IS_MOBILE and 3.5 or 3.5)
    profileAvatar.BackgroundColor3 = C.Surface3
    profileAvatar.BorderSizePixel = 0
    profileAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    profileAvatar.ZIndex = 13
    profileAvatar.Parent = profile
    local profileAvatarCorner = Instance.new("UICorner")
    profileAvatarCorner.CornerRadius = UDim.new(1, 0)
    profileAvatarCorner.Parent = profileAvatar
    local profileAvatarStroke = Instance.new("UIStroke")
    profileAvatarStroke.Color = C.Accent2
    profileAvatarStroke.Thickness = 1
    profileAvatarStroke.Parent = profileAvatar
    registerTheme(profileAvatarStroke, "Accent2", "Color")

    local profileName = Instance.new("TextLabel")
    profileName.Size = UDim2.new(1, -(IS_MOBILE and 60 or 68), 0, 16)
    profileName.Position = UDim2.fromOffset(IS_MOBILE and 37 or 43, 4)
    profileName.BackgroundTransparency = 1
    profileName.Text = LocalPlayer.DisplayName
    profileName.TextColor3 = C.Text
    profileName.Font = Enum.Font.GothamBold
    profileName.TextSize = IS_MOBILE and 10 or 11
    profileName.TextXAlignment = Enum.TextXAlignment.Left
    profileName.TextTruncate = Enum.TextTruncate.AtEnd
    profileName.ZIndex = 13
    profileName.Parent = profile
    registerTheme(profileName, "Text", "TextColor3")

    local profileUser = Instance.new("TextLabel")
    profileUser.Size = UDim2.new(1, -(IS_MOBILE and 60 or 68), 0, 12)
    profileUser.Position = UDim2.fromOffset(IS_MOBILE and 37 or 43, 20)
    profileUser.BackgroundTransparency = 1
    profileUser.Text = "@" .. LocalPlayer.Name
    profileUser.TextColor3 = C.Muted
    profileUser.Font = Enum.Font.GothamSemibold
    profileUser.TextSize = IS_MOBILE and 8 or 9
    profileUser.TextXAlignment = Enum.TextXAlignment.Left
    profileUser.TextTruncate = Enum.TextTruncate.AtEnd
    profileUser.ZIndex = 13
    profileUser.Parent = profile
    registerTheme(profileUser, "Muted", "TextColor3")

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(minW, IS_MOBILE and 28 or 32)
    minBtn.Position = UDim2.new(1, minLeft, 0.5, -(IS_MOBILE and 14 or 16))
    minBtn.BackgroundColor3 = C.Surface3
    minBtn.Text = "−"
    minBtn.TextColor3 = C.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = IS_MOBILE and 18 or 20
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 14
    minBtn.Parent = header
    registerTheme(minBtn, "Surface3", "BackgroundColor3")
    registerTheme(minBtn, "Text", "TextColor3")

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(1, 0)
    minCorner.Parent = minBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(closeW, IS_MOBILE and 28 or 32)
    closeBtn.Position = UDim2.new(1, closeLeft, 0.5, -(IS_MOBILE and 14 or 16))
    closeBtn.BackgroundColor3 = C.Surface3
    closeBtn.Text = "×"
    closeBtn.TextColor3 = C.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = IS_MOBILE and 20 or 22
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 14
    closeBtn.Parent = header
    registerTheme(closeBtn, "Surface3", "BackgroundColor3")
    registerTheme(closeBtn, "Text", "TextColor3")

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(1, 0)
    closeCorner.Parent = closeBtn

    -- BODY
    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -20, 1, -(CFG.HEADER_H + 20))
    body.Position = UDim2.new(0, 10, 0, CFG.HEADER_H + 10)
    body.BackgroundTransparency = 1
    body.ZIndex = 2
    body.Parent = main

    local sidebarW = CFG.SIDEBAR_W
    -- SIDEBAR CONTAINER
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, sidebarW, 1, 0)
    sidebar.BackgroundColor3 = C.Surface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 3
    sidebar.ClipsDescendants = true
    sidebar.Parent = body
    registerTheme(sidebar, "Surface", "BackgroundColor3")
    sidebar.BackgroundTransparency = 0.5

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 14)
    sidebarCorner.Parent = sidebar

    local sidebarStroke = Instance.new("UIStroke")
    sidebarStroke.Color = C.Accent
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = 0.7
    sidebarStroke.Parent = sidebar
    registerTheme(sidebarStroke, "Accent", "Color")

    local sidebarGlow = Instance.new("Frame")
    sidebarGlow.Size = UDim2.new(1, -18, 0, 2)
    sidebarGlow.Position = UDim2.fromOffset(9, 1)
    sidebarGlow.BackgroundColor3 = C.Accent2
    sidebarGlow.BackgroundTransparency = 0.1
    sidebarGlow.BorderSizePixel = 0
    sidebarGlow.ZIndex = 5
    sidebarGlow.Parent = sidebar
    local sidebarGlowCorner = Instance.new("UICorner")
    sidebarGlowCorner.CornerRadius = UDim.new(1, 0)
    sidebarGlowCorner.Parent = sidebarGlow
    registerTheme(sidebarGlow, "Accent2", "BackgroundColor3")

    -- SCROLLING FRAME DI DALAM SIDEBAR
    local sidebarScroll = Instance.new("ScrollingFrame")
    sidebarScroll.Size = UDim2.fromScale(1, 1)
    sidebarScroll.BackgroundTransparency = 1
    sidebarScroll.BorderSizePixel = 0
    sidebarScroll.ScrollBarThickness = 2
    sidebarScroll.ScrollBarImageColor3 = C.Accent
    sidebarScroll.ScrollBarImageTransparency = 0.5
    sidebarScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    sidebarScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sidebarScroll.ZIndex = 4
    sidebarScroll.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 4)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebarScroll

    local sidebarPad = Instance.new("UIPadding")
    sidebarPad.PaddingTop = UDim.new(0, IS_MOBILE and 6 or 10)
    sidebarPad.PaddingBottom = UDim.new(0, IS_MOBILE and 6 or 10)
    sidebarPad.PaddingLeft = UDim.new(0, 6)
    sidebarPad.PaddingRight = UDim.new(0, 6)
    sidebarPad.Parent = sidebarScroll

    local pageHolder = Instance.new("ScrollingFrame")
    pageHolder.Size = UDim2.new(1, -(sidebarW + 10), 1, 0)
    pageHolder.Position = UDim2.new(0, sidebarW + 10, 0, 0)
    pageHolder.BackgroundTransparency = 1
    pageHolder.BorderSizePixel = 0
    pageHolder.ScrollBarThickness = 4
    pageHolder.ScrollBarImageColor3 = C.Accent
    pageHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    pageHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
    pageHolder.ZIndex = 3
    pageHolder.Parent = body
    registerTheme(pageHolder, "Accent", "ScrollBarImageColor3")

    local pageHolderPad = Instance.new("UIPadding")
    pageHolderPad.PaddingTop = UDim.new(0, 4)
    pageHolderPad.PaddingBottom = UDim.new(0, 40)
    pageHolderPad.PaddingLeft = UDim.new(0, IS_MOBILE and 6 or 10)
    pageHolderPad.PaddingRight = UDim.new(0, IS_MOBILE and 6 or 10)
    pageHolderPad.Parent = pageHolder

        -- Resize handle (PC + Mobile)
do
        local resizeHandle = Instance.new("TextButton")
    local handleSize = IS_MOBILE and 32 or 22
    resizeHandle.Size = UDim2.fromOffset(handleSize, handleSize)
    resizeHandle.Position = UDim2.new(1, -handleSize, 1, -handleSize) -- ⭐ Mentok di pojok
    resizeHandle.AnchorPoint = Vector2.new(1, 1)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Text = "" -- ⭐ Hapus teksnya
    resizeHandle.TextColor3 = Color3.fromRGB(0, 0, 0) -- ⭐ Jadiin item (transparan)
    resizeHandle.TextSize = IS_MOBILE and 22 or 17
    resizeHandle.Font = Enum.Font.GothamBold
    resizeHandle.AutoButtonColor = false
    resizeHandle.Active = false
    resizeHandle.ZIndex = 100
    resizeHandle.Parent = main
    -- (registerTheme dihapus biar gak ada warna orange)

    -- Hit target lebih gede biar gampang di-tap di HP
    local hitPad = Instance.new("TextButton")
    hitPad.AnchorPoint = Vector2.new(1, 1)
    hitPad.Size = UDim2.fromOffset(handleSize + 14, handleSize + 14)
    hitPad.Position = UDim2.new(1, 0, 1, 0) -- ⭐ Mentok 100% di pojok kanan bawah
    hitPad.BackgroundTransparency = 1
    hitPad.Text = ""
    hitPad.AutoButtonColor = false
    hitPad.Active = true
    hitPad.ZIndex = 200
    hitPad.Parent = main
    
    local resizing = false
    local resizeStart = nil
    local startSize = nil
    local resizeInput = nil

    local function isResizeInput(i)
        return i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch
    end

    hitPad.InputBegan:Connect(function(i)
        if not isResizeInput(i) then return end
        if resizing then return end  -- ⭐ FIX: jangan re-trigger

        resizing = true
        resizeStart = i.Position
        startSize = main.Size
        resizeInput = i
    end)

    -- ⭐ FIX: reset via global InputEnded, gak peduli End state
    UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
        resizing = false
        resizeInput = nil
        resizeStart = nil
        startSize = nil
    end
end)

    UserInputService.InputChanged:Connect(function(i)
    if not resizing then return end
    if i.UserInputType ~= Enum.UserInputType.MouseMovement
        and i.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    if not resizeStart or not startSize then return end

    local deltaX = i.Position.X - resizeStart.X
    local deltaY = i.Position.Y - resizeStart.Y

    local minW = IS_MOBILE and 260 or 600
    local minH = IS_MOBILE and 300 or 400
    local maxW = IS_MOBILE and (viewport.X - 8) or 1200
    local maxH = IS_MOBILE and (viewport.Y - 20) or 800

    local newX = math.clamp(startSize.X.Offset + deltaX, minW, maxW)
    local newY = math.clamp(startSize.Y.Offset + deltaY, minH, maxH)
    main.Size = UDim2.fromOffset(newX, newY)
end)
    end
        
    -- OPEN BUTTON
    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.fromOffset(CFG.OPEN_BTN, CFG.OPEN_BTN)
    openBtn.Position = UDim2.fromOffset(20, 20)
    openBtn.BackgroundColor3 = C.Surface
    openBtn.Text = ""
    openBtn.TextColor3 = C.Accent
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = IS_MOBILE and 14 or 16
    openBtn.BorderSizePixel = 0
    openBtn.Visible = false
    openBtn.ZIndex = 400
    openBtn.Parent = screenGui
    registerTheme(openBtn, "Surface", "BackgroundColor3")
    registerTheme(openBtn, "Accent", "TextColor3")

    local openCorner = Instance.new("UICorner")
    openCorner.CornerRadius = UDim.new(0, 16)
    openCorner.Parent = openBtn

    local openGradient = Instance.new("UIGradient")
    openGradient.Rotation = 135
    openGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 11, 14)),
    })
    openGradient.Parent = openBtn

    local openStroke = Instance.new("UIStroke")
    openStroke.Color = C.Accent
    openStroke.Thickness = 2
    openStroke.Transparency = 0.3
    openStroke.Parent = openBtn

    -- MINIMIZE ICON ONLY: clearer VH + lightweight lightning effect
    local vhShadow = Instance.new("TextLabel")
    vhShadow.Name = "VH3DShadow"
    vhShadow.Size = UDim2.fromScale(1, 1)
    vhShadow.Position = UDim2.fromOffset(2, 3)
    vhShadow.BackgroundTransparency = 1
    vhShadow.Text = "VH"
    vhShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    vhShadow.TextTransparency = 0.05
    vhShadow.TextSize = IS_MOBILE and 22 or 26
    vhShadow.Font = Enum.Font.GothamBlack
    vhShadow.ZIndex = 401
    vhShadow.Parent = openBtn

    local vhDepth = Instance.new("TextLabel")
    vhDepth.Name = "VH3DDepth"
    vhDepth.Size = UDim2.fromScale(1, 1)
    vhDepth.Position = UDim2.fromOffset(1, 1)
    vhDepth.BackgroundTransparency = 1
    vhDepth.Text = "VH"
    vhDepth.TextColor3 = C.Accent
    vhDepth.TextTransparency = 0
    vhDepth.TextSize = IS_MOBILE and 22 or 26
    vhDepth.Font = Enum.Font.GothamBlack
    vhDepth.ZIndex = 402
    vhDepth.Parent = openBtn
    registerTheme(vhDepth, "Accent", "TextColor3")

    local vhFace = Instance.new("TextLabel")
    vhFace.Name = "VH3DFace"
    vhFace.Size = UDim2.fromScale(1, 1)
    vhFace.Position = UDim2.fromOffset(0, 0)
    vhFace.BackgroundTransparency = 1
    vhFace.Text = "VH"
    vhFace.TextColor3 = Color3.fromRGB(255, 255, 255)
    vhFace.TextSize = IS_MOBILE and 22 or 26
    vhFace.Font = Enum.Font.GothamBlack
    vhFace.TextStrokeColor3 = C.Accent
    vhFace.TextStrokeTransparency = 0
    vhFace.ZIndex = 403
    vhFace.Parent = openBtn
    registerTheme(vhFace, "Accent", "TextStrokeColor3")

        local lightningLoopThread = nil -- ⚡ Variabel buat nyimpen thread loop

    local function playMinimizeLightning()
        -- Matiin loop sebelumnya kalau ada
        if lightningLoopThread then
            task.cancel(lightningLoopThread)
            lightningLoopThread = nil
        end

        -- Mulai loop petir merah nyambar terus-terusan
        lightningLoopThread = task.spawn(function()
            while openBtn.Visible do
                -- 1. Efek Getar VH
                local origPos = openBtn.Position
                task.spawn(function()
                    for i = 1, 4 do
                        openBtn.Position = origPos + UDim2.fromOffset(math.random(-3, 3), math.random(-3, 3))
                        task.wait(0.03)
                    end
                    openBtn.Position = origPos
                end)

                -- 2. Efek Petir Merah
                local holder = Instance.new("Frame")
                holder.Name = "MinimizeLightning"
                holder.Size = UDim2.fromScale(1, 1)
                holder.BackgroundTransparency = 1
                holder.ClipsDescendants = true
                holder.ZIndex = 410
                holder.Parent = openBtn

                local segments = {
                    {0.46, 0.18, 18, -28},
                    {0.56, 0.39, 15, 24},
                    {0.48, 0.58, 16, -22},
                    {0.57, 0.77, 13, 26},
                }

                for _, seg in ipairs(segments) do
                    local bolt = Instance.new("Frame")
                    bolt.AnchorPoint = Vector2.new(0.5, 0.5)
                    bolt.Size = UDim2.fromOffset(2, seg[3])
                    bolt.Position = UDim2.fromScale(seg[1], seg[2])
                    bolt.Rotation = seg[4]
                    bolt.BackgroundColor3 = Color3.fromRGB(255, 30, 30) -- ⚡ MERAH
                    bolt.BorderSizePixel = 0
                    bolt.ZIndex = 411
                    bolt.Parent = holder
                    local bc = Instance.new("UICorner")
                    bc.CornerRadius = UDim.new(1, 0)
                    bc.Parent = bolt
                end

                -- 3. Kilatan Merah
                local flash = Instance.new("Frame")
                flash.Size = UDim2.fromScale(1, 1)
                flash.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                flash.BackgroundTransparency = 0.8
                flash.BorderSizePixel = 0
                flash.ZIndex = 410
                flash.Parent = holder
                local fc = Instance.new("UICorner")
                fc.CornerRadius = UDim.new(0, 16)
                fc.Parent = flash

                -- 4. Animasi Hilang
                TweenService:Create(flash, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
                for _, child in ipairs(holder:GetChildren()) do
                    if child:IsA("Frame") and child ~= flash then
                        TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                    end
                end
                
                -- Jeda sebelum nyambar lagi (acak biar natural)
                task.wait(math.random(3, 10) / 10) 
                if holder then holder:Destroy() end

                -- Jeda antar sambaran
                task.wait(math.random(5, 15) / 10)
            end
        end)
    end

    local openDrag, openDS, openSP = false, nil, nil
    openBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            openDrag = true
            openDS = i.Position
            openSP = openBtn.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if openDrag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - openDS
            openBtn.Position = UDim2.new(openSP.X.Scale, openSP.X.Offset + d.X, openSP.Y.Scale, openSP.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            openDrag = false
        end
    end)

    openBtn.MouseButton1Click:Connect(function()
        openBtn.Visible = false
        main.Visible = true
        main.Size = UDim2.fromOffset(0, 0)
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(winW, winH)
        }):Play()
    end)

    minBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.delay(0.3, function()
            main.Visible = false
            openBtn.Visible = true
            playMinimizeLightning()
        end)
    end)

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.delay(0.3, function()
            screenGui:Destroy()
        end)
    end)

    -- TAB SYSTEM
    local pages = {}
    local navs = {}

        local function registerTab(id, icon, label, isAsset)
        local tabH = CFG.TAB_H
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, tabH)
        btn.BackgroundColor3 = C.Surface3
        btn.BackgroundTransparency = 0.7
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 5
        btn.Parent = sidebarScroll
        registerTheme(btn, "Surface3", "BackgroundColor3")

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 11)
        corner.Parent = btn

        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = C.Accent
        tabStroke.Thickness = 1
        tabStroke.Transparency = 0.82
        tabStroke.Parent = btn
        registerTheme(tabStroke, "Accent", "Color")

        -- ⭐ LOGIKA BARU: Cek apakah pakai Asset ID (gambar) atau Emoji (text)
if isAsset then
    local ic = Instance.new("ImageLabel")
    if CFG.TAB_SHOW_LABEL then
        ic.Size = UDim2.fromOffset(24, 24)
        ic.Position = UDim2.fromOffset(10, (tabH - 24) / 2)
    else
        ic.Size = UDim2.fromOffset(24, 24)
        ic.Position = UDim2.new(0.5, -12, 0.5, -12)
    end
    ic.BackgroundTransparency = 1
    ic.Image = "rbxassetid://" .. icon
    ic.ImageColor3 = Color3.new(1, 1, 1)  -- ✅ putih = warna asli asset
    ic.ZIndex = 6
    ic.Parent = btn

            if CFG.TAB_SHOW_LABEL then
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -44, 1, 0)
                lbl.Position = UDim2.fromOffset(42, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = label
                lbl.TextColor3 = C.Muted
                lbl.TextSize = CFG.FONT_LABEL
                lbl.Font = Enum.Font.GothamSemibold
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.ZIndex = 6
                lbl.Parent = btn
                registerTheme(lbl, "Muted", "TextColor3")
                navs[id] = {btn = btn, ic = ic, lbl = lbl, isAsset = true}
            else
                navs[id] = {btn = btn, ic = ic, lbl = nil, isAsset = true}
            end
        else
            -- Mode lama (Emoji / Teks)
            local ic = Instance.new("TextLabel")
            if CFG.TAB_SHOW_LABEL then
                ic.Size = UDim2.fromOffset(28, tabH)
                ic.Position = UDim2.fromOffset(10, 0)
            else
                ic.Size = UDim2.fromScale(1, 1)
                ic.Position = UDim2.fromOffset(0, 0)
            end
            ic.BackgroundTransparency = 1
            ic.Text = icon
            ic.TextSize = CFG.TAB_ICON
            ic.Font = Enum.Font.GothamBold
            ic.TextColor3 = C.Accent
            ic.ZIndex = 6
            ic.Parent = btn
            registerTheme(ic, "Accent", "TextColor3")

            if CFG.TAB_SHOW_LABEL then
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -44, 1, 0)
                lbl.Position = UDim2.fromOffset(42, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = label
                lbl.TextColor3 = C.Muted
                lbl.TextSize = CFG.FONT_LABEL
                lbl.Font = Enum.Font.GothamSemibold
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.ZIndex = 6
                lbl.Parent = btn
                registerTheme(lbl, "Muted", "TextColor3")
                navs[id] = {btn = btn, ic = ic, lbl = lbl, isAsset = false}
            else
                navs[id] = {btn = btn, ic = ic, lbl = nil, isAsset = false}
            end
        end

                local function switchTo()
    if not pages or not navs then return end
    for n, p in pairs(pages) do
        if p and p.Parent then p.Visible = false end
    end
    if pages[id] and pages[id].Parent then
        pages[id].Visible = true
    end
    for n, x in pairs(navs) do
        if not x or not x.btn or not x.btn.Parent then continue end
        if n == id then
            x.btn.BackgroundColor3 = C.Accent
                    x.btn.BackgroundTransparency = 0.35
                    if x.isAsset then
                        x.ic.ImageColor3 = Color3.new(1, 1, 1)
                    else
                        x.ic.TextColor3 = Color3.new(1, 1, 1)
                    end
                    if x.btn:FindFirstChildOfClass("UIStroke") then x.btn:FindFirstChildOfClass("UIStroke").Transparency = 0.15 end
                    if x.lbl then x.lbl.TextColor3 = Color3.new(1, 1, 1) end
                else
                    x.btn.BackgroundColor3 = C.Surface3
                    x.btn.BackgroundTransparency = 0.5
                    if x.isAsset then
                        x.ic.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    else
                        x.ic.TextColor3 = C.Accent
                    end
                    if x.btn:FindFirstChildOfClass("UIStroke") then x.btn:FindFirstChildOfClass("UIStroke").Transparency = 0.82 end
                    if x.lbl then x.lbl.TextColor3 = C.Muted end
                end
            end
        end

                btn.MouseButton1Click:Connect(function()
            local ok, err = pcall(switchTo)
            if not ok then warn("[TAB] switchTo error: " .. tostring(err)) end
        end)

        -- ⭐ FIX: pastikan _G.VRILZ_SwitchTab BENERAN table
        if type(_G.VRILZ_SwitchTab) ~= "table" then
            _G.VRILZ_SwitchTab = {}
        end
        _G.VRILZ_SwitchTab[id] = switchTo
    end

    local function createPage(name)
        local page = Instance.new("ScrollingFrame")
        page.Name = name
        page.Size = UDim2.fromScale(1, 1)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 4
        page.ScrollBarImageColor3 = C.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ScrollingEnabled = true
        page.Visible = false
        page.ZIndex = 7
        page.Parent = pageHolder
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, IS_MOBILE and 8 or 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page

        -- FIX: sync canvas otomatis tiap konten berubah
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 120)
        end)
        task.defer(function()
            page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 120)
        end)

        return page
    end

-- ===== 2-COLUMN PAGE HELPER (khusus tab Info) =====
local function createTwoColumnPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Size = UDim2.fromScale(1, 1)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = C.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.ScrollingDirection = Enum.ScrollingDirection.Y
    page.ScrollingEnabled = true
    page.Visible = false
    page.ZIndex = 7
    page.Parent = pageHolder

    -- Layout horizontal: kiri | kanan
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 0)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.BackgroundTransparency = 1
    row.ZIndex = 7
    row.Parent = page

    local rowLayout = Instance.new("UIListLayout")
    rowLayout.FillDirection = Enum.FillDirection.Horizontal
    rowLayout.Padding = UDim.new(0, IS_MOBILE and 8 or 12)
    rowLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rowLayout.Parent = row

    -- Kolom kiri
    local leftCol = Instance.new("Frame")
    leftCol.Name = "LeftColumn"
    leftCol.Size = UDim2.new(0.5, -(IS_MOBILE and 4 or 6), 0, 0)
    leftCol.AutomaticSize = Enum.AutomaticSize.Y
    leftCol.BackgroundTransparency = 1
    leftCol.LayoutOrder = 1
    leftCol.ZIndex = 7
    leftCol.Parent = row

    local leftLayout = Instance.new("UIListLayout")
    leftLayout.Padding = UDim.new(0, IS_MOBILE and 8 or 12)
    leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
    leftLayout.Parent = leftCol

    -- Kolom kanan
    local rightCol = Instance.new("Frame")
    rightCol.Name = "RightColumn"
    rightCol.Size = UDim2.new(0.5, -(IS_MOBILE and 4 or 6), 0, 0)
    rightCol.AutomaticSize = Enum.AutomaticSize.Y
    rightCol.BackgroundTransparency = 1
    rightCol.LayoutOrder = 2
    rightCol.ZIndex = 7
    rightCol.Parent = row

    local rightLayout = Instance.new("UIListLayout")
    rightLayout.Padding = UDim.new(0, IS_MOBILE and 8 or 12)
    rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
    rightLayout.Parent = rightCol

    -- Sync canvas height
    local function syncCanvas()
        page.CanvasSize = UDim2.new(0, 0, 0, rowLayout.AbsoluteContentSize.Y + 120)
    end
    rowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncCanvas)
    task.defer(syncCanvas)

    return page, leftCol, rightCol
end

-- TAB INFO (2 KOLOM)
do
    local infoPage, infoLeft, infoRight = createTwoColumnPage("Info")
    pages.Info = infoPage

    -- ═══ KOLOM KIRI ═══
    local infoCard, infoContent = makeCard(infoLeft, "CLIENT INFORMATION", 1)

    local avRow = Instance.new("Frame")
    avRow.Size = UDim2.new(1, 0, 0, IS_MOBILE and 60 or 70)
    avRow.BackgroundTransparency = 1
    avRow.LayoutOrder = 1
    avRow.Parent = infoContent

    local avSz = IS_MOBILE and 50 or 60
    local avatarGlow = Instance.new("Frame")
    avatarGlow.Size = UDim2.fromOffset(avSz + 8, avSz + 8)
    avatarGlow.Position = UDim2.fromOffset(-4, 1)
    avatarGlow.BackgroundColor3 = C.Accent
    avatarGlow.BackgroundTransparency = 0.84
    avatarGlow.BorderSizePixel = 0
    avatarGlow.ZIndex = 2
    avatarGlow.Parent = avRow
    local avatarGlowCorner = Instance.new("UICorner")
    avatarGlowCorner.CornerRadius = UDim.new(1, 0)
    avatarGlowCorner.Parent = avatarGlow
    registerTheme(avatarGlow, "Accent", "BackgroundColor3")

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(avSz, avSz)
    avatar.Position = UDim2.fromOffset(0, 5)
    avatar.BackgroundColor3 = C.Surface3
    avatar.BorderSizePixel = 0
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    avatar.ZIndex = 3
    avatar.Parent = avRow

    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = avatar

    local avStroke = Instance.new("UIStroke")
    avStroke.Color = C.Accent
    avStroke.Thickness = 2.5
    avStroke.Parent = avatar
    registerTheme(avStroke, "Accent", "Color")

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, -(avSz + 15), 0, 22)
    nameLbl.Position = UDim2.fromOffset(avSz + 15, IS_MOBILE and 10 or 12)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = LocalPlayer.DisplayName
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = IS_MOBILE and 13 or 15
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    nameLbl.ZIndex = 3
    nameLbl.Parent = avRow
    registerTheme(nameLbl, "Text", "TextColor3")

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -(avSz + 15), 0, 16)
    userLbl.Position = UDim2.fromOffset(avSz + 15, IS_MOBILE and 30 or 34)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = "@" .. LocalPlayer.Name
    userLbl.TextColor3 = C.Muted
    userLbl.Font = Enum.Font.GothamSemibold
    userLbl.TextSize = IS_MOBILE and 10 or 11
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.TextTruncate = Enum.TextTruncate.AtEnd
    userLbl.ZIndex = 3
    userLbl.Parent = avRow
    registerTheme(userLbl, "Muted", "TextColor3")

    local sessionLbl = Instance.new("TextLabel")
    sessionLbl.Size = UDim2.new(1, 0, 0, 20)
    sessionLbl.BackgroundTransparency = 1
    sessionLbl.Text = "Session: 00:00"
    sessionLbl.TextColor3 = C.Accent2
    sessionLbl.Font = Enum.Font.GothamBold
    sessionLbl.TextSize = CFG.FONT_LABEL
    sessionLbl.TextXAlignment = Enum.TextXAlignment.Left
    sessionLbl.LayoutOrder = 2
    sessionLbl.ZIndex = 3
    sessionLbl.Parent = infoContent
    registerTheme(sessionLbl, "Accent2", "TextColor3")

    local keyTypeLbl = Instance.new("TextLabel")
    keyTypeLbl.Size = UDim2.new(1, 0, 0, 20)
    keyTypeLbl.BackgroundTransparency = 1
    keyTypeLbl.Text = "Key Type: " .. tostring(Shared.KeyType or "UNKNOWN")
    keyTypeLbl.TextColor3 = C.Text
    keyTypeLbl.Font = Enum.Font.GothamBold
    keyTypeLbl.TextSize = CFG.FONT_LABEL
    keyTypeLbl.TextXAlignment = Enum.TextXAlignment.Left
    keyTypeLbl.LayoutOrder = 3
    keyTypeLbl.ZIndex = 3
    keyTypeLbl.Parent = infoContent
    registerTheme(keyTypeLbl, "Text", "TextColor3")

    local keyExpiryLbl = Instance.new("TextLabel")
    keyExpiryLbl.Size = UDim2.new(1, 0, 0, 20)
    keyExpiryLbl.BackgroundTransparency = 1
    keyExpiryLbl.TextColor3 = C.Muted
    keyExpiryLbl.Font = Enum.Font.GothamSemibold
    keyExpiryLbl.TextSize = CFG.FONT_LABEL
    keyExpiryLbl.TextXAlignment = Enum.TextXAlignment.Left
    keyExpiryLbl.LayoutOrder = 4
    keyExpiryLbl.ZIndex = 3
    keyExpiryLbl.Parent = infoContent
    registerTheme(keyExpiryLbl, "Muted", "TextColor3")

    local function refreshKeyInfo()
        local keyType = tostring(Shared.KeyType or "UNKNOWN"):upper()
        local expiresAt = tonumber(Shared.KeyExpiresAt or 0) or 0
        keyTypeLbl.Text = "Key Type: " .. keyType
        if expiresAt > 0 then
            local secondsLeft = math.max(0, math.floor(expiresAt / 1000 - os.time()))
            local days = math.floor(secondsLeft / 86400)
            local hours = math.floor((secondsLeft % 86400) / 3600)
            local mins = math.floor((secondsLeft % 3600) / 60)
            local expiryText = os.date("%d/%m/%Y %H:%M:%S", math.floor(expiresAt / 1000))
            keyExpiryLbl.Text = string.format("Expired: %s\nRemaining: %dd %02dj %02dm", expiryText, days, hours, mins)
            if secondsLeft <= 0 then
                keyExpiryLbl.Text = "Expired: KEY EXPIRED"
                keyExpiryLbl.TextColor3 = C.Error
            else
                keyExpiryLbl.TextColor3 = C.Muted
            end
        else
            keyExpiryLbl.Text = "Expired: -"
        end
    end
    refreshKeyInfo()

    local sessionStart = os.clock()
    task.spawn(function()
        while sessionLbl.Parent do
            task.wait(1)
            local elapsed = math.floor(os.clock() - sessionStart)
            local m = math.floor(elapsed / 60)
            local s = elapsed % 60
            sessionLbl.Text = string.format("Session: %02d:%02d", m, s)
        end
    end)

    -- ⭐ Card update info (kiri bawah)
    local updateCard, updateContent = makeCard(infoLeft, "📢 UPDATE INFORMATION", 2)

    local infoLines = {
        "Version        : 2.4",
        "Last Update    : 24 Okt 2026",
        "Status         : Online ✅",
        "Changelog      : Fly Chard, Webhook, Auto Crash",
        "                  Auto Event, Auto Yin, Auto Obby",
    }
    for i, line in ipairs(infoLines) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.Text = line
        lbl.TextColor3 = C.Muted
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = CFG.FONT_MUTED
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextWrapped = true
        lbl.LayoutOrder = i
        lbl.ZIndex = 3
        lbl.Parent = updateContent
        registerTheme(lbl, "Muted", "TextColor3")
    end

    -- ═══ KOLOM KANAN ═══
    local explCard, explContent = makeCard(infoRight, "🎮 EXPLOIT SUPPORT", 1)

    local explLines = {
    "✅ Delta       ✅ Fluxus",
    "✅ Xeno        ✅ Codex",
    "✅ Solara      ✅ Wave",
    "✅ Madium      ✅ Real",
    "✅ Potasium    ✅ AWP",
    "✅ Hydrogen    ✅ Velocity",
    "✅ Wave        ✅ Swift",
    "✅ Trigon      ✅ Cryptic",
    "✅ Arceus      ✅ Nihon",
}
    for i, line in ipairs(explLines) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 14)
        lbl.BackgroundTransparency = 1
        lbl.Text = line
        lbl.TextColor3 = C.Muted
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = CFG.FONT_MUTED
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = i
        lbl.ZIndex = 3
        lbl.Parent = explContent
        registerTheme(lbl, "Muted", "TextColor3")
    end

    -- ⭐ Discord card (kanan bawah)
    local discordCard, discordContent = makeCard(infoRight, "💬 JOIN DISCORD", 2)
    local DISCORD_LINK = "https://discord.gg/psWhrYWbq"

    local discordLinkLbl = Instance.new("TextLabel")
    discordLinkLbl.Size = UDim2.new(1, 0, 0, 18)
    discordLinkLbl.BackgroundTransparency = 1
    discordLinkLbl.Text = "discord.gg/psWhrYWbq"
    discordLinkLbl.TextColor3 = C.Accent
    discordLinkLbl.Font = Enum.Font.GothamBold
    discordLinkLbl.TextSize = CFG.FONT_LABEL
    discordLinkLbl.TextXAlignment = Enum.TextXAlignment.Center
    discordLinkLbl.LayoutOrder = 1
    discordLinkLbl.ZIndex = 3
    discordLinkLbl.Parent = discordContent
    registerTheme(discordLinkLbl, "Accent", "TextColor3")

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, 0, 0, 32)
    discordBtn.BackgroundColor3 = C.Accent
    discordBtn.Text = "[ CLICK TO JOIN ]"
    discordBtn.TextColor3 = Color3.new(1, 1, 1)
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = CFG.FONT_LABEL
    discordBtn.AutoButtonColor = false
    discordBtn.LayoutOrder = 2
    discordBtn.ZIndex = 3
    discordBtn.Parent = discordContent
    registerTheme(discordBtn, "Accent", "BackgroundColor3")

    local discordBtnCorner = Instance.new("UICorner")
    discordBtnCorner.CornerRadius = UDim.new(0, 8)
    discordBtnCorner.Parent = discordBtn

    discordBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(DISCORD_LINK) end)
        notify("✓ Discord link copied!", "success")
    end)
end

    -- Lightweight 3D egg preview used only by the prediction/info cards.
    -- It reads an existing rendered egg model when available and falls back to a simple 3D egg.
    local function makeEggPreview(parent, eggName)
        local viewport = Instance.new("ViewportFrame")
        viewport.Name = "Egg3DPreview"
        viewport.Size = UDim2.fromOffset(IS_MOBILE and 42 or 48, IS_MOBILE and 42 or 48)
        viewport.BackgroundColor3 = C.Surface
        viewport.BackgroundTransparency = 0.08
        viewport.BorderSizePixel = 0
        viewport.ZIndex = 5
        viewport.Ambient = Color3.fromRGB(190, 200, 215)
        viewport.LightColor = Color3.fromRGB(255, 255, 255)
        viewport.LightDirection = Vector3.new(-1, -1, -1)
        viewport.Parent = parent

        local vc = Instance.new("UICorner")
        vc.CornerRadius = UDim.new(0, 12)
        vc.Parent = viewport

        local vs = Instance.new("UIStroke")
        vs.Color = C.Accent
        vs.Thickness = 1
        vs.Transparency = 0.35
        vs.Parent = viewport
        registerTheme(vs, "Accent", "Color")

        local world = Instance.new("WorldModel")
        world.Parent = viewport

        local camera = Instance.new("Camera")
        camera.FieldOfView = 38
        camera.Parent = viewport
        viewport.CurrentCamera = camera

        local source
        local rendered = Workspace:FindFirstChild("RenderedEggs")
        if rendered then
            source = rendered:FindFirstChild(eggName)
        end
        if not source then
            local ok, descendants = pcall(function() return Workspace:GetDescendants() end)
            if ok then
                for _, obj in ipairs(descendants) do
                    if obj:IsA("Model") and obj.Name == eggName then
                        source = obj
                        break
                    end
                end
            end
        end

        local model
        if source and source:IsA("Model") then
            local ok, clone = pcall(function() return source:Clone() end)
            if ok and clone then model = clone end
        end

        if not model then
            model = Instance.new("Model")
            model.Name = eggName .. "_Preview"
            local egg = Instance.new("Part")
            egg.Name = "Egg"
            egg.Shape = Enum.PartType.Ball
            egg.Size = Vector3.new(2.2, 2.6, 2.2)
            egg.Material = Enum.Material.SmoothPlastic
            egg.Color = C.Surface3
            egg.Anchored = true
            egg.CanCollide = false
            egg.Parent = model
        end

        for _, obj in ipairs(model:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Anchored = true
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = false
            elseif obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                obj:Destroy()
            end
        end
        model.Parent = world

        local okBounds, boundsCFrame, boundsSize = pcall(function()
            return model:GetBoundingBox()
        end)
        if not okBounds or boundsSize.Magnitude <= 0 then
            boundsCFrame = CFrame.new()
            boundsSize = Vector3.new(2, 2, 2)
        end

        pcall(function()
            model:PivotTo(CFrame.new(-boundsCFrame.Position) * model:GetPivot())
        end)

        local radius = math.max(boundsSize.X, boundsSize.Y, boundsSize.Z) * 0.72
        local distance = math.max(4.5, radius / math.tan(math.rad(camera.FieldOfView / 2)))
        camera.CFrame = CFrame.lookAt(Vector3.new(distance * 0.72, radius * 0.18, distance), Vector3.new(0, 0, 0))

        return viewport
    end

        -- ============================================================
    -- BUILD LIVE CHAT WINDOW (TERPISAH)
    -- ============================================================
    local function buildLiveChatWindow(screenGui)
        print("[CHAT] buildLiveChatWindow START")

        local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
        local isMob = IS_MOBILE

        local winW = isMob and math.min(340, viewport.X - 32) or math.min(520, math.floor(viewport.X * 0.55))
        local winH = isMob and math.min(420, viewport.Y - 160) or 520

        -- ===== WINDOW UTAMA =====
        local win = Instance.new("Frame")
        win.Name = "LiveChatWindow"
        win.AnchorPoint = Vector2.new(0.5, 0.5)
        win.Position = UDim2.fromScale(0.5, 0.5)
        win.Size = UDim2.fromOffset(winW, winH)
        win.BackgroundColor3 = C.BG
        win.BorderSizePixel = 0
        win.Visible = false
        win.ZIndex = 600
        win.Parent = screenGui
        registerTheme(win, "BG", "BackgroundColor3")

        -- Shadow
        local shadow = Instance.new("Frame")
        shadow.Size = UDim2.new(1, 20, 1, 20)
        shadow.Position = UDim2.fromOffset(-10, -10)
        shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        shadow.BackgroundTransparency = 0.5
        shadow.BorderSizePixel = 0
        shadow.ZIndex = 599
        shadow.Parent = win
        local shadowCorner = Instance.new("UICorner")
        shadowCorner.CornerRadius = UDim.new(0, 20)
        shadowCorner.Parent = shadow

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 16)
        corner.Parent = win

        local stroke = Instance.new("UIStroke")
        stroke.Color = C.Accent
        stroke.Thickness = 2.2
        stroke.Transparency = 0.15
        stroke.Parent = win
        registerTheme(stroke, "Accent", "Color")

        local gradient = Instance.new("UIGradient")
        gradient.Rotation = 90
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 23, 28)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 9, 12)),
        })
        gradient.Parent = win

        -- ===== HEADER =====
        local headerH = 42
        local header = Instance.new("Frame")
        header.Size = UDim2.new(1, 0, 0, headerH)
        header.BackgroundColor3 = C.Surface
        header.BorderSizePixel = 0
        header.ZIndex = 610
        header.Parent = win
        registerTheme(header, "Surface", "BackgroundColor3")

        local headerCorner = Instance.new("UICorner")
        headerCorner.CornerRadius = UDim.new(0, 16)
        headerCorner.Parent = header

        local headerFix = Instance.new("Frame")
        headerFix.Size = UDim2.new(1, 0, 0, 16)
        headerFix.Position = UDim2.new(0, 0, 1, -16)
        headerFix.BackgroundColor3 = C.Surface
        headerFix.BorderSizePixel = 0
        headerFix.ZIndex = 610
        headerFix.Parent = header

        local headerGlow = Instance.new("Frame")
        headerGlow.Size = UDim2.new(1, -20, 0, 2)
        headerGlow.Position = UDim2.new(0, 10, 1, -2)
        headerGlow.BackgroundColor3 = C.Accent
        headerGlow.BackgroundTransparency = 0.15
        headerGlow.BorderSizePixel = 0
        headerGlow.ZIndex = 612
        headerGlow.Parent = header
        local hgc = Instance.new("UICorner")
        hgc.CornerRadius = UDim.new(1, 0)
        hgc.Parent = headerGlow
        registerTheme(headerGlow, "Accent", "BackgroundColor3")

        local dot = Instance.new("Frame")
        dot.Size = UDim2.fromOffset(10, 10)
        dot.Position = UDim2.new(0, 12, 0.5, -5)
        dot.BackgroundColor3 = C.Accent
        dot.BorderSizePixel = 0
        dot.ZIndex = 613
        dot.Parent = header
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot
        registerTheme(dot, "Accent", "BackgroundColor3")

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, -100, 1, 0)
        titleLbl.Position = UDim2.fromOffset(30, 0)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = "💬 LIVE CHAT (GLOBAL)"
        titleLbl.TextColor3 = C.Text
        titleLbl.Font = Enum.Font.GothamBold
        titleLbl.TextSize = isMob and 12 or 13
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.ZIndex = 613
        titleLbl.Parent = header
        registerTheme(titleLbl, "Text", "TextColor3")

        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.fromOffset(28, 28)
        closeBtn.Position = UDim2.new(1, -36, 0.5, -14)
        closeBtn.BackgroundColor3 = C.Surface3
        closeBtn.Text = "×"
        closeBtn.TextColor3 = C.Text
        closeBtn.Font = Enum.Font.GothamBold
        closeBtn.TextSize = 18
        closeBtn.BorderSizePixel = 0
        closeBtn.ZIndex = 613
        closeBtn.Parent = header
        registerTheme(closeBtn, "Surface3", "BackgroundColor3")
        registerTheme(closeBtn, "Text", "TextColor3")
        local closeCorner = Instance.new("UICorner")
        closeCorner.CornerRadius = UDim.new(1, 0)
        closeCorner.Parent = closeBtn

        closeBtn.MouseButton1Click:Connect(function()
            win.Visible = false
        end)

                -- Drag window via header
        local dragging = false
        local dragStart = nil
        local startPos = nil
        local dragInput = nil   -- ⭐ FIX: deklarasi lokal

        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then return end
                dragging = true
                dragStart = input.Position
                startPos = win.Position   -- ⭐ FIX: pakai `win`, bukan `main`
                dragInput = input
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if dragInput == input then
                dragging = false
                dragInput = nil
                dragStart = nil
                startPos = nil
            end
        end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    if not dragStart or not startPos then return end

    local delta = input.Position - dragStart
    main.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end)

        UserInputService.InputEnded:Connect(function(input)
            if dragInput == input then
                dragging = false
                dragInput = nil
                dragStart = nil
                startPos = nil
            end
        end)
        
        -- ===== BODY =====
        local body = Instance.new("Frame")
        body.Size = UDim2.new(1, -20, 1, -(headerH + 16))
        body.Position = UDim2.new(0, 10, 0, headerH + 8)
        body.BackgroundTransparency = 1
        body.ZIndex = 605
        body.Parent = win

        -- List
        local listFrame = Instance.new("ScrollingFrame")
        listFrame.Size = UDim2.new(1, 0, 1, -50)
        listFrame.Position = UDim2.new(0, 0, 0, 0)
        listFrame.BackgroundColor3 = C.Surface2
        listFrame.BackgroundTransparency = 0.4
        listFrame.BorderSizePixel = 0
        listFrame.ScrollBarThickness = 4
        listFrame.ScrollBarImageColor3 = C.Accent
        listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listFrame.ZIndex = 606
        listFrame.Parent = body
        registerTheme(listFrame, "Surface2", "BackgroundColor3")

        local lc = Instance.new("UICorner")
        lc.CornerRadius = UDim.new(0, 12)
        lc.Parent = listFrame

        local ls = Instance.new("UIStroke")
        ls.Color = C.Accent
        ls.Thickness = 1
        ls.Transparency = 0.65
        ls.Parent = listFrame
        registerTheme(ls, "Accent", "Color")

        local lp = Instance.new("UIPadding")
        lp.PaddingTop = UDim.new(0, 8)
        lp.PaddingBottom = UDim.new(0, 8)
        lp.PaddingLeft = UDim.new(0, 8)
        lp.PaddingRight = UDim.new(0, 8)
        lp.Parent = listFrame

        local ll = Instance.new("UIListLayout")
        ll.Padding = UDim.new(0, 6)
        ll.SortOrder = Enum.SortOrder.LayoutOrder
        ll.Parent = listFrame

        local emptyLbl = Instance.new("TextLabel")
        emptyLbl.Size = UDim2.new(1, 0, 0, 40)
        emptyLbl.BackgroundTransparency = 1
        emptyLbl.Text = "No messages yet... say hi! 👋"
        emptyLbl.TextColor3 = C.Muted
        emptyLbl.Font = Enum.Font.GothamSemibold
        emptyLbl.TextSize = CFG.FONT_LABEL
        emptyLbl.ZIndex = 607
        emptyLbl.Parent = listFrame
        registerTheme(emptyLbl, "Muted", "TextColor3")

        -- Input
        local inputBg = Instance.new("Frame")
        inputBg.Size = UDim2.new(1, 0, 0, 42)
        inputBg.Position = UDim2.new(0, 0, 1, -42)
        inputBg.BackgroundColor3 = C.Surface3
        inputBg.BorderSizePixel = 0
        inputBg.ZIndex = 606
        inputBg.Parent = body
        registerTheme(inputBg, "Surface3", "BackgroundColor3")

        local ic = Instance.new("UICorner")
        ic.CornerRadius = UDim.new(0, 10)
        ic.Parent = inputBg

        local is = Instance.new("UIStroke")
        is.Color = C.Accent
        is.Thickness = 1
        is.Transparency = 0.5
        is.Parent = inputBg
        registerTheme(is, "Accent", "Color")

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -76, 1, 0)
        box.Position = UDim2.fromOffset(12, 0)
        box.BackgroundTransparency = 1
        box.Text = ""
        box.PlaceholderText = "Type message..."
        box.PlaceholderColor3 = C.Muted
        box.TextColor3 = C.Text
        box.Font = Enum.Font.GothamSemibold
        box.TextSize = CFG.FONT_LABEL
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        box.ZIndex = 607
        box.Parent = inputBg
        registerTheme(box, "Text", "TextColor3")

        local sendBtn = Instance.new("TextButton")
        sendBtn.Size = UDim2.fromOffset(60, 32)
        sendBtn.Position = UDim2.new(1, -68, 0.5, -16)
        sendBtn.BackgroundColor3 = C.Accent
        sendBtn.Text = isMob and "▶" or "SEND"
        sendBtn.TextColor3 = Color3.new(1, 1, 1)
        sendBtn.Font = Enum.Font.GothamBold
        sendBtn.TextSize = isMob and 14 or 11
        sendBtn.AutoButtonColor = false
        sendBtn.BorderSizePixel = 0
        sendBtn.ZIndex = 607
        sendBtn.Parent = inputBg
        registerTheme(sendBtn, "Accent", "BackgroundColor3")

        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(0, 8)
        sc.Parent = sendBtn

                -- ===== RENDER MESSAGE (AVATAR + OWNER TAG) =====
        local msgCounter = 0
        
        -- ⚠️ GANTI ANGKA INI DENGAN USERID LU
        local OWNER_IDS = {
            [5126297278] = true,   -- akun lu
        }
        
        local function scrollBottom()
            task.defer(function()
                listFrame.CanvasPosition = Vector2.new(0, listFrame.AbsoluteCanvasSize.Y)
            end)
        end

        local function renderMessage(msg)
            if emptyLbl.Parent then emptyLbl:Destroy() end

            local isMe = (msg.userId == LocalPlayer.UserId)
            local isOwner = (OWNER_IDS[msg.userId] == true)
            
            -- Avatar selalu muncul (PC & HP, beda ukuran)
            local avatarSize = isMob and 26 or 34
            local avatarGap = isMob and 6 or 10

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 0)
            row.AutomaticSize = Enum.AutomaticSize.Y
            row.BackgroundColor3 = isOwner and Color3.fromRGB(45, 20, 10) or (isMe and C.Surface3 or C.Surface)
            row.BackgroundTransparency = 0.3
            row.BorderSizePixel = 0
            msgCounter = msgCounter + 1
            row.LayoutOrder = msgCounter
            row.ZIndex = 607
            row.Parent = listFrame

            local rc = Instance.new("UICorner")
            rc.CornerRadius = UDim.new(0, 10)
            rc.Parent = row

            -- Kalo owner, kasih stroke emas
            if isOwner then
                local ownerStroke = Instance.new("UIStroke")
                ownerStroke.Color = Color3.fromRGB(255, 200, 50)
                ownerStroke.Thickness = 1.5
                ownerStroke.Transparency = 0.2
                ownerStroke.Parent = row
            end

            local rp = Instance.new("UIPadding")
            rp.PaddingTop = UDim.new(0, 8)
            rp.PaddingBottom = UDim.new(0, 8)
            rp.PaddingLeft = UDim.new(0, isMob and 8 or 10)
            rp.PaddingRight = UDim.new(0, isMob and 8 or 10)
            rp.Parent = row

            -- ===== AVATAR =====
            local avContainer = Instance.new("Frame")
            avContainer.Size = UDim2.fromOffset(avatarSize, avatarSize)
            avContainer.Position = UDim2.fromOffset(0, 0)
            avContainer.BackgroundColor3 = C.Surface2
            avContainer.BorderSizePixel = 0
            avContainer.ZIndex = 608
            avContainer.Parent = row
            
            local avCorner = Instance.new("UICorner")
            avCorner.CornerRadius = UDim.new(1, 0)
            avCorner.Parent = avContainer

            local avImg = Instance.new("ImageLabel")
            avImg.Size = UDim2.fromScale(1, 1)
            avImg.BackgroundTransparency = 1
            avImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(msg.userId) .. "&w=100&h=100"
            avImg.ZIndex = 609
            avImg.Parent = avContainer
            
            local avImgCorner = Instance.new("UICorner")
            avImgCorner.CornerRadius = UDim.new(1, 0)
            avImgCorner.Parent = avImg

            local avStroke = Instance.new("UIStroke")
            avStroke.Thickness = 1.5
            avStroke.Transparency = 0.2
            avStroke.Parent = avContainer
            if isOwner then
                avStroke.Color = Color3.fromRGB(255, 200, 50)
            else
                avStroke.Color = isMe and C.Accent2 or C.Accent
            end

            -- ===== HEADER (name + OWNER badge + time) =====
            local hdr = Instance.new("Frame")
            hdr.Size = UDim2.new(1, -(avatarSize + avatarGap), 0, isMob and 16 or 18)
            hdr.Position = UDim2.fromOffset(avatarSize + avatarGap, 0)
            hdr.BackgroundTransparency = 1
            hdr.ZIndex = 608
            hdr.Parent = row

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(0, 0, 1, 0)
            nameLbl.AutomaticSize = Enum.AutomaticSize.X
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = (isMe and "You" or msg.displayName)
            nameLbl.TextColor3 = isOwner and Color3.fromRGB(255, 200, 50) or (isMe and C.Accent2 or C.Accent)
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = isMob and 10 or 11
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.ZIndex = 609
            nameLbl.Parent = hdr

            if isOwner then
                local ownerBadge = Instance.new("Frame")
                ownerBadge.Size = UDim2.fromOffset(isMob and 48 or 54, isMob and 14 or 16)
                ownerBadge.Position = UDim2.fromOffset(60, 1)
                ownerBadge.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
                ownerBadge.BorderSizePixel = 0
                ownerBadge.ZIndex = 610
                ownerBadge.Parent = hdr

                local obCorner = Instance.new("UICorner")
                obCorner.CornerRadius = UDim.new(0, 4)
                obCorner.Parent = ownerBadge

                local obLbl = Instance.new("TextLabel")
                obLbl.Size = UDim2.fromScale(1, 1)
                obLbl.BackgroundTransparency = 1
                obLbl.Text = "👑 OWNER"
                obLbl.TextColor3 = Color3.fromRGB(30, 20, 0)
                obLbl.Font = Enum.Font.GothamBold
                obLbl.TextSize = isMob and 8 or 9
                obLbl.ZIndex = 611
                obLbl.Parent = ownerBadge
            end

            local timeLbl = Instance.new("TextLabel")
            timeLbl.Size = UDim2.fromOffset(50, 16)
            timeLbl.Position = UDim2.new(1, -50, 0, 1)
            timeLbl.BackgroundTransparency = 1
            timeLbl.Text = msg.time
            timeLbl.TextColor3 = C.Muted
            timeLbl.Font = Enum.Font.GothamSemibold
            timeLbl.TextSize = isMob and 9 or 10
            timeLbl.TextXAlignment = Enum.TextXAlignment.Right
            timeLbl.ZIndex = 609
            timeLbl.Parent = hdr

            -- ===== BODY =====
            local bodyLbl = Instance.new("TextLabel")
            bodyLbl.Size = UDim2.new(1, -(avatarSize + avatarGap), 0, 0)
            bodyLbl.AutomaticSize = Enum.AutomaticSize.Y
            bodyLbl.Position = UDim2.fromOffset(avatarSize + avatarGap, isMob and 18 or 20)
            bodyLbl.BackgroundTransparency = 1
            bodyLbl.Text = msg.text
            bodyLbl.TextColor3 = C.Text
            bodyLbl.Font = Enum.Font.GothamSemibold
            bodyLbl.TextSize = CFG.CHAT_FONT
            bodyLbl.TextWrapped = true
            bodyLbl.TextXAlignment = Enum.TextXAlignment.Left
            bodyLbl.TextYAlignment = Enum.TextYAlignment.Top
            bodyLbl.ZIndex = 608
            bodyLbl.Parent = row
            registerTheme(bodyLbl, "Text", "TextColor3")

            scrollBottom()
        end

        -- Hydrate
        for _, m in ipairs(Shared.LiveChat_Messages) do
            renderMessage(m)
        end

        ChatClient.onMessage(function(msg)
            renderMessage(msg)
        end)

        -- Send
        local function doSend()
            local text = box.Text
            if text == "" then return end
            sendBtn.Text = "..."
            task.spawn(function()
                local ok, err = ChatClient.send(text)
                if ok then
                    box.Text = ""
                else
                    notify("Chat: " .. tostring(err), "error")
                end
                sendBtn.Text = isMob and "▶" or "SEND"
            end)
        end

        sendBtn.MouseButton1Click:Connect(doSend)
        box.FocusLost:Connect(function(enter)
            if enter then doSend() end
        end)

        print("[CHAT] buildLiveChatWindow OK")
        return win
    end

    -- TAB PREDIKSI
do
    local predPage = createPage("Prediksi")
    pages.Prediksi = predPage

    local eggInMapCard, eggInMapContent = makeCard(predPage, "EGG SPAWN ON MAP", 1)

    local eggInMapList = Instance.new("ScrollingFrame")
    eggInMapList.Size = UDim2.new(1, 0, 0, IS_MOBILE and 140 or 160)
    eggInMapList.BackgroundTransparency = 1
    eggInMapList.BorderSizePixel = 0
    eggInMapList.ScrollBarThickness = 3
    eggInMapList.ScrollBarImageColor3 = C.Success
    eggInMapList.CanvasSize = UDim2.new(0, 0, 0, 0)
    eggInMapList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    eggInMapList.ZIndex = 3
    eggInMapList.LayoutOrder = 1
    eggInMapList.Parent = eggInMapContent

    local eggInMapLayout = Instance.new("UIListLayout")
    eggInMapLayout.Padding = UDim.new(0, 3)
    eggInMapLayout.SortOrder = Enum.SortOrder.LayoutOrder
    eggInMapLayout.Parent = eggInMapList

    local eggPredCard, eggPredContent = makeCard(predPage, "NEXT EGG PREDICTION", 2)

    local eggPredList = Instance.new("ScrollingFrame")
    eggPredList.Size = UDim2.new(1, 0, 0, IS_MOBILE and 140 or 160)
    eggPredList.BackgroundTransparency = 1
    eggPredList.BorderSizePixel = 0
    eggPredList.ScrollBarThickness = 3
    eggPredList.ScrollBarImageColor3 = C.Accent3
    eggPredList.CanvasSize = UDim2.new(0, 0, 0, 0)
    eggPredList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    eggPredList.ZIndex = 3
    eggPredList.LayoutOrder = 1
    eggPredList.Parent = eggPredContent

    local eggPredLayout = Instance.new("UIListLayout")
    eggPredLayout.Padding = UDim.new(0, 3)
    eggPredLayout.SortOrder = Enum.SortOrder.LayoutOrder
    eggPredLayout.Parent = eggPredList

    local lastEggInMapStr = ""
    local lastEggPredStr = ""

    task.spawn(function()
        while eggInMapList.Parent do
            task.wait(1)

            local eggsInMap = Shared.EggsInMap or {}
            local inMapStr = table.concat(eggsInMap, ",")
            if inMapStr ~= lastEggInMapStr then
                lastEggInMapStr = inMapStr
                for _, child in ipairs(eggInMapList:GetChildren()) do
                    if child:IsA("TextLabel") then child:Destroy() end
                end
                if #eggsInMap == 0 then
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 0, IS_MOBILE and 26 or 28)
                    lbl.BackgroundColor3 = C.Surface3
                    lbl.BackgroundTransparency = 0.5
                    lbl.Text = "   No egg on map"
                    lbl.TextColor3 = C.Muted
                    lbl.Font = Enum.Font.GothamSemibold
                    lbl.TextSize = CFG.FONT_LABEL
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.LayoutOrder = 1
                    lbl.ZIndex = 4
                    lbl.Parent = eggInMapList
                    local c = Instance.new("UICorner")
                    c.CornerRadius = UDim.new(0, 5)
                    c.Parent = lbl
                else
                    for i, eggName in ipairs(eggsInMap) do
                        local row = Instance.new("Frame")
                        row.Name = "EggInfo"
                        row.Size = UDim2.new(1, -4, 0, IS_MOBILE and 52 or 58)
                        row.BackgroundColor3 = C.Surface3
                        row.BackgroundTransparency = 0.08
                        row.BorderSizePixel = 0
                        row.LayoutOrder = i
                        row.ZIndex = 4
                        row.Parent = eggInMapList
                        registerTheme(row, "Surface3", "BackgroundColor3")

                        local rc = Instance.new("UICorner")
                        rc.CornerRadius = UDim.new(0, 10)
                        rc.Parent = row
                        local rs = Instance.new("UIStroke")
                        rs.Color = C.Success
                        rs.Thickness = 1
                        rs.Transparency = 0.55
                        rs.Parent = row
                        registerTheme(rs, "Success", "Color")

                        local preview = makeEggPreview(row, eggName)
                        preview.Position = UDim2.fromOffset(5, IS_MOBILE and 5 or 5)

                        local name = Instance.new("TextLabel")
                        name.Size = UDim2.new(1, -(IS_MOBILE and 60 or 68), 0, 20)
                        name.Position = UDim2.fromOffset(IS_MOBILE and 54 or 60, IS_MOBILE and 7 or 9)
                        name.BackgroundTransparency = 1
                        name.Text = eggName
                        name.TextColor3 = C.Text
                        name.Font = Enum.Font.GothamBold
                        name.TextSize = CFG.FONT_LABEL + 1
                        name.TextXAlignment = Enum.TextXAlignment.Left
                        name.TextTruncate = Enum.TextTruncate.AtEnd
                        name.ZIndex = 6
                        name.Parent = row
                        registerTheme(name, "Text", "TextColor3")

                        local meta = Instance.new("TextLabel")
                        meta.Size = UDim2.new(1, -(IS_MOBILE and 60 or 68), 0, 16)
                        meta.Position = UDim2.fromOffset(IS_MOBILE and 54 or 60, IS_MOBILE and 28 or 30)
                        meta.BackgroundTransparency = 1
                        meta.Text = "EGG SPAWNED  •  LIVE"
                        meta.TextColor3 = C.Muted
                        meta.Font = Enum.Font.GothamSemibold
                        meta.TextSize = CFG.FONT_MUTED
                        meta.TextXAlignment = Enum.TextXAlignment.Left
                        meta.ZIndex = 6
                        meta.Parent = row
                        registerTheme(meta, "Muted", "TextColor3")
                    end
                end
            end

            local preds = Shared.EggPredictions or {}
            local predStr = table.concat(preds, ",")
            if predStr ~= lastEggPredStr then
                lastEggPredStr = predStr
                for _, child in ipairs(eggPredList:GetChildren()) do
                    if child:IsA("TextLabel") then child:Destroy() end
                end
                if #preds == 0 then
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 0, IS_MOBILE and 26 or 28)
                    lbl.BackgroundColor3 = C.Surface3
                    lbl.BackgroundTransparency = 0.5
                    lbl.Text = "   Waiting for data..."
                    lbl.TextColor3 = C.Muted
                    lbl.Font = Enum.Font.GothamSemibold
                    lbl.TextSize = CFG.FONT_LABEL
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.LayoutOrder = 1
                    lbl.ZIndex = 4
                    lbl.Parent = eggPredList
                    local c = Instance.new("UICorner")
                    c.CornerRadius = UDim.new(0, 5)
                    c.Parent = lbl
                else
                    for i, eggName in ipairs(preds) do
                        local row = Instance.new("Frame")
                        row.Name = "EggPrediction"
                        row.Size = UDim2.new(1, -4, 0, IS_MOBILE and 52 or 58)
                        row.BackgroundColor3 = C.Surface3
                        row.BackgroundTransparency = 0.08
                        row.BorderSizePixel = 0
                        row.LayoutOrder = i
                        row.ZIndex = 4
                        row.Parent = eggPredList
                        registerTheme(row, "Surface3", "BackgroundColor3")

                        local rc = Instance.new("UICorner")
                        rc.CornerRadius = UDim.new(0, 10)
                        rc.Parent = row
                        local rs = Instance.new("UIStroke")
                        rs.Color = C.Accent2
                        rs.Thickness = 1
                        rs.Transparency = 0.5
                        rs.Parent = row
                        registerTheme(rs, "Accent2", "Color")

                        local preview = makeEggPreview(row, eggName)
                        preview.Position = UDim2.fromOffset(5, IS_MOBILE and 5 or 5)

                        local name = Instance.new("TextLabel")
                        name.Size = UDim2.new(1, -(IS_MOBILE and 60 or 68), 0, 20)
                        name.Position = UDim2.fromOffset(IS_MOBILE and 54 or 60, IS_MOBILE and 7 or 9)
                        name.BackgroundTransparency = 1
                        name.Text = eggName
                        name.TextColor3 = C.Text
                        name.Font = Enum.Font.GothamBold
                        name.TextSize = CFG.FONT_LABEL + 1
                        name.TextXAlignment = Enum.TextXAlignment.Left
                        name.TextTruncate = Enum.TextTruncate.AtEnd
                        name.ZIndex = 6
                        name.Parent = row
                        registerTheme(name, "Text", "TextColor3")

                        local meta = Instance.new("TextLabel")
                        meta.Size = UDim2.new(1, -(IS_MOBILE and 60 or 68), 0, 16)
                        meta.Position = UDim2.fromOffset(IS_MOBILE and 54 or 60, IS_MOBILE and 28 or 30)
                        meta.BackgroundTransparency = 1
                        meta.Text = "NEXT PREDICTION  •  39% CHANCE SPAWN"
                        meta.TextColor3 = C.Muted
                        meta.Font = Enum.Font.GothamSemibold
                        meta.TextSize = CFG.FONT_MUTED
                        meta.TextXAlignment = Enum.TextXAlignment.Left
                        meta.ZIndex = 6
                        meta.Parent = row
                        registerTheme(meta, "Muted", "TextColor3")
                    end
                end
            end
        end
    end)
end

    -- TAB EGG (2 KOLOM)
do
    local eggPage, eggLeft, eggRight = createTwoColumnPage("Egg")
    pages.Egg = eggPage

    -- ═══ KOLOM KIRI ═══
    local eggEspCard, eggEspContent = makeCard(eggLeft, "EGG ESP", 1)
    makeToggle(eggEspContent, "Enable Egg ESP", false, function(v) Shared.ESP_Eggs_Enabled = v end)
    makeToggle(eggEspContent, "Show Name", false, function(v) Shared.ESP_EggName_Enabled = v end)
    makeToggle(eggEspContent, "Show Luck", false, function(v) Shared.ESP_EggLuck_Enabled = v end)

    -- ═══ KOLOM KANAN ═══
    local hatchLuckCard, hatchLuckContent = makeCard(eggRight, "🥚 EGG PLOT", 1)

    -- Auto Hatch
    makeToggle(hatchLuckContent, "Auto Hatch", false, function(v)
        Shared.AutoHatch_Enabled = v
        if v then notify("Auto Hatch: ON", "success") else notify("Auto Hatch: OFF", "info") end
    end)

    -- Auto Hatch Luck
    makeToggle(hatchLuckContent, "Auto Hatch Luck", false, function(v)
        Shared.AutoHatchLuck_Enabled = v
        local F = getFeatures()
        if F and F.getHatchLuckState then F.getHatchLuckState().Enabled = v end
        if v then notify("Hatch Luck: ON", "success") else notify("Hatch Luck: OFF", "info") end
    end)

    -- Hatch Luck Mode
    local hatchModeLbl = Instance.new("TextLabel")
    hatchModeLbl.Size = UDim2.new(1, 0, 0, 16)
    hatchModeLbl.BackgroundTransparency = 1
    hatchModeLbl.Text = "Hatch Luck Mode:"
    hatchModeLbl.TextColor3 = C.Muted
    hatchModeLbl.Font = Enum.Font.GothamSemibold
    hatchModeLbl.TextSize = CFG.FONT_MUTED
    hatchModeLbl.TextXAlignment = Enum.TextXAlignment.Left
    hatchModeLbl.ZIndex = 3
    hatchModeLbl.Parent = hatchLuckContent

    makeDropdownGlobal(hatchLuckContent, {"Max", "A little"}, Shared.HatchLuck_Mode or "Max", function(v)
        Shared.HatchLuck_Mode = v
        local F = getFeatures()
        if F and F.setHatchLuckMode then F.setHatchLuckMode(v) end
        notify("Hatch Luck Mode: " .. v, "info")
    end)

    -- Auto Plant Egg
    makeToggle(hatchLuckContent, "Auto Plant Egg", false, function(v)
        Shared.AutoPlantEgg_Enabled = v
        local F = getFeatures()
        if F and F.getAutoPlantState then F.getAutoPlantState().Enabled = v end
        if v then notify("Auto Plant: ON", "success") else notify("Auto Plant: OFF", "info") end
    end)

    -- Auto Plant Filter (by name)
    local plantFilterLbl = Instance.new("TextLabel")
    plantFilterLbl.Size = UDim2.new(1, 0, 0, 16)
    plantFilterLbl.BackgroundTransparency = 1
    plantFilterLbl.Text = "Plant Filter (by name):"
    plantFilterLbl.TextColor3 = C.Muted
    plantFilterLbl.Font = Enum.Font.GothamSemibold
    plantFilterLbl.TextSize = CFG.FONT_MUTED
    plantFilterLbl.TextXAlignment = Enum.TextXAlignment.Left
    plantFilterLbl.ZIndex = 3
    plantFilterLbl.Parent = hatchLuckContent

    local PlantFilterList = {"None"}
    for _, eggN in ipairs(EggNames) do
        table.insert(PlantFilterList, eggN)
    end

    makeDropdownGlobal(hatchLuckContent, PlantFilterList, Shared.AutoPlantEgg_Filter or "None", function(v)
        Shared.AutoPlantEgg_Filter = v
        local F = getFeatures()
        if F and F.setAutoPlantFilter then F.setAutoPlantFilter(v) end
        if v == "None" then
            notify("Plant Filter: None (pick an egg first!)", "warning")
        else
            notify("Plant Filter: " .. v, "info")
        end
    end)
end

     -- TAB VISUAL (2 KOLOM)
do
    local visualPage, visLeft, visRight = createTwoColumnPage("Visual")
    pages.Visual = visualPage

    -- ═══ KOLOM KIRI ═══
    local pEspCard, pEspContent = makeCard(visLeft, "PLAYER ESP", 1)
    makeToggle(pEspContent, "Player ESP", false, function(v) Shared.ESP_Players_Enabled = v end)
    makeToggle(pEspContent, "Player Chams", false, function(v) Shared.ESP_PlayerChams_Enabled = v end)
    makeToggle(pEspContent, "Player Studs", false, function(v) Shared.ESP_PlayerStuds_Enabled = v end)

    -- ═══ KOLOM KANAN ═══
    local petEspCard, petEspContent = makeCard(visRight, "PET ESP", 1)
    makeToggle(petEspContent, "Pet ESP", false, function(v) Shared.ESP_Pets_Enabled = v end)
    makeToggle(petEspContent, "Show Name", false, function(v) Shared.ESP_PetName_Enabled = v end)
    makeToggle(petEspContent, "Show Cash", false, function(v) Shared.ESP_PetCash_Enabled = v end)
    makeToggle(petEspContent, "Show Speed", false, function(v) Shared.ESP_PetSpeed_Enabled = v end)
end

       -- TAB AUTO (2 KOLOM)
do
    local autoPage, autoLeft, autoRight = createTwoColumnPage("Auto")
    pages.Auto = autoPage

    -- ═══ KOLOM KIRI: SPEED + FLY ═══
    local speedCard, speedContent = makeCard(autoLeft, "SPEED", 1)
    makeToggle(speedContent, "Enable Speed", false, function(v) Shared.Speed_Enabled = v end)

    local speedLbl = Instance.new("TextLabel")
    speedLbl.Size = UDim2.new(1, 0, 0, 16)
    speedLbl.BackgroundTransparency = 1
    speedLbl.Text = "Speed: " .. (Shared.Speed_Value or 100)
    speedLbl.TextColor3 = C.Muted
    speedLbl.Font = Enum.Font.GothamSemibold
    speedLbl.TextSize = CFG.FONT_MUTED
    speedLbl.TextXAlignment = Enum.TextXAlignment.Left
    speedLbl.LayoutOrder = 2
    speedLbl.Parent = speedContent

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, 0, 0, 8)
    sliderBg.BackgroundColor3 = C.Surface3
    sliderBg.BorderSizePixel = 0
    sliderBg.LayoutOrder = 3
    sliderBg.Parent = speedContent
    local sbc = Instance.new("UICorner"); sbc.CornerRadius = UDim.new(1,0); sbc.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((Shared.Speed_Value or 100) / 500, 0, 1, 0)
    sliderFill.BackgroundColor3 = C.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    local sfc = Instance.new("UICorner"); sfc.CornerRadius = UDim.new(1,0); sfc.Parent = sliderFill

    local sliderBtn = Instance.new("TextButton")
    sliderBtn.Size = UDim2.new(1, 0, 1, 20)
    sliderBtn.Position = UDim2.new(0, 0, 0.5, -10)
    sliderBtn.BackgroundTransparency = 1
    sliderBtn.Text = ""
    sliderBtn.Parent = sliderBg

    local draggingSlider = false
    sliderBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if draggingSlider and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = UserInputService:GetMouseLocation().X
            local rel = math.clamp((mouseX - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            Shared.Speed_Value = math.floor(rel * 500)
            sliderFill.Size = UDim2.new(rel, 0, 1, 0)
            speedLbl.Text = "Speed: " .. Shared.Speed_Value
            local F = getFeatures()
            if F and F.setSpeed then F.setSpeed(Shared.Speed_Value) end
        end
    end)

    -- Infinity Jump (masih di card SPEED)
    buildInfinityJumpSection(speedContent, makeToggle, C, CFG, notify, registerTheme)

    -- CHARACTER FLY CARD (kiri bawah)
    local flyCard, flyContent = makeCard(autoLeft, "🛸 CHARACTER FLY", 2)

    makeToggle(flyContent, "Enable Fly", false, function(v)
        Shared.Fly_Enabled = v
        local F = getFeatures()
        if F and F.setFlyEnabled then F.setFlyEnabled(v) end
        if v then notify("🛸 Fly: ON", "success")
        else notify("🛸 Fly: OFF", "info") end
    end)

    local flyHeightLbl = Instance.new("TextLabel")
    flyHeightLbl.Size = UDim2.new(1, 0, 0, 16)
    flyHeightLbl.BackgroundTransparency = 1
    flyHeightLbl.Text = "Fly Height:"
    flyHeightLbl.TextColor3 = C.Muted
    flyHeightLbl.Font = Enum.Font.GothamSemibold
    flyHeightLbl.TextSize = CFG.FONT_MUTED
    flyHeightLbl.TextXAlignment = Enum.TextXAlignment.Left
    flyHeightLbl.LayoutOrder = 2
    flyHeightLbl.ZIndex = 3
    flyHeightLbl.Parent = flyContent
    registerTheme(flyHeightLbl, "Muted", "TextColor3")

    local flyHeightHolder = Instance.new("Frame")
    flyHeightHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
    flyHeightHolder.BackgroundTransparency = 1
    flyHeightHolder.LayoutOrder = 3
    flyHeightHolder.ZIndex = 3
    flyHeightHolder.Parent = flyContent

    local FLY_HEIGHT_LIST = {"50", "100", "150", "200", "250", "500"}
    makeDropdownGlobal(flyHeightHolder, FLY_HEIGHT_LIST, tostring(Shared.Fly_Height or 100), function(v)
        local h = tonumber(v) or 100
        Shared.Fly_Height = h
        local F = getFeatures()
        if F and F.setFlyHeight then F.setFlyHeight(h) end
        notify("🛸 Fly Height: " .. h .. " studs", "info")
    end)

    local flySpeedLbl = Instance.new("TextLabel")
    flySpeedLbl.Size = UDim2.new(1, 0, 0, 16)
    flySpeedLbl.BackgroundTransparency = 1
    flySpeedLbl.Text = "Fly Speed:"
    flySpeedLbl.TextColor3 = C.Muted
    flySpeedLbl.Font = Enum.Font.GothamSemibold
    flySpeedLbl.TextSize = CFG.FONT_MUTED
    flySpeedLbl.TextXAlignment = Enum.TextXAlignment.Left
    flySpeedLbl.LayoutOrder = 4
    flySpeedLbl.ZIndex = 3
    flySpeedLbl.Parent = flyContent
    registerTheme(flySpeedLbl, "Muted", "TextColor3")

    local flySpeedHolder = Instance.new("Frame")
    flySpeedHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
    flySpeedHolder.BackgroundTransparency = 1
    flySpeedHolder.LayoutOrder = 5
    flySpeedHolder.ZIndex = 3
    flySpeedHolder.Parent = flyContent

    local FLY_SPEED_LIST = {"100", "200", "300", "400", "500"}
    makeDropdownGlobal(flySpeedHolder, FLY_SPEED_LIST, tostring(Shared.Fly_Speed or 300), function(v)
        local s = tonumber(v) or 300
        Shared.Fly_Speed = s
        local F = getFeatures()
        if F and F.setFlySpeed then F.setFlySpeed(s) end
        notify("🛸 Fly Speed: " .. s .. " studs/s", "info")
    end)

    -- ═══ KOLOM KANAN: INSTANT PICKUP + OTHER AUTO ═══
    local ipCard, ipContent = makeCard(autoRight, "INSTANT PICKUP", 1)
    makeToggle(ipContent, "Enable Instant Pickup", false, function(v) Shared.InstantPickup_Enabled = v end)

    local ipNote = Instance.new("TextLabel")
    ipNote.Size = UDim2.new(1, 0, 0, 14)
    ipNote.BackgroundTransparency = 1
    ipNote.Text = "Take Instant Egg"
    ipNote.TextColor3 = C.Muted
    ipNote.Font = Enum.Font.GothamSemibold
    ipNote.TextSize = CFG.FONT_MUTED
    ipNote.TextXAlignment = Enum.TextXAlignment.Left
    ipNote.LayoutOrder = 2
    ipNote.Parent = ipContent

    local autoCard, autoContent = makeCard(autoRight, "OTHER AUTO", 2)

    do
        makeToggle(autoContent, "Auto Ride Pet", true, function(v)
            Shared.AutoRidePet_Enabled = v
            local F = getFeatures()
            if F and F.setAutoRideEnabled then F.setAutoRideEnabled(v) end
            if v then notify("🐉 Auto Ride Pet: ON", "success")
            else notify("🐉 Auto Ride Pet: OFF", "info") end
        end)

        local ridePetLbl = Instance.new("TextLabel")
        ridePetLbl.Size = UDim2.new(1, 0, 0, 16)
        ridePetLbl.BackgroundTransparency = 1
        ridePetLbl.Text = "Select Pet:"
        ridePetLbl.TextColor3 = C.Muted
        ridePetLbl.Font = Enum.Font.GothamSemibold
        ridePetLbl.TextSize = CFG.FONT_MUTED
        ridePetLbl.TextXAlignment = Enum.TextXAlignment.Left
        ridePetLbl.ZIndex = 3
        ridePetLbl.Parent = autoContent
        registerTheme(ridePetLbl, "Muted", "TextColor3")

        local petDropHolder = Instance.new("Frame")
        petDropHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
        petDropHolder.BackgroundTransparency = 1
        petDropHolder.ZIndex = 3
        petDropHolder.Parent = autoContent

        local function buildPetList()
            local list = {"Auto (Best KG)"}
            local F = getFeatures()
            if F and F.getPetListForDropdown then
                for _, p in ipairs(F.getPetListForDropdown()) do
                    local kgStr
                    if p.kg >= 1e12 then kgStr = string.format("%.2fT", p.kg / 1e12)
                    elseif p.kg >= 1e9 then kgStr = string.format("%.2fB", p.kg / 1e9)
                    elseif p.kg >= 1e6 then kgStr = string.format("%.1fM", p.kg / 1e6)
                    elseif p.kg >= 1e3 then kgStr = string.format("%.1fK", p.kg / 1e3)
                    else kgStr = string.format("%.0f", p.kg) end
                    table.insert(list, p.name .. " (" .. kgStr .. ")")
                end
            end
            return list
        end

        makeDropdownGlobal(petDropHolder, buildPetList(), Shared.AutoRideSelectedPet or "Auto (Best KG)", function(v)
            local petName = v:match("^([^%(]+)")
            if petName then petName = petName:gsub("%s+$", "") end
            if not petName or petName == "" then petName = "Auto (Best KG)" end
            Shared.AutoRideSelectedPet = petName
            local F = getFeatures()
            if F and F.setAutoRidePet then F.setAutoRidePet(petName) end
            notify("🐉 Selected: " .. petName, "info")
        end)
    end

    makeToggle(autoContent, "Auto Equip Best", false, function(v) Shared.AutoEquipBest_Enabled = v end)
end

      -- ═══════════════════════════════════════════════════════════
    -- 🏆 TAB WEBHOOK — PLATINUM EDITION
    -- ═══════════════════════════════════════════════════════════
    do
        local webhookPage, webhookLeft, webhookRight = createTwoColumnPage("Webhook")
        pages.Webhook = webhookPage

        -- ╔═══════════════════════════════════════════════════════╗
        -- ║  PLATINUM HERO PANEL — Big Status Display              ║
        -- ╚═══════════════════════════════════════════════════════╝
        local heroFrame = Instance.new("Frame")
        heroFrame.Size = UDim2.new(1, 0, 0, 140)
        heroFrame.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
        heroFrame.BorderSizePixel = 0
        heroFrame.LayoutOrder = 1
        heroFrame.ClipsDescendants = true
        heroFrame.ZIndex = 3
        heroFrame.Parent = webhookLeft

        local heroCorner = Instance.new("UICorner")
        heroCorner.CornerRadius = UDim.new(0, 18)
        heroCorner.Parent = heroFrame

        -- Hero gradient (platinum metallic)
        local heroGradient = Instance.new("UIGradient")
        heroGradient.Rotation = 135
        heroGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 22, 28)),
            ColorSequenceKeypoint.new(0.4, Color3.fromRGB(32, 34, 42)),
            ColorSequenceKeypoint.new(0.6, Color3.fromRGB(24, 26, 32)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 12, 16)),
        })
        heroGradient.Parent = heroFrame

        -- Platinum shine strip
        local heroShine = Instance.new("Frame")
        heroShine.Size = UDim2.new(0, 120, 2, 0)
        heroShine.Position = UDim2.new(-0.5, 0, -0.5, 0)
        heroShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        heroShine.BackgroundTransparency = 0.92
        heroShine.BorderSizePixel = 0
        heroShine.Rotation = 25
        heroShine.ZIndex = 4
        heroShine.Parent = heroFrame

        task.spawn(function()
            while heroShine.Parent do
                task.wait(4)
                heroShine.Position = UDim2.new(-0.5, 0, -0.5, 0)
                TweenService:Create(heroShine, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(1.5, 0, 1.5, 0)
                }):Play()
                task.wait(1.3)
            end
        end)

        -- Platinum border glow
        local heroStroke = Instance.new("UIStroke")
        heroStroke.Color = Color3.fromRGB(200, 210, 225)
        heroStroke.Thickness = 1.8
        heroStroke.Transparency = 0.4
        heroStroke.Parent = heroFrame

        -- Sparkle dots (platinum effect)
        for i = 1, 5 do
            local sparkle = Instance.new("Frame")
            sparkle.Size = UDim2.fromOffset(2, 2)
            sparkle.Position = UDim2.fromScale(math.random(), math.random())
            sparkle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            sparkle.BackgroundTransparency = 0.3
            sparkle.BorderSizePixel = 0
            sparkle.ZIndex = 5
            sparkle.Parent = heroFrame
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(1, 0)
            sc.Parent = sparkle

            task.spawn(function()
                while sparkle.Parent do
                    task.wait(math.random(1, 3))
                    sparkle.BackgroundTransparency = 0.2
                    task.wait(0.3)
                    sparkle.BackgroundTransparency = 0.9
                    task.wait(0.3)
                    sparkle.BackgroundTransparency = 0.3
                    task.wait(1)
                    sparkle.BackgroundTransparency = 1
                end
            end)
        end

        -- Platinum Logo/Badge
        local platBadge = Instance.new("Frame")
        platBadge.Size = UDim2.fromOffset(48, 48)
        platBadge.Position = UDim2.fromOffset(20, 20)
        platBadge.BackgroundColor3 = Color3.fromRGB(30, 33, 40)
        platBadge.BorderSizePixel = 0
        platBadge.ZIndex = 6
        platBadge.Parent = heroFrame

        local pbCorner = Instance.new("UICorner")
        pbCorner.CornerRadius = UDim.new(0, 12)
        pbCorner.Parent = platBadge

        local pbGradient = Instance.new("UIGradient")
        pbGradient.Rotation = 135
        pbGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 235, 245)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 190, 205)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 130, 150)),
        })
        pbGradient.Parent = platBadge

        local pbStroke = Instance.new("UIStroke")
        pbStroke.Color = Color3.fromRGB(220, 225, 235)
        pbStroke.Thickness = 1.5
        pbStroke.Transparency = 0.2
        pbStroke.Parent = platBadge

        local pbIcon = Instance.new("TextLabel")
        pbIcon.Size = UDim2.fromScale(1, 1)
        pbIcon.BackgroundTransparency = 1
        pbIcon.Text = "🔔"
        pbIcon.TextSize = 24
        pbIcon.Font = Enum.Font.GothamBold
        pbIcon.TextColor3 = Color3.fromRGB(20, 22, 28)
        pbIcon.ZIndex = 7
        pbIcon.Parent = platBadge

        -- Title
        local heroTitle = Instance.new("TextLabel")
        heroTitle.Size = UDim2.new(1, -90, 0, 26)
        heroTitle.Position = UDim2.fromOffset(80, 24)
        heroTitle.BackgroundTransparency = 1
        heroTitle.Text = "WEBHOOK SYSTEM"
        heroTitle.TextColor3 = Color3.fromRGB(245, 248, 255)
        heroTitle.Font = Enum.Font.GothamBlack
        heroTitle.TextSize = 16
        heroTitle.TextXAlignment = Enum.TextXAlignment.Left
        heroTitle.ZIndex = 6
        heroTitle.Parent = heroFrame

        local heroSubtitle = Instance.new("TextLabel")
        heroSubtitle.Size = UDim2.new(1, -90, 0, 16)
        heroSubtitle.Position = UDim2.fromOffset(80, 48)
        heroSubtitle.BackgroundTransparency = 1
        heroSubtitle.Text = "◆ PLATINUM EDITION ◆"
        heroSubtitle.TextColor3 = Color3.fromRGB(180, 190, 205)
        heroSubtitle.Font = Enum.Font.GothamBold
        heroSubtitle.TextSize = 10
        heroSubtitle.TextXAlignment = Enum.TextXAlignment.Left
        heroSubtitle.ZIndex = 6
        heroSubtitle.Parent = heroFrame

        -- Status Row (bottom of hero)
        local statusRow = Instance.new("Frame")
        statusRow.Size = UDim2.new(1, -40, 0, 40)
        statusRow.Position = UDim2.new(0, 20, 1, -55)
        statusRow.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
        statusRow.BackgroundTransparency = 0.3
        statusRow.BorderSizePixel = 0
        statusRow.ZIndex = 6
        statusRow.Parent = heroFrame

        local srCorner = Instance.new("UICorner")
        srCorner.CornerRadius = UDim.new(0, 10)
        srCorner.Parent = statusRow

        local srStroke = Instance.new("UIStroke")
        srStroke.Color = Color3.fromRGB(200, 210, 225)
        srStroke.Thickness = 1
        srStroke.Transparency = 0.6
        srStroke.Parent = statusRow

        -- Status dot
        local statusDot = Instance.new("Frame")
        statusDot.Size = UDim2.fromOffset(10, 10)
        statusDot.Position = UDim2.new(0, 14, 0.5, -5)
        statusDot.BackgroundColor3 = C.Error
        statusDot.BorderSizePixel = 0
        statusDot.ZIndex = 7
        statusDot.Parent = statusRow

        local sdc = Instance.new("UICorner")
        sdc.CornerRadius = UDim.new(1, 0)
        sdc.Parent = statusDot

        local dotRing = Instance.new("Frame")
        dotRing.Size = UDim2.fromOffset(10, 10)
        dotRing.Position = UDim2.new(0, 14, 0.5, -5)
        dotRing.BackgroundTransparency = 1
        dotRing.BorderSizePixel = 0
        dotRing.ZIndex = 6
        dotRing.Parent = statusRow

        local drc = Instance.new("UICorner")
        drc.CornerRadius = UDim.new(1, 0)
        drc.Parent = dotRing

        local drStroke = Instance.new("UIStroke")
        drStroke.Color = C.Error
        drStroke.Thickness = 1.5
        drStroke.Transparency = 0.5
        drStroke.Parent = dotRing

        -- Ring pulse
        task.spawn(function()
            while dotRing.Parent do
                task.wait(0.4)
                dotRing.Size = UDim2.fromOffset(10, 10)
                dotRing.Position = UDim2.new(0, 14, 0.5, -5)
                TweenService:Create(dotRing, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.fromOffset(26, 26),
                    Position = UDim2.new(0, 6, 0.5, -13),
                }):Play()
                TweenService:Create(drStroke, TweenInfo.new(0.8), { Transparency = 1 }):Play()
                task.wait(0.5)
                drStroke.Transparency = 0.5
            end
        end)

        local statusText = Instance.new("TextLabel")
        statusText.Size = UDim2.new(1, -60, 1, 0)
        statusText.Position = UDim2.fromOffset(34, 0)
        statusText.BackgroundTransparency = 1
        statusText.Text = "OFFLINE — Enable webhook to start"
        statusText.TextColor3 = Color3.fromRGB(200, 210, 225)
        statusText.Font = Enum.Font.GothamBold
        statusText.TextSize = CFG.FONT_LABEL
        statusText.TextXAlignment = Enum.TextXAlignment.Left
        statusText.TextTruncate = Enum.TextTruncate.AtEnd
        statusText.ZIndex = 7
        statusText.Parent = statusRow

        -- ╔═══════════════════════════════════════════════════════╗
        -- ║  TOGGLE ENABLE WEBHOOK                                 ║
        -- ╚═══════════════════════════════════════════════════════╝
        local toggleCard, toggleContent = makeCard(webhookLeft, "⚡ SYSTEM CONTROL", 2)

        makeToggle(toggleContent, "Enable Webhook System", Shared.WebhookEnabled or false, function(v)
            Shared.WebhookEnabled = v
            if v then
                statusText.Text = "ONLINE — Listening for notifications"
                statusDot.BackgroundColor3 = C.Success
                drStroke.Color = C.Success
                heroStroke.Color = C.Success
                notify("🔔 Webhook: ONLINE", "success")
            else
                statusText.Text = "OFFLINE — Enable webhook to start"
                statusDot.BackgroundColor3 = C.Error
                drStroke.Color = C.Error
                heroStroke.Color = Color3.fromRGB(200, 210, 225)
                notify("🔔 Webhook: OFFLINE", "info")
            end
        end)
makeToggle(toggleContent, "Ping @everyone", Shared.WebhookMentionEveryone or false, function(v)
    Shared.WebhookMentionEveryone = v
    if v then
        notify("🔔 @everyone ping: ON", "success")
    else
        notify("🔕 @everyone ping: OFF", "info")
    end
end)

        -- ╔═══════════════════════════════════════════════════════╗
        -- ║  URL INPUT — Platinum Style                            ║
        -- ╚═══════════════════════════════════════════════════════╝
        local urlCard, urlContent = makeCard(webhookRight, "🔗 WEBHOOK ENDPOINT", 1)

        local urlHint = Instance.new("TextLabel")
        urlHint.Size = UDim2.new(1, 0, 0, 14)
        urlHint.BackgroundTransparency = 1
        urlHint.Text = "◆ Paste your Discord webhook URL below"
        urlHint.TextColor3 = Color3.fromRGB(160, 170, 185)
        urlHint.Font = Enum.Font.GothamSemibold
        urlHint.TextSize = CFG.FONT_MUTED
        urlHint.TextXAlignment = Enum.TextXAlignment.Left
        urlHint.ZIndex = 3
        urlHint.Parent = urlContent
        registerTheme(urlHint, "Muted", "TextColor3")

        -- Input Wrapper (anti-overflow)
        local inputWrap = Instance.new("Frame")
        inputWrap.Size = UDim2.new(1, 0, 0, 46)
        inputWrap.BackgroundColor3 = Color3.fromRGB(10, 12, 16)
        inputWrap.BorderSizePixel = 0
        inputWrap.ClipsDescendants = true
        inputWrap.ZIndex = 3
        inputWrap.Parent = urlContent

        local iwc = Instance.new("UICorner")
        iwc.CornerRadius = UDim.new(0, 12)
        iwc.Parent = inputWrap

        local iwGrad = Instance.new("UIGradient")
        iwGrad.Rotation = 135
        iwGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 25, 32)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(14, 16, 22)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 9, 13)),
        })
        iwGrad.Parent = inputWrap

        local iwStroke = Instance.new("UIStroke")
        iwStroke.Color = Color3.fromRGB(200, 210, 225)
        iwStroke.Thickness = 1.5
        iwStroke.Transparency = 0.5
        iwStroke.Parent = inputWrap

        -- Left accent bar (platinum)
        local accentBar = Instance.new("Frame")
        accentBar.Size = UDim2.new(0, 3, 1, -16)
        accentBar.Position = UDim2.new(0, 0, 0, 8)
        accentBar.BackgroundColor3 = Color3.fromRGB(220, 230, 245)
        accentBar.BorderSizePixel = 0
        accentBar.ZIndex = 5
        accentBar.Parent = inputWrap

        local ac = Instance.new("UICorner")
        ac.CornerRadius = UDim.new(0, 2)
        ac.Parent = accentBar

        -- Icon
        local urlIcon = Instance.new("TextLabel")
        urlIcon.Size = UDim2.fromOffset(32, 32)
        urlIcon.Position = UDim2.new(0, 12, 0.5, -16)
        urlIcon.BackgroundTransparency = 1
        urlIcon.Text = "🔗"
        urlIcon.TextSize = 15
        urlIcon.Font = Enum.Font.GothamBold
        urlIcon.ZIndex = 5
        urlIcon.Parent = inputWrap

        -- TextBox
        local urlBox = Instance.new("TextBox")
        urlBox.Size = UDim2.new(1, -60, 1, 0)
        urlBox.Position = UDim2.fromOffset(50, 0)
        urlBox.BackgroundTransparency = 1
        urlBox.Text = Shared.WebhookURL or ""
        urlBox.PlaceholderText = "https://discord.com/api/webhooks/..."
        urlBox.PlaceholderColor3 = Color3.fromRGB(110, 120, 135)
        urlBox.TextColor3 = Color3.fromRGB(235, 240, 250)
        urlBox.Font = Enum.Font.GothamSemibold
        urlBox.TextSize = CFG.FONT_MUTED
        urlBox.TextXAlignment = Enum.TextXAlignment.Left
        urlBox.TextTruncate = Enum.TextTruncate.AtEnd
        urlBox.ClearTextOnFocus = false
        urlBox.ZIndex = 5
        urlBox.Parent = inputWrap

        -- Auto-save
        urlBox.FocusLost:Connect(function()
            local url = urlBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
            if url ~= "" and (url:find("discord.com/api/webhooks") or url:find("discordapp.com/api/webhooks")) then
                Shared.WebhookURL = url
                saveWebhookURL(url)
                iwStroke.Color = C.Success
                iwStroke.Transparency = 0.2
                accentBar.BackgroundColor3 = C.Success
                notify("✅ URL saved", "success")
                task.delay(2, function()
                    TweenService:Create(iwStroke, TweenInfo.new(0.5), { Transparency = 0.5 }):Play()
                end)
            elseif url ~= "" then
                iwStroke.Color = C.Error
                accentBar.BackgroundColor3 = C.Error
                notify("❌ Invalid URL", "error")
            end
        end)

        -- Sync status awal
        task.defer(function()
            if Shared.WebhookURL and Shared.WebhookURL ~= "" then
                iwStroke.Color = C.Success
                accentBar.BackgroundColor3 = C.Success
                if Shared.WebhookEnabled then
                    statusText.Text = "ONLINE — Listening for notifications"
                    statusDot.BackgroundColor3 = C.Success
                    drStroke.Color = C.Success
                    heroStroke.Color = C.Success
                end
            end
        end)

        -- ╔═══════════════════════════════════════════════════════╗
        -- ║  TEST BUTTON — Platinum Shine                          ║
        -- ╚═══════════════════════════════════════════════════════╝
        local testCard, testContent = makeCard(webhookRight, "🧪 TEST CONNECTION", 2)

        local testDesc = Instance.new("TextLabel")
        testDesc.Size = UDim2.new(1, 0, 0, 30)
        testDesc.BackgroundTransparency = 1
        testDesc.Text = "◆ Verify your webhook connection by sending a test notification to Discord."
        testDesc.TextColor3 = Color3.fromRGB(160, 170, 185)
        testDesc.Font = Enum.Font.GothamSemibold
        testDesc.TextSize = CFG.FONT_MUTED
        testDesc.TextWrapped = true
        testDesc.TextXAlignment = Enum.TextXAlignment.Left
        testDesc.TextYAlignment = Enum.TextYAlignment.Top
        testDesc.ZIndex = 3
        testDesc.Parent = testContent
        registerTheme(testDesc, "Muted", "TextColor3")

        -- Platinum Test Button
        local testBtn = Instance.new("TextButton")
        testBtn.Size = UDim2.new(1, 0, 0, 50)
        testBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 35)
        testBtn.Text = ""
        testBtn.BorderSizePixel = 0
        testBtn.AutoButtonColor = false
        testBtn.ZIndex = 4
        testBtn.Parent = testContent

        local tbc = Instance.new("UICorner")
        tbc.CornerRadius = UDim.new(0, 14)
        tbc.Parent = testBtn

        local tbGrad = Instance.new("UIGradient")
        tbGrad.Rotation = 135
        tbGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(240, 245, 255)),
            ColorSequenceKeypoint.new(0.35, Color3.fromRGB(200, 210, 225)),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(160, 175, 200)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 115, 140)),
        })
        tbGrad.Parent = testBtn

        local tbStroke = Instance.new("UIStroke")
        tbStroke.Color = Color3.fromRGB(255, 255, 255)
        tbStroke.Thickness = 1.8
        tbStroke.Transparency = 0.3
        tbStroke.Parent = testBtn

        -- Shine effect
        local shine = Instance.new("Frame")
        shine.Size = UDim2.new(0, 80, 1, 0)
        shine.Position = UDim2.new(-1, 0, 0, 0)
        shine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        shine.BackgroundTransparency = 0.6
        shine.BorderSizePixel = 0
        shine.ZIndex = 5
        shine.Parent = testBtn

        local shineCorner = Instance.new("UICorner")
        shineCorner.CornerRadius = UDim.new(0, 14)
        shineCorner.Parent = shine

        task.spawn(function()
            while shine.Parent do
                task.wait(3.5)
                shine.Position = UDim2.new(-1, 0, 0, 0)
                TweenService:Create(shine, TweenInfo.new(1, Enum.EasingStyle.Quad), {
                    Position = UDim2.new(2, 0, 0, 0)
                }):Play()
                task.wait(1.1)
            end
        end)

        local tbLabel = Instance.new("TextLabel")
        tbLabel.Size = UDim2.fromScale(1, 1)
        tbLabel.BackgroundTransparency = 1
        tbLabel.Text = "🚀  SEND TEST NOTIFICATION"
        tbLabel.TextColor3 = Color3.fromRGB(20, 22, 28)
        tbLabel.Font = Enum.Font.GothamBlack
        tbLabel.TextSize = CFG.FONT_LABEL + 1
        tbLabel.ZIndex = 6
        tbLabel.Parent = testBtn

        -- Hover effect
        testBtn.MouseEnter:Connect(function()
            TweenService:Create(tbStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
            TweenService:Create(tbLabel, TweenInfo.new(0.2), { TextSize = CFG.FONT_LABEL + 2 }):Play()
        end)
        testBtn.MouseLeave:Connect(function()
            TweenService:Create(tbStroke, TweenInfo.new(0.2), { Transparency = 0.3 }):Play()
            TweenService:Create(tbLabel, TweenInfo.new(0.2), { TextSize = CFG.FONT_LABEL + 1 }):Play()
        end)

        -- Click handler
        testBtn.MouseButton1Click:Connect(function()
            if not Shared.WebhookURL or Shared.WebhookURL == "" then
                notify("❌ Set webhook URL first!", "error")
                return
            end

            -- Click animation
            TweenService:Create(testBtn, TweenInfo.new(0.08), {
                Size = UDim2.new(0.97, 0, 0, 48)
            }):Play()
            task.delay(0.12, function()
                TweenService:Create(testBtn, TweenInfo.new(0.15), {
                    Size = UDim2.new(1, 0, 0, 50)
                }):Play()
            end)

            tbLabel.Text = "⏳  SENDING..."
            task.spawn(function()
                local HttpService = game:GetService("HttpService")
                local payload = HttpService:JSONEncode({
                    username = "🏆 VRILZHUB PLATINUM",
                    avatar_url = "https://i.imgur.com/your-logo.png",
                    embeds = {{
                        author = {
                            name = "VRILZHUB · Platinum Edition",
                            icon_url = "https://i.imgur.com/your-logo.png",
                        },
                        title = "🏆  WEBHOOK CONNECTED",
                        description = "Platinum webhook system **successfully connected**!\n\n*All notifications will arrive in this channel.*",
                        color = 15859455,
                        fields = {
                            {
                                name = "👤  **PLAYER**",
                                value = "```\n" .. LocalPlayer.DisplayName .. "\n@" .. LocalPlayer.Name .. "\n```",
                                inline = true,
                            },
                            {
                                name = "🎮  **GAME**",
                                value = "```\nPlace: " .. game.PlaceId .. "\nKey: " .. tostring(Shared.KeyType or "FREE") .. "\n```",
                                inline = true,
                            },
                            {
                                name = "⏰  **TIME**",
                                value = "```\n" .. os.date("%H:%M:%S") .. "\n" .. os.date("%d/%m/%Y") .. "\n```",
                                inline = true,
                            },
                        },
                        footer = {
                            text = "🏆 VRILZHUB PLATINUM  •  v2.4",
                        },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
                    }}
                })

                local ok, res = pcall(function()
                    local req = (syn and syn.request) or (http and http.request) or http_request or request
                    if req then
                        return req({
                            Url = Shared.WebhookURL,
                            Method = "POST",
                            Headers = {["Content-Type"] = "application/json"},
                            Body = payload,
                        })
                    end
                    return {StatusCode = 200}
                end)

                local success = false
                if ok and res then
                    local code = tonumber(res.StatusCode or res.Status or 0) or 0
                    if (code >= 200 and code < 300) or code == 204 then
                        success = true
                    end
                end

                if success then
                    tbLabel.Text = "✅  CONNECTED!"
                    notify("✅ Test sent to Discord!", "success")
                else
                    tbLabel.Text = "❌  FAILED"
                    notify("❌ Webhook failed! Check URL", "error")
                end

                task.wait(2.5)
                tbLabel.Text = "🚀  SEND TEST NOTIFICATION"
            end)
        end)

        -- ╔═══════════════════════════════════════════════════════╗
        -- ║  INFO PANEL — Platinum List                            ║
        -- ╚═══════════════════════════════════════════════════════╝
        local infoCard, infoContent = makeCard(webhookRight, "💎 PLATINUM FEATURES", 3)

        local features = {
            { icon = "🎯", title = "Rare Egg Alerts",  desc = "Auto-notify saat rare egg spawn",     color = C.Accent },
            { icon = "🔥", title = "Mutation Alerts",  desc = "Notify saat mutation complete",       color = C.Accent2 },
            { icon = "💾", title = "Auto-Save System", desc = "URL tersimpan otomatis",              color = C.Success },
            { icon = "🔒", title = "Secure Connect",   desc = "Koneksi aman & private",              color = C.Accent3 },
        }

        for i, feat in ipairs(features) do
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 46)
            row.BackgroundColor3 = Color3.fromRGB(18, 20, 26)
            row.BackgroundTransparency = 0.4
            row.BorderSizePixel = 0
            row.LayoutOrder = i
            row.ZIndex = 3
            row.Parent = infoContent

            local rc = Instance.new("UICorner")
            rc.CornerRadius = UDim.new(0, 10)
            rc.Parent = row

            local rs = Instance.new("UIStroke")
            rs.Color = Color3.fromRGB(80, 90, 110)
            rs.Thickness = 1
            rs.Transparency = 0.7
            rs.Parent = row

            -- Icon container
            local iconBox = Instance.new("Frame")
            iconBox.Size = UDim2.fromOffset(32, 32)
            iconBox.Position = UDim2.new(0, 8, 0.5, -16)
            iconBox.BackgroundColor3 = feat.color
            iconBox.BackgroundTransparency = 0.8
            iconBox.BorderSizePixel = 0
            iconBox.ZIndex = 4
            iconBox.Parent = row

            local ibc = Instance.new("UICorner")
            ibc.CornerRadius = UDim.new(0, 8)
            ibc.Parent = iconBox

            local ibs = Instance.new("UIStroke")
            ibs.Color = feat.color
            ibs.Thickness = 1
            ibs.Transparency = 0.4
            ibs.Parent = iconBox

            local iconLbl = Instance.new("TextLabel")
            iconLbl.Size = UDim2.fromScale(1, 1)
            iconLbl.BackgroundTransparency = 1
            iconLbl.Text = feat.icon
            iconLbl.TextSize = 14
            iconLbl.Font = Enum.Font.GothamBold
            iconLbl.ZIndex = 5
            iconLbl.Parent = iconBox

            -- Title
            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -60, 0, 16)
            titleLbl.Position = UDim2.fromOffset(50, 8)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = feat.title
            titleLbl.TextColor3 = Color3.fromRGB(235, 240, 250)
            titleLbl.Font = Enum.Font.GothamBold
            titleLbl.TextSize = CFG.FONT_LABEL
            titleLbl.TextXAlignment = Enum.TextXAlignment.Left
            titleLbl.TextTruncate = Enum.TextTruncate.AtEnd
            titleLbl.ZIndex = 4
            titleLbl.Parent = row

            -- Desc
            local descLbl = Instance.new("TextLabel")
            descLbl.Size = UDim2.new(1, -60, 0, 14)
            descLbl.Position = UDim2.fromOffset(50, 24)
            descLbl.BackgroundTransparency = 1
            descLbl.Text = feat.desc
            descLbl.TextColor3 = Color3.fromRGB(150, 160, 175)
            descLbl.Font = Enum.Font.GothamSemibold
            descLbl.TextSize = CFG.FONT_MUTED
            descLbl.TextXAlignment = Enum.TextXAlignment.Left
            descLbl.TextTruncate = Enum.TextTruncate.AtEnd
            descLbl.ZIndex = 4
            descLbl.Parent = row
        end
    end

              -- TAB SETTINGS
    do
        local setPage, setLeft, setRight = createTwoColumnPage("Settings")
        pages.Settings = setPage

        -- ===== ANTI-AFK CARD =====
        local afkCard, afkContent = makeCard(setLeft, "🛡 ANTI-AFK", 1)

        local afkLbl = Instance.new("TextLabel")
        afkLbl.Size = UDim2.new(1, 0, 0, 16)
        afkLbl.BackgroundTransparency = 1
        afkLbl.Text = "Prevent kick due to idling for 20 minutes:"
        afkLbl.TextColor3 = C.Muted
        afkLbl.Font = Enum.Font.GothamSemibold
        afkLbl.TextSize = CFG.FONT_MUTED
        afkLbl.TextXAlignment = Enum.TextXAlignment.Left
        afkLbl.ZIndex = 3
        afkLbl.Parent = afkContent
        registerTheme(afkLbl, "Muted", "TextColor3")

        makeToggle(afkContent, "Enable Anti-AFK", true, function(v)
            Shared.AntiAFK_Enabled = v
            if v then notify("🛡 Anti-AFK: ON", "success")
            else notify("🛡 Anti-AFK: OFF", "info") end
        end)

        -- ===== THEME CARD =====
        local themeCard, themeContent = makeCard(setLeft, "THEME", 2)

        local themeLbl = Instance.new("TextLabel")
        themeLbl.Size = UDim2.new(1, 0, 0, 16)
        themeLbl.BackgroundTransparency = 1
        themeLbl.Text = "Select Theme:"
        themeLbl.TextColor3 = C.Muted
        themeLbl.Font = Enum.Font.GothamSemibold
        themeLbl.TextSize = CFG.FONT_MUTED
        themeLbl.TextXAlignment = Enum.TextXAlignment.Left
        themeLbl.ZIndex = 3
        themeLbl.Parent = themeContent

        local themeList = {"Brutal", "Ice", "Fire", "Pink", "Green", "Blue", "Mustard", "Olive"}
        makeDropdownGlobal(themeContent, themeList, CurrentTheme, function(v)
            applyTheme(v)
            notify("Theme: " .. v, "success")
        end)

        -- ===== TITLE CARD =====
        local titleCard, titleContent = makeCard(setLeft, "👑 TITLE", 3)

        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(1, 0, 0, 16)
        titleLbl.BackgroundTransparency = 1
        titleLbl.Text = "Show title above character:"
        titleLbl.TextColor3 = C.Muted
        titleLbl.Font = Enum.Font.GothamSemibold
        titleLbl.TextSize = CFG.FONT_MUTED
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.ZIndex = 3
        titleLbl.Parent = titleContent
        registerTheme(titleLbl, "Muted", "TextColor3")

        makeToggle(titleContent, "Show Title", true, function(v)
            Shared.ShowTitle = v
            if _G.VRILZ_RefreshTitle then _G.VRILZ_RefreshTitle() end
            if v then notify("👑 Title: ON", "success")
            else notify("👑 Title: OFF", "info") end
        end)

        local customTitleHolder = Instance.new("Frame")
        customTitleHolder.Name = "CustomTitleHolder"
        customTitleHolder.Size = UDim2.new(1, 0, 0, 0)
        customTitleHolder.AutomaticSize = Enum.AutomaticSize.Y
        customTitleHolder.BackgroundTransparency = 1
        customTitleHolder.ZIndex = 3
        customTitleHolder.Parent = titleContent

        local customTitleLayout = Instance.new("UIListLayout")
        customTitleLayout.Padding = UDim.new(0, CFG.CARD_GAP)
        customTitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
        customTitleLayout.Parent = customTitleHolder

        local function rebuildCustomTitleUI()
            for _, c in ipairs(customTitleHolder:GetChildren()) do
                if not c:IsA("UIListLayout") then c:Destroy() end
            end

            local canCustom = false
            if LocalPlayer.UserId == OWNER_USERID then
                canCustom = true
            elseif Shared and Shared.KeyType then
                local kt = tostring(Shared.KeyType):upper()
                if kt == "PREMIUM" or kt == "OWNER" or kt == "VIP" then
                    canCustom = true
                end
            end

            if canCustom then
                local customLbl = Instance.new("TextLabel")
                customLbl.Size = UDim2.new(1, 0, 0, 16)
                customLbl.BackgroundTransparency = 1
                customLbl.Text = "Custom Title (auto UPPERCASE, max 15):"
                customLbl.TextColor3 = C.Accent
                customLbl.Font = Enum.Font.GothamBold
                customLbl.TextSize = CFG.FONT_MUTED
                customLbl.TextXAlignment = Enum.TextXAlignment.Left
                customLbl.LayoutOrder = 1
                customLbl.Parent = customTitleHolder

                local customBox = Instance.new("TextBox")
                customBox.Size = UDim2.new(1, 0, 0, 34)
                customBox.BackgroundColor3 = C.Surface3
                customBox.BorderSizePixel = 0
                customBox.Text = _G.VRILZ_CustomTitle or ""
                customBox.PlaceholderText = "Enter Text"
                customBox.PlaceholderColor3 = C.Muted
                customBox.TextColor3 = C.Text
                customBox.Font = Enum.Font.GothamBold
                customBox.TextSize = CFG.FONT_LABEL
                customBox.TextXAlignment = Enum.TextXAlignment.Center
                customBox.ClearTextOnFocus = false
                customBox.LayoutOrder = 2
                customBox.Parent = customTitleHolder

                local cbCorner = Instance.new("UICorner")
                cbCorner.CornerRadius = UDim.new(0, 8)
                cbCorner.Parent = customBox

                local btnRow = Instance.new("Frame")
                btnRow.Size = UDim2.new(1, 0, 0, 32)
                btnRow.BackgroundTransparency = 1
                btnRow.LayoutOrder = 3
                btnRow.Parent = customTitleHolder

                local saveBtn = Instance.new("TextButton")
                saveBtn.Size = UDim2.new(0.48, 0, 1, 0)
                saveBtn.BackgroundColor3 = C.Success
                saveBtn.Text = "💾 SAVE"
                saveBtn.TextColor3 = Color3.new(1, 1, 1)
                saveBtn.Font = Enum.Font.GothamBold
                saveBtn.TextSize = CFG.FONT_LABEL
                saveBtn.BorderSizePixel = 0
                saveBtn.Parent = btnRow

                local clearBtn = Instance.new("TextButton")
                clearBtn.Size = UDim2.new(0.48, 0, 1, 0)
                clearBtn.Position = UDim2.new(0.52, 0, 0, 0)
                clearBtn.BackgroundColor3 = C.Error
                clearBtn.Text = "🗑 CLEAR"
                clearBtn.TextColor3 = Color3.new(1, 1, 1)
                clearBtn.Font = Enum.Font.GothamBold
                clearBtn.TextSize = CFG.FONT_LABEL
                clearBtn.BorderSizePixel = 0
                clearBtn.Parent = btnRow

                saveBtn.MouseButton1Click:Connect(function()
                    local txt = customBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
                    if txt == "" then notify("❌ Empty!", "error") return end
                    txt = txt:upper():sub(1, 15):gsub("[^%w%s]", "")
                    customBox.Text = txt
                    _G.VRILZ_CustomTitle = txt
                    saveCustomTitle(txt)
                    notify("✅ Saved: " .. txt, "success")
                    if _G.VRILZ_RefreshTitle then _G.VRILZ_RefreshTitle() end
                end)

                clearBtn.MouseButton1Click:Connect(function()
                    customBox.Text = ""
                    clearCustomTitle()
                    notify("🗑 Cleared", "info")
                    if _G.VRILZ_RefreshTitle then _G.VRILZ_RefreshTitle() end
                end)
            else
                local lockedFrame = Instance.new("Frame")
                lockedFrame.Size = UDim2.new(1, 0, 0, 52)
                lockedFrame.BackgroundColor3 = C.Surface3
                lockedFrame.BackgroundTransparency = 0.5
                lockedFrame.BorderSizePixel = 0
                lockedFrame.Parent = customTitleHolder

                local lc = Instance.new("UICorner")
                lc.CornerRadius = UDim.new(0, 8)
                lc.Parent = lockedFrame

                local lt = Instance.new("TextLabel")
                lt.Size = UDim2.new(1, -20, 0, 20)
                lt.Position = UDim2.fromOffset(10, 8)
                lt.BackgroundTransparency = 1
                lt.Text = "🔒 Custom Title (Premium only)"
                lt.TextColor3 = C.Muted
                lt.Font = Enum.Font.GothamBold
                lt.TextSize = CFG.FONT_LABEL
                lt.TextXAlignment = Enum.TextXAlignment.Left
                lt.Parent = lockedFrame
            end
        end

        rebuildCustomTitleUI()
        _G.VRILZ_RebuildCustomTitle = rebuildCustomTitleUI

        -- ===== STEAL MODE CARD =====
        local stealModeCard, stealModeContent = makeCard(setRight, "STEAL MODE", 1)

        local stealModeLbl = Instance.new("TextLabel")
        stealModeLbl.Size = UDim2.new(1, 0, 0, 16)
        stealModeLbl.BackgroundTransparency = 1
        stealModeLbl.Text = "Select Steal Mode:"
        stealModeLbl.TextColor3 = C.Muted
        stealModeLbl.Font = Enum.Font.GothamSemibold
        stealModeLbl.TextSize = CFG.FONT_MUTED
        stealModeLbl.TextXAlignment = Enum.TextXAlignment.Left
        stealModeLbl.Parent = stealModeContent

        local stealModeList = {"TP", "TP GLIDE", "Fly"}
        makeDropdownGlobal(stealModeContent, stealModeList, Shared.StealMode or "TP", function(v)
            Shared.StealMode = v
            notify("Steal Mode: " .. v, "info")
        end)

        -- ===== LIVE CHAT CARD =====
        local chatToggleCard, chatToggleContent = makeCard(setRight, "💬 LIVE CHAT", 2)
        local liveChatWin = buildLiveChatWindow(screenGui)

        makeToggle(chatToggleContent, "Show Live Chat Window", false, function(v)
            if liveChatWin then
                liveChatWin.Visible = v
                if v then
                    pcall(function()
                        if ChatClient and ChatClient.start then ChatClient.start() end
                    end)
                    notify("💬 Live Chat opened", "success")
                else
                    notify("💬 Live Chat closed", "info")
                end
            end
        end)

        local chatHint = Instance.new("TextLabel")
        chatHint.Size = UDim2.new(1, 0, 0, 16)
        chatHint.BackgroundTransparency = 1
        chatHint.Text = "🌐 Global chat · all user vrilzhub"
        chatHint.TextColor3 = C.Muted
        chatHint.Font = Enum.Font.GothamSemibold
        chatHint.TextSize = CFG.FONT_MUTED
        chatHint.TextXAlignment = Enum.TextXAlignment.Left
        chatHint.Parent = chatToggleContent

        -- ===== GRAPHICS CARD =====
        local fpsCard, fpsContent = makeCard(setRight, "⚡ GRAPHICS", 3)
        local fpsWin = buildFPSWindow(screenGui)
        UI._fpsWindow = fpsWin

        -- ⭐ LIGHTS EFFECT LAYER
        local lightsLayer = buildLightsEffectLayer(main)
        lightsLayer.Visible = true

        -- ⚡ LIGHTNING EFFECT LAYER (terpisah)
        local lightningLayer = buildLightningEffectLayer(main)
        lightningLayer.Visible = false

        makeToggle(fpsContent, "FPS Boost", false, function(v)
            Shared.FPSBoost_Enabled = v
            if v then gfx_enableFPS() else gfx_disableFPS() end
        end)

        makeToggle(fpsContent, "4K HD Mode", false, function(v)
            Shared.HD4K_Enabled = v
            if v then gfx_enableHD() else gfx_disableHD() end
        end)

        makeToggle(fpsContent, "FPS Window", false, function(v)
            if fpsWin then fpsWin.Visible = v end
        end)

        -- ⭐ TOGGLE LIGHTS EFFECT (meteor + bintang + shadow)
            makeToggle(fpsContent, "Lights Effect", true, function(v)
            Shared.LightsEffect_Enabled = v
            if lightsLayer then
                lightsLayer.Visible = v
            end
            if v then
                notify("✨ Lights Effect: ON (meteor + stars)", "success")
            else
                notify("✨ Lights Effect: OFF", "info")
            end
        end)

        -- ⚡ TOGGLE LIGHTNING EFFECT (petir merah terpisah)
        makeToggle(fpsContent, "Lightning Effect", false, function(v)
            Shared.LightningEffect_Enabled = v
            if lightningLayer then
                lightningLayer.Visible = v
            end
            if v then
                notify("⚡ Lightning Effect: ON (red lightning)", "success")
            else
                notify("⚡ Lightning Effect: OFF", "info")
            end
        end)
end

        -- ===== EVENT TAB =====
    do
        local eventPage, eventLeft, eventRight = createTwoColumnPage("Event")
        pages.Event = eventPage
        buildEventTab(eventLeft, eventRight, makeCard, makeToggle, makeDropdownMulti, notify)
    end

        -- ===== EGG MUTATION TAB =====
    do
        local mutPage, mutLeft, mutRight = createTwoColumnPage("EggMutation")
        pages.EggMutation = mutPage

        local mutStealCard, mutStealContent = makeCard(mutLeft, "🎯 AUTO STEAL (FILTER)", 0)

        local raritySection = Instance.new("Frame")
        raritySection.Size = UDim2.new(1, 0, 0, 0)
        raritySection.AutomaticSize = Enum.AutomaticSize.Y
        raritySection.BackgroundTransparency = 1
        raritySection.LayoutOrder = 10
        raritySection.Parent = mutStealContent

        local rarityLayout = Instance.new("UIListLayout")
        rarityLayout.Padding = UDim.new(0, CFG.CARD_GAP)
        rarityLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rarityLayout.Parent = raritySection

        local nameSection = Instance.new("Frame")
        nameSection.Size = UDim2.new(1, 0, 0, 0)
        nameSection.AutomaticSize = Enum.AutomaticSize.Y
        nameSection.BackgroundTransparency = 1
        nameSection.LayoutOrder = 11
        nameSection.Visible = false
        nameSection.Parent = mutStealContent

        local nameLayout = Instance.new("UIListLayout")
        nameLayout.Padding = UDim.new(0, CFG.CARD_GAP)
        nameLayout.SortOrder = Enum.SortOrder.LayoutOrder
        nameLayout.Parent = nameSection

        local function updateSections(mode)
            if mode == "Rarity" then
                raritySection.Visible = true
                nameSection.Visible = false
            else
                raritySection.Visible = false
                nameSection.Visible = true
            end
        end

        local modeLbl = Instance.new("TextLabel")
        modeLbl.Size = UDim2.new(1, 0, 0, 16)
        modeLbl.BackgroundTransparency = 1
        modeLbl.Text = "Steal Mode:"
        modeLbl.TextColor3 = C.Muted
        modeLbl.Font = Enum.Font.GothamSemibold
        modeLbl.TextSize = CFG.FONT_MUTED
        modeLbl.TextXAlignment = Enum.TextXAlignment.Left
        modeLbl.LayoutOrder = 1
        modeLbl.Parent = mutStealContent

        local modeHolder = Instance.new("Frame")
        modeHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
        modeHolder.BackgroundTransparency = 1
        modeHolder.LayoutOrder = 2
        modeHolder.Parent = mutStealContent

        makeDropdownGlobal(modeHolder, {"Rarity", "Name"}, Shared.MutationStealMode or "Rarity", function(v)
            Shared.MutationStealMode = v
            notify("🎯 Mode: " .. v, "info")
            updateSections(v)
        end)

        local stealToggleHolder = Instance.new("Frame")
        stealToggleHolder.Size = UDim2.new(1, 0, 0, CFG.TOGGLE_H)
        stealToggleHolder.BackgroundTransparency = 1
        stealToggleHolder.LayoutOrder = 3
        stealToggleHolder.Parent = mutStealContent

        makeToggle(stealToggleHolder, "Auto Steal", false, function(v)
            Shared.MutationSteal_Enabled = v
            if v then notify("🎯 Steal: ON", "success")
            else notify("🎯 Steal: OFF", "info") end
        end)

        local rarityLbl = Instance.new("TextLabel")
        rarityLbl.Size = UDim2.new(1, 0, 0, 16)
        rarityLbl.BackgroundTransparency = 1
        rarityLbl.Text = "Select Rarity:"
        rarityLbl.TextColor3 = C.Muted
        rarityLbl.Font = Enum.Font.GothamSemibold
        rarityLbl.TextSize = CFG.FONT_MUTED
        rarityLbl.TextXAlignment = Enum.TextXAlignment.Left
        rarityLbl.LayoutOrder = 1
        rarityLbl.Parent = raritySection

        local rarityDropdownHolder = Instance.new("Frame")
        rarityDropdownHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
        rarityDropdownHolder.BackgroundTransparency = 1
        rarityDropdownHolder.LayoutOrder = 2
        rarityDropdownHolder.Parent = raritySection

        makeDropdownMulti(rarityDropdownHolder, RarityList, Shared.SelectedRarities, nil, function(t) end)

        local nameLbl = Instance.new("TextLabel")
        nameLbl.Size = UDim2.new(1, 0, 0, 16)
        nameLbl.BackgroundTransparency = 1
        nameLbl.Text = "Select Egg Name:"
        nameLbl.TextColor3 = C.Muted
        nameLbl.Font = Enum.Font.GothamSemibold
        nameLbl.TextSize = CFG.FONT_MUTED
        nameLbl.TextXAlignment = Enum.TextXAlignment.Left
        nameLbl.LayoutOrder = 1
        nameLbl.Parent = nameSection

        local nameDropdownHolder = Instance.new("Frame")
        nameDropdownHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
        nameDropdownHolder.BackgroundTransparency = 1
        nameDropdownHolder.LayoutOrder = 2
        nameDropdownHolder.Parent = nameSection

        makeDropdownMulti(nameDropdownHolder, EggNames, Shared.MutationSelectedEggs, nil, function(t) end)

        updateSections(Shared.MutationStealMode or "Rarity")

        -- Auto Mutation card
        local mutCard, mutContent = makeCard(mutRight, "🔥 EGG MUTATION", 1)

        makeToggle(mutContent, "Auto Mutation", false, function(v)
            Shared.AutoMutation_Enabled = v
            if v then notify("🔥 Auto Mutation: ON", "success")
            else notify("🔥 Auto Mutation: OFF", "info") end
        end)

        makeToggle(mutContent, "Auto Return to Plot", false, function(v)
            Shared.MutationReturn_Enabled = v
            if v then notify("🏠 Return: ON", "success")
            else notify("🏠 Return: OFF", "info") end
        end)

        local returnModeLbl = Instance.new("TextLabel")
        returnModeLbl.Size = UDim2.new(1, 0, 0, 16)
        returnModeLbl.BackgroundTransparency = 1
        returnModeLbl.Text = "Return Mode:"
        returnModeLbl.TextColor3 = C.Muted
        returnModeLbl.Font = Enum.Font.GothamSemibold
        returnModeLbl.TextSize = CFG.FONT_MUTED
        returnModeLbl.TextXAlignment = Enum.TextXAlignment.Left
        returnModeLbl.LayoutOrder = 5
        returnModeLbl.Parent = mutContent

        local returnModeHolder = Instance.new("Frame")
        returnModeHolder.Size = UDim2.new(1, 0, 0, CFG.DROPDOWN_H)
        returnModeHolder.BackgroundTransparency = 1
        returnModeHolder.LayoutOrder = 6
        returnModeHolder.Parent = mutContent

        local returnModeInner = Instance.new("Frame")
        returnModeInner.Size = UDim2.new(1, 0, 1, 0)
        returnModeInner.BackgroundTransparency = 1
        returnModeInner.Parent = returnModeHolder

        local function rebuildReturnModeUI()
            for _, c in ipairs(returnModeInner:GetChildren()) do c:Destroy() end

            local isPremUser = false
            if LocalPlayer.UserId == OWNER_USERID then
                isPremUser = true
            elseif Shared and Shared.KeyType then
                local kt = tostring(Shared.KeyType):upper()
                if kt == "PREMIUM" or kt == "OWNER" or kt == "VIP" then
                    isPremUser = true
                end
            end

            if isPremUser then
                makeDropdownGlobal(returnModeInner, {"Step", "Instant"}, Shared.ReturnMode or "Step", function(v)
                    Shared.ReturnMode = v
                    notify("Return Mode: " .. v, "info")
                end)
            else
                local lockedFrame = Instance.new("Frame")
                lockedFrame.Size = UDim2.new(1, 0, 1, 0)
                lockedFrame.BackgroundColor3 = C.Surface3
                lockedFrame.BackgroundTransparency = 0.5
                lockedFrame.BorderSizePixel = 0
                lockedFrame.Parent = returnModeInner

                local lk = Instance.new("UICorner")
                lk.CornerRadius = UDim.new(0, 9)
                lk.Parent = lockedFrame

                local lkLbl = Instance.new("TextLabel")
                lkLbl.Size = UDim2.new(1, -20, 1, 0)
                lkLbl.Position = UDim2.fromOffset(12, 0)
                lkLbl.BackgroundTransparency = 1
                lkLbl.Text = "🔒 Instant (Premium only)"
                lkLbl.TextColor3 = C.Muted
                lkLbl.Font = Enum.Font.GothamSemibold
                lkLbl.TextSize = CFG.FONT_LABEL
                lkLbl.TextXAlignment = Enum.TextXAlignment.Left
                lkLbl.Parent = lockedFrame
            end
        end

        rebuildReturnModeUI()
        _G.VRILZ_RebuildReturnMode = rebuildReturnModeUI

        -- Status card
        -- Status card
        local infoCard, infoContent = makeCard(mutRight, "📊 STATUS MUTATION", 2)

        local mutInfoLbl = Instance.new("TextLabel")
        mutInfoLbl.Size = UDim2.new(1, 0, 0, 90)
        mutInfoLbl.BackgroundColor3 = C.Surface3
        mutInfoLbl.BackgroundTransparency = 0.3
        mutInfoLbl.BorderSizePixel = 0
        mutInfoLbl.Text = "Loading..."
        mutInfoLbl.TextColor3 = C.Text
        mutInfoLbl.Font = Enum.Font.Code
        mutInfoLbl.TextSize = CFG.FONT_MUTED
        mutInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
        mutInfoLbl.TextYAlignment = Enum.TextYAlignment.Top
        mutInfoLbl.LayoutOrder = 1
        mutInfoLbl.Parent = infoContent

        local mic = Instance.new("UICorner")
        mic.CornerRadius = UDim.new(0, 6)
        mic.Parent = mutInfoLbl

        task.spawn(function()
            while mutInfoLbl.Parent do
                task.wait(0.5)
                local lines = {}
                local F = getFeatures()

                if F and F.isHoldingEgg then
                    local holding, eggName = F.isHoldingEgg()
                    table.insert(lines, "✋ Held: " .. (holding and ("YES " .. (eggName or "?")) or "no"))
                else
                    table.insert(lines, "✋ Held: --")
                end

                if F and F.getMutationState then
                    local state = F.getMutationState()
                    table.insert(lines, "🔒 Lock: " .. (state.EggLocked and "YES" or "no"))
                    table.insert(lines, "⏸ Paused: " .. (state.StealPaused and "YES" or "no"))
                    table.insert(lines, "▶ Running: " .. (state.Running and "YES" or "no"))
                end

                mutInfoLbl.Text = table.concat(lines, "\n")
            end
        end)
    end

    registerTab("Info", "ℹ", "Info")
    registerTab("Prediksi", "◎", "Prediksi")
    registerTab("Egg", "◯", "Egg")
    registerTab("Visual", "👁️", "Visual")
    registerTab("Auto", "▶", "Auto")
    registerTab("Event", "👻", "Event")  
    registerTab("EggMutation", "⚔️", "EggMutation")  
    registerTab("Webhook", "🔔", "Webhook")
    registerTab("Settings", "⚙", "Settings")

                -- ⭐ AUTO BUKA TAB INFO PAS PERTAMA LAUNCH
    task.defer(function()
        local tries = 0
        while tries < 30 do
            if type(_G.VRILZ_SwitchTab) == "table"
                and type(_G.VRILZ_SwitchTab.Info) == "function" then
                local ok, err = pcall(_G.VRILZ_SwitchTab.Info)
                if not ok then
                    warn("[TAB] Auto-open Info failed: " .. tostring(err))
                end
                return
            end
            task.wait(0.1)
            tries = tries + 1
        end
        warn("[TAB] _G.VRILZ_SwitchTab.Info not registered after 3s!")
    end)

        -- Drag handler (PC + Mobile) — single source of truth
do
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local dragInput = nil

    local function isPress(input)
        return input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
    end

    header.InputBegan:Connect(function(input)
        if not isPress(input) then return end

        -- Jangan drag kalau klik area tombol close/min (kanan header)
        local posX = input.Position.X
        if posX > (header.AbsolutePosition.X + header.AbsoluteSize.X - 90) then return end
        if dragging then return end  -- ⭐ FIX: jangan re-trigger

        dragging = true
        dragStart = input.Position
        startPos = main.Position
        dragInput = input
    end)

    -- ⭐ FIX: reset via global InputEnded, gak peduli di mana jari/mouse diangkat
    UserInputService.InputEnded:Connect(function(input)
        if dragInput == input then
            dragging = false
            dragInput = nil
            dragStart = nil
            startPos = nil
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseMovement
            and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        if not dragStart or not startPos then return end

        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end)
end

-- ⭐ PANGGIL EGG EXECUTOR DI SINI
    buildEggExecutorGUI(screenGui)

    return main
end

-- ============================================================
-- KEY SYSTEM GATE
-- Only adds a window before the existing loading screen.
-- Existing main UI/loading code remains unchanged.
-- ============================================================

local function getHttpRequest()
    return (syn and syn.request)
        or (http and http.request)
        or (http_request)
        or (request)
end

local function getKeyStorage()
    local ok, env = pcall(function()
        if getgenv then
            return getgenv()
        end
        return _G
    end)
    if ok and type(env) == "table" then
        return env
    end
    return _G
end

local function loadSavedKey()
    local env = getKeyStorage()
    local saved = env.VRILZ_KEY
    if type(saved) == "string" and saved:gsub("%s+", "") ~= "" then
        return saved
    end

    if readfile and isfile then
        local okFile, exists = pcall(isfile, "vrilz_key.txt")
        if okFile and exists then
            local okRead, content = pcall(readfile, "vrilz_key.txt")
            if okRead and type(content) == "string" and content:gsub("%s+", "") ~= "" then
                return content
            end
        end
    end

    return nil
end

local function saveKey(key)
    key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", ""):upper()
    if key == "" then return end

    local env = getKeyStorage()
    env.VRILZ_KEY = key

    if writefile then
        pcall(writefile, "vrilz_key.txt", key)
    end

    -- ⭐ Update _RealKeyType juga — biar transisi OFF pakai key baru
    if Shared then
        Shared._RealKeyType = Shared.KeyType
        Shared._RealKeyExpiresAt = Shared.KeyExpiresAt or 0
    end
end

local function clearSavedKey()
    local env = getKeyStorage()
    env.VRILZ_KEY = nil
    if delfile and isfile then
        local okFile, exists = pcall(isfile, "vrilz_key.txt")
        if okFile and exists then
            pcall(delfile, "vrilz_key.txt")
        end
    end
end

local function applyKeyInfo(data, key)
    if type(data) ~= "table" then return end
    Shared = Shared or {}
    Shared.KeyValue = key
    Shared.KeyType = tostring(data.type or data.key_type or "UNKNOWN"):upper()
    Shared.KeyExpiresAt = tonumber(data.expires_at or data.expiry or 0) or 0
end

-- Stable device ID for Premium device-limit tracking.
-- Persists in executor file storage when available, so the same device
-- is recognized again after rejoining/reloading the script.
local function getStableDeviceId()
    local env = getKeyStorage()
    local cached = env.VRILZ_DEVICE_ID
    if type(cached) == "string" and #cached >= 8 then
        return cached
    end

    local fileName = "vrilz_device_id.txt"

    if readfile and isfile then
        local okFile, exists = pcall(isfile, fileName)
        if okFile and exists then
            local okRead, content = pcall(readfile, fileName)
            if okRead and type(content) == "string" then
                content = content:gsub("^%s+", ""):gsub("%s+$", "")
                if #content >= 8 then
                    env.VRILZ_DEVICE_ID = content
                    return content
                end
            end
        end
    end

    local HttpService = game:GetService("HttpService")
    local generated = nil

    pcall(function()
        generated = HttpService:GenerateGUID(false)
    end)

    if type(generated) ~= "string" or #generated < 8 then
        generated = tostring(LocalPlayer.UserId) .. "-" .. tostring(game.PlaceId)
    end

    env.VRILZ_DEVICE_ID = generated

    if writefile then
        pcall(writefile, fileName, generated)
    end

    return generated
end

local function verifyKeyWithServer(key)
    key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", ""):upper()
    if key == "" then
        return false, "Please enter a key first."
    end

    if KEY_SYSTEM_URL:find("YOUR%-KEY%-SYSTEM") then
        return false, "Please set the Key System URL first."
    end

    local HttpService = game:GetService("HttpService")
    local payload = HttpService:JSONEncode({
        username = LocalPlayer.Name,
        key = key,
        device_id = getStableDeviceId(),
    })
    local url = KEY_SYSTEM_URL:gsub("/$", "") .. "/api/redeem"

    local ok, response = pcall(function()
        local req = getHttpRequest()
        if req then
            return req({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Accept"] = "application/json",
                },
                Body = payload,
            })
        end

        return {
            StatusCode = 200,
            Body = HttpService:PostAsync(
                url,
                payload,
                Enum.HttpContentType.ApplicationJson,
                false,
                { ["Accept"] = "application/json" }
            )
        }
    end)

    if not ok or not response then
        return false, "Cannot connect to Key System."
    end

    local status = tonumber(response.StatusCode or response.Status or 0) or 0
    local body = response.Body or response.body or ""
    local decodedOk, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)

    if decodedOk and type(data) == "table" then
        if data.success == true then
            return true, data.message or "Key valid.", data
        end
        local serverMessage = tostring(data.message or "Invalid key.")
        if status > 0 and status ~= 200 then
            serverMessage = serverMessage .. " [HTTP " .. tostring(status) .. "]"
        end
        return false, serverMessage, data
    end

    if status >= 200 and status < 300 then
        return false, "Invalid Key System response."
    end

    return false, "Key System server error [HTTP " .. tostring(status) .. "]."
end

-- Mengecek key yang SUDAH pernah diredeem tanpa membuat redeem kedua.
-- Return: (valid, message, data, isNetworkError)
local function verifySavedKeyWithServer(key)
    key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", ""):upper()
    if key == "" then
        return false, "Saved key is empty.", nil, false
    end

    local HttpService = game:GetService("HttpService")
    local payload = HttpService:JSONEncode({
        username = LocalPlayer.Name,
        key = key,
        device_id = getStableDeviceId(),
    })
    local url = KEY_SYSTEM_URL:gsub("/$", "") .. "/api/verify"

    local ok, response = pcall(function()
        local req = getHttpRequest()
        if req then
            return req({
                Url = url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Accept"] = "application/json",
                },
                Body = payload,
            })
        end

        return {
            StatusCode = 200,
            Body = HttpService:PostAsync(
                url,
                payload,
                Enum.HttpContentType.ApplicationJson,
                false,
                { ["Accept"] = "application/json" }
            )
        }
    end)

    -- ⭐ Network / request gagal total → bukan invalid key
    if not ok or not response then
        return false, "Cannot verify saved key (network).", nil, true
    end

    local status = tonumber(response.StatusCode or response.Status or 0) or 0
    local body = response.Body or response.body or ""
    local decodedOk, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)

    -- ⭐ Server error 5xx → network/server issue, bukan invalid
    if status >= 500 then
        return false, "Key server error [HTTP " .. tostring(status) .. "]", nil, true
    end

    -- ⭐ Response bukan JSON valid → anggap network error
    if not decodedOk or type(data) ~= "table" then
        if status >= 200 and status < 300 then
            return false, "Invalid Key System response.", nil, true
        end
        return false, "Invalid key.", nil, false
    end

    if data.success == true then
        return true, data.message or "Key is still active.", data, false
    end

    -- ⭐ Cek apakah ini network-ish error dari server
    local msg = tostring(data.message or "")
    local msgLower = msg:lower()
    if msgLower:find("network")
        or msgLower:find("timeout")
        or msgLower:find("connect")
        or msgLower:find("server")
        or msgLower:find("unavailable")
    then
        return false, msg, data, true
    end

    -- ⭐ Invalid key beneran
    return false, msg ~= "" and msg or "Invalid key.", data, false
end

-- ============================================================
-- 🌌 LOADING SCREEN v2 — BULAN + METEOR SHOWER
-- ============================================================
local function buildLoadingScreen(parent)
    local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)

    local winW = IS_MOBILE and 340 or 460
    local winH = IS_MOBILE and 280 or 320

    -- ═══ MAIN CONTAINER ═══
    local loading = Instance.new("Frame")
    loading.Name = "LoadingScreen"
    loading.AnchorPoint = Vector2.new(0.5, 0.5)
    loading.Position = UDim2.fromScale(0.5, 0.5)
    loading.Size = UDim2.fromOffset(0, 0)
    loading.BackgroundColor3 = Color3.fromRGB(5, 8, 20)
    loading.BorderSizePixel = 0
    loading.ZIndex = 300
    loading.ClipsDescendants = true
    loading.Parent = parent

    -- ═══ DEEP SPACE GRADIENT ═══
    local bgGradient = Instance.new("UIGradient")
    bgGradient.Rotation = 115
    bgGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 20, 45)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(8, 12, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 3, 10)),
    })
    bgGradient.Parent = loading

    -- ═══ STROKE (neon cyan) ═══
    local stroke1 = Instance.new("UIStroke")
    stroke1.Color = Color3.fromRGB(80, 200, 255)
    stroke1.Thickness = 2.5
    stroke1.Transparency = 0.1
    stroke1.Parent = loading

    local stroke2 = Instance.new("UIStroke")
    stroke2.Color = Color3.fromRGB(255, 255, 255)
    stroke2.Thickness = 1
    stroke2.Transparency = 0.8
    stroke2.Parent = loading

    -- ═══ STARFIELD (bintang statis) ═══
    local starfield = Instance.new("Frame")
    starfield.Size = UDim2.fromScale(1, 1)
    starfield.BackgroundTransparency = 1
    starfield.ZIndex = 301
    starfield.ClipsDescendants = true
    starfield.Parent = loading

    for i = 1, 60 do
        local star = Instance.new("Frame")
        local sz = math.random(1, 3)
        star.Size = UDim2.fromOffset(sz, sz)
        star.Position = UDim2.fromScale(math.random(0, 100) / 100, math.random(0, 100) / 100)
        star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        star.BackgroundTransparency = math.random(20, 70) / 100
        star.BorderSizePixel = 0
        star.ZIndex = 302
        star.Parent = starfield

        local sc = Instance.new("UICorner")
        sc.CornerRadius = UDim.new(1, 0)
        sc.Parent = star

        -- Twinkle animation
        task.spawn(function()
            local baseTrans = star.BackgroundTransparency
            while star.Parent do
                task.wait(math.random(15, 40) / 10)
                if not star.Parent then break end
                TweenService:Create(star, TweenInfo.new(0.6), {BackgroundTransparency = baseTrans - 0.3}):Play()
                task.wait(0.6)
                TweenService:Create(star, TweenInfo.new(0.6), {BackgroundTransparency = baseTrans}):Play()
            end
        end)
    end

    -- ═══ MOON (bulan glow) ═══
    local moonSize = IS_MOBILE and 80 or 110
    local moonX = winW * 0.72
    local moonY = winH * 0.22

    -- Outer glow (halo)
    local moonGlow = Instance.new("Frame")
    moonGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    moonGlow.Position = UDim2.fromOffset(moonX, moonY)
    moonGlow.Size = UDim2.fromOffset(moonSize + 60, moonSize + 60)
    moonGlow.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
    moonGlow.BackgroundTransparency = 0.85
    moonGlow.BorderSizePixel = 0
    moonGlow.ZIndex = 303
    moonGlow.Parent = loading
    local mg1c = Instance.new("UICorner")
    mg1c.CornerRadius = UDim.new(1, 0)
    mg1c.Parent = moonGlow

    -- Mid glow
    local moonGlow2 = Instance.new("Frame")
    moonGlow2.AnchorPoint = Vector2.new(0.5, 0.5)
    moonGlow2.Position = UDim2.fromOffset(moonX, moonY)
    moonGlow2.Size = UDim2.fromOffset(moonSize + 25, moonSize + 25)
    moonGlow2.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
    moonGlow2.BackgroundTransparency = 0.7
    moonGlow2.BorderSizePixel = 0
    moonGlow2.ZIndex = 304
    moonGlow2.Parent = loading
    local mg2c = Instance.new("UICorner")
    mg2c.CornerRadius = UDim.new(1, 0)
    mg2c.Parent = moonGlow2

    -- Moon body
    local moon = Instance.new("Frame")
    moon.AnchorPoint = Vector2.new(0.5, 0.5)
    moon.Position = UDim2.fromOffset(moonX, moonY)
    moon.Size = UDim2.fromOffset(moonSize, moonSize)
    moon.BackgroundColor3 = Color3.fromRGB(240, 245, 255)
    moon.BorderSizePixel = 0
    moon.ZIndex = 305
    moon.Parent = loading
    local moonCorner = Instance.new("UICorner")
    moonCorner.CornerRadius = UDim.new(1, 0)
    moonCorner.Parent = moon

    -- Moon gradient (3D effect)
    local moonGradient = Instance.new("UIGradient")
    moonGradient.Rotation = 135
    moonGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(220, 230, 250)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 160, 200)),
    })
    moonGradient.Parent = moon

    -- Moon craters
    local craters = {
        {0.3, 0.3, 0.15},
        {0.65, 0.45, 0.12},
        {0.5, 0.65, 0.10},
        {0.25, 0.55, 0.08},
    }
    for _, crater in ipairs(craters) do
        local c = Instance.new("Frame")
        c.AnchorPoint = Vector2.new(0.5, 0.5)
        c.Position = UDim2.fromScale(crater[1], crater[2])
        c.Size = UDim2.fromScale(crater[3], crater[3])
        c.BackgroundColor3 = Color3.fromRGB(180, 195, 225)
        c.BackgroundTransparency = 0.3
        c.BorderSizePixel = 0
        c.ZIndex = 306
        c.Parent = moon
        local cc = Instance.new("UICorner")
        cc.CornerRadius = UDim.new(1, 0)
        cc.Parent = c
    end

    -- Moon pulse glow
    task.spawn(function()
        while moonGlow.Parent do
            moonGlow.BackgroundTransparency = 0.85
            TweenService:Create(moonGlow, TweenInfo.new(2.5), {BackgroundTransparency = 0.92}):Play()
            task.wait(2.5)
        end
    end)

    -- ═══ METEOR SHOWER (jatuh terus-terusan) ═══
    local meteorLayer = Instance.new("Frame")
    meteorLayer.Size = UDim2.fromScale(1, 1)
    meteorLayer.BackgroundTransparency = 1
    meteorLayer.ZIndex = 310
    meteorLayer.ClipsDescendants = true
    meteorLayer.Parent = loading

    local meteorActive = true
    loading.Destroying:Connect(function()
        meteorActive = false
    end)

    local function spawnMeteor()
        if not meteorActive or not meteorLayer.Parent then return end

        local meteor = Instance.new("Frame")
        meteor.AnchorPoint = Vector2.new(0.5, 0.5)
        
        -- Start position (random top area)
        local startX = math.random(-100, winW + 100)
        local startY = -50
        meteor.Position = UDim2.fromOffset(startX, startY)
        meteor.Size = UDim2.fromOffset(3, 3)
        meteor.BackgroundColor3 = Color3.fromRGB(200, 230, 255)
        meteor.BorderSizePixel = 0
        meteor.Rotation = 45
        meteor.ZIndex = 311
        meteor.Parent = meteorLayer

        local mc = Instance.new("UICorner")
        mc.CornerRadius = UDim.new(1, 0)
        mc.Parent = meteor

        -- Meteor head glow
        local headGlow = Instance.new("Frame")
        headGlow.AnchorPoint = Vector2.new(0.5, 0.5)
        headGlow.Position = UDim2.fromScale(0.5, 0.5)
        headGlow.Size = UDim2.fromOffset(12, 12)
        headGlow.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
        headGlow.BackgroundTransparency = 0.5
        headGlow.BorderSizePixel = 0
        headGlow.ZIndex = 310
        headGlow.Parent = meteor
        local hgc = Instance.new("UICorner")
        hgc.CornerRadius = UDim.new(1, 0)
        hgc.Parent = headGlow

        -- Trail (fire tail)
        local trail = Instance.new("Frame")
        trail.AnchorPoint = Vector2.new(1, 0.5)
        trail.Position = UDim2.fromScale(0.5, 0.5)
        trail.Size = UDim2.fromOffset(math.random(40, 90), 2)
        trail.BackgroundColor3 = Color3.fromRGB(150, 200, 255)
        trail.BackgroundTransparency = 0.3
        trail.BorderSizePixel = 0
        trail.ZIndex = 309
        trail.Parent = meteor

        local trailGrad = Instance.new("UIGradient")
        trailGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.3, 0.2),
            NumberSequenceKeypoint.new(1, 0),
        })
        trailGrad.Parent = trail

        -- Trail sparks (3-5 titik)
        for i = 1, math.random(3, 5) do
            local spark = Instance.new("Frame")
            spark.AnchorPoint = Vector2.new(0.5, 0.5)
            spark.Position = UDim2.new(1, math.random(-40, -10), 0.5, math.random(-3, 3))
            spark.Size = UDim2.fromOffset(math.random(2, 4), math.random(2, 4))
            spark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            spark.BackgroundTransparency = 0.4
            spark.BorderSizePixel = 0
            spark.ZIndex = 308
            spark.Parent = meteor
            local sc = Instance.new("UICorner")
            sc.CornerRadius = UDim.new(1, 0)
            sc.Parent = spark
        end

        -- Duration & end position
        local duration = math.random(120, 200) / 100
        local endX = startX + math.random(-80, 80)
        local endY = winH + 100

        -- Animate fall
        TweenService:Create(meteor, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Position = UDim2.fromOffset(endX, endY),
            Rotation = 45,
        }):Play()

        -- Fade out near end
        task.delay(duration * 0.8, function()
            if meteor.Parent then
                TweenService:Create(meteor, TweenInfo.new(duration * 0.2), {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(headGlow, TweenInfo.new(duration * 0.2), {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(trail, TweenInfo.new(duration * 0.2), {
                    BackgroundTransparency = 1,
                }):Play()
            end
        end)

        -- Cleanup
        task.delay(duration + 0.1, function()
            if meteor then meteor:Destroy() end
        end)
    end

    -- Meteor spawner loop (continuous)
    task.spawn(function()
        task.wait(0.3)  -- delay awal
        while meteorActive do
            spawnMeteor()
            -- Spawn 1-2 meteor sekaligus, dengan jeda acak
            if math.random() < 0.3 then
                task.wait(0.1)
                spawnMeteor()
            end
            task.wait(math.random(30, 90) / 100)
        end
    end)

    -- ═══ SCANLINES (subtle) ═══
    local scanlines = Instance.new("Frame")
    scanlines.Size = UDim2.fromScale(1, 1)
    scanlines.BackgroundTransparency = 1
    scanlines.ZIndex = 320
    scanlines.ClipsDescendants = true
    scanlines.Parent = loading

    for i = 0, math.floor(winH / 5) do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.fromOffset(0, i * 5)
        line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        line.BackgroundTransparency = 0.85
        line.BorderSizePixel = 0
        line.ZIndex = 320
        line.Parent = scanlines
    end

    -- ═══ NOISE ═══
    local noise = Instance.new("Frame")
    noise.Size = UDim2.fromScale(1, 1)
    noise.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    noise.BackgroundTransparency = 0.94
    noise.BorderSizePixel = 0
    noise.ZIndex = 319
    noise.Parent = loading

    task.spawn(function()
        while noise.Parent do
            task.wait(0.06)
            noise.BackgroundTransparency = 0.90 + math.random() * 0.06
        end
    end)

    -- ═══ GLITCH BARS ═══
    local glitchBars = {}
    for i = 1, 4 do
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, math.random(2, 4))
        bar.Position = UDim2.fromScale(0, math.random())
        bar.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
        bar.BackgroundTransparency = 0.6
        bar.BorderSizePixel = 0
        bar.ZIndex = 330
        bar.Visible = false
        bar.Parent = loading
        table.insert(glitchBars, bar)
    end

    task.spawn(function()
        while loading.Parent do
            task.wait(math.random(15, 40) / 100)
            for _, bar in ipairs(glitchBars) do
                if math.random() < 0.3 then
                    bar.Visible = true
                    bar.Position = UDim2.fromScale(0, math.random())
                    bar.Size = UDim2.new(1, 0, 0, math.random(2, 6))
                    task.wait(0.03)
                    bar.Visible = false
                end
            end
        end
    end)

    -- ═══ VH LOGO (3D + petir) ═══
    local vHolder = Instance.new("Frame")
    vHolder.Size = UDim2.fromScale(1, 0.5)
    vHolder.Position = UDim2.fromScale(0, 0.18)
    vHolder.BackgroundTransparency = 1
    vHolder.ZIndex = 305
    vHolder.Parent = loading

    local vGlow = Instance.new("TextLabel")
    vGlow.Size = UDim2.fromScale(1, 1)
    vGlow.BackgroundTransparency = 1
    vGlow.Text = "V"
    vGlow.TextColor3 = Color3.fromRGB(100, 200, 255)
    vGlow.TextTransparency = 0.3
    vGlow.Font = Enum.Font.GothamBlack
    vGlow.TextSize = 1
    vGlow.ZIndex = 304
    vGlow.Parent = vHolder

    local vRed = Instance.new("TextLabel")
    vRed.Size = UDim2.fromScale(1, 1)
    vRed.Position = UDim2.fromOffset(-2, 0)
    vRed.BackgroundTransparency = 1
    vRed.Text = "V"
    vRed.TextColor3 = Color3.fromRGB(255, 0, 0)
    vRed.TextTransparency = 0.6
    vRed.Font = Enum.Font.GothamBlack
    vRed.TextSize = 1
    vRed.ZIndex = 305
    vRed.Parent = vHolder

    local vBlue = Instance.new("TextLabel")
    vBlue.Size = UDim2.fromScale(1, 1)
    vBlue.Position = UDim2.fromOffset(2, 0)
    vBlue.BackgroundTransparency = 1
    vBlue.Text = "V"
    vBlue.TextColor3 = Color3.fromRGB(0, 100, 255)
    vBlue.TextTransparency = 0.6
    vBlue.Font = Enum.Font.GothamBlack
    vBlue.TextSize = 1
    vBlue.ZIndex = 305
    vBlue.Parent = vHolder

    local vLabel = Instance.new("TextLabel")
    vLabel.Size = UDim2.fromScale(1, 1)
    vLabel.BackgroundTransparency = 1
    vLabel.Text = "V"
    vLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    vLabel.Font = Enum.Font.GothamBlack
    vLabel.TextSize = 1
    vLabel.ZIndex = 306
    vLabel.Parent = vHolder

    -- Glitch anim
    task.spawn(function()
        while loading.Parent do
            task.wait(math.random(8, 20) / 100)
            local offset = math.random(1, 4)
            vRed.Position = UDim2.fromOffset(-offset, 0)
            vBlue.Position = UDim2.fromOffset(offset, 0)
            task.wait(0.05)
            vRed.Position = UDim2.fromOffset(-1, 0)
            vBlue.Position = UDim2.fromOffset(1, 0)
        end
    end)

    -- Glow pulse
    task.spawn(function()
        while loading.Parent do
            task.wait(0.6)
            TweenService:Create(vGlow, TweenInfo.new(0.6), {TextTransparency = 0.05}):Play()
            task.wait(0.6)
            TweenService:Create(vGlow, TweenInfo.new(0.6), {TextTransparency = 0.4}):Play()
        end
    end)

    -- Grow animation
    task.spawn(function()
        local endSize = IS_MOBILE and 100 or 130
        local steps = 40
        for i = 1, steps do
            task.wait(1.0 / steps)
            local t = i / steps
            local eased = 1 - (1 - t) ^ 3
            local size = 1 + (endSize - 1) * eased
            vLabel.TextSize = size
            vGlow.TextSize = size
            vRed.TextSize = size
            vBlue.TextSize = size
        end

        -- Final shake
        task.wait(0.2)
        for i = 1, 6 do
            vLabel.Position = UDim2.fromOffset(math.random(-5, 5), math.random(-5, 5))
            task.wait(0.04)
            vLabel.Position = UDim2.fromOffset(0, 0)
        end
    end)

    -- ═══ LOADING TEXT (bottom) ═══
    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, -20, 0, 18)
    loadingText.Position = UDim2.new(0, 10, 0, winH - 68)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "LOADING..."
    loadingText.TextColor3 = Color3.fromRGB(200, 230, 255)
    loadingText.Font = Enum.Font.GothamBlack
    loadingText.TextSize = IS_MOBILE and 11 or 12
    loadingText.TextXAlignment = Enum.TextXAlignment.Left
    loadingText.ZIndex = 306
    loadingText.Parent = loading

    -- Progress bar bg
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -20, 0, 6)
    barBg.Position = UDim2.new(0, 10, 0, winH - 44)
    barBg.BackgroundColor3 = Color3.fromRGB(20, 30, 60)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 305
    barBg.Parent = loading

    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barBg

    local barStroke = Instance.new("UIStroke")
    barStroke.Color = Color3.fromRGB(80, 200, 255)
    barStroke.Thickness = 1
    barStroke.Transparency = 0.3
    barStroke.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(80, 200, 255)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 306
    barFill.Parent = barBg

    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill

    local barFillGlow = Instance.new("UIGradient")
    barFillGlow.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 200, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 220, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 200, 255)),
    })
    barFillGlow.Parent = barFill

    -- Percent
    local percentLbl = Instance.new("TextLabel")
    percentLbl.Size = UDim2.new(1, -20, 0, 14)
    percentLbl.Position = UDim2.new(0, 10, 0, winH - 26)
    percentLbl.BackgroundTransparency = 1
    percentLbl.Text = "0%"
    percentLbl.TextColor3 = Color3.fromRGB(80, 200, 255)
    percentLbl.Font = Enum.Font.GothamBlack
    percentLbl.TextSize = 10
    percentLbl.TextXAlignment = Enum.TextXAlignment.Right
    percentLbl.ZIndex = 306
    percentLbl.Parent = loading

    local brandLbl = Instance.new("TextLabel")
    brandLbl.Size = UDim2.new(1, -20, 0, 14)
    brandLbl.Position = UDim2.new(0, 10, 0, winH - 26)
    brandLbl.BackgroundTransparency = 1
    brandLbl.Text = "V R I L Z H U B"
    brandLbl.TextColor3 = Color3.fromRGB(100, 140, 180)
    brandLbl.Font = Enum.Font.GothamBold
    brandLbl.TextSize = 10
    brandLbl.TextXAlignment = Enum.TextXAlignment.Left
    brandLbl.ZIndex = 306
    brandLbl.Parent = loading

    -- ═══ MAIN LOADING SEQUENCE ═══
    task.spawn(function()
        loading.Size = UDim2.fromOffset(0, 0)
        TweenService:Create(loading, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(winW, winH)
        }):Play()
        task.wait(0.6)

        loadingText.Text = "INITIALIZING..."
        for i = 1, 30 do
            task.wait(0.1)
            local p = (i / 30) * 0.15
            barFill.Size = UDim2.new(p, 0, 1, 0)
            percentLbl.Text = math.floor(p * 100) .. "%"
        end

        local phases = {
            {text = "LOADING MODULES...", target = 0.4, duration = 2.5},
            {text = "CONNECTING SERVER...", target = 0.6, duration = 2.5},
            {text = "LOADING FEATURES...", target = 0.8, duration = 2.5},
            {text = "FINALIZING...", target = 1.0, duration = 2.5},
        }

        for _, phase in ipairs(phases) do
            loadingText.Text = phase.text
            local startP = barFill.Size.X.Scale
            local steps = math.floor(phase.duration / 0.05)
            for i = 1, steps do
                task.wait(0.05)
                local t = i / steps
                local p = startP + (phase.target - startP) * t
                barFill.Size = UDim2.new(p, 0, 1, 0)
                percentLbl.Text = math.floor(p * 100) .. "%"
            end
        end

        loadingText.Text = "READY!"
        percentLbl.Text = "100%"

        -- Final shake
        for i = 1, 8 do
            loading.Position = UDim2.fromScale(0.5 + math.random(-15, 15)/1000, 0.5 + math.random(-15, 15)/1000)
            task.wait(0.03)
        end
        loading.Position = UDim2.fromScale(0.5, 0.5)

        task.wait(0.6)

        -- Stop meteor spawn
        meteorActive = false

        TweenService:Create(loading, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.wait(0.5)

        if loading then loading:Destroy() end
        buildMainWindow(parent)
        notify("Welcome, " .. LocalPlayer.DisplayName, "success")

        -- Features.Init after UI ready
        task.spawn(function()
            task.wait(0.5)
            local timeout = 0
            while not _G.VRILZ_Features and timeout < 10 do
                task.wait(0.5)
                timeout = timeout + 0.5
            end

            if _G.VRILZ_Features and _G.VRILZ_Features.Init then
                print("[UI] ✅ Starting Features (after key + loading)...")
                local ok, err = pcall(function()
                    _G.VRILZ_Features.Init(Shared)
                end)
                if not ok then
                    warn("[UI] ❌ Features.Init failed: " .. tostring(err))
                end
            else
                warn("[UI] ❌ _G.VRILZ_Features not loaded!")
            end
        end)
    end)
end

-- ============================================================
-- ARQEL KEY SYSTEM UI — PORT PERSIS (UI only)
-- Logic verify/storage tetap VRILZHUB
-- ============================================================

local ArqelUI = {}

-- ===== SERVICES =====
local A_Tween = TweenService
local A_UIS = UserInputService
local A_Http = game:GetService("HttpService")
local A_WS = workspace
local A_Run = RunService
local A_Light = Lighting
local A_Players = Players
local A_LP = LocalPlayer
local A_hui = (gethui and gethui()) or game:GetService("CoreGui")

-- ===== APPEARANCE =====
local A_Appearance = {
    Title = "VRILZHUB",
    Subtitle = "Enter your key to continue",
    Icon = "rbxassetid://95721401302279",
    IconSize = UDim2.new(0, 30, 0, 30)
}

local A_Links = {
    GetKey = KEY_SYSTEM_URL,
    Discord = "https://discord.gg/psWhrYWbq"
}

-- Changelog VRILZHUB
local A_Changelog = {
    {
        Version = "v2.4",
        Date = "19 Okt 2026",
        Changes = {
            "Fly Chard (Character Fly)",
            "TP Mode (Glide / Fast)",
            "Gui Stats (FPS / Ping window)",
            "Auto Event (Halloween Candy)",
            "Auto Yin Ritual",
            "Auto Obby (Talk + Finish)",
            "Infinity Jump",
            "Live Chat Global",
            "Webhook Platinum Edition",
        }
    },
    {
        Version = "v2.1",
        Date = "10 Okt 2026",
        Changes = {
            "Auto Steal (Rarity / Name filter)",
            "Auto Mutation + Return to Plot",
            "Egg Executor (Steal from here)",
            "4K HD Mode + FPS Boost",
        }
    }
}

-- ===== THEME (Arqel persis) =====
local A_Theme = {
    Accent = Color3.fromRGB(139, 0, 0),
    AccentHover = Color3.fromRGB(170, 20, 20),
    Background = Color3.fromRGB(15, 15, 15),
    Header = Color3.fromRGB(20, 20, 20),
    Input = Color3.fromRGB(25, 25, 25),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(120, 120, 120),
    Success = Color3.fromRGB(50, 205, 110),
    Error = Color3.fromRGB(245, 70, 90),
    Warning = Color3.fromRGB(255, 180, 50),
    StatusIdle = Color3.fromRGB(180, 80, 80),
    Discord = Color3.fromRGB(88, 101, 242),
    DiscordHover = Color3.fromRGB(114, 137, 218),
    Divider = Color3.fromRGB(45, 45, 70),
    Pending = Color3.fromRGB(60, 60, 60)
}

-- ===== INTERNAL =====
local A_Internal = {
    BlurEffect = nil,
    NotificationList = {},
    IsKeylessMode = false
}

-- ===== ICONS =====
local A_IconBaseURL = "https://raw.githubusercontent.com/Cobruhehe/expert-octo-doodle/main/Icons/"
local A_IconFiles = {
    key = "lucide--key.png",
    shield = "lucide--shield-minus.png",
    check = "prime--check-square.png",
    copy = "flowbite--clipboard-outline.png",
    discord = "qlementine-icons--discord-16.png",
    alert = "mdi--alert-octagon-outline.png",
    lock = "lucide--user-lock.png",
    loading = "nonicons--loading-16.png",
    close = "material-symbols--dangerous-outline.png",
    changelog = "ant-design--sync-outlined.png",
    logo = "rrjlGmac.png",
    user = "U.png",
    clock = "Clock.png",
    cart = "Cart.png",
    nogetkey = "lucide--lock.png"
}

local A_FallbackIcons = {
    key = "rbxassetid://96510194465420",
    shield = "rbxassetid://89965059528921",
    check = "rbxassetid://76078495178149",
    copy = "rbxassetid://125851897718493",
    discord = "rbxassetid://83278450537116",
    alert = "rbxassetid://140438367956051",
    lock = "rbxassetid://114355063515473",
    loading = "rbxassetid://116535712789945",
    close = "rbxassetid://6022668916",
    changelog = "rbxassetid://138133190015277",
    logo = "rbxassetid://95721401302279",
    user = "rbxassetid://77400125196692",
    clock = "rbxassetid://87505349362628",
    cart = "rbxassetid://114754518183872",
    nogetkey = "rbxassetid://119765975153029"
}

local A_CachedIcons = {}
local A_FolderName = "VRILZHUB_KS"
local A_IconsFolder = "Icons"
local A_DefaultLogoAsset = "rbxassetid://95721401302279"

-- ===== HELPER =====
local function a_isMobile()
    return A_UIS.TouchEnabled and not A_UIS.KeyboardEnabled
end

local function a_getScale()
    local vp = A_WS.CurrentCamera.ViewportSize
    return math.clamp(math.min(vp.X, vp.Y) / 900, 0.65, 1.3)
end

local function a_hasFileSystem()
    local ok1 = pcall(function() return type(writefile) == "function" end)
    local ok2 = pcall(function() return type(readfile) == "function" end)
    local ok3 = pcall(function() return type(isfile) == "function" end)
    local ok4 = pcall(function() return type(makefolder) == "function" end)
    local ok5 = pcall(function() return type(isfolder) == "function" end)
    return ok1 and ok2 and ok3 and ok4 and ok5
end

local a_fsSupported = a_hasFileSystem()

local function a_ensureFolders()
    if not a_fsSupported then return false end
    pcall(function()
        if not isfolder(A_FolderName) then makefolder(A_FolderName) end
        if not isfolder(A_FolderName .. "/" .. A_IconsFolder) then makefolder(A_FolderName .. "/" .. A_IconsFolder) end
    end)
    return true
end

local function a_getIconPath(name)
    return A_FolderName .. "/" .. A_IconsFolder .. "/" .. A_IconFiles[name]
end

local function a_isIconCached(name)
    if not a_fsSupported then return false end
    local ok, res = pcall(function() return isfile(a_getIconPath(name)) end)
    return ok and res
end

local function a_downloadIcon(name)
    if not a_fsSupported then
        A_CachedIcons[name] = A_FallbackIcons[name]
        return false
    end
    local path = a_getIconPath(name)
    if a_isIconCached(name) then
        local ok = pcall(function() A_CachedIcons[name] = getcustomasset(path) end)
        if ok then return true end
    end
    local ok = pcall(function()
        local res = game:HttpGet(A_IconBaseURL .. A_IconFiles[name])
        if #res < 100 then error("Invalid") end
        writefile(path, res)
        A_CachedIcons[name] = getcustomasset(path)
    end)
    if not ok then A_CachedIcons[name] = A_FallbackIcons[name] end
    return ok
end

local function a_getIcon(name)
    return A_CachedIcons[name] or A_FallbackIcons[name]
end

local function a_getLogoIcon()
    if A_Appearance.Icon == A_DefaultLogoAsset then return a_getIcon("logo") end
    return A_Appearance.Icon
end

local function a_shouldDownloadLogo()
    return A_Appearance.Icon == A_DefaultLogoAsset
end

local function a_allIconsCached()
    if not a_fsSupported then return false end
    local list = {"key","shield","check","copy","discord","alert","lock","loading","close","changelog","user","clock","cart","nogetkey"}
    if a_shouldDownloadLogo() then table.insert(list, "logo") end
    for _, n in ipairs(list) do
        if not a_isIconCached(n) then return false end
    end
    return true
end

local function a_loadAllIcons()
    a_ensureFolders()
    local list = {"key","shield","check","copy","discord","alert","lock","loading","close","changelog","user","clock","cart","nogetkey"}
    if a_shouldDownloadLogo() then table.insert(list, "logo") end
    for _, n in ipairs(list) do a_downloadIcon(n) end
end

local function a_ensureIconsReady(cb)
    if a_allIconsCached() then
        a_loadAllIcons()
        if cb then cb() end
    else
        a_ensureFolders()
        a_loadAllIcons()
        if cb then cb() end
    end
end

local function a_getExecutorName()
    local ok, name = pcall(identifyexecutor)
    if ok and name then return tostring(name) end
    return "Unknown"
end

local function a_getDeviceType()
    local t = A_UIS.TouchEnabled
    local k = A_UIS.KeyboardEnabled
    local g = A_UIS.GamepadEnabled
    if g and not k and not t then return "Console"
    elseif t and not k then return "Mobile"
    elseif k and t then return "PC & Touch"
    elseif k then return "PC"
    else return "Unknown" end
end

local function a_getHWID()
    local hwid = nil
    pcall(function() if gethwid then hwid = gethwid() end end)
    if not hwid then pcall(function() if getgenv().HWID then hwid = getgenv().HWID end end) end
    if not hwid then pcall(function() if game.RobloxHWID then hwid = tostring(game.RobloxHWID) end end) end
    if not hwid then
        hwid = A_Http:GenerateGUID(false):gsub("-", ""):sub(1, 32)
        if A_LP then hwid = tostring(A_LP.UserId) .. hwid:sub(1, 20) end
    end
    return hwid or "N/A"
end

local function a_generateHiddenDots(w, cw)
    cw = cw or 5
    local n = math.max(math.floor(w / cw), 8)
    return string.rep("•", n)
end

local function a_formatTime12()
    local h = tonumber(os.date("%H"))
    local m = os.date("%M")
    local s = os.date("%S")
    local p = "AM"
    if h >= 12 then p = "PM" end
    if h > 12 then h = h - 12 end
    if h == 0 then h = 12 end
    return string.format("%d:%s:%s %s", h, m, s, p)
end

local function a_formatDate()
    return os.date("%b %d, %Y")
end

-- ===== BLUR =====
local function a_enableBlur()
    local existing = A_Light:FindFirstChild("VH_KS_Blur")
    if existing then existing:Destroy() end
    A_Internal.BlurEffect = Instance.new("BlurEffect")
    A_Internal.BlurEffect.Name = "VH_KS_Blur"
    A_Internal.BlurEffect.Size = 0
    A_Internal.BlurEffect.Parent = A_Light
    A_Tween:Create(A_Internal.BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = 24}):Play()
end

local function a_disableBlur()
    if A_Internal.BlurEffect and A_Internal.BlurEffect.Parent then
        A_Tween:Create(A_Internal.BlurEffect, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = 0}):Play()
        task.delay(0.3, function()
            if A_Internal.BlurEffect and A_Internal.BlurEffect.Parent then
                A_Internal.BlurEffect:Destroy()
                A_Internal.BlurEffect = nil
            end
        end)
    else
        local ex = A_Light:FindFirstChild("VH_KS_Blur")
        if ex then ex:Destroy() end
        A_Internal.BlurEffect = nil
    end
end

-- ===== DRAG =====
local function a_setupDragging(header, main)
    local dragging, dragStart, startPos, dragInput
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if dragInput == input then dragging = false dragInput = nil end
                end
            end)
        end
    end)
    A_UIS.InputChanged:Connect(function(input)
        if not dragging or not dragInput then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        elseif input.UserInputType == Enum.UserInputType.Touch then
            if input == dragInput then
                local d = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end
    end)
end

-- ===== NOTIFY (Arqel style — bottom-right, progress bar, stacking) =====
local function a_Notify(title, message, duration, iconType)
    duration = duration or 5
    iconType = iconType or "info"
    local scale = a_getScale()
    local width = math.clamp(320 * scale, 260, 380)
    local height = math.clamp(80 * scale, 75, 105)

    local notifGui = Instance.new("ScreenGui")
    notifGui.ResetOnSpawn = false
    notifGui.DisplayOrder = 999999
    notifGui.Parent = A_hui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, width, 0, height)
    frame.Position = UDim2.new(1, width + 20, 1, -15)
    frame.AnchorPoint = Vector2.new(1, 1)
    frame.BackgroundColor3 = A_Theme.Header
    frame.BorderSizePixel = 0
    frame.Parent = notifGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = A_Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, 0, 0, 2)
    progressBg.Position = UDim2.new(0, 0, 1, -2)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = A_Theme.Accent
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg

    local iconSize = height - 35
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, iconSize, 0, iconSize)
    icon.Position = UDim2.new(0, 14, 0.5, -2)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = frame

    local iconMap = {
        success = {"check", A_Theme.Success}, error = {"alert", A_Theme.Error},
        warning = {"alert", A_Theme.Warning}, shield = {"shield", A_Theme.Accent},
        info = {"shield", A_Theme.Accent}, key = {"key", A_Theme.Accent},
        copy = {"copy", A_Theme.Success}, discord = {"discord", A_Theme.Discord},
        close = {"close", A_Theme.Error}, nogetkey = {"nogetkey", A_Theme.TextDim}
    }

    if iconMap[iconType] then
        icon.Image = a_getIcon(iconMap[iconType][1])
        icon.ImageColor3 = iconMap[iconType][2]
    else
        icon.Image = a_getLogoIcon()
        icon.ImageColor3 = A_Theme.Text
    end

    local textX = 14 + iconSize + 14
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -(textX + 14), 0, 24)
    titleLabel.Position = UDim2.new(0, textX, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.ArimoBold
    titleLabel.TextSize = math.clamp(15 * scale, 13, 18)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = A_Theme.Text
    titleLabel.Text = title
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = frame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -(textX + 14), 0, 22)
    messageLabel.Position = UDim2.new(0, textX, 0, 38)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.ArimoBold
    messageLabel.TextSize = math.clamp(13 * scale, 11, 15)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextColor3 = A_Theme.TextDim
    messageLabel.Text = message
    messageLabel.TextTruncate = Enum.TextTruncate.AtEnd
    messageLabel.Parent = frame

    local id = tick() .. A_Http:GenerateGUID(false)
    table.insert(A_Internal.NotificationList, {id = id, frame = frame, gui = notifGui, height = height})

    local function restack()
        local yOff = 0
        for i = #A_Internal.NotificationList, 1, -1 do
            local n = A_Internal.NotificationList[i]
            if n and n.frame and n.frame.Parent then
                A_Tween:Create(n.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -15, 1, -15 - yOff)}):Play()
                yOff = yOff + n.height + 12
            end
        end
    end

    A_Tween:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -15, 1, -15)}):Play()
    task.wait(0.1)
    restack()

    local function dismiss()
        for i, n in ipairs(A_Internal.NotificationList) do
            if n.id == id then table.remove(A_Internal.NotificationList, i) break end
        end
        A_Tween:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, width + 20, frame.Position.Y.Scale, frame.Position.Y.Offset)}):Play()
        task.wait(0.3)
        notifGui:Destroy()
        restack()
    end

    A_Tween:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
    task.delay(duration, dismiss)

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = frame
    clickBtn.MouseButton1Click:Connect(dismiss)
end

-- ===== DOOR OVERLAY =====
local function a_CreateDoorOverlay(parentFrame, width, height)
    local overlay = Instance.new("Frame")
    overlay.Name = "DoorOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.ClipsDescendants = true
    overlay.ZIndex = 50
    overlay.Parent = parentFrame

    local leftDoor = Instance.new("Frame")
    leftDoor.Name = "LeftDoor"
    leftDoor.Size = UDim2.new(0.5, 0, 1, 0)
    leftDoor.BackgroundColor3 = A_Theme.Header
    leftDoor.BorderSizePixel = 0
    leftDoor.ZIndex = 51
    leftDoor.Parent = overlay

    local rightDoor = Instance.new("Frame")
    rightDoor.Name = "RightDoor"
    rightDoor.Size = UDim2.new(0.5, 0, 1, 0)
    rightDoor.Position = UDim2.new(0.5, 0, 0, 0)
    rightDoor.BackgroundColor3 = A_Theme.Header
    rightDoor.BorderSizePixel = 0
    rightDoor.ZIndex = 51
    rightDoor.Parent = overlay

       -- ===== VH LOGO (3D text + lightning) — door overlay =====
    local logoSize = math.min(width, height) * 0.28
    local logoHolder = Instance.new("Frame")
    logoHolder.Name = "DoorLogo"
    logoHolder.Size = UDim2.new(0, logoSize, 0, logoSize)
    logoHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    logoHolder.BackgroundColor3 = A_Theme.Background
    logoHolder.BackgroundTransparency = 0.1
    logoHolder.BorderSizePixel = 0
    logoHolder.ClipsDescendants = true
    logoHolder.ZIndex = 54
    logoHolder.Parent = overlay

    local dlCorner = Instance.new("UICorner")
    dlCorner.CornerRadius = UDim.new(0, 10)
    dlCorner.Parent = logoHolder

    local dlStroke = Instance.new("UIStroke")
    dlStroke.Color = A_Theme.Accent
    dlStroke.Thickness = 2
    dlStroke.Transparency = 0.15
    dlStroke.Parent = logoHolder

    local dlTextSize = math.floor(logoSize * 0.42)

    local dlShadow = Instance.new("TextLabel")
    dlShadow.Size = UDim2.fromScale(1, 1)
    dlShadow.Position = UDim2.fromOffset(2, 3)
    dlShadow.BackgroundTransparency = 1
    dlShadow.Text = "VH"
    dlShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    dlShadow.TextTransparency = 0.05
    dlShadow.Font = Enum.Font.GothamBlack
    dlShadow.TextSize = dlTextSize
    dlShadow.ZIndex = 55
    dlShadow.Parent = logoHolder

    local dlDepth = Instance.new("TextLabel")
    dlDepth.Size = UDim2.fromScale(1, 1)
    dlDepth.Position = UDim2.fromOffset(1, 1)
    dlDepth.BackgroundTransparency = 1
    dlDepth.Text = "VH"
    dlDepth.TextColor3 = A_Theme.Accent
    dlDepth.Font = Enum.Font.GothamBlack
    dlDepth.TextSize = dlTextSize
    dlDepth.ZIndex = 56
    dlDepth.Parent = logoHolder

    local dlFace = Instance.new("TextLabel")
    dlFace.Size = UDim2.fromScale(1, 1)
    dlFace.BackgroundTransparency = 1
    dlFace.Text = "VH"
    dlFace.TextColor3 = A_Theme.Text
    dlFace.Font = Enum.Font.GothamBlack
    dlFace.TextSize = dlTextSize
    dlFace.TextStrokeColor3 = A_Theme.Accent
    dlFace.TextStrokeTransparency = 0
    dlFace.ZIndex = 57
    dlFace.Parent = logoHolder

    local dlLightningHolder = Instance.new("Frame")
    dlLightningHolder.Size = UDim2.fromScale(1, 1)
    dlLightningHolder.BackgroundTransparency = 1
    dlLightningHolder.ClipsDescendants = true
    dlLightningHolder.ZIndex = 58
    dlLightningHolder.Parent = logoHolder

    local doorSegments = {
        {0.18, 0.15, logoSize * 0.35, -30},
        {0.80, 0.30, logoSize * 0.30, 35},
        {0.15, 0.55, logoSize * 0.38, -25},
        {0.85, 0.72, logoSize * 0.28, 30},
        {0.50, 0.10, logoSize * 0.22, 0},
    }

    local dlBolts = {}
    for _, seg in ipairs(doorSegments) do
        local bolt = Instance.new("Frame")
        bolt.AnchorPoint = Vector2.new(0.5, 0.5)
        bolt.Size = UDim2.fromOffset(2, seg[3])
        bolt.Position = UDim2.fromScale(seg[1], seg[2])
        bolt.Rotation = seg[4]
        bolt.BackgroundColor3 = Color3.fromRGB(170, 220, 255)
        bolt.BackgroundTransparency = 1
        bolt.BorderSizePixel = 0
        bolt.ZIndex = 59
        bolt.Parent = dlLightningHolder
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(1, 0)
        bc.Parent = bolt
        table.insert(dlBolts, bolt)
    end

    -- Lightning loop
    task.spawn(function()
        while logoHolder.Parent do
            task.wait(math.random(12, 30) / 10)
            if not logoHolder.Parent then break end
            for _, bolt in ipairs(dlBolts) do
                bolt.BackgroundTransparency = 0
                task.wait(0.05)
                bolt.BackgroundTransparency = 1
            end
            task.wait(0.08)
            for _, bolt in ipairs(dlBolts) do
                bolt.BackgroundTransparency = 0
                task.wait(0.03)
                bolt.BackgroundTransparency = 1
            end
        end
    end)

    local halfWidth = math.ceil(width / 2)

          local function openDoors(cb)
        -- Fade out VH logo (pakai BackgroundTransparency + TextTransparency)
        A_Tween:Create(logoHolder, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {BackgroundTransparency = 1}):Play()
        for _, child in ipairs(logoHolder:GetChildren()) do
            if child:IsA("TextLabel") then
                A_Tween:Create(child, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {TextTransparency = 1}):Play()
            end
        end
        task.wait(0.25)
        A_Tween:Create(leftDoor, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0, -halfWidth, 0, 0)}):Play()
        A_Tween:Create(rightDoor, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.45)
        overlay.Visible = false
        if cb then cb() end
    end

            local function closeDoors(cb)
        overlay.Visible = true
        leftDoor.Position = UDim2.new(0, -halfWidth, 0, 0)
        rightDoor.Position = UDim2.new(1, 0, 0, 0)
        -- Reset VH logo ke kondisi transparan dulu
        logoHolder.BackgroundTransparency = 1
        for _, child in ipairs(logoHolder:GetChildren()) do
            if child:IsA("TextLabel") then
                child.TextTransparency = 1
            end
        end
        A_Tween:Create(leftDoor, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        A_Tween:Create(rightDoor, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 0)}):Play()
        task.wait(0.38)
        -- Fade in VH logo
        A_Tween:Create(logoHolder, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.1}):Play()
        for _, child in ipairs(logoHolder:GetChildren()) do
            if child:IsA("TextLabel") then
                A_Tween:Create(child, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {TextTransparency = 0}):Play()
            end
        end
        task.wait(0.3)
        if cb then cb() end
    end

    return {overlay = overlay, open = openDoors, close = closeDoors}
end

-- ===== CHANGELOG PANEL =====
local function a_CreateChangelogPanel(parent, windowWidth, panelHeight, panelWidth, mainFrame, gap)
    panelWidth = panelWidth or 220
    local isOpen = false

    local panel = Instance.new("Frame")
    panel.Name = "ChangelogPanel"
    panel.Size = UDim2.new(0, 0, 0, panelHeight)
    panel.Position = UDim2.new(1, gap, 0, 0)
    panel.BackgroundColor3 = A_Theme.Background
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Parent = mainFrame
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 4)

    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = A_Theme.Accent
    panelStroke.Thickness = 2
    panelStroke.Transparency = 1

    local panelHeader = Instance.new("Frame")
    panelHeader.Size = UDim2.new(1, 0, 0, 50)
    panelHeader.BackgroundColor3 = A_Theme.Header
    panelHeader.BorderSizePixel = 0
    panelHeader.Parent = panel
    Instance.new("UICorner", panelHeader).CornerRadius = UDim.new(0, 4)

    local panelHeaderFix = Instance.new("Frame")
    panelHeaderFix.Size = UDim2.new(1, 0, 0, 8)
    panelHeaderFix.Position = UDim2.new(0, 0, 1, -8)
    panelHeaderFix.BackgroundColor3 = A_Theme.Header
    panelHeaderFix.BorderSizePixel = 0
    panelHeaderFix.Parent = panelHeader

    local panelHeaderLine = Instance.new("Frame")
    panelHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    panelHeaderLine.Position = UDim2.new(0, 0, 1, 0)
    panelHeaderLine.BackgroundColor3 = A_Theme.Accent
    panelHeaderLine.BackgroundTransparency = 0.6
    panelHeaderLine.BorderSizePixel = 0
    panelHeaderLine.Parent = panelHeader

    local panelHeaderIcon = Instance.new("ImageLabel")
    panelHeaderIcon.Size = UDim2.new(0, 16, 0, 16)
    panelHeaderIcon.Position = UDim2.new(0, 12, 0.5, 0)
    panelHeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
    panelHeaderIcon.BackgroundTransparency = 1
    panelHeaderIcon.Image = a_getIcon("changelog")
    panelHeaderIcon.ImageColor3 = A_Theme.Accent
    panelHeaderIcon.ScaleType = Enum.ScaleType.Fit
    panelHeaderIcon.Parent = panelHeader

    local panelTitle = Instance.new("TextLabel")
    panelTitle.Size = UDim2.new(1, -65, 1, 0)
    panelTitle.Position = UDim2.new(0, 34, 0, 0)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "Changelog"
    panelTitle.TextColor3 = A_Theme.Text
    panelTitle.TextSize = 16
    panelTitle.Font = Enum.Font.ArimoBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = panelHeader

    local panelClose = Instance.new("ImageButton")
    panelClose.Size = UDim2.new(0, 20, 0, 20)
    panelClose.Position = UDim2.new(1, -14, 0.5, 0)
    panelClose.AnchorPoint = Vector2.new(1, 0.5)
    panelClose.BackgroundTransparency = 1
    panelClose.Image = a_getIcon("close")
    panelClose.ImageColor3 = A_Theme.TextDim
    panelClose.ScaleType = Enum.ScaleType.Fit
    panelClose.Parent = panelHeader
    panelClose.MouseEnter:Connect(function() A_Tween:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = A_Theme.Error}):Play() end)
    panelClose.MouseLeave:Connect(function() A_Tween:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = A_Theme.TextDim}):Play() end)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -55)
    scrollFrame.Position = UDim2.new(0, 0, 0, 55)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = A_Theme.Accent
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = panel

       local isMobCL = a_isMobile()
local clPadSide  = isMobCL and 14 or 10
local clPadTopBot = isMobCL and 8  or 5
local clGap      = isMobCL and 14 or 10

local sp = Instance.new("UIPadding", scrollFrame)
sp.PaddingLeft   = UDim.new(0, clPadSide)
sp.PaddingRight  = UDim.new(0, clPadSide)
sp.PaddingTop    = UDim.new(0, clPadTopBot)
sp.PaddingBottom = UDim.new(0, clPadTopBot)

local cl = Instance.new("UIListLayout", scrollFrame)
cl.Padding = UDim.new(0, clGap)
cl.SortOrder = Enum.SortOrder.LayoutOrder
        for i, update in ipairs(A_Changelog) do
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, 0, 0, 0)
        entry.AutomaticSize = Enum.AutomaticSize.Y
        entry.BackgroundTransparency = 1
        entry.LayoutOrder = i * 2
        entry.Parent = scrollFrame

        local el = Instance.new("UIListLayout", entry)
        el.Padding = UDim.new(0, isMobCL and 8 or 5)

        local vLbl = Instance.new("TextLabel")
        vLbl.Size = UDim2.new(1, 0, 0, isMobCL and 28 or 22)
        vLbl.BackgroundTransparency = 1
        vLbl.Text = update.Version .. "  •  " .. update.Date
        vLbl.TextColor3 = A_Theme.Accent
        vLbl.TextSize = 14
        vLbl.Font = Enum.Font.ArimoBold
        vLbl.TextXAlignment = Enum.TextXAlignment.Left
        vLbl.LayoutOrder = 1
        vLbl.Parent = entry

        for j, change in ipairs(update.Changes) do
            local cLbl = Instance.new("TextLabel")
            cLbl.Size = UDim2.new(1, 0, 0, 0)
            cLbl.AutomaticSize = Enum.AutomaticSize.Y
            cLbl.BackgroundTransparency = 1
            cLbl.Text = "  •  " .. change
            cLbl.TextColor3 = A_Theme.TextDim
            cLbl.TextSize = 12
            cLbl.Font = Enum.Font.ArimoBold
            cLbl.TextXAlignment = Enum.TextXAlignment.Left
            cLbl.TextWrapped = true
            cLbl.LayoutOrder = j + 1
            cLbl.Parent = entry
        end

        if i < #A_Changelog then
            local divW = Instance.new("Frame")
            divW.Size = UDim2.new(1, 0, 0, 2)
            divW.BackgroundTransparency = 1
            divW.LayoutOrder = i * 2 + 1
            divW.Parent = scrollFrame
            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, 0, 0, 2)
            div.BackgroundColor3 = A_Theme.Divider
            div.BorderSizePixel = 0
            div.Parent = divW
        end
    end

    local function toggle(changelogIcon, container, currentContainerWidth)
        isOpen = not isOpen
        if isOpen then
            A_Tween:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            A_Tween:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, panelWidth, 0, panelHeight)}):Play()
            A_Tween:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, currentContainerWidth + gap + panelWidth, 0, panelHeight)}):Play()
            if changelogIcon then A_Tween:Create(changelogIcon, TweenInfo.new(0.3), {Rotation = 180}):Play() end
        else
            A_Tween:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            A_Tween:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, panelHeight)}):Play()
            A_Tween:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, currentContainerWidth, 0, panelHeight)}):Play()
            if changelogIcon then A_Tween:Create(changelogIcon, TweenInfo.new(0.3), {Rotation = 0}):Play() end
        end
    end

    panelClose.MouseButton1Click:Connect(function() if isOpen then toggle(nil, parent, windowWidth) end end)
    return panel, toggle, function() return isOpen end, panelWidth
end

-- ===== USER INFO PANEL =====
local function a_CreateUserInfoPanel(parent, windowWidth, panelHeight, panelWidth, mainFrame, gap, startOpen)
    panelWidth = panelWidth or 180
    local isOpen = startOpen or false
    local isCompact = panelHeight < 300
local isMobPanel = a_isMobile()

-- ⭐ Mobile: paksa ukuran PC-style, gak peduli compact atau nggak
local avatarSize  = (isMobPanel or not isCompact) and 52 or 42
local fieldHeight = (isMobPanel or not isCompact) and 27 or 24
local titleSize   = (isMobPanel or not isCompact) and 9  or 8
local valueSize   = (isMobPanel or not isCompact) and 11 or 10
local welcomeSize = (isMobPanel or not isCompact) and 12 or 11
local spacing     = (isMobPanel or not isCompact) and 5  or 3

    local panel = Instance.new("Frame")
    panel.Name = "UserInfoPanel"
    panel.Size = UDim2.new(0, isOpen and panelWidth or 0, 0, panelHeight)
    panel.Position = UDim2.new(0, -(gap), 0, 0)
    panel.AnchorPoint = Vector2.new(1, 0)
    panel.BackgroundColor3 = A_Theme.Background
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Parent = mainFrame
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 4)

    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = A_Theme.Accent
    panelStroke.Thickness = 2
    panelStroke.Transparency = isOpen and 0.4 or 1

    local panelHeader = Instance.new("Frame")
    panelHeader.Size = UDim2.new(1, 0, 0, 50)
    panelHeader.BackgroundColor3 = A_Theme.Header
    panelHeader.BorderSizePixel = 0
    panelHeader.Parent = panel
    Instance.new("UICorner", panelHeader).CornerRadius = UDim.new(0, 4)

    local panelHeaderFix = Instance.new("Frame")
    panelHeaderFix.Size = UDim2.new(1, 0, 0, 8)
    panelHeaderFix.Position = UDim2.new(0, 0, 1, -8)
    panelHeaderFix.BackgroundColor3 = A_Theme.Header
    panelHeaderFix.BorderSizePixel = 0
    panelHeaderFix.Parent = panelHeader

    local panelHeaderLine = Instance.new("Frame")
    panelHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    panelHeaderLine.Position = UDim2.new(0, 0, 1, 0)
    panelHeaderLine.BackgroundColor3 = A_Theme.Accent
    panelHeaderLine.BackgroundTransparency = 0.6
    panelHeaderLine.BorderSizePixel = 0
    panelHeaderLine.Parent = panelHeader

    local panelHeaderIcon = Instance.new("ImageLabel")
    panelHeaderIcon.Size = UDim2.new(0, 16, 0, 16)
    panelHeaderIcon.Position = UDim2.new(0, 12, 0.5, 0)
    panelHeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
    panelHeaderIcon.BackgroundTransparency = 1
    panelHeaderIcon.Image = a_getIcon("user")
    panelHeaderIcon.ImageColor3 = A_Theme.Accent
    panelHeaderIcon.ScaleType = Enum.ScaleType.Fit
    panelHeaderIcon.Parent = panelHeader

    local panelTitle = Instance.new("TextLabel")
    panelTitle.Size = UDim2.new(1, -65, 1, 0)
    panelTitle.Position = UDim2.new(0, 34, 0, 0)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "User Info"
    panelTitle.TextColor3 = A_Theme.Text
    panelTitle.TextSize = 16
    panelTitle.Font = Enum.Font.ArimoBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = panelHeader

    local panelClose = Instance.new("ImageButton")
    panelClose.Size = UDim2.new(0, 20, 0, 20)
    panelClose.Position = UDim2.new(1, -14, 0.5, 0)
    panelClose.AnchorPoint = Vector2.new(1, 0.5)
    panelClose.BackgroundTransparency = 1
    panelClose.Image = a_getIcon("close")
    panelClose.ImageColor3 = A_Theme.TextDim
    panelClose.ScaleType = Enum.ScaleType.Fit
    panelClose.Parent = panelHeader
    panelClose.MouseEnter:Connect(function() A_Tween:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = A_Theme.Error}):Play() end)
    panelClose.MouseLeave:Connect(function() A_Tween:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = A_Theme.TextDim}):Play() end)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -55)
    contentFrame.Position = UDim2.new(0, 0, 0, 55)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = panel

    local cp = Instance.new("UIPadding", contentFrame)
    cp.PaddingLeft = UDim.new(0, 8)
    cp.PaddingRight = UDim.new(0, 8)

    local cLayout = Instance.new("UIListLayout", contentFrame)
    cLayout.Padding = UDim.new(0, spacing)
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    cLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local player = A_LP

    local avatarWrapper = Instance.new("Frame")
    avatarWrapper.Size = UDim2.new(0, avatarSize + 6, 0, avatarSize + 6)
    avatarWrapper.BackgroundTransparency = 1
    avatarWrapper.LayoutOrder = 1
    avatarWrapper.Parent = contentFrame

    local avatarGlow = Instance.new("Frame")
    avatarGlow.Size = UDim2.new(1, 0, 1, 0)
    avatarGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarGlow.BackgroundColor3 = A_Theme.Accent
    avatarGlow.BackgroundTransparency = 0.5
    avatarGlow.BorderSizePixel = 0
    avatarGlow.Parent = avatarWrapper
    Instance.new("UICorner", avatarGlow).CornerRadius = UDim.new(0, 4)

    local avatarGlowStroke = Instance.new("UIStroke", avatarGlow)
    avatarGlowStroke.Color = A_Theme.Accent
    avatarGlowStroke.Thickness = 1.5
    avatarGlowStroke.Transparency = 0.3

    local avatarContainer = Instance.new("Frame")
    avatarContainer.Size = UDim2.new(0, avatarSize, 0, avatarSize)
    avatarContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarContainer.BackgroundColor3 = A_Theme.Input
    avatarContainer.BorderSizePixel = 0
    avatarContainer.ClipsDescendants = true
    avatarContainer.Parent = avatarWrapper
    Instance.new("UICorner", avatarContainer).CornerRadius = UDim.new(0, 4)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarImage.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ScaleType = Enum.ScaleType.Crop
    avatarImage.Parent = avatarContainer
    pcall(function()
        local content = A_Players:GetUserThumbnailAsync(player and player.UserId or 0, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        avatarImage.Image = content
    end)

    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, 0, 0, isCompact and 14 or 18)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = "Welcome, " .. (player and player.DisplayName or "User")
    welcomeLabel.TextColor3 = A_Theme.Text
    welcomeLabel.TextSize = welcomeSize
    welcomeLabel.Font = Enum.Font.ArimoBold
    welcomeLabel.TextTruncate = Enum.TextTruncate.AtEnd
    welcomeLabel.LayoutOrder = 2
    welcomeLabel.Parent = contentFrame

    local divider1 = Instance.new("Frame")
    divider1.Size = UDim2.new(1, 16, 0, 2)
    divider1.Position = UDim2.new(0.5, 0, 0, 0)
    divider1.AnchorPoint = Vector2.new(0.5, 0)
    divider1.BackgroundColor3 = A_Theme.Divider
    divider1.BorderSizePixel = 0
    divider1.LayoutOrder = 3
    divider1.Parent = contentFrame

    local executorContainer = Instance.new("Frame")
    executorContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    executorContainer.BackgroundTransparency = 1
    executorContainer.LayoutOrder = 4
    executorContainer.Parent = contentFrame

    local executorTitle = Instance.new("TextLabel")
    executorTitle.Size = UDim2.new(1, 0, 0, 11)
    executorTitle.BackgroundTransparency = 1
    executorTitle.Text = "Executor"
    executorTitle.TextColor3 = A_Theme.TextDim
    executorTitle.TextSize = titleSize
    executorTitle.Font = Enum.Font.ArimoBold
    executorTitle.TextXAlignment = Enum.TextXAlignment.Left
    executorTitle.Parent = executorContainer

    local executorValue = Instance.new("TextLabel")
    executorValue.Size = UDim2.new(1, 0, 0, 14)
    executorValue.Position = UDim2.new(0, 0, 0, 11)
    executorValue.BackgroundTransparency = 1
    executorValue.Text = a_getExecutorName()
    executorValue.TextColor3 = A_Theme.Accent
    executorValue.TextSize = valueSize
    executorValue.Font = Enum.Font.ArimoBold
    executorValue.TextXAlignment = Enum.TextXAlignment.Left
    executorValue.TextTruncate = Enum.TextTruncate.AtEnd
    executorValue.Parent = executorContainer

    local deviceContainer = Instance.new("Frame")
    deviceContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    deviceContainer.BackgroundTransparency = 1
    deviceContainer.LayoutOrder = 5
    deviceContainer.Parent = contentFrame

    local deviceTitle = Instance.new("TextLabel")
    deviceTitle.Size = UDim2.new(1, 0, 0, 11)
    deviceTitle.BackgroundTransparency = 1
    deviceTitle.Text = "Device"
    deviceTitle.TextColor3 = A_Theme.TextDim
    deviceTitle.TextSize = titleSize
    deviceTitle.Font = Enum.Font.ArimoBold
    deviceTitle.TextXAlignment = Enum.TextXAlignment.Left
    deviceTitle.Parent = deviceContainer

    local deviceValue = Instance.new("TextLabel")
    deviceValue.Size = UDim2.new(1, 0, 0, 14)
    deviceValue.Position = UDim2.new(0, 0, 0, 11)
    deviceValue.BackgroundTransparency = 1
    deviceValue.Text = a_getDeviceType()
    deviceValue.TextColor3 = A_Theme.Accent
    deviceValue.TextSize = valueSize
    deviceValue.Font = Enum.Font.ArimoBold
    deviceValue.TextXAlignment = Enum.TextXAlignment.Left
    deviceValue.TextTruncate = Enum.TextTruncate.AtEnd
    deviceValue.Parent = deviceContainer

    local divider2 = Instance.new("Frame")
    divider2.Size = UDim2.new(1, 16, 0, 2)
    divider2.Position = UDim2.new(0.5, 0, 0, 0)
    divider2.AnchorPoint = Vector2.new(0.5, 0)
    divider2.BackgroundColor3 = A_Theme.Divider
    divider2.BorderSizePixel = 0
    divider2.LayoutOrder = 6
    divider2.Parent = contentFrame

    local hwidContainer = Instance.new("Frame")
    hwidContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    hwidContainer.BackgroundTransparency = 1
    hwidContainer.LayoutOrder = 7
    hwidContainer.Parent = contentFrame

    local hwidTitle = Instance.new("TextLabel")
    hwidTitle.Size = UDim2.new(1, 0, 0, 11)
    hwidTitle.BackgroundTransparency = 1
    hwidTitle.Text = "HWID"
    hwidTitle.TextColor3 = A_Theme.TextDim
    hwidTitle.TextSize = titleSize
    hwidTitle.Font = Enum.Font.ArimoBold
    hwidTitle.TextXAlignment = Enum.TextXAlignment.Left
    hwidTitle.Parent = hwidContainer

    local fullHWID = a_getHWID()
    local copyBtnSize = 18
    local dotAreaWidth = panelWidth - 16 - copyBtnSize - 6
    local hiddenDots = a_generateHiddenDots(dotAreaWidth, 5)

    local hwidValue = Instance.new("TextLabel")
    hwidValue.Size = UDim2.new(1, -(copyBtnSize + 6), 0, 14)
    hwidValue.Position = UDim2.new(0, 0, 0, 11)
    hwidValue.BackgroundTransparency = 1
    hwidValue.Text = hiddenDots
    hwidValue.TextColor3 = A_Theme.TextDim
    hwidValue.TextSize = isCompact and 9 or 10
    hwidValue.Font = Enum.Font.ArimoBold
    hwidValue.TextXAlignment = Enum.TextXAlignment.Left
    hwidValue.TextTruncate = Enum.TextTruncate.AtEnd
    hwidValue.Parent = hwidContainer

    local copyBtn = Instance.new("ImageButton")
    copyBtn.Size = UDim2.new(0, copyBtnSize, 0, copyBtnSize)
    copyBtn.Position = UDim2.new(1, 0, 0.5, 1)
    copyBtn.AnchorPoint = Vector2.new(1, 0.5)
    copyBtn.BackgroundTransparency = 1
    copyBtn.Image = a_getIcon("copy")
    copyBtn.ImageColor3 = A_Theme.TextDim
    copyBtn.ScaleType = Enum.ScaleType.Fit
    copyBtn.Parent = hwidContainer
    copyBtn.MouseEnter:Connect(function() A_Tween:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = A_Theme.Accent}):Play() end)
    copyBtn.MouseLeave:Connect(function() A_Tween:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = A_Theme.TextDim}):Play() end)
    copyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(fullHWID) end)
        A_Tween:Create(copyBtn, TweenInfo.new(0.1), {ImageColor3 = A_Theme.Success}):Play()
        task.delay(0.3, function() A_Tween:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = A_Theme.TextDim}):Play() end)
        a_Notify("Copied", "HWID copied to clipboard", 2, "copy")
    end)

    local divider3 = Instance.new("Frame")
    divider3.Size = UDim2.new(1, 16, 0, 2)
    divider3.Position = UDim2.new(0.5, 0, 0, 0)
    divider3.AnchorPoint = Vector2.new(0.5, 0)
    divider3.BackgroundColor3 = A_Theme.Divider
    divider3.BorderSizePixel = 0
    divider3.LayoutOrder = 8
    divider3.Parent = contentFrame

    local clockContainer = Instance.new("Frame")
    clockContainer.Size = UDim2.new(1, 0, 0, isCompact and 30 or 38)
    clockContainer.BackgroundTransparency = 1
    clockContainer.LayoutOrder = 9
    clockContainer.Parent = contentFrame

    local clockRow = Instance.new("Frame")
    clockRow.Size = UDim2.new(1, 0, 0, isCompact and 18 or 22)
    clockRow.Position = UDim2.new(0.5, -8, 0, 0)
    clockRow.AnchorPoint = Vector2.new(0.5, 0)
    clockRow.BackgroundTransparency = 1
    clockRow.Parent = clockContainer

    local clockRowLayout = Instance.new("UIListLayout", clockRow)
    clockRowLayout.FillDirection = Enum.FillDirection.Horizontal
    clockRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    clockRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    clockRowLayout.Padding = UDim.new(0, isCompact and 4 or 6)

    local clockIcon = Instance.new("ImageLabel")
    clockIcon.Size = UDim2.new(0, isCompact and 14 or 16, 0, isCompact and 14 or 16)
    clockIcon.BackgroundTransparency = 1
    clockIcon.Image = a_getIcon("clock")
    clockIcon.ImageColor3 = A_Theme.Accent
    clockIcon.ScaleType = Enum.ScaleType.Fit
    clockIcon.LayoutOrder = 1
    clockIcon.Parent = clockRow

    local clockTimeLabel = Instance.new("TextLabel")
    clockTimeLabel.Size = UDim2.new(0, 0, 1, 0)
    clockTimeLabel.AutomaticSize = Enum.AutomaticSize.X
    clockTimeLabel.BackgroundTransparency = 1
    clockTimeLabel.Text = a_formatTime12()
    clockTimeLabel.TextColor3 = A_Theme.Accent
    clockTimeLabel.TextSize = isCompact and 14 or 16
    clockTimeLabel.Font = Enum.Font.ArimoBold
    clockTimeLabel.LayoutOrder = 2
    clockTimeLabel.Parent = clockRow

    local clockDateLabel = Instance.new("TextLabel")
    clockDateLabel.Size = UDim2.new(1, 0, 0, isCompact and 12 or 14)
    clockDateLabel.Position = UDim2.new(0, -8, 0, isCompact and 18 or 22)
    clockDateLabel.BackgroundTransparency = 1
    clockDateLabel.Text = a_formatDate()
    clockDateLabel.TextColor3 = A_Theme.TextDim
    clockDateLabel.TextSize = isCompact and 9 or 11
    clockDateLabel.Font = Enum.Font.ArimoBold
    clockDateLabel.TextXAlignment = Enum.TextXAlignment.Center
    clockDateLabel.Parent = clockContainer

    local clockRunning = true
    task.spawn(function()
        while clockRunning do
            if not clockTimeLabel or not clockTimeLabel.Parent then clockRunning = false break end
            clockTimeLabel.Text = a_formatTime12()
            clockDateLabel.Text = a_formatDate()
            task.wait(1)
        end
    end)
    panel.Destroying:Connect(function() clockRunning = false end)

    local function toggle(userIcon, container, baseWidth)
        isOpen = not isOpen
        if isOpen then
            A_Tween:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            A_Tween:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, panelWidth, 0, panelHeight)}):Play()
            A_Tween:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, baseWidth + gap + panelWidth, 0, panelHeight)}):Play()
        else
            A_Tween:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            A_Tween:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, panelHeight)}):Play()
            A_Tween:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, baseWidth, 0, panelHeight)}):Play()
        end
    end

    panelClose.MouseButton1Click:Connect(function() if isOpen then toggle(nil, parent, windowWidth) end end)
    return panel, toggle, function() return isOpen end, panelWidth
end

-- ===== BUILD CENTERED UI =====
local function a_BuildCenteredUI(windowWidth, windowHeight, panelHeight, userPanelWidth, changelogPanelWidth, gap, buildContent)
    local gui = buildContent.gui

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, windowWidth, 0, panelHeight)
    container.Position = UDim2.new(0.5, 0, 1.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundTransparency = 1
    container.Parent = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    mainFrame.Position = UDim2.new(0.5, 0, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0)
    mainFrame.BackgroundColor3 = A_Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = container
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 4)

    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = A_Theme.Accent
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.4

    local userPanel, toggleUserPanel, isUserOpen, userPanelActualWidth = a_CreateUserInfoPanel(container, windowWidth, panelHeight, userPanelWidth, mainFrame, gap, false)
    local changelogPanel, toggleChangelog, isChangelogOpen, changelogPanelActualWidth = a_CreateChangelogPanel(container, windowWidth, panelHeight, changelogPanelWidth, mainFrame, gap)

    local function getContainerWidth()
        local w = windowWidth
        if isUserOpen() then w = w + gap + userPanelActualWidth end
        if isChangelogOpen() then w = w + gap + changelogPanelActualWidth end
        return w
    end

    local function toggleUser(userIcon)
        local currentW = getContainerWidth()
        if isUserOpen() then
            toggleUserPanel(userIcon, container, currentW - gap - userPanelActualWidth)
        else
            toggleUserPanel(userIcon, container, currentW)
        end
    end

    local function toggleCL(changelogIcon)
        local currentW = getContainerWidth()
        if isChangelogOpen() then
            toggleChangelog(changelogIcon, container, currentW - gap - changelogPanelActualWidth)
        else
            toggleChangelog(changelogIcon, container, currentW)
        end
    end

    local function closeAllPanels(userIcon, changelogIcon, callback)
        if isChangelogOpen() then toggleCL(changelogIcon) task.wait(0.35) end
        if isUserOpen() then toggleUser(userIcon) task.wait(0.35) end
        if callback then callback() end
    end

    return {
        container = container,
        mainFrame = mainFrame,
        mainStroke = mainStroke,
        toggleUser = toggleUser,
        toggleCL = toggleCL,
        isUserOpen = isUserOpen,
        isChangelogOpen = isChangelogOpen,
        closeAllPanels = closeAllPanels
    }
end

-- ===== BUILD KEY UI (Arqel persis) =====
local function a_BuildKeyUI(onSuccess)
    local existing = A_hui:FindFirstChild("VH_KeySystem")
    if existing then existing:Destroy() end
    local existing2 = A_hui:FindFirstChild("VH_KeylessSystem")
    if existing2 then existing2:Destroy() end

    a_enableBlur()

    local mobile = a_isMobile()
    local vp = A_WS.CurrentCamera and A_WS.CurrentCamera.ViewportSize or Vector2.new(1280, 720)

        -- ⭐ UKURAN KECIL — khusus HP. PC tetap sama.
    local padding = mobile and 8 or 14
    local baseWindowHeight, windowWidth, windowHeight
    local elementHeight, buttonHeight, statusHeight
    local userPanelWidth, changelogPanelWidth, gap

    if mobile then
        -- HP: window lebih kecil lagi
        windowWidth  = math.floor(math.clamp(vp.X * 0.64, 220, 270))
        windowHeight = math.floor(math.clamp(vp.Y * 0.50, 240, 310))
        baseWindowHeight = windowHeight
        elementHeight = math.clamp(math.floor(vp.Y * 0.052), 32, 40)   -- input tipis
        buttonHeight  = math.clamp(math.floor(vp.Y * 0.043), 28, 34)   -- tombol tipis
        statusHeight  = math.clamp(math.floor(vp.Y * 0.056), 34, 44)   -- status tipis
        userPanelWidth      = math.clamp(math.floor(vp.X * 0.32), 100, 130)
        changelogPanelWidth = math.clamp(math.floor(vp.X * 0.38), 110, 150)
        gap = 6
    else
        -- PC: SAMA PERSIS seperti sebelumnya (tidak diubah)
        baseWindowHeight = 360
        windowWidth  = 400
        windowHeight = 360
        elementHeight = 56
        buttonHeight  = 42
        statusHeight  = 60
        userPanelWidth      = 180
        changelogPanelWidth = 220
        gap = 12
    end

    -- ⭐ Panel samping auto-hide kalau ruang sempit
    local function getAvailableSideSpace()
        return math.max(0, (vp.X - windowWidth) / 2 - 6)
    end
    if mobile then
    local sideSpace = getAvailableSideSpace()
    -- ⭐ Mobile: perkecil window utama dulu biar panel samping dapat ruang lebih lebar
    if sideSpace < 60 then
        -- Sempit banget → matikan panel samping (biar gak dempet)
        userPanelWidth = 0
        changelogPanelWidth = 0
    elseif sideSpace < 140 then
        -- Sedang → panel kiri saja (user info), lebih lebar dari sebelumnya
        userPanelWidth      = math.clamp(sideSpace - 8, 110, 160)
        changelogPanelWidth = 0
    else
        -- Lega → dua panel, proporsi lebih seimbang
        userPanelWidth      = math.clamp(sideSpace * 0.46, 130, 180)
        changelogPanelWidth = math.clamp(sideSpace * 0.54, 150, 200)
    end
end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "VH_KeySystem"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = A_hui

    local ui = a_BuildCenteredUI(windowWidth, windowHeight, baseWindowHeight, userPanelWidth, changelogPanelWidth, gap, {gui = screenGui})
    local container = ui.container
    local mainFrame = ui.mainFrame
    local mainStroke = ui.mainStroke

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = A_Theme.Header
    header.BorderSizePixel = 0
    header.Active = true
    header.Parent = mainFrame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 4)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 6)
    headerFix.Position = UDim2.new(0, 0, 1, -6)
    headerFix.BackgroundColor3 = A_Theme.Header
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 1, 0)
    headerLine.BackgroundColor3 = A_Theme.Accent
    headerLine.BackgroundTransparency = 0.6
    headerLine.BorderSizePixel = 0
    headerLine.Parent = header

       -- ===== VH LOGO (3D text + lightning) — header =====
    local logoHolder = Instance.new("Frame")
    logoHolder.Name = "VHLogoHeader"
    local _logoHdr = mobile and math.clamp(math.floor(windowWidth * 0.078), 22, 28) or 30
    logoHolder.Size = UDim2.fromOffset(_logoHdr, _logoHdr)
    logoHolder.Position = UDim2.new(0, padding, 0.5, 0)
    logoHolder.AnchorPoint = Vector2.new(0, 0.5)
    logoHolder.BackgroundColor3 = A_Theme.Background
    logoHolder.BackgroundTransparency = 0.15
    logoHolder.BorderSizePixel = 0
    logoHolder.ClipsDescendants = true
    logoHolder.Parent = header

    local lhCorner = Instance.new("UICorner")
    lhCorner.CornerRadius = UDim.new(0, 6)
    lhCorner.Parent = logoHolder

    local lhStroke = Instance.new("UIStroke")
    lhStroke.Color = A_Theme.Accent
    lhStroke.Thickness = 1.5
    lhStroke.Transparency = 0.2
    lhStroke.Parent = logoHolder

    -- Shadow (depth)
    local lhShadow = Instance.new("TextLabel")
    lhShadow.Size = UDim2.fromScale(1, 1)
    lhShadow.Position = UDim2.fromOffset(1, 2)
    lhShadow.BackgroundTransparency = 1
    lhShadow.Text = "VH"
    lhShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    lhShadow.TextTransparency = 0.05
    lhShadow.Font = Enum.Font.GothamBlack
    lhShadow.TextSize = 14
    lhShadow.ZIndex = 12
    lhShadow.Parent = logoHolder

    -- Depth accent (VH accent color)
    local lhDepth = Instance.new("TextLabel")
    lhDepth.Size = UDim2.fromScale(1, 1)
    lhDepth.Position = UDim2.fromOffset(1, 1)
    lhDepth.BackgroundTransparency = 1
    lhDepth.Text = "VH"
    lhDepth.TextColor3 = A_Theme.Accent
    lhDepth.Font = Enum.Font.GothamBlack
    lhDepth.TextSize = 14
    lhDepth.ZIndex = 13
    lhDepth.Parent = logoHolder

    -- Face (white + accent stroke)
    local lhFace = Instance.new("TextLabel")
    lhFace.Size = UDim2.fromScale(1, 1)
    lhFace.BackgroundTransparency = 1
    lhFace.Text = "VH"
    lhFace.TextColor3 = A_Theme.Text
    lhFace.Font = Enum.Font.GothamBlack
    lhFace.TextSize = 14
    lhFace.TextStrokeColor3 = A_Theme.Accent
    lhFace.TextStrokeTransparency = 0
    lhFace.ZIndex = 14
    lhFace.Parent = logoHolder

    -- Lightning segments
    local lhLightningHolder = Instance.new("Frame")
    lhLightningHolder.Size = UDim2.fromScale(1, 1)
    lhLightningHolder.BackgroundTransparency = 1
    lhLightningHolder.ClipsDescendants = true
    lhLightningHolder.ZIndex = 15
    lhLightningHolder.Parent = logoHolder

    local lightningSegments = {
        {0.20, 0.15, 10, -30},
        {0.78, 0.30, 9, 35},
        {0.15, 0.55, 11, -25},
        {0.82, 0.70, 8, 30},
    }

    local lhBolts = {}
    for _, seg in ipairs(lightningSegments) do
        local bolt = Instance.new("Frame")
        bolt.AnchorPoint = Vector2.new(0.5, 0.5)
        bolt.Size = UDim2.fromOffset(1.5, seg[3])
        bolt.Position = UDim2.fromScale(seg[1], seg[2])
        bolt.Rotation = seg[4]
        bolt.BackgroundColor3 = Color3.fromRGB(170, 220, 255)
        bolt.BackgroundTransparency = 1
        bolt.BorderSizePixel = 0
        bolt.ZIndex = 16
        bolt.Parent = lhLightningHolder
        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(1, 0)
        bc.Parent = bolt
        table.insert(lhBolts, bolt)
    end

    -- Lightning loop
    task.spawn(function()
        while logoHolder.Parent do
            task.wait(math.random(15, 35) / 10)
            if not logoHolder.Parent then break end
            for _, bolt in ipairs(lhBolts) do
                bolt.BackgroundTransparency = 0
                task.wait(0.05)
                bolt.BackgroundTransparency = 1
            end
            task.wait(0.08)
            for _, bolt in ipairs(lhBolts) do
                bolt.BackgroundTransparency = 0
                task.wait(0.03)
                bolt.BackgroundTransparency = 1
            end
        end
    end)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 1, 0)
    titleLabel.Position = UDim2.new(0, padding + A_Appearance.IconSize.X.Offset + 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = A_Appearance.Title
    titleLabel.TextColor3 = A_Theme.Text
    titleLabel.TextSize = mobile and math.clamp(math.floor(windowWidth * 0.048), 14, 17) or 26
    titleLabel.Font = Enum.Font.ArimoBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = header

    local closeBtn = Instance.new("ImageButton")
    local _clSz = mobile and math.clamp(math.floor(windowWidth * 0.06), 16, 22) or 22
    closeBtn.Size = UDim2.fromOffset(_clSz, _clSz)
    closeBtn.Position = UDim2.new(1, -padding, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = a_getIcon("close")
    closeBtn.ImageColor3 = A_Theme.TextDim
    closeBtn.ScaleType = Enum.ScaleType.Fit
    closeBtn.Parent = header
    closeBtn.MouseEnter:Connect(function() A_Tween:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = A_Theme.Error}):Play() end)
    closeBtn.MouseLeave:Connect(function() A_Tween:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = A_Theme.TextDim}):Play() end)

    local contentStartY = mobile and math.clamp(math.floor(windowWidth * 0.16), 42, 52) or 60

    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(0.94, 0, 0, statusHeight)
    statusFrame.Position = UDim2.new(0.5, 0, 0, contentStartY)
    statusFrame.AnchorPoint = Vector2.new(0.5, 0)
    statusFrame.BackgroundColor3 = A_Theme.Input
    statusFrame.BorderSizePixel = 0
    statusFrame.ClipsDescendants = true
    statusFrame.Parent = mainFrame
    Instance.new("UICorner", statusFrame).CornerRadius = UDim.new(0, 4)

    local statusStroke = Instance.new("UIStroke", statusFrame)
    statusStroke.Color = A_Theme.Accent
    statusStroke.Thickness = 1
    statusStroke.Transparency = 0.8

    local statusIcon = Instance.new("ImageLabel")
    local _stIco = mobile and math.clamp(math.floor(windowWidth * 0.065), 16, 22) or 24
    statusIcon.Size = UDim2.fromOffset(_stIco, _stIco)
    statusIcon.Position = UDim2.new(0, mobile and 10 or 16, 0.5, 0)
    statusIcon.AnchorPoint = Vector2.new(0, 0.5)
    statusIcon.BackgroundTransparency = 1
    statusIcon.Image = a_getIcon("lock")
    statusIcon.ImageColor3 = A_Theme.StatusIdle
    statusIcon.ScaleType = Enum.ScaleType.Fit
    statusIcon.Parent = statusFrame

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -60, 1, 0)
    statusLabel.Position = UDim2.new(0, mobile and (_stIco + 16) or 52, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = A_Appearance.Subtitle
    statusLabel.TextColor3 = A_Theme.StatusIdle
    statusLabel.TextSize = mobile and math.clamp(math.floor(windowWidth * 0.034), 10, 13) or 18
    statusLabel.Font = Enum.Font.ArimoBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    statusLabel.Parent = statusFrame

    local inputStartY = contentStartY + statusHeight + 10

    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(0.94, 0, 0, elementHeight)
    inputFrame.Position = UDim2.new(0.5, 0, 0, inputStartY)
    inputFrame.AnchorPoint = Vector2.new(0.5, 0)
    inputFrame.BackgroundColor3 = A_Theme.Input
    inputFrame.BorderSizePixel = 0
    inputFrame.ClipsDescendants = true
    inputFrame.Parent = mainFrame
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 4)

    local inputStroke = Instance.new("UIStroke", inputFrame)
    inputStroke.Color = A_Theme.Accent
    inputStroke.Thickness = 1
    inputStroke.Transparency = 0.7

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -24, 1, 0)
    textBox.Position = UDim2.new(0, 12, 0.5, 0)
    textBox.AnchorPoint = Vector2.new(0, 0.5)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.TextColor3 = A_Theme.Text
    textBox.PlaceholderText = "Enter your key..."
    textBox.PlaceholderColor3 = A_Theme.TextDim
    textBox.TextSize = mobile and math.clamp(math.floor(windowWidth * 0.036), 10, 13) or 18
    textBox.Font = Enum.Font.ArimoBold
    textBox.ClearTextOnFocus = false
    textBox.TextTruncate = Enum.TextTruncate.AtEnd
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Parent = inputFrame
    textBox.Focused:Connect(function() A_Tween:Create(inputStroke, TweenInfo.new(0.15), {Transparency = 0.3}):Play() end)
    textBox.FocusLost:Connect(function() A_Tween:Create(inputStroke, TweenInfo.new(0.15), {Transparency = 0.7}):Play() end)

    local dividerY = inputStartY + elementHeight + 12

    local dividerLine = Instance.new("Frame")
    dividerLine.Size = UDim2.new(1, 0, 0, 3)
    dividerLine.Position = UDim2.new(0, 0, 0, dividerY)
    dividerLine.BackgroundColor3 = A_Theme.Divider
    dividerLine.BorderSizePixel = 0
    dividerLine.Parent = mainFrame

    local acquireStartY = dividerY + 15

    local function createButton(text, iconKey, isPrimary, yPos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.75, 0, 0, buttonHeight)
        btn.Position = UDim2.new(0.5, 0, 0, yPos)
        btn.AnchorPoint = Vector2.new(0.5, 0)
        btn.BackgroundColor3 = isPrimary and A_Theme.Accent or A_Theme.Input
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.Parent = mainFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        local btnStroke = Instance.new("UIStroke", btn)
        btnStroke.Color = isPrimary and A_Theme.AccentHover or A_Theme.Accent
        btnStroke.Thickness = 1
        btnStroke.Transparency = isPrimary and 0.5 or 0.7

        local content = Instance.new("Frame")
        content.Size = UDim2.new(1, 0, 1, 0)
        content.BackgroundTransparency = 1
        content.Parent = btn

        local layout = Instance.new("UIListLayout", content)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 8)

        local iconImg = Instance.new("ImageLabel")
        local _btnIco = mobile and math.clamp(math.floor(windowWidth * 0.038), 11, 15) or 18
        iconImg.Size = UDim2.fromOffset(_btnIco, _btnIco)
        iconImg.BackgroundTransparency = 1
        iconImg.Image = a_getIcon(iconKey)
        iconImg.ImageColor3 = A_Theme.Text
        iconImg.ScaleType = Enum.ScaleType.Fit
        iconImg.LayoutOrder = 1
        iconImg.Parent = content

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 0, 0, 20)
        label.AutomaticSize = Enum.AutomaticSize.X
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = A_Theme.Text
        label.TextSize = mobile and math.clamp(math.floor(windowWidth * 0.032), 10, 12) or 15
        label.Font = Enum.Font.ArimoBold
        label.LayoutOrder = 2
        label.Parent = content

        local origColor = btn.BackgroundColor3
        local hoverColor = isPrimary and A_Theme.AccentHover or A_Theme.Accent
        btn.MouseEnter:Connect(function() A_Tween:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hoverColor}):Play() end)
        btn.MouseLeave:Connect(function() A_Tween:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = origColor}):Play() end)
        return btn
    end

    local acquireBtn = createButton("Get Key", "key", false, acquireStartY)
    local redeemBtn = createButton("Redeem Key", "shield", true, acquireStartY + buttonHeight + 5)
    local bottomY = acquireStartY + buttonHeight * 2 + 10

    local iconBtnSize = mobile and math.clamp(math.floor(windowWidth * 0.075), 22, 28) or 36
    local iconBtnGap  = mobile and math.clamp(math.floor(windowWidth * 0.022), 5, 9) or 8

    local userBtn = Instance.new("TextButton")
    userBtn.Size = UDim2.fromOffset(iconBtnSize, iconBtnSize)
    userBtn.Position = UDim2.new(0.5, -(iconBtnSize + iconBtnGap), 0, bottomY)
    userBtn.AnchorPoint = Vector2.new(0.5, 0)
    userBtn.BackgroundColor3 = A_Theme.Background
    userBtn.BorderSizePixel = 0
    userBtn.Text = ""
    userBtn.AutoButtonColor = false
    userBtn.Parent = mainFrame
    Instance.new("UICorner", userBtn).CornerRadius = UDim.new(0, 4)

    local userIcon = Instance.new("ImageLabel")
    userIcon.Size = UDim2.fromOffset(iconBtnSize * 0.5, iconBtnSize * 0.5)
    userIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    userIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    userIcon.BackgroundTransparency = 1
    userIcon.Image = a_getIcon("user")
    userIcon.ImageColor3 = A_Theme.TextDim
    userIcon.ScaleType = Enum.ScaleType.Fit
    userIcon.Parent = userBtn
    userBtn.MouseEnter:Connect(function() A_Tween:Create(userIcon, TweenInfo.new(0.15), {ImageColor3 = A_Theme.Accent}):Play() end)
    userBtn.MouseLeave:Connect(function() A_Tween:Create(userIcon, TweenInfo.new(0.15), {ImageColor3 = A_Theme.TextDim}):Play() end)

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.fromOffset(iconBtnSize, iconBtnSize)
    discordBtn.Position = UDim2.new(0.5, 0, 0, bottomY)
    discordBtn.AnchorPoint = Vector2.new(0.5, 0)
    discordBtn.BackgroundColor3 = A_Theme.Background
    discordBtn.BorderSizePixel = 0
    discordBtn.Text = ""
    discordBtn.AutoButtonColor = false
    discordBtn.Parent = mainFrame
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 4)

    local discordIcon = Instance.new("ImageLabel")
    discordIcon.Size = UDim2.fromOffset(iconBtnSize * 0.5, iconBtnSize * 0.5)
    discordIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    discordIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Image = a_getIcon("discord")
    discordIcon.ImageColor3 = A_Theme.Discord
    discordIcon.ScaleType = Enum.ScaleType.Fit
    discordIcon.Parent = discordBtn
    discordBtn.MouseEnter:Connect(function() A_Tween:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = A_Theme.DiscordHover}):Play() end)
    discordBtn.MouseLeave:Connect(function() A_Tween:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = A_Theme.Discord}):Play() end)

    local changelogBtn = Instance.new("TextButton")
    changelogBtn.Size = UDim2.fromOffset(iconBtnSize, iconBtnSize)
    changelogBtn.Position = UDim2.new(0.5, iconBtnSize + iconBtnGap, 0, bottomY)
    changelogBtn.AnchorPoint = Vector2.new(0.5, 0)
    changelogBtn.BackgroundColor3 = A_Theme.Background
    changelogBtn.BorderSizePixel = 0
    changelogBtn.Text = ""
    changelogBtn.AutoButtonColor = false
    changelogBtn.Parent = mainFrame
    Instance.new("UICorner", changelogBtn).CornerRadius = UDim.new(0, 4)

    local changelogIcon = Instance.new("ImageLabel")
    changelogIcon.Size = UDim2.fromOffset(iconBtnSize * 0.5, iconBtnSize * 0.5)
    changelogIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    changelogIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    changelogIcon.BackgroundTransparency = 1
    changelogIcon.Image = a_getIcon("changelog")
    changelogIcon.ImageColor3 = A_Theme.TextDim
    changelogIcon.ScaleType = Enum.ScaleType.Fit
    changelogIcon.Parent = changelogBtn
    changelogBtn.MouseEnter:Connect(function() A_Tween:Create(changelogIcon, TweenInfo.new(0.15), {ImageColor3 = A_Theme.Text}):Play() end)
    changelogBtn.MouseLeave:Connect(function() A_Tween:Create(changelogIcon, TweenInfo.new(0.15), {ImageColor3 = A_Theme.TextDim}):Play() end)

    if #A_Changelog == 0 then
        changelogBtn.Visible = false
        userBtn.Position = UDim2.new(0.5, -22, 0, bottomY)
        discordBtn.Position = UDim2.new(0.5, 22, 0, bottomY)
    end

    local doors = a_CreateDoorOverlay(mainFrame, windowWidth, windowHeight)

    userBtn.MouseButton1Click:Connect(function() ui.toggleUser(userIcon) end)
    changelogBtn.MouseButton1Click:Connect(function() ui.toggleCL(changelogIcon) end)

    local spinConnection, dotsThread

    local function setStatus(state, customText)
        if spinConnection then spinConnection:Disconnect() spinConnection = nil statusIcon.Rotation = 0 end
        if dotsThread then task.cancel(dotsThread) dotsThread = nil end
        local color, icon, text = A_Theme.StatusIdle, a_getIcon("lock"), customText or "No key detected"
        if state == "verifying" then
            color, icon, text = A_Theme.Accent, a_getIcon("loading"), "Verifying key"
            spinConnection = A_Run.Heartbeat:Connect(function(dt)
                if statusIcon and statusIcon.Parent then statusIcon.Rotation = (statusIcon.Rotation + dt * 360) % 360
                else if spinConnection then spinConnection:Disconnect() end end
            end)
            local dots, i = {".", "..", "...", ""}, 1
            dotsThread = task.spawn(function()
                while statusLabel and statusLabel.Parent and statusLabel.Text:find("Verifying", 1, true) do
                    statusLabel.Text = text .. dots[i] i = (i % #dots) + 1 task.wait(0.4)
                end
            end)
        elseif state == "success" then color, icon, text = A_Theme.Success, a_getIcon("check"), customText or "Access Granted"
        elseif state == "error" then color, icon, text = A_Theme.Error, a_getIcon("alert"), customText or "Invalid Key" end
        A_Tween:Create(statusLabel, TweenInfo.new(0.3), {TextColor3 = color}):Play()
        A_Tween:Create(statusIcon, TweenInfo.new(0.3), {ImageColor3 = color}):Play()
        statusLabel.Text = text statusIcon.Image = icon
    end

    local function closeDoorsThenExit(callback)
        ui.closeAllPanels(userIcon, changelogIcon, function()
            doors.close(function() task.wait(0.3) if callback then callback() end end)
        end)
    end

    closeBtn.MouseButton1Click:Connect(function()
        a_Notify("Goodbye", "See you next time!", 2, "close")
        closeDoorsThenExit(function()
            a_disableBlur()
            A_Tween:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
            A_Tween:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.4)
            screenGui:Destroy()
        end)
    end)

    -- ============================================================
    -- HANDLE REDEEM — LOGIC VRILZHUB (verifyKeyWithServer)
    -- ============================================================
    local function handleRedeem()
        local key = textBox.Text:gsub("%s+", "")
        if key == "" then a_Notify("Error", "Please enter your key", 3, "warning") return end

        setStatus("verifying")
        redeemBtn.Active = false
        task.wait(0.3)

        -- ⭐ LOGIC VRILZHUB (bukan Arqel)
        local valid, message, data = verifyKeyWithServer(key)

        redeemBtn.Active = true

        if valid then
            applyKeyInfo(data, key)
            saveKey(key)  -- simpan vrilz_key.txt + _G.VRILZ_KEY
            setStatus("success", "Access Granted")
            a_Notify("Success", "Key validated successfully!", 2, "success")
            task.wait(1)

            closeDoorsThenExit(function()
                a_disableBlur()
                A_Tween:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
                A_Tween:Create(mainFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                task.wait(0.4)
                screenGui:Destroy()
                if onSuccess then onSuccess() end
            end)
        else
            setStatus("error", message or "Invalid key")
            a_Notify("Invalid", message or "Invalid key", 4, "error")
        end
    end

    redeemBtn.MouseButton1Click:Connect(handleRedeem)

    acquireBtn.MouseButton1Click:Connect(function()
        if A_Links.GetKey ~= "" then
            a_Notify("Copied", "Key link copied!", 3, "copy")
            pcall(function() setclipboard(A_Links.GetKey) end)
        else
            a_Notify("Error", "No key link set", 3, "warning")
        end
    end)

    discordBtn.MouseButton1Click:Connect(function()
        if A_Links.Discord ~= "" then
            a_Notify("Discord", "Invite link copied!", 2, "discord")
            pcall(function() setclipboard(A_Links.Discord) end)
        end
    end)

    textBox.FocusLost:Connect(function(enter) if enter then handleRedeem() end end)

    a_setupDragging(header, container)
    A_Tween:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
    task.wait(0.6)
    doors.open(function()
        task.wait(0.2)
        ui.toggleUser(userIcon)
        if #A_Changelog > 0 then task.wait(0.3) ui.toggleCL(changelogIcon) end
    end)
end

-- ===== PUBLIC ENTRY =====
function ArqelUI.ShowKeyWindow(onSuccess)
    a_ensureIconsReady(function()
        a_BuildKeyUI(onSuccess)
    end)
end

_G.VRILZ_ArqelUI = ArqelUI

-- ============================================================
-- ⭐ KEY/PREMIUM HELPERS — DIPISAH DARI UI.INIT (FIX COMPILE)
-- ============================================================
local function isRealPremiumKey(keyType)
    if not keyType then return false end
    local kt = tostring(keyType):upper()
    return kt == "PREMIUM" or kt == "OWNER" or kt == "VIP"
end

local function isPremiumTimeNow()
    if LocalPlayer.UserId == OWNER_USERID then
        return true
    end
    local ok, result = pcall(function()
        local wibTime = os.time() + 7 * 3600
        local wibDate = os.date("!*t", wibTime)
        if wibDate.wday ~= 7 then return false end
        local totalMin = wibDate.hour * 60 + wibDate.min
        return totalMin >= 1190 and totalMin <= 1439
    end)
    return ok and result
end

local function restoreSavedKeySync()
    local savedKey = loadSavedKey()

    if not savedKey then
        Shared.KeyType = Shared.KeyType or "FREE"
        Shared.KeyExpiresAt = Shared.KeyExpiresAt or 0
        Shared.KeyValue = nil
        Shared._RealKeyType = Shared.KeyType
        Shared._RealKeyExpiresAt = Shared.KeyExpiresAt
        print("[KEY] No saved key found.")
        return
    end

    Shared.KeyValue = savedKey
    local valid, message, data, isNetworkError = verifySavedKeyWithServer(savedKey)

    if valid and data then
        applyKeyInfo(data, savedKey)
        print("[KEY] ✅ Restored saved key:", Shared.KeyType)
        Shared._RealKeyType = Shared.KeyType
        Shared._RealKeyExpiresAt = Shared.KeyExpiresAt or 0
        return
    end

    if data and type(data) == "table" then
        local expiresAt = tonumber(data.expires_at or data.expiry or 0) or 0
        if expiresAt > 0 then
            local nowMs = os.time() * 1000
            if expiresAt <= nowMs then
                clearSavedKey()
                Shared.KeyType = "FREE"
                Shared.KeyExpiresAt = 0
                print("[KEY] ❌ Saved key EXPIRED (local check).")
                Shared._RealKeyType = "FREE"
                Shared._RealKeyExpiresAt = 0
                return
            end
        end
    end

    if isNetworkError then
        print("[KEY] ⚠️ Verify failed (network). Keeping saved key:", message)
        Shared.KeyType = Shared.KeyType or "PREMIUM"
        Shared.KeyExpiresAt = Shared.KeyExpiresAt or 0
        Shared._RealKeyType = Shared.KeyType
        Shared._RealKeyExpiresAt = Shared.KeyExpiresAt or 0
        return
    end

    clearSavedKey()
    Shared.KeyType = "FREE"
    Shared.KeyExpiresAt = 0
    print("[KEY] ❌ Saved key INVALID:", message)
    Shared._RealKeyType = "FREE"
    Shared._RealKeyExpiresAt = 0
end

-- ============================================================
-- ⭐ PREMIUM AUTO-UNLOCK TRANSITION LOOP (dipisah)
-- ============================================================
local function startPremiumTransitionLoop()
    task.spawn(function()
        while true do
            task.wait(30)
            local nowPrem = isPremiumTimeNow()
            if nowPrem == Shared._PremiumAutoUnlock then
                continue
            end
            Shared._PremiumAutoUnlock = nowPrem

            if nowPrem then
                Shared.KeyType = "PREMIUM"
                Shared.KeyExpiresAt = 0
                if _G.VRILZ_RefreshTitle then _G.VRILZ_RefreshTitle() end
                if _G.VRILZ_RebuildCustomTitle then pcall(_G.VRILZ_RebuildCustomTitle) end
                if _G.VRILZ_RebuildReturnMode then pcall(_G.VRILZ_RebuildReturnMode) end
                if Shared.Notify and not isRealPremiumKey(Shared._RealKeyType) then
                    Shared.Notify("👑 PREMIUM AUTO-UNLOCK AKTIF!", "success")
                end
            else
                if isRealPremiumKey(Shared._RealKeyType) then
                    Shared.KeyType = Shared._RealKeyType
                    Shared.KeyExpiresAt = Shared._RealKeyExpiresAt or 0
                    if Shared.Notify then
                        Shared.Notify("👑 Key premium tetap aktif — auto-unlock selesai", "info")
                    end
                else
                    Shared.KeyType = "FREE"
                    Shared.KeyExpiresAt = 0
                    if Shared.Notify then
                        Shared.Notify("🔒 Premium auto-unlock selesai — fitur premium ditutup", "warning")
                    end
                end
                if _G.VRILZ_RefreshTitle then _G.VRILZ_RefreshTitle() end
                if _G.VRILZ_RebuildCustomTitle then pcall(_G.VRILZ_RebuildCustomTitle) end
                if _G.VRILZ_RebuildReturnMode then pcall(_G.VRILZ_RebuildReturnMode) end
            end
        end
    end)
end

-- ============================================================
-- UI.INIT
-- ============================================================
function UI.Init(sharedState)
    Shared = sharedState
    Shared.Notify = notify
    _G.VRILZ_UI_Shared = Shared   -- ← TAMBAH INI (biar bisa debug)

    Shared.ESP_Eggs_Enabled = false
    Shared.ESP_EggName_Enabled = false
    Shared.ESP_EggLuck_Enabled = false
    Shared.ESP_Pets_Enabled = false
    Shared.ESP_PetName_Enabled = false
    Shared.ESP_PetCash_Enabled = false
    Shared.ESP_PetSpeed_Enabled = false
    Shared.AutoSteal_Enabled = false
    Shared.AutoReturn_Enabled = false
    Shared.AutoHatch_Enabled = false
    Shared.AutoPlantEgg_Enabled = false
    Shared.AutoPlantEgg_Filter = "None"
    Shared.AutoRidePet_Enabled = true
    Shared.AutoRideSelectedPet = "Auto (Best KG)"
    Shared.AutoEquipBest_Enabled = false
    Shared.SelectedEgg = "Cherub"
    Shared.EggPrediction_Enabled = false
    Shared.EggsInMap = {}
    Shared.EggPredictions = {}

        Shared.Speed_Enabled = false
    Shared.Speed_Value = 100
    Shared.InstantPickup_Enabled = false
    Shared.AutoFarm_Enabled = false
    Shared.AntiAFK_Enabled = true   -- ← TAMBAH INI
    Shared.SelectedRarities = {
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
    }
    Shared.AutoHatchLuck_Enabled = false
    Shared.HatchLuck_Mode = "Max"
          Shared.StealMode = "TP"
    Shared.TP_Method = "TP100"
    Shared.ShowTitle = true
    Shared.RarityNotifThreshold = "Legendary"
    Shared.VolcanicHunt_Enabled = false
    Shared.VolcanicReturn_Enabled = false
    Shared.VolcanicMutation_Enabled = false
    Shared.AutoMutation_Enabled = false
    Shared.MutationReturn_Enabled = false
    Shared.ReturnMode = "Step"
        Shared.MutationSelectedEggs = {
        ["Cherub Egg"] = false, ["Volcanic Egg"] = false, ["Blackhole Egg"] = false,
        ["Solaris Egg"] = false, ["Galaxy Egg"] = false, ["Crystal Egg"] = false,
        ["Golden Egg"] = false, ["Glass Egg"] = false, ["Skull Egg"] = false,
        ["Sinister Egg"] = false, ["Soul Egg"] = false, ["Dominus Egg"] = false,
        ["Slime Egg"] = false, ["Flower Egg"] = false, ["Leaf Egg"] = false,
        ["Stone Egg"] = false, ["Easter Egg"] = false, ["Cracked Egg"] = false,
        ["Ice Egg"] = false, ["Tidal Egg"] = false, ["Bloom Egg"] = false,
        ["Aurora Egg"] = false, ["White Egg"] = false, ["Brown Egg"] = false,
        ["Flaming Egg"] = false, ["Mushroom Egg"] = false, ["Asteroid Egg"] = false,
        ["Giant Egg"] = false, ["Diamond Egg"] = false, ["Dragon Egg"] = false,
        -- ⭐ BARU:
        ["Seraph Egg"] = false, ["Halloween Egg"] = false,
    }
    Shared.FPSBoost_Enabled = false
    Shared.LightsEffect_Enabled = true
    Shared.HD4K_Enabled = false
    Shared.YinRitual_Enabled = false
    Shared.InfinityJump_Enabled = false
    Shared.InfinityJump_Height = 50
        -- ⭐ WEBHOOK STATE
    Shared.WebhookURL = loadWebhookURL() or ""
    Shared.WebhookEnabled = false
    Shared.WebhookLastSend = 0
    Shared.WebhookMentionEveryone = false

    -- Live Chat state
    Shared.LiveChat_Messages = {}
    Shared.LiveChat_MaxMessages = CFG.CHAT_MAX_MSG
    Shared.LiveChat_PollInterval = 1.5

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRILZHUB_RideAPet"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

        setupNotifHolder(ScreenGui)
    setupDropdownLayer(ScreenGui)

    -- Auto-start chat polling (biar selalu nyambung)
    task.spawn(function()
        task.wait(2)
        pcall(function()
            if _G.VRILZ_ChatClient and _G.VRILZ_ChatClient.start then
                _G.VRILZ_ChatClient.start()
            end
        end)
    end)

    local function startLoading()
        buildLoadingScreen(ScreenGui)
    end

        local function showKeyWindow()
        ArqelUI.ShowKeyWindow(function()
            startLoading()
        end)
    end

        -- Load custom title dari save file
    task.spawn(function()
        task.wait(1)
        local savedTitle = loadCustomTitle()
        if savedTitle then
            print("[TITLE] Loaded: " .. savedTitle)
        end
        task.wait(1)
        if _G.VRILZ_RefreshTitle then
            _G.VRILZ_RefreshTitle()
        end
    end)

    -- ============================================================
    -- ⭐ STARTUP (RINGKAS — panggil helper di luar)
    -- ============================================================
    restoreSavedKeySync()
    local premiumNow = isPremiumTimeNow()
    Shared._PremiumAutoUnlock = premiumNow

    local hasRealPremium = isRealPremiumKey(Shared._RealKeyType)
    local savedKeyNow = loadSavedKey()
    local hasValidSavedKey = savedKeyNow ~= nil
        and (Shared.KeyType == "FREE"
            or Shared.KeyType == "PREMIUM"
            or Shared.KeyType == "VIP"
            or Shared.KeyType == "OWNER")

    if hasRealPremium or hasValidSavedKey then
        Shared.KeyType = Shared._RealKeyType
        Shared.KeyExpiresAt = Shared._RealKeyExpiresAt or 0
        print("[KEY] ✅ Auto-login with saved key:", Shared.KeyType)
        startLoading()

    elseif premiumNow then
        Shared.KeyType = "PREMIUM"
        Shared.KeyExpiresAt = 0
        task.spawn(function()
            task.wait(1.5)
            if Shared.Notify then
                Shared.Notify("👑 PREMIUM AUTO-UNLOCK (Sabtu 19:50–23:59 WIB)", "success")
            end
        end)
        startLoading()

    else
        Shared.KeyType = "FREE"
        Shared.KeyExpiresAt = 0
        showKeyWindow()
    end

    task.spawn(function()
        startPremiumTransitionLoop()
    end)
end

return UI
