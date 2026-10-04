-- ============================================================
-- VRILZHUB UI — RIDE A PET v1.6 (AUTO-DETECT PC & MOBILE)
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

-- ====== AUTO-DETECT MOBILE ======
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ====== UI CONFIG ======
local UI_CONFIG = {
    MOBILE = {
        WIN_W_PCT = 0.92, WIN_H_PCT = 0.88,
        SIDEBAR_W = 78, TAB_H = 42, TAB_ICON = 18, TAB_SHOW_LABEL = false,
        CARD_HEADER = 34, CARD_PAD_TOP = 10, CARD_PAD_BOT = 12, CARD_PAD_SIDE = 12,
        CARD_GAP = 8, TOGGLE_H = 38, TOGGLE_W = 50, TOGGLE_KNOB = 20,
        DROPDOWN_H = 42, DROPDOWN_ITEM = 32, DROPDOWN_POPUP_W = 154, ACTION_H = 36,
        FONT_TITLE = 13, FONT_LABEL = 11, FONT_MUTED = 9, FONT_SMALL = 10,
        FONT_MED = 11, FONT_LARGE = 14,
        HEADER_H = 40, SEARCH_H = 30, NOTIF_W = 300, NOTIF_H = 52, OPEN_BTN = 52,
        -- LIVE CHAT
        CHAT_MSG_H = 46, CHAT_AVATAR = 22, CHAT_FONT = 10, CHAT_NAME_FONT = 10,
        CHAT_INPUT_H = 34, CHAT_SEND_W = 46, CHAT_BUBBLE_PAD = 8,
        CHAT_MAX_MSG = 80, CHAT_SHOW_AVATAR = false, CHAT_PANEL_H = 340,
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

-- ====== EGG NAMES ======
local EggNames = {
    "Cherub", "Volcanic", "Blackhole", "Solaris", "Galaxy",
    "Crystal", "Golden", "Glass", "Skull", "Sinister",
    "Soul", "Dominus", "Slime", "Flower", "Leaf",
    "Stone", "Easter", "Cracked", "Ice", "Tidal",
    "Bloom", "Aurora", "White", "Brown"
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

local function notify(text, type)
    if not NotifHolder then return end
    type = type or "info"

    local color, icon
    if type == "success" then color = C.Success; icon = "✓"
    elseif type == "error" then color = C.Error; icon = "✕"
    elseif type == "warning" then color = Color3.fromRGB(255, 200, 50); icon = "!"
    else color = C.Accent; icon = "i" end

    local notif = Instance.new("Frame")
    notif.Size = UDim2.fromOffset(CFG.NOTIF_W, CFG.NOTIF_H)
    notif.BackgroundColor3 = C.Surface
    notif.BorderSizePixel = 0
    notif.ZIndex = 501
    notif.Parent = NotifHolder
    registerTheme(notif, "Surface", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = notif

    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = notif

    local iconBg = Instance.new("Frame")
    iconBg.Size = UDim2.fromOffset(32, 32)
    iconBg.Position = UDim2.new(0, 12, 0.5, -16)
    iconBg.BackgroundColor3 = color
    iconBg.BorderSizePixel = 0
    iconBg.ZIndex = 502
    iconBg.Parent = notif

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconBg

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.fromScale(1, 1)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextColor3 = Color3.new(1, 1, 1)
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.TextSize = 16
    iconLbl.ZIndex = 503
    iconLbl.Parent = iconBg

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.fromOffset(54, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = CFG.FONT_LABEL
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 502
    label.Parent = notif
    registerTheme(label, "Text", "TextColor3")

    notif.Position = UDim2.fromOffset(0, -80)
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(0, 0)
    }):Play()

    task.delay(3, function()
        if notif and notif.Parent then
            TweenService:Create(notif, TweenInfo.new(0.3), {
                Position = UDim2.fromOffset(0, -80),
                BackgroundTransparency = 1
            }):Play()
            TweenService:Create(label, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(iconLbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.35)
            if notif then notif:Destroy() end
        end
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
    cardGradient.Parent = card

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

    -- Ripple layer
    local rippleLayer = Instance.new("Frame")
    rippleLayer.Name = "RippleLayer"
    rippleLayer.Size = UDim2.fromScale(1, 1)
    rippleLayer.BackgroundTransparency = 1
    rippleLayer.ClipsDescendants = true
    rippleLayer.ZIndex = 99
    rippleLayer.Parent = card

    -- RIPPLE SAJA (TANPA NAIK/TURUN)
    card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            local ripple = Instance.new("Frame")
            ripple.Size = UDim2.fromOffset(0, 0)
            ripple.Position = UDim2.fromOffset(input.Position.X - card.AbsolutePosition.X, input.Position.Y - card.AbsolutePosition.Y)
            ripple.AnchorPoint = Vector2.new(0.5, 0.5)
            ripple.BackgroundColor3 = C.Accent
            ripple.BackgroundTransparency = 0.7
            ripple.BorderSizePixel = 0
            ripple.ZIndex = 100
            ripple.Parent = rippleLayer

            local rippleCorner = Instance.new("UICorner")
            rippleCorner.CornerRadius = UDim.new(1, 0)
            rippleCorner.Parent = ripple

            TweenService:Create(ripple, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(card.AbsoluteSize.X * 2, card.AbsoluteSize.X * 2),
                BackgroundTransparency = 1
            }):Play()

            task.delay(0.7, function()
                if ripple then ripple:Destroy() end
            end)
        end
    end)

    -- Header
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, CFG.CARD_HEADER)
    headerFrame.BackgroundColor3 = C.Surface2
    headerFrame.BorderSizePixel = 0
    headerFrame.ZIndex = 2
    headerFrame.Parent = card
    registerTheme(headerFrame, "Surface2", "BackgroundColor3")

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Rotation = 0
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(34, 34, 39)),
        ColorSequenceKeypoint.new(0.55, C.Surface2),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 22)),
    })
    headerGradient.Parent = headerFrame

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

    local dropGradient = Instance.new("UIGradient")
    dropGradient.Rotation = 0
    dropGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
        ColorSequenceKeypoint.new(0.5, C.Surface3),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 21, 25)),
    })
    dropGradient.Parent = container

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
        opt.Text = item
        opt.TextColor3 = C.Text
        opt.Font = Enum.Font.GothamSemibold
        opt.TextSize = CFG.FONT_LABEL
        opt.AutoButtonColor = false
        opt.ZIndex = 2002
        opt.LayoutOrder = i
        opt.Parent = listFrame
        registerTheme(opt, "Surface3", "BackgroundColor3")
        registerTheme(opt, "Text", "TextColor3")

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 8)
        optCorner.Parent = opt

        local optStroke = Instance.new("UIStroke")
        optStroke.Color = C.Accent
        optStroke.Thickness = 1
        optStroke.Transparency = 1
        optStroke.Parent = opt

        if item == selectedValue then
            opt.BackgroundColor3 = C.Accent
            optStroke.Transparency = 0.15
        end

        opt.MouseEnter:Connect(function()
            if item ~= selectedValue then
                TweenService:Create(opt, TweenInfo.new(0.12), {BackgroundColor3 = C.Surface2}):Play()
            end
            TweenService:Create(optStroke, TweenInfo.new(0.12), {Transparency = item == selectedValue and 0.15 or 0.45}):Play()
        end)
        opt.MouseLeave:Connect(function()
            if item ~= selectedValue then
                TweenService:Create(opt, TweenInfo.new(0.12), {BackgroundColor3 = C.Surface3}):Play()
            end
            TweenService:Create(optStroke, TweenInfo.new(0.12), {Transparency = item == selectedValue and 0.15 or 1}):Play()
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
        opt.txt.TextColor3 = C.Text
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
        opt.Parent = listFrame
        registerTheme(opt, "Surface3", "BackgroundColor3")

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 5)
        optCorner.Parent = opt

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
        txt.ZIndex = 2003
        txt.Parent = opt

        if sharedTable[item] then
            opt.BackgroundColor3 = C.Surface2
            txt.TextColor3 = C.Text
        end

        optionButtons[item] = {bg = opt, chk = chk, txt = txt}

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
-- BUILD MAIN WINDOW
-- ============================================================
local function buildMainWindow(parent)
    local screenGui = parent
    local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)

    local winW, winH
    if IS_MOBILE then
        winW = math.floor(viewport.X * CFG.WIN_W_PCT)
        winH = math.floor(viewport.Y * CFG.WIN_H_PCT)
    else
        winW = math.min(CFG.WIN_W, math.floor(viewport.X * 0.7))
        winH = math.min(CFG.WIN_H, math.floor(viewport.Y * 0.78))
    end

    local main = Instance.new("Frame")
    main.Name = "MainWindow"
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.fromScale(0.5, 0.5)
    main.Size = UDim2.fromOffset(winW, winH)
    main.BackgroundColor3 = C.BG
    main.BorderSizePixel = 0
    main.ZIndex = 1
    main.Parent = screenGui
    registerTheme(main, "BG", "BackgroundColor3")

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
    gradient.Parent = main

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
    registerTheme(header, "Surface", "BackgroundColor3")

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 18)
    headerCorner.Parent = header

    local headerGradient = Instance.new("UIGradient")
    headerGradient.Rotation = 0
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 35)),
        ColorSequenceKeypoint.new(0.5, C.Surface),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 13, 17)),
    })
    headerGradient.Parent = header

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
    headerFix.BackgroundColor3 = C.Surface
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 10
    headerFix.Parent = header

    local logo = Instance.new("TextLabel")
    logo.Size = UDim2.fromOffset(IS_MOBILE and 30 or 36, IS_MOBILE and 30 or 36)
    logo.Position = UDim2.fromOffset(IS_MOBILE and 10 or 12, (CFG.HEADER_H - (IS_MOBILE and 30 or 36)) / 2)
    logo.BackgroundColor3 = C.Accent
    logo.Text = "VH"
    logo.TextColor3 = Color3.new(1, 1, 1)
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = IS_MOBILE and 16 or 20
    logo.ZIndex = 11
    logo.Parent = header
    registerTheme(logo, "Accent", "BackgroundColor3")

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logo

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
    subtitle.Text = "Ride a Pet · v1.6"
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

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 14)
    sidebarCorner.Parent = sidebar

    local sidebarGradient = Instance.new("UIGradient")
    sidebarGradient.Rotation = 90
    sidebarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 25, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 11, 14)),
    })
    sidebarGradient.Parent = sidebar

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

    if not IS_MOBILE then
        local resizeHandle = Instance.new("TextButton")
        resizeHandle.Size = UDim2.fromOffset(22, 22)
        resizeHandle.Position = UDim2.new(1, -24, 1, -24)
        resizeHandle.BackgroundTransparency = 1
        resizeHandle.Text = "⌟"
        resizeHandle.TextColor3 = C.Accent
        resizeHandle.TextSize = 17
        resizeHandle.Font = Enum.Font.GothamBold
        resizeHandle.AutoButtonColor = false
        resizeHandle.ZIndex = 100
        resizeHandle.Parent = main
        registerTheme(resizeHandle, "Accent", "TextColor3")

        local resizing = false
        local resizeStart, startSize
        resizeHandle.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = true
                resizeStart = i.Position
                startSize = main.Size
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if resizing and i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - resizeStart
                local newX = math.clamp(startSize.X.Offset + delta.X, 600, 1200)
                local newY = math.clamp(startSize.Y.Offset + delta.Y, 400, 800)
                main.Size = UDim2.fromOffset(newX, newY)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                resizing = false
            end
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

    local function playMinimizeLightning()
        -- Lightweight visual strike: a few short UI segments, then cleanup.
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
            bolt.BackgroundColor3 = Color3.fromRGB(170, 220, 255)
            bolt.BorderSizePixel = 0
            bolt.ZIndex = 411
            bolt.Parent = holder
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(1, 0)
            bc.Parent = bolt
        end

        local flash = Instance.new("Frame")
        flash.Size = UDim2.fromScale(1, 1)
        flash.BackgroundColor3 = C.Accent
        flash.BackgroundTransparency = 0.9
        flash.BorderSizePixel = 0
        flash.ZIndex = 410
        flash.Parent = holder
        local fc = Instance.new("UICorner")
        fc.CornerRadius = UDim.new(0, 16)
        fc.Parent = flash

        task.spawn(function()
            TweenService:Create(flash, TweenInfo.new(0.10), {BackgroundTransparency = 1}):Play()
            for _, child in ipairs(holder:GetChildren()) do
                if child:IsA("Frame") and child ~= flash then
                    TweenService:Create(child, TweenInfo.new(0.16), {BackgroundTransparency = 1}):Play()
                end
            end
            task.wait(0.18)
            if holder then holder:Destroy() end
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

    local function registerTab(id, icon, label)
        local tabH = CFG.TAB_H
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, tabH)
        btn.BackgroundColor3 = C.Surface3
        btn.BackgroundTransparency = 0.5
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
            navs[id] = {btn = btn, ic = ic, lbl = lbl}
        else
            navs[id] = {btn = btn, ic = ic, lbl = nil}
        end

              local function switchTo()
            for n, p in pairs(pages) do
                if p then p.Visible = false end
            end
            if pages[id] then
                pages[id].Visible = true
            end
            for n, x in pairs(navs) do
                if n == id then
                    x.btn.BackgroundColor3 = C.Accent
                    x.btn.BackgroundTransparency = 0
                    x.ic.TextColor3 = Color3.new(1, 1, 1)
                    if x.btn:FindFirstChildOfClass("UIStroke") then x.btn:FindFirstChildOfClass("UIStroke").Transparency = 0.15 end
                    if x.lbl then x.lbl.TextColor3 = Color3.new(1, 1, 1) end
                else
                    x.btn.BackgroundColor3 = C.Surface3
                    x.btn.BackgroundTransparency = 0.5
                    x.ic.TextColor3 = C.Accent
                    if x.btn:FindFirstChildOfClass("UIStroke") then x.btn:FindFirstChildOfClass("UIStroke").Transparency = 0.82 end
                    if x.lbl then x.lbl.TextColor3 = C.Muted end
                end
            end
        end

        btn.MouseButton1Click:Connect(switchTo)
        return btn, switchTo
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
        page.Visible = false
        page.ZIndex = 7
        page.Parent = pageHolder
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, IS_MOBILE and 8 or 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page
        return page
    end

    -- TAB INFO
    local infoPage = createPage("Info")
    pages.Info = infoPage

    local infoCard, infoContent = makeCard(infoPage, "CLIENT INFORMATION", 1)

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
            keyExpiryLbl.Text = string.format("Expired: %s | Remaining: %dd %02dj %02dm", expiryText, days, hours, mins)
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

    local updateCard, updateContent = makeCard(infoPage, "📢 UPDATE INFORMATION", 2)

    local infoLines = {
        "Version        : 1.6",
        "Last Update    : 29 Sept 2026",
        "Status         : Online ✅",
        "Changelog      : Speed, Auto Farm, Mutation",
        "                 Instant Pickup, Rarity, Volcanic",
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
        lbl.LayoutOrder = i
        lbl.ZIndex = 3
        lbl.Parent = updateContent
        registerTheme(lbl, "Muted", "TextColor3")
    end

    local explCard, explContent = makeCard(infoPage, "🎮 EXPLOIT SUPPORT", 3)

    local explLines = {
        "✅ Delta       ✅ Fluxus",
        "✅ Xeno        ✅ Codex",
        "✅ Solara      ✅ Wave",
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

    local discordCard, discordContent = makeCard(infoPage, "💬 JOIN DISCORD", 4)
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

    registerTab("Info", "ℹ", "Info")

    -- Keep the Info tab independently scrollable all the way to the Discord copy button.
    do
        local infoLayout = infoPage:FindFirstChildOfClass("UIListLayout")
        if infoLayout then
            infoPage.AutomaticCanvasSize = Enum.AutomaticSize.None
            infoPage.ScrollingDirection = Enum.ScrollingDirection.Y
            infoPage.ScrollingEnabled = true
            local function syncInfoCanvas()
                infoPage.CanvasSize = UDim2.new(0, 0, 0, infoLayout.AbsoluteContentSize.Y + 50)
            end
            infoLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(syncInfoCanvas)
            task.defer(syncInfoCanvas)
        end
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

        local winW = isMob and math.floor(viewport.X * 0.92) or math.min(520, math.floor(viewport.X * 0.55))
        local winH = isMob and math.floor(viewport.Y * 0.7) or 520

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
        local dragging, dragStart, startPos = false, nil, nil
        header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = win.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                win.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
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

    registerTab("Prediksi", "◎", "Prediksi")

    -- TAB EGG
    local eggPage = createPage("Egg")
    pages.Egg = eggPage

    local eggEspCard, eggEspContent = makeCard(eggPage, "EGG ESP", 1)
    makeToggle(eggEspContent, "Enable Egg ESP", false, function(v) Shared.ESP_Eggs_Enabled = v end)
    makeToggle(eggEspContent, "Show Name", false, function(v) Shared.ESP_EggName_Enabled = v end)
    makeToggle(eggEspContent, "Show Luck", false, function(v) Shared.ESP_EggLuck_Enabled = v end)

    local autoStealCard, autoStealContent = makeCard(eggPage, "AUTO STEAL", 2)
    makeToggle(autoStealContent, "Enable Auto Steal", false, function(v) Shared.AutoSteal_Enabled = v end)
    makeToggle(autoStealContent, "Auto Return to Plot", false, function(v) Shared.AutoReturn_Enabled = v end)
    makeToggle(autoStealContent, "Auto Hatch", false, function(v) Shared.AutoHatch_Enabled = v end)

    local eggNameLbl = Instance.new("TextLabel")
    eggNameLbl.Size = UDim2.new(1, 0, 0, 16)
    eggNameLbl.BackgroundTransparency = 1
    eggNameLbl.Text = "Select Eggs:"
    eggNameLbl.TextColor3 = C.Muted
    eggNameLbl.Font = Enum.Font.GothamSemibold
    eggNameLbl.TextSize = CFG.FONT_MUTED
    eggNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    eggNameLbl.ZIndex = 3
    eggNameLbl.Parent = autoStealContent

    makeDropdownGlobal(autoStealContent, EggNames, "Cherub", function(v)
        Shared.SelectedEgg = v
        notify("Egg: " .. v, "info")
    end)

    registerTab("Egg", "◯", "Egg")

    -- TAB VISUAL
    local visualPage = createPage("Visual")
    pages.Visual = visualPage

    local pEspCard, pEspContent = makeCard(visualPage, "PLAYER ESP", 1)
    makeToggle(pEspContent, "Player ESP", false, function(v) Shared.ESP_Players_Enabled = v end)
    makeToggle(pEspContent, "Player Chams", false, function(v) Shared.ESP_PlayerChams_Enabled = v end)
    makeToggle(pEspContent, "Player Studs", false, function(v) Shared.ESP_PlayerStuds_Enabled = v end)

    local petEspCard, petEspContent = makeCard(visualPage, "PET ESP", 2)
    makeToggle(petEspContent, "Pet ESP", false, function(v) Shared.ESP_Pets_Enabled = v end)
    makeToggle(petEspContent, "Show Name", false, function(v) Shared.ESP_PetName_Enabled = v end)
    makeToggle(petEspContent, "Show Cash", false, function(v) Shared.ESP_PetCash_Enabled = v end)
    makeToggle(petEspContent, "Show Speed", false, function(v) Shared.ESP_PetSpeed_Enabled = v end)

    registerTab("Visual", "◆", "Visual")

    -- TAB AUTO
    local autoPage = createPage("Auto")
    pages.Auto = autoPage

    local speedCard, speedContent = makeCard(autoPage, "SPEED", 1)
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
            if Features and Features.setSpeed then
                Features.setSpeed(Shared.Speed_Value)
            end
        end
    end)

    local ipCard, ipContent = makeCard(autoPage, "INSTANT PICKUP", 2)
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

    local farmCard, farmContent = makeCard(autoPage, "AUTO FARM", 3)
    makeToggle(farmContent, "Activate Auto Farm", false, function(v) Shared.AutoFarm_Enabled = v end)
    makeToggle(farmContent, "Auto Return to Plot", false, function(v) Shared.AutoReturn_Enabled = v end)

    local rarTitle = Instance.new("TextLabel")
    rarTitle.Size = UDim2.new(1, 0, 0, 16)
    rarTitle.BackgroundTransparency = 1
    rarTitle.Text = "Select Rarity Egg:"
    rarTitle.TextColor3 = C.Muted
    rarTitle.Font = Enum.Font.GothamSemibold
    rarTitle.TextSize = CFG.FONT_MUTED
    rarTitle.TextXAlignment = Enum.TextXAlignment.Left
    rarTitle.LayoutOrder = 3
    rarTitle.Parent = farmContent

    makeDropdownMulti(farmContent, RarityList, Shared.SelectedRarities, nil, function(t) end)

    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, 0, 0, 16)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = "Notify only for rarity:"
    notifTitle.TextColor3 = C.Muted
    notifTitle.Font = Enum.Font.GothamSemibold
    notifTitle.TextSize = CFG.FONT_MUTED
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.LayoutOrder = 20
    notifTitle.Parent = farmContent

    makeDropdownGlobal(farmContent, RarityList, "Legendary", function(v)
        Shared.RarityNotifThreshold = v
    end)

    local autoCard, autoContent = makeCard(autoPage, "OTHER AUTO", 4)
    makeToggle(autoContent, "Auto Ride Pet", false, function(v) Shared.AutoRidePet_Enabled = v end)
    makeToggle(autoContent, "Auto Equip Best", false, function(v) Shared.AutoEquipBest_Enabled = v end)

    registerTab("Auto", "▶", "Auto")

    -- TAB SETTINGS
    local setPage = createPage("Settings")
    pages.Settings = setPage

    local themeCard, themeContent = makeCard(setPage, "THEME", 1)

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

   local themeList = {"Brutal", "Ice", "Fire", "Pink", "Green", "Blue"}
    makeDropdownGlobal(themeContent, themeList, CurrentTheme, function(v)
        applyTheme(v)
        notify("Theme: " .. v, "success")
    end)

    -- ===== LIVE CHAT TOGGLE =====
    local chatToggleCard, chatToggleContent = makeCard(setPage, "💬 LIVE CHAT", 3)

    -- Buat window-nya dulu (hidden)
    local liveChatWin = buildLiveChatWindow(screenGui)

    makeToggle(chatToggleContent, "Show Live Chat Window", false, function(v)
        if liveChatWin then
            liveChatWin.Visible = v
            if v then
                -- Auto-start polling pas dinyalain
                pcall(function()
                    if ChatClient and ChatClient.start then
                        ChatClient.start()
                    end
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
    chatHint.Text = "🌐 Global chat · semua user script"
    chatHint.TextColor3 = C.Muted
    chatHint.Font = Enum.Font.GothamSemibold
    chatHint.TextSize = CFG.FONT_MUTED
    chatHint.TextXAlignment = Enum.TextXAlignment.Left
    chatHint.LayoutOrder = 10
    chatHint.Parent = chatToggleContent
    registerTheme(chatHint, "Muted", "TextColor3")

    
    local fpsCard, fpsContent = makeCard(setPage, "FPS BOOST", 2)

    local fpsWin = buildFPSWindow(screenGui)
    UI._fpsWindow = fpsWin

    makeToggle(fpsContent, "FPS Boost", false, function(v)
        if v then
            pcall(function() Lighting.GlobalShadows = false end)
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
            task.spawn(function()
                local hidden = {}
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local name = string.lower(obj.Name)
                        local parentName = obj.Parent and string.lower(obj.Parent.Name) or ""
                        local skip = false
                        if obj:FindFirstChildWhichIsA("Humanoid") then skip = true end
                        if name:find("egg") or name:find("nest") then skip = true end
                        if parentName:find("plot") or parentName:find("char") then skip = true end
                        if obj:FindFirstChildWhichIsA("ProximityPrompt") then skip = true end
                        if not skip then
                            local isDeco = false
                            if obj.Transparency >= 0.5 then isDeco = true end
                            if name:find("tree") or name:find("rock") or name:find("bush") then isDeco = true end
                            if name:find("grass") or name:find("flower") or name:find("cloud") then isDeco = true end
                            if isDeco and obj.Size.Magnitude < 50 then
                                obj.LocalTransparencyModifier = 1
                                obj.CanCollide = false
                                table.insert(hidden, obj)
                            end
                        end
                    end
                end
                UI._fpsHiddenParts = hidden
                notify("FPS Boost: " .. #hidden .. " Parts hidden", "info")
            end)
            notify("FPS Boost enabled", "success")
        else
            pcall(function() Lighting.GlobalShadows = true end)
            pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level10 end)
            if UI._fpsHiddenParts then
                for _, part in ipairs(UI._fpsHiddenParts) do
                    if part and part.Parent then
                        part.LocalTransparencyModifier = 0
                        part.CanCollide = true
                    end
                end
                UI._fpsHiddenParts = nil
            end
            notify("FPS Boost disabled", "info")
        end
    end, "FPS Boost")

    makeToggle(fpsContent, "FPS Window", false, function(v)
        if fpsWin then fpsWin.Visible = v end
    end, "FPS Window")

   -- TAB VOLCANIC
local volcanicPage = createPage("Vulcanic")
pages.Vulcanic = volcanicPage

local volcanicHuntCard, volcanicHuntContent = makeCard(volcanicPage, "🌋 VOLCANIC HUNTER", 1)

makeToggle(volcanicHuntContent, "Auto Hunt Volcanic", false, function(v)
    Shared.VolcanicHunt_Enabled = v
    if v then
        notify("🌋 Volcanic Hunt enabled", "success")
    else
        notify("🌋 Volcanic Hunt disabled", "info")
    end
end)

makeToggle(volcanicHuntContent, "Auto Return to Plot", false, function(v)
    Shared.VolcanicReturn_Enabled = v
    if v then
        notify("🏠 Auto Return enabled", "success")
    end
end)

makeToggle(volcanicHuntContent, "Auto Mutation in Lava", false, function(v)
    Shared.VolcanicMutation_Enabled = v
    if v then
        notify("🔥 Auto Mutation enabled", "success")
    else
        notify("🔥 Auto Mutation disabled", "info")
    end
end)

makeToggle(volcanicHuntContent, "Instant Collect", false, function(v)
    Shared.InstantPickup_Enabled = v
end)

local volcanicNote = Instance.new("TextLabel")
volcanicNote.Size = UDim2.new(1, 0, 0, 96)
volcanicNote.BackgroundTransparency = 1
volcanicNote.Text = "⚠️ IMPORTANT: Turn OFF Auto Farm & Auto Steal first!\n\n✅ Then enable 'Auto Hunt Volcanic'\n✅ Enable 'Auto Return' to come back to base\n✅ Optional: Enable 'Auto Mutation' if you want mutation"
volcanicNote.TextColor3 = C.Muted
volcanicNote.Font = Enum.Font.GothamSemibold
volcanicNote.TextSize = CFG.FONT_MUTED
volcanicNote.TextWrapped = true
volcanicNote.TextXAlignment = Enum.TextXAlignment.Left
volcanicNote.TextYAlignment = Enum.TextYAlignment.Top
volcanicNote.LayoutOrder = 10
volcanicNote.ZIndex = 3
volcanicNote.Parent = volcanicHuntContent
registerTheme(volcanicNote, "Muted", "TextColor3")

registerTab("Vulcanic", "🌋", "Vulcanic")

    -- ============================================================
    -- TAB EGG MUTATION (BARU)
    -- ============================================================
    local mutPage = createPage("EggMutation")
    pages.EggMutation = mutPage

    -- ===== CARD 0: AUTO STEAL (RARITY) =====
    local mutStealCard, mutStealContent = makeCard(mutPage, "🎯 AUTO STEAL (RARITY)", 0)

    makeToggle(mutStealContent, "Auto Steal by Rarity", false, function(v)
        Shared.MutationSteal_Enabled = v
        if v then
            notify("🎯 Mutation Steal enabled (by rarity)", "success")
        else
            notify("🎯 Mutation Steal disabled", "info")
        end
    end)

    local mutRarLabel = Instance.new("TextLabel")
    mutRarLabel.Size = UDim2.new(1, 0, 0, 16)
    mutRarLabel.BackgroundTransparency = 1
    mutRarLabel.Text = "Select Rarity Egg:"
    mutRarLabel.TextColor3 = C.Muted
    mutRarLabel.Font = Enum.Font.GothamSemibold
    mutRarLabel.TextSize = CFG.FONT_MUTED
    mutRarLabel.TextXAlignment = Enum.TextXAlignment.Left
    mutRarLabel.LayoutOrder = 3
    mutRarLabel.ZIndex = 3
    mutRarLabel.Parent = mutStealContent
    registerTheme(mutRarLabel, "Muted", "TextColor3")

    makeDropdownMulti(mutStealContent, RarityList, Shared.SelectedRarities, nil, function(t) end)

    -- CARD 1: AUTO MUTATION
    local mutCard, mutContent = makeCard(mutPage, "🔥 EGG MUTATION", 1)

    makeToggle(mutContent, "Auto Mutation", false, function(v)
        Shared.AutoMutation_Enabled = v
        if v then
            notify("🔥 Auto Mutation enabled", "success")
        else
            notify("🔥 Auto Mutation disabled", "info")
        end
    end)

    makeToggle(mutContent, "Auto Return to Plot", false, function(v)
        Shared.MutationReturn_Enabled = v
        if v then
            notify("🏠 Return to Plot enabled", "success")
        end
    end)

    local mutNote = Instance.new("TextLabel")
    mutNote.Size = UDim2.new(1, 0, 0, 60)
    mutNote.BackgroundTransparency = 1
    mutNote.Text = "Auto drop egg to volcano (VolcanoDip)\n→ wait egg return (max 45s)\n→ return to plot"
    mutNote.TextColor3 = C.Muted
    mutNote.Font = Enum.Font.GothamSemibold
    mutNote.TextSize = CFG.FONT_MUTED
    mutNote.TextWrapped = true
    mutNote.TextXAlignment = Enum.TextXAlignment.Left
    mutNote.TextYAlignment = Enum.TextYAlignment.Top
    mutNote.LayoutOrder = 10
    mutNote.ZIndex = 3
    mutNote.Parent = mutContent
    registerTheme(mutNote, "Muted", "TextColor3")

    -- CARD 2: INFO PANEL (state live)
    local infoCard, infoContent = makeCard(mutPage, "📊 STATUS MUTATION", 2)

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
    mutInfoLbl.ZIndex = 3
    mutInfoLbl.Parent = infoContent
    registerTheme(mutInfoLbl, "Text", "TextColor3")

    local mutInfoCorner = Instance.new("UICorner")
    mutInfoCorner.CornerRadius = UDim.new(0, 6)
    mutInfoCorner.Parent = mutInfoLbl

    local mutInfoPad = Instance.new("UIPadding")
    mutInfoPad.PaddingLeft = UDim.new(0, 8)
    mutInfoPad.PaddingTop = UDim.new(0, 6)
    mutInfoPad.Parent = mutInfoLbl

    -- Auto update info tiap 0.5 detik
    task.spawn(function()
        while mutInfoLbl.Parent do
            task.wait(0.5)
            local lines = {}
            
            if Features and Features.isHoldingEgg then
                local holding, eggName = Features.isHoldingEgg()
                table.insert(lines, "✋ Held: " .. (holding and ("YES " .. (eggName or "?")) or "no"))
            else
                table.insert(lines, "✋ Held: --")
            end

            if Features and Features.getMutationState then
                local state = Features.getMutationState()
                table.insert(lines, "🔒 Lock: " .. (state.EggLocked and "YES" or "no"))
                table.insert(lines, "⏸ Paused: " .. (state.StealPaused and "YES" or "no"))
                table.insert(lines, "▶ Running: " .. (state.Running and "YES" or "no"))
            end

            mutInfoLbl.Text = table.concat(lines, "\n")
        end
    end)

        registerTab("EggMutation", "🔥", "Egg Mutation")

    registerTab("Settings", "⚙", "Settings")

    pages.Info.Visible = true
    navs.Info.btn.BackgroundColor3 = C.Accent
    navs.Info.btn.BackgroundTransparency = 0
    navs.Info.ic.TextColor3 = Color3.new(1, 1, 1)
    if navs.Info.lbl then navs.Info.lbl.TextColor3 = Color3.new(1, 1, 1) end

    local dragging, dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mouseX = UserInputService:GetMouseLocation().X
            if mouseX > (header.AbsolutePosition.X + header.AbsoluteSize.X - 90) then return end
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

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
        return false, data.message or "Invalid key.", data
    end

    if status >= 200 and status < 300 then
        return false, "Invalid Key System response."
    end

    return false, "Invalid key."
end

-- Mengecek key yang SUDAH pernah diredeem tanpa membuat redeem kedua.
local function verifySavedKeyWithServer(key)
    key = tostring(key or ""):gsub("^%s+", ""):gsub("%s+$", ""):upper()
    if key == "" then
        return false, "Saved key is empty."
    end

    local HttpService = game:GetService("HttpService")
    local payload = HttpService:JSONEncode({
        username = LocalPlayer.Name,
        key = key,
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

    if not ok or not response then
        return false, "Cannot verify saved key."
    end

    local status = tonumber(response.StatusCode or response.Status or 0) or 0
    local body = response.Body or response.body or ""
    local decodedOk, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)

    if decodedOk and type(data) == "table" then
        if data.success == true then
            return true, data.message or "Key is still active.", data
        end
        return false, data.message or "Invalid key.", data
    end

    if status >= 200 and status < 300 then
        return false, "Invalid Key System response."
    end

    return false, "Invalid key."
end

local function buildKeyWindow(parent, onSuccess)
    local winW = IS_MOBILE and 280 or 360
    local winH = IS_MOBILE and 190 or 220

    local gate = Instance.new("Frame")
    gate.Name = "KeyWindow"
    gate.AnchorPoint = Vector2.new(0.5, 0.5)
    gate.Position = UDim2.fromScale(0.5, 0.5)
    gate.Size = UDim2.fromOffset(winW, winH)
    gate.BackgroundColor3 = C.BG
    gate.BorderSizePixel = 0
    gate.ZIndex = 400
    gate.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = gate

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Stroke
    stroke.Thickness = 2
    stroke.Parent = gate

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -24, 0, 30)
    title.Position = UDim2.fromOffset(12, 10)
    title.BackgroundTransparency = 1
    title.Text = "VRILZ HUB • KEY SYSTEM"
    title.TextColor3 = C.Text
    title.Font = Enum.Font.GothamBlack
    title.TextSize = IS_MOBILE and 13 or 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 401
    title.Parent = gate

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -24, 0, 20)
    subtitle.Position = UDim2.fromOffset(12, 39)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Paste your key in here"
    subtitle.TextColor3 = C.Muted
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 11
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 401
    subtitle.Parent = gate

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -24, 0, 38)
    box.Position = UDim2.fromOffset(12, 65)
    box.BackgroundColor3 = C.Surface2
    box.BorderSizePixel = 0
    box.ClearTextOnFocus = false
    box.PlaceholderText = "Paste key in here..."
    box.PlaceholderColor3 = C.Muted
    box.Text = ""
    box.TextColor3 = C.Text
    box.Font = Enum.Font.GothamMedium
    box.TextSize = 12
    box.TextXAlignment = Enum.TextXAlignment.Left
    box.ZIndex = 401
    box.Parent = gate

    local boxCorner = Instance.new("UICorner")
    boxCorner.CornerRadius = UDim.new(0, 6)
    boxCorner.Parent = box

    local boxPad = Instance.new("UIPadding")
    boxPad.PaddingLeft = UDim.new(0, 10)
    boxPad.PaddingRight = UDim.new(0, 10)
    boxPad.Parent = box

    local boxStroke = Instance.new("UIStroke")
    boxStroke.Color = C.Stroke
    boxStroke.Transparency = 0.45
    boxStroke.Parent = box

    local function makeButton(text, x, width)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(width, 34)
        btn.Position = UDim2.fromOffset(x, 112)
        btn.BackgroundColor3 = C.Accent
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 11
        btn.AutoButtonColor = true
        btn.ZIndex = 401
        btn.Parent = gate

        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 6)
        c.Parent = btn
        return btn
    end

    local checkBtn = makeButton("CHECK KEY", 12, IS_MOBILE and 150 or 190)
    local getBtn = makeButton("GET KEY", IS_MOBILE and 168 or 210, IS_MOBILE and 100 or 138)

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -24, 0, 42)
    status.Position = UDim2.fromOffset(12, 153)
    status.BackgroundTransparency = 1
    status.Text = "Status: Waiting for key..."
    status.TextColor3 = C.Muted
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 10
    status.TextWrapped = true
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.ZIndex = 401
    status.Parent = gate

    local checking = false

    getBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            pcall(setclipboard, KEY_SYSTEM_URL)
            status.Text = "Key System link copied. Open it, create your key, then paste it here."
            status.TextColor3 = C.Muted
        else
            status.Text = "Setclipboard is unavailable. Open the Key System URL manually."
            status.TextColor3 = C.Muted
        end
    end)

    checkBtn.MouseButton1Click:Connect(function()
        if checking then return end
        checking = true
        checkBtn.Text = "CHECKING..."
        status.Text = "Status: Checking key..."
        status.TextColor3 = C.Muted

        task.spawn(function()
            local valid, message, data = verifyKeyWithServer(box.Text)
            if valid then
                local normalizedKey = tostring(box.Text):gsub("^%s+", ""):gsub("%s+$", ""):upper()
                saveKey(normalizedKey)
                applyKeyInfo(data, normalizedKey)
                status.Text = "Status: " .. message
                status.TextColor3 = C.Success
                task.wait(0.35)
                if gate and gate.Parent then
                    gate:Destroy()
                end
                onSuccess()
            else
                status.Text = "Status: " .. message
                status.TextColor3 = C.Error
                checkBtn.Text = "CHECK KEY"
                checking = false
            end
        end)
    end)

    box.FocusLost:Connect(function()
        box.Text = box.Text:gsub("%s+", "")
    end)

    return gate
end

-- ============================================================
-- LOADING SCREEN BRUTAL
-- ============================================================
local function buildLoadingScreen(parent)
    local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)

    local winW = IS_MOBILE and 280 or 360
    local winH = IS_MOBILE and 200 or 240

    local loading = Instance.new("Frame")
    loading.Name = "LoadingScreen"
    loading.AnchorPoint = Vector2.new(0.5, 0.5)
    loading.Position = UDim2.fromScale(0.5, 0.5)
    loading.Size = UDim2.fromOffset(0, 0)
    loading.BackgroundColor3 = Color3.fromRGB(5, 0, 2)
    loading.BorderSizePixel = 0
    loading.ZIndex = 300
    loading.ClipsDescendants = true
    loading.Parent = parent

    local stroke1 = Instance.new("UIStroke")
    stroke1.Color = Color3.fromRGB(255, 30, 60)
    stroke1.Thickness = 3
    stroke1.Transparency = 0
    stroke1.Parent = loading

    local stroke2 = Instance.new("UIStroke")
    stroke2.Color = Color3.fromRGB(255, 255, 255)
    stroke2.Thickness = 1
    stroke2.Transparency = 0.7
    stroke2.Parent = loading

    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 4)
    topBar.Position = UDim2.fromOffset(0, 0)
    topBar.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 310
    topBar.Parent = loading

    local botBar = Instance.new("Frame")
    botBar.Size = UDim2.new(1, 0, 0, 4)
    botBar.Position = UDim2.new(0, 0, 1, -4)
    botBar.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
    botBar.BorderSizePixel = 0
    botBar.ZIndex = 310
    botBar.Parent = loading

    local function makeBracket(posX, posY, sizeX, sizeY)
        local b = Instance.new("Frame")
        b.Size = UDim2.fromOffset(sizeX, sizeY)
        b.Position = UDim2.fromOffset(posX, posY)
        b.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
        b.BorderSizePixel = 0
        b.ZIndex = 311
        b.Parent = loading
        return b
    end

    makeBracket(6, 6, 22, 2)
    makeBracket(6, 6, 2, 22)
    makeBracket(winW - 28, 6, 22, 2)
    makeBracket(winW - 8, 6, 2, 22)
    makeBracket(6, winH - 8, 22, 2)
    makeBracket(6, winH - 28, 2, 22)
    makeBracket(winW - 28, winH - 8, 22, 2)
    makeBracket(winW - 8, winH - 28, 2, 22)

    local scanlines = Instance.new("Frame")
    scanlines.Size = UDim2.fromScale(1, 1)
    scanlines.BackgroundTransparency = 1
    scanlines.ZIndex = 320
    scanlines.ClipsDescendants = true
    scanlines.Parent = loading

    for i = 0, math.floor(winH / 4) do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1, 0, 0, 1)
        line.Position = UDim2.fromOffset(0, i * 4)
        line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        line.BackgroundTransparency = 0.65
        line.BorderSizePixel = 0
        line.ZIndex = 320
        line.Parent = scanlines
    end

    local noise = Instance.new("Frame")
    noise.Size = UDim2.fromScale(1, 1)
    noise.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    noise.BackgroundTransparency = 0.93
    noise.BorderSizePixel = 0
    noise.ZIndex = 319
    noise.Parent = loading

    local glitchBars = {}
    for i = 1, 6 do
        local bar = Instance.new("Frame")
        bar.Size = UDim2.new(1, 0, 0, math.random(2, 5))
        bar.Position = UDim2.fromScale(0, math.random())
        bar.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
        bar.BackgroundTransparency = 0.4
        bar.BorderSizePixel = 0
        bar.ZIndex = 330
        bar.Visible = false
        bar.Parent = loading
        table.insert(glitchBars, bar)
    end

    local vHolder = Instance.new("Frame")
    vHolder.Size = UDim2.fromScale(1, 0.55)
    vHolder.Position = UDim2.fromScale(0, 0.15)
    vHolder.BackgroundTransparency = 1
    vHolder.ZIndex = 305
    vHolder.Parent = loading

    local vGlow = Instance.new("TextLabel")
    vGlow.Size = UDim2.fromScale(1, 1)
    vGlow.BackgroundTransparency = 1
    vGlow.Text = "V"
    vGlow.TextColor3 = Color3.fromRGB(255, 30, 60)
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

    local lightningHolder = Instance.new("Frame")
    lightningHolder.Size = UDim2.fromScale(1, 1)
    lightningHolder.BackgroundTransparency = 1
    lightningHolder.ZIndex = 340
    lightningHolder.ClipsDescendants = true
    lightningHolder.Parent = loading

    local function createLightning()
        local bolt = Instance.new("Frame")
        bolt.BackgroundTransparency = 1
        bolt.Size = UDim2.fromScale(1, 1)
        bolt.ZIndex = 341
        bolt.Parent = lightningHolder

        local segments = 8
        local startX = winW * 0.5
        local startY = 0
        local endX = winW * 0.5
        local endY = winH * 0.5

        for i = 1, segments do
            local t1 = (i - 1) / segments
            local t2 = i / segments
            local x1 = startX + (endX - startX) * t1 + math.random(-20, 20)
            local y1 = startY + (endY - startY) * t1
            local x2 = startX + (endX - startX) * t2 + math.random(-20, 20)
            local y2 = startY + (endY - startY) * t2

            local dx = x2 - x1
            local dy = y2 - y1
            local length = math.sqrt(dx * dx + dy * dy)
            local angle = math.atan2(dy, dx)

            local seg = Instance.new("Frame")
            seg.Size = UDim2.fromOffset(length, 2)
            seg.Position = UDim2.fromOffset((x1 + x2) / 2 - length / 2, (y1 + y2) / 2 - 1)
            seg.Rotation = math.deg(angle)
            seg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            seg.BorderSizePixel = 0
            seg.ZIndex = 342
            seg.Parent = bolt

            local glowSeg = Instance.new("Frame")
            glowSeg.Size = UDim2.fromOffset(length + 4, 6)
            glowSeg.Position = UDim2.fromOffset((x1 + x2) / 2 - (length + 4) / 2, (y1 + y2) / 2 - 3)
            glowSeg.Rotation = math.deg(angle)
            glowSeg.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
            glowSeg.BackgroundTransparency = 0.5
            glowSeg.BorderSizePixel = 0
            glowSeg.ZIndex = 341
            glowSeg.Parent = bolt
        end

        TweenService:Create(bolt, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        for _, child in ipairs(bolt:GetChildren()) do
            if child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            end
        end
        task.delay(0.4, function()
            if bolt then bolt:Destroy() end
        end)
    end

    local loadingText = Instance.new("TextLabel")
    loadingText.Size = UDim2.new(1, -20, 0, 18)
    loadingText.Position = UDim2.new(0, 10, 0, winH - 68)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "LOADING..."
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.Font = Enum.Font.GothamBlack
    loadingText.TextSize = IS_MOBILE and 11 or 12
    loadingText.TextXAlignment = Enum.TextXAlignment.Left
    loadingText.ZIndex = 306
    loadingText.Parent = loading

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -20, 0, 6)
    barBg.Position = UDim2.new(0, 10, 0, winH - 44)
    barBg.BackgroundColor3 = Color3.fromRGB(30, 5, 10)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 305
    barBg.Parent = loading

    local barStroke = Instance.new("UIStroke")
    barStroke.Color = Color3.fromRGB(255, 30, 60)
    barStroke.Thickness = 1
    barStroke.Transparency = 0.3
    barStroke.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 30, 60)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 306
    barFill.Parent = barBg

    local percentLbl = Instance.new("TextLabel")
    percentLbl.Size = UDim2.new(1, -20, 0, 14)
    percentLbl.Position = UDim2.new(0, 10, 0, winH - 26)
    percentLbl.BackgroundTransparency = 1
    percentLbl.Text = "0%"
    percentLbl.TextColor3 = Color3.fromRGB(255, 30, 60)
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
    brandLbl.TextColor3 = Color3.fromRGB(150, 80, 100)
    brandLbl.Font = Enum.Font.GothamBold
    brandLbl.TextSize = 10
    brandLbl.TextXAlignment = Enum.TextXAlignment.Left
    brandLbl.ZIndex = 306
    brandLbl.Parent = loading

    task.spawn(function()
        while loading.Parent do
            task.wait(math.random(8, 25) / 100)
            for _, bar in ipairs(glitchBars) do
                if math.random() < 0.4 then
                    bar.Visible = true
                    bar.Position = UDim2.fromScale(0, math.random())
                    bar.Size = UDim2.new(1, 0, 0, math.random(2, 10))
                    task.wait(0.03)
                    bar.Visible = false
                end
            end
        end
    end)

    task.spawn(function()
        while loading.Parent do
            task.wait(math.random(6, 15) / 100)
            local offset = math.random(1, 6)
            vRed.Position = UDim2.fromOffset(-offset, 0)
            vBlue.Position = UDim2.fromOffset(offset, 0)
            task.wait(0.05)
            vRed.Position = UDim2.fromOffset(-1, 0)
            vBlue.Position = UDim2.fromOffset(1, 0)
        end
    end)

    task.spawn(function()
        while loading.Parent do
            task.wait(0.05)
            noise.BackgroundTransparency = 0.88 + math.random() * 0.08
        end
    end)

    task.spawn(function()
        while loading.Parent do
            task.wait(0.5)
            TweenService:Create(vGlow, TweenInfo.new(0.5), {TextTransparency = 0.1}):Play()
            task.wait(0.5)
            TweenService:Create(vGlow, TweenInfo.new(0.5), {TextTransparency = 0.4}):Play()
        end
    end)

    task.spawn(function()
        local startSize = 1
        local endSize = IS_MOBILE and 130 or 170
        local duration = 1.2
        local steps = 40
        for i = 1, steps do
            task.wait(duration / steps)
            local t = i / steps
            local eased = 1 - (1 - t) ^ 3
            local size = startSize + (endSize - startSize) * eased
            vLabel.TextSize = size
            vGlow.TextSize = size
            vRed.TextSize = size
            vBlue.TextSize = size
        end

        task.wait(0.2)
        for i = 1, 6 do
            vLabel.Position = UDim2.fromOffset(math.random(-6, 6), math.random(-6, 6))
            task.wait(0.04)
            vLabel.Position = UDim2.fromOffset(0, 0)
        end
    end)

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

        for i = 1, 8 do
            loading.Position = UDim2.fromScale(0.5 + math.random(-15, 15)/1000, 0.5 + math.random(-15, 15)/1000)
            task.wait(0.03)
        end
        loading.Position = UDim2.fromScale(0.5, 0.5)

        task.wait(0.6)

        TweenService:Create(loading, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.wait(0.5)

        if loading then loading:Destroy() end
        buildMainWindow(parent)
        notify("Welcome, " .. LocalPlayer.DisplayName, "success")
    end)
end

-- ============================================================
-- UI.INIT
-- ============================================================
function UI.Init(sharedState)
    Shared = sharedState
    Shared.Notify = notify

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
    Shared.AutoRidePet_Enabled = false
    Shared.AutoEquipBest_Enabled = false
    Shared.SelectedEgg = "Cherub"
    Shared.EggPrediction_Enabled = false
    Shared.EggsInMap = {}
    Shared.EggPredictions = {}

    Shared.Speed_Enabled = false
    Shared.Speed_Value = 100
    Shared.InstantPickup_Enabled = false
    Shared.AutoFarm_Enabled = false
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
    Shared.RarityNotifThreshold = "Legendary"
    Shared.VolcanicHunt_Enabled = false
    Shared.VolcanicReturn_Enabled = false
    Shared.VolcanicMutation_Enabled = false
    Shared.AutoMutation_Enabled = false
    Shared.MutationReturn_Enabled = false

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
        buildKeyWindow(ScreenGui, function()
            startLoading()
        end)
    end

    local savedKey = loadSavedKey()
    if savedKey then
        task.spawn(function()
            local valid, message, data = verifySavedKeyWithServer(savedKey)
            if valid then
                applyKeyInfo(data, savedKey)
                startLoading()
                return
            end

            -- Jika expired / tidak valid, hapus key tersimpan supaya gate muncul lagi.
            clearSavedKey()
            showKeyWindow()
        end)
    else
        showKeyWindow()
    end
end

return UI
