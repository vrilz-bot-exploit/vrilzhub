-- ============================================================
-- VRILZHUB UI — RIDE A PET v5.5 (AUTO-DETECT PC & MOBILE)
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

-- ====== UI CONFIG (PC & MOBILE BEDA) ======
local UI_CONFIG = {
    MOBILE = {
        WIN_W_PCT = 0.88,
        WIN_H_PCT = 0.78,
        SIDEBAR_W = 70,
        TAB_H = 40,
        TAB_ICON = 18,
        TAB_SHOW_LABEL = false,
        CARD_HEADER = 28,
        CARD_PAD_TOP = 8,
        CARD_PAD_BOT = 8,
        CARD_PAD_SIDE = 10,
        CARD_GAP = 6,
        TOGGLE_H = 36,
        TOGGLE_W = 48,
        TOGGLE_KNOB = 20,
        DROPDOWN_H = 40,
        DROPDOWN_ITEM = 36,
        ACTION_H = 36,
        FONT_TITLE = 13,
        FONT_LABEL = 11,
        FONT_MUTED = 9,
        FONT_SMALL = 10,
        FONT_MED = 11,
        FONT_LARGE = 14,
        HEADER_H = 40,
        SEARCH_H = 30,
        NOTIF_W = 300,
        NOTIF_H = 52,
        OPEN_BTN = 52,
    },
    PC = {
        WIN_W = 800,
        WIN_H = 580,
        SIDEBAR_W = 140,
        TAB_H = 44,
        TAB_ICON = 16,
        TAB_SHOW_LABEL = true,
        CARD_HEADER = 30,
        CARD_PAD_TOP = 10,
        CARD_PAD_BOT = 12,
        CARD_PAD_SIDE = 14,
        CARD_GAP = 8,
        TOGGLE_H = 30,
        TOGGLE_W = 46,
        TOGGLE_KNOB = 18,
        DROPDOWN_H = 34,
        DROPDOWN_ITEM = 28,
        ACTION_H = 34,
        FONT_TITLE = 12,
        FONT_LABEL = 12,
        FONT_MUTED = 10,
        FONT_SMALL = 10,
        FONT_MED = 12,
        FONT_LARGE = 15,
        HEADER_H = 52,
        SEARCH_H = 34,
        NOTIF_W = 380,
        NOTIF_H = 52,
        OPEN_BTN = 56,
    },
}

local CFG = IS_MOBILE and UI_CONFIG.MOBILE or UI_CONFIG.PC

-- ====== EGG NAMES ======
local EggNames = {
    "Cherub", "Volcanic", "Blackhole", "Solaris", "Galaxy",
    "Crystal", "Golden", "Glass", "Skull", "Sinister",
    "Soul", "Dominus", "Slime", "Flower", "Leaf",
    "Stone", "Easter", "Cracked", "Ice", "Tidal",
    "Bloom", "Aurora", "White", "Brown"
}

-- ====== RARITY LIST ======
local RarityList = {
    "Common", "Uncommon", "Rare", "Epic",
    "Legendary", "Mythic", "Divine", "Ethereal", "Secret"
}
local RarityColors = {
    Common = Color3.fromRGB(180, 180, 180),
    Uncommon = Color3.fromRGB(80, 200, 80),
    Rare = Color3.fromRGB(80, 150, 255),
    Epic = Color3.fromRGB(180, 80, 255),
    Legendary = Color3.fromRGB(255, 200, 50),
    Mythic = Color3.fromRGB(255, 80, 80),
    Divine = Color3.fromRGB(255, 255, 150),
    Ethereal = Color3.fromRGB(150, 255, 255),
    Secret = Color3.fromRGB(200, 200, 200),
}

-- ====== THEME ======
local Themes = {
    Brutal = {
        BG = Color3.fromRGB(15, 5, 10),
        Surface = Color3.fromRGB(25, 10, 20),
        Surface2 = Color3.fromRGB(35, 15, 25),
        Surface3 = Color3.fromRGB(45, 20, 35),
        Stroke = Color3.fromRGB(255, 50, 80),
        Text = Color3.fromRGB(255, 240, 245),
        Muted = Color3.fromRGB(200, 150, 180),
        Accent = Color3.fromRGB(255, 50, 80),
        Accent2 = Color3.fromRGB(50, 150, 255),
        Accent3 = Color3.fromRGB(150, 220, 255),
        Success = Color3.fromRGB(50, 255, 150),
        Error = Color3.fromRGB(255, 50, 80),
    },
    Ice = {
        BG = Color3.fromRGB(5, 10, 20),
        Surface = Color3.fromRGB(10, 20, 35),
        Surface2 = Color3.fromRGB(15, 30, 50),
        Surface3 = Color3.fromRGB(20, 40, 65),
        Stroke = Color3.fromRGB(150, 220, 255),
        Text = Color3.fromRGB(240, 250, 255),
        Muted = Color3.fromRGB(150, 200, 240),
        Accent = Color3.fromRGB(50, 150, 255),
        Accent2 = Color3.fromRGB(150, 220, 255),
        Accent3 = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(50, 255, 150),
        Error = Color3.fromRGB(255, 50, 80),
    },
    Fire = {
        BG = Color3.fromRGB(20, 5, 0),
        Surface = Color3.fromRGB(35, 10, 5),
        Surface2 = Color3.fromRGB(50, 15, 5),
        Surface3 = Color3.fromRGB(65, 20, 10),
        Stroke = Color3.fromRGB(255, 100, 50),
        Text = Color3.fromRGB(255, 240, 230),
        Muted = Color3.fromRGB(220, 170, 150),
        Accent = Color3.fromRGB(255, 100, 50),
        Accent2 = Color3.fromRGB(255, 200, 50),
        Accent3 = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(50, 255, 150),
        Error = Color3.fromRGB(255, 50, 80),
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

-- ====== CARD ======
local function makeCard(parent, title, layoutOrder)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = C.Surface
    card.BorderSizePixel = 0
    card.ClipsDescendants = false
    card.LayoutOrder = layoutOrder or 1
    card.ZIndex = 1
    card.Parent = parent
    registerTheme(card, "Surface", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = card
    registerTheme(stroke, "Accent", "Color")

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, CFG.CARD_HEADER)
    headerFrame.BackgroundColor3 = C.Surface2
    headerFrame.BorderSizePixel = 0
    headerFrame.ZIndex = 2
    headerFrame.Parent = card
    registerTheme(headerFrame, "Surface2", "BackgroundColor3")

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = headerFrame

    local dot = Instance.new("Frame")
    dot.Size = UDim2.fromOffset(6, 6)
    dot.Position = UDim2.new(0, 12, 0.5, -3)
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
    btn.Size = UDim2.fromOffset(CFG.TOGGLE_W, IS_MOBILE and 26 or 24)
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

-- ====== DROPDOWN GLOBAL (PAKAI _G) ======
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
    local selectedValue = default or items[1] or "Pilih..."

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
    selectedLbl.Text = selectedValue
    selectedLbl.TextColor3 = C.Text
    selectedLbl.Font = Enum.Font.GothamSemibold
    selectedLbl.TextSize = CFG.FONT_LABEL
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
    selectedLbl.ZIndex = 4
    selectedLbl.Parent = container
    registerTheme(selectedLbl, "Text", "TextColor3")

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.fromOffset(30, CFG.DROPDOWN_H)
    arrow.Position = UDim2.new(1, -34, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = C.Accent
    arrow.TextSize = 10
    arrow.ZIndex = 4
    arrow.Parent = container
    registerTheme(arrow, "Accent", "TextColor3")

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.fromOffset(200, 0)
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

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = C.Accent
    listStroke.Transparency = 0.2
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    registerTheme(listStroke, "Accent", "Color")

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
    local maxH = math.min(#items * (itemHeight + 2) + 10, IS_MOBILE and 220 or 180)

    local function closeList()
        isOpen = false
        arrow.Text = "▼"
        local w = listFrame.Size.X.Offset
        TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.fromOffset(w, 0)}):Play()
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
        arrow.Text = "▲"

        local width = container.AbsoluteSize.X
        listFrame.Size = UDim2.fromOffset(width, 0)

        local containerAbsY = container.AbsolutePosition.Y
        local containerAbsH = container.AbsoluteSize.Y
        local screenH = workspace.CurrentCamera.ViewportSize.Y
        local spaceBelow = screenH - (containerAbsY + containerAbsH + 10)
        local spaceAbove = containerAbsY

        if spaceBelow >= maxH or spaceBelow >= spaceAbove then
            listFrame.Position = UDim2.fromOffset(container.AbsolutePosition.X, containerAbsY + containerAbsH + 4)
        else
            listFrame.Position = UDim2.fromOffset(container.AbsolutePosition.X, containerAbsY - maxH - 4)
        end

        TweenService:Create(listFrame, TweenInfo.new(0.2), {
            Size = UDim2.fromOffset(width, maxH)
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
        opt.Size = UDim2.new(1, 0, 0, itemHeight)
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
        optCorner.CornerRadius = UDim.new(0, 5)
        optCorner.Parent = opt

        if item == selectedValue then
            opt.BackgroundColor3 = C.Accent
        end

        opt.MouseButton1Click:Connect(function()
            selectedValue = item
            selectedLbl.Text = item
            closeList()
            if onSelect then onSelect(item) end
        end)
    end

    return container
end

-- ====== DROPDOWN MULTI-SELECT (BUAT RARITY) ======
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

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.fromOffset(30, CFG.DROPDOWN_H)
    arrow.Position = UDim2.new(1, -34, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = C.Accent
    arrow.TextSize = 10
    arrow.ZIndex = 4
    arrow.Parent = container
    registerTheme(arrow, "Accent", "TextColor3")

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.fromOffset(200, 0)
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

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = C.Accent
    listStroke.Transparency = 0.2
    listStroke.Thickness = 2
    listStroke.Parent = listFrame
    registerTheme(listStroke, "Accent", "Color")

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
    local maxH = math.min(#items * (itemHeight + 2) + 10, IS_MOBILE and 220 or 180)

    local function updateLabel()
        local selected = {}
        for _, r in ipairs(items) do
            if sharedTable[r] then table.insert(selected, r) end
        end
        if #selected == 0 then
            selectedLbl.Text = "Pilih Rarity..."
        elseif #selected <= 2 then
            selectedLbl.Text = table.concat(selected, ", ")
        else
            selectedLbl.Text = #selected .. " rarity dipilih"
        end
    end

    local function closeList()
        isOpen = false
        arrow.Text = "▼"
        local w = listFrame.Size.X.Offset
        TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.fromOffset(w, 0)}):Play()
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
        arrow.Text = "▲"

        local width = container.AbsoluteSize.X
        listFrame.Size = UDim2.fromOffset(width, 0)

        local containerAbsY = container.AbsolutePosition.Y
        local containerAbsH = container.AbsoluteSize.Y
        local screenH = workspace.CurrentCamera.ViewportSize.Y
        local spaceBelow = screenH - (containerAbsY + containerAbsH + 10)
        local spaceAbove = containerAbsY

        if spaceBelow >= maxH or spaceBelow >= spaceAbove then
            listFrame.Position = UDim2.fromOffset(container.AbsolutePosition.X, containerAbsY + containerAbsH + 4)
        else
            listFrame.Position = UDim2.fromOffset(container.AbsolutePosition.X, containerAbsY - maxH - 4)
        end

        TweenService:Create(listFrame, TweenInfo.new(0.2), {
            Size = UDim2.fromOffset(width, maxH)
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
        opt.Size = UDim2.new(1, 0, 0, itemHeight)
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
        chk.TextColor3 = (itemColors and itemColors[item]) or C.Accent
        chk.Font = Enum.Font.GothamBold
        chk.TextSize = 14
        chk.ZIndex = 2003
        chk.Parent = opt

        local txt = Instance.new("TextLabel")
        txt.Size = UDim2.new(1, -40, 1, 0)
        txt.Position = UDim2.fromOffset(36, 0)
        txt.BackgroundTransparency = 1
        txt.Text = item
        txt.TextColor3 = (itemColors and itemColors[item]) or C.Text
        txt.Font = Enum.Font.GothamBold
        txt.TextSize = CFG.FONT_LABEL
        txt.TextXAlignment = Enum.TextXAlignment.Left
        txt.ZIndex = 2003
        txt.Parent = opt

        if sharedTable[item] then
            opt.BackgroundColor3 = (itemColors and itemColors[item]) or C.Accent
            txt.TextColor3 = Color3.new(1, 1, 1)
        end

        opt.MouseButton1Click:Connect(function()
            sharedTable[item] = not sharedTable[item]
            local on = sharedTable[item]
            chk.Text = on and "✓" or "○"
            opt.BackgroundColor3 = on and ((itemColors and itemColors[item]) or C.Accent) or C.Surface3
            txt.TextColor3 = on and Color3.new(1, 1, 1) or ((itemColors and itemColors[item]) or C.Text)
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
-- BUILD MAIN WINDOW (AUTO-DETECT PC & MOBILE)
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

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = main

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0.4
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
    headerCorner.CornerRadius = UDim.new(0, 14)
    headerCorner.Parent = header

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
    logo.Text = "⚡"
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
    subtitle.Text = "Ride a Pet · v5.5"
    subtitle.TextColor3 = C.Muted
    subtitle.Font = Enum.Font.GothamSemibold
    subtitle.TextSize = IS_MOBILE and 9 or 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 11
    subtitle.Parent = header
    registerTheme(subtitle, "Muted", "TextColor3")

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(IS_MOBILE and 28 or 32, IS_MOBILE and 28 or 32)
    minBtn.Position = UDim2.new(1, -(IS_MOBILE and 66 or 78), 0.5, -(IS_MOBILE and 14 or 16))
    minBtn.BackgroundColor3 = C.Surface3
    minBtn.Text = "−"
    minBtn.TextColor3 = C.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = IS_MOBILE and 18 or 20
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 11
    minBtn.Parent = header
    registerTheme(minBtn, "Surface3", "BackgroundColor3")
    registerTheme(minBtn, "Text", "TextColor3")

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = minBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(IS_MOBILE and 28 or 32, IS_MOBILE and 28 or 32)
    closeBtn.Position = UDim2.new(1, -(IS_MOBILE and 34 or 40), 0.5, -(IS_MOBILE and 14 or 16))
    closeBtn.BackgroundColor3 = C.Surface3
    closeBtn.Text = "×"
    closeBtn.TextColor3 = C.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = IS_MOBILE and 20 or 22
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 11
    closeBtn.Parent = header
    registerTheme(closeBtn, "Surface3", "BackgroundColor3")
    registerTheme(closeBtn, "Text", "TextColor3")

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    -- BODY
    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -20, 1, -(CFG.HEADER_H + 20))
    body.Position = UDim2.new(0, 10, 0, CFG.HEADER_H + 10)
    body.BackgroundTransparency = 1
    body.ZIndex = 2
    body.Parent = main

    local sidebarW = CFG.SIDEBAR_W
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, sidebarW, 1, 0)
    sidebar.BackgroundColor3 = C.Surface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 3
    sidebar.Parent = body
    registerTheme(sidebar, "Surface", "BackgroundColor3")

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 10)
    sidebarCorner.Parent = sidebar

    local sidebarStroke = Instance.new("UIStroke")
    sidebarStroke.Color = C.Accent
    sidebarStroke.Thickness = 1
    sidebarStroke.Transparency = 0.7
    sidebarStroke.Parent = sidebar
    registerTheme(sidebarStroke, "Accent", "Color")

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 4)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebar

    local sidebarPad = Instance.new("UIPadding")
    sidebarPad.PaddingTop = UDim.new(0, IS_MOBILE and 6 or 10)
    sidebarPad.PaddingBottom = UDim.new(0, IS_MOBILE and 6 or 10)
    sidebarPad.PaddingLeft = UDim.new(0, 6)
    sidebarPad.PaddingRight = UDim.new(0, 6)
    sidebarPad.Parent = sidebar

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

    -- RESIZE HANDLE (PC only)
    if not IS_MOBILE then
        local resizeHandle = Instance.new("TextButton")
        resizeHandle.Size = UDim2.fromOffset(22, 22)
        resizeHandle.Position = UDim2.new(1, -24, 1, -24)
        resizeHandle.BackgroundTransparency = 1
        resizeHandle.Text = "◢"
        resizeHandle.TextColor3 = C.Accent
        resizeHandle.TextSize = 14
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
    openBtn.Text = "⚡"
    openBtn.TextColor3 = C.Accent
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = IS_MOBILE and 24 or 28
    openBtn.BorderSizePixel = 0
    openBtn.Visible = false
    openBtn.ZIndex = 400
    openBtn.Parent = screenGui
    registerTheme(openBtn, "Surface", "BackgroundColor3")
    registerTheme(openBtn, "Accent", "TextColor3")

    local openCorner = Instance.new("UICorner")
    openCorner.CornerRadius = UDim.new(1, 0)
    openCorner.Parent = openBtn

    local openStroke = Instance.new("UIStroke")
    openStroke.Color = C.Accent
    openStroke.Thickness = 2
    openStroke.Transparency = 0.3
    openStroke.Parent = openBtn

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
        btn.ZIndex = 4
        btn.Parent = sidebar
        registerTheme(btn, "Surface3", "BackgroundColor3")

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

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
        ic.ZIndex = 5
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
            lbl.ZIndex = 5
            lbl.Parent = btn
            registerTheme(lbl, "Muted", "TextColor3")
            navs[id] = {btn = btn, ic = ic, lbl = lbl}
        else
            navs[id] = {btn = btn, ic = ic, lbl = nil}
        end

        local function switchTo()
            for n, p in pairs(pages) do
                if p then p.Visible = (n == id) end
            end
            for n, x in pairs(navs) do
                if n == id then
                    x.btn.BackgroundColor3 = C.Accent
                    x.btn.BackgroundTransparency = 0
                    x.ic.TextColor3 = Color3.new(1, 1, 1)
                    if x.lbl then x.lbl.TextColor3 = Color3.new(1, 1, 1) end
                else
                    x.btn.BackgroundColor3 = C.Surface3
                    x.btn.BackgroundTransparency = 0.5
                    x.ic.TextColor3 = C.Accent
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
        page.ZIndex = 6
        page.Parent = pageHolder
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, IS_MOBILE and 8 or 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page
        return page
    end

    -- ========================================================
    -- TAB INFO
    -- ========================================================
    local infoPage = createPage("Info")
    pages.Info = infoPage

    local infoCard, infoContent = makeCard(infoPage, "INFORMASI CLIENT", 1)

    local avRow = Instance.new("Frame")
    avRow.Size = UDim2.new(1, 0, 0, IS_MOBILE and 60 or 70)
    avRow.BackgroundTransparency = 1
    avRow.LayoutOrder = 1
    avRow.Parent = infoContent

    local avSz = IS_MOBILE and 50 or 60
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
    avStroke.Thickness = 2
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
    sessionLbl.Text = "Sesi: 00:00"
    sessionLbl.TextColor3 = C.Accent2
    sessionLbl.Font = Enum.Font.GothamBold
    sessionLbl.TextSize = CFG.FONT_LABEL
    sessionLbl.TextXAlignment = Enum.TextXAlignment.Left
    sessionLbl.LayoutOrder = 2
    sessionLbl.ZIndex = 3
    sessionLbl.Parent = infoContent
    registerTheme(sessionLbl, "Accent2", "TextColor3")

    local sessionStart = os.clock()
    task.spawn(function()
        while sessionLbl.Parent do
            task.wait(1)
            local elapsed = math.floor(os.clock() - sessionStart)
            local m = math.floor(elapsed / 60)
            local s = elapsed % 60
            sessionLbl.Text = string.format("Sesi: %02d:%02d", m, s)
        end
    end)

    registerTab("Info", "ℹ", "Info")

    -- ========================================================
    -- TAB PREDIKSI
    -- ========================================================
    local predPage = createPage("Prediksi")
    pages.Prediksi = predPage

    local eggInMapCard, eggInMapContent = makeCard(predPage, "EGG SPAWN DI MAP", 1)

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

    local eggPredCard, eggPredContent = makeCard(predPage, "PREDIKSI EGG BERIKUTNYA", 2)

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
                    lbl.Text = "   Nggak ada egg di map"
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
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 0, IS_MOBILE and 26 or 28)
                        lbl.BackgroundColor3 = C.Surface3
                        lbl.BackgroundTransparency = 0.3
                        lbl.Text = "   🥚  " .. eggName
                        lbl.TextColor3 = C.Text
                        lbl.Font = Enum.Font.GothamSemibold
                        lbl.TextSize = CFG.FONT_LABEL
                        lbl.TextXAlignment = Enum.TextXAlignment.Left
                        lbl.LayoutOrder = i
                        lbl.ZIndex = 4
                        lbl.Parent = eggInMapList
                        local c = Instance.new("UICorner")
                        c.CornerRadius = UDim.new(0, 5)
                        c.Parent = lbl

                        local s = Instance.new("UIStroke")
                        s.Color = C.Success
                        s.Thickness = 1
                        s.Transparency = 0.5
                        s.Parent = lbl
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
                    lbl.Text = "   Menunggu data..."
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
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 0, IS_MOBILE and 26 or 28)
                        lbl.BackgroundColor3 = C.Surface3
                        lbl.BackgroundTransparency = 0.3
                        lbl.Text = "   🎯  " .. eggName
                        lbl.TextColor3 = C.Text
                        lbl.Font = Enum.Font.GothamSemibold
                        lbl.TextSize = CFG.FONT_LABEL
                        lbl.TextXAlignment = Enum.TextXAlignment.Left
                        lbl.LayoutOrder = i
                        lbl.ZIndex = 4
                        lbl.Parent = eggPredList
                        local c = Instance.new("UICorner")
                        c.CornerRadius = UDim.new(0, 5)
                        c.Parent = lbl

                        local s = Instance.new("UIStroke")
                        s.Color = C.Accent3
                        s.Thickness = 1
                        s.Transparency = 0.5
                        s.Parent = lbl
                    end
                end
            end
        end
    end)

    registerTab("Prediksi", "◎", "Prediksi")

    -- ========================================================
    -- TAB EGG
    -- ========================================================
    local eggPage = createPage("Egg")
    pages.Egg = eggPage

    local eggEspCard, eggEspContent = makeCard(eggPage, "EGG ESP", 1)
    makeToggle(eggEspContent, "Aktifkan Egg ESP", false, function(v) Shared.ESP_Eggs_Enabled = v end)
    makeToggle(eggEspContent, "Tampilkan Nama", true, function(v) Shared.ESP_EggName_Enabled = v end)
    makeToggle(eggEspContent, "Tampilkan Luck", true, function(v) Shared.ESP_EggLuck_Enabled = v end)

    local autoStealCard, autoStealContent = makeCard(eggPage, "AUTO STEAL", 2)
    makeToggle(autoStealContent, "Aktifkan Auto Steal", false, function(v) Shared.AutoSteal_Enabled = v end)
    makeToggle(autoStealContent, "Auto Return ke Plot", true, function(v) Shared.AutoReturn_Enabled = v end)
    makeToggle(autoStealContent, "Auto Hatch", false, function(v) Shared.AutoHatch_Enabled = v end)

    local eggNameLbl = Instance.new("TextLabel")
    eggNameLbl.Size = UDim2.new(1, 0, 0, 16)
    eggNameLbl.BackgroundTransparency = 1
    eggNameLbl.Text = "Pilih Egg:"
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

    -- ========================================================
    -- TAB VISUAL
    -- ========================================================
    local visualPage = createPage("Visual")
    pages.Visual = visualPage

    local pEspCard, pEspContent = makeCard(visualPage, "PLAYER ESP", 1)
    makeToggle(pEspContent, "Player ESP", false, function(v) Shared.ESP_Players_Enabled = v end)
    makeToggle(pEspContent, "Player Chams", true, function(v) Shared.ESP_PlayerChams_Enabled = v end)
    makeToggle(pEspContent, "Player Studs", true, function(v) Shared.ESP_PlayerStuds_Enabled = v end)

    local petEspCard, petEspContent = makeCard(visualPage, "PET ESP", 2)
    makeToggle(petEspContent, "Pet ESP", false, function(v) Shared.ESP_Pets_Enabled = v end)
    makeToggle(petEspContent, "Tampilkan Nama", true, function(v) Shared.ESP_PetName_Enabled = v end)
    makeToggle(petEspContent, "Tampilkan Cash", true, function(v) Shared.ESP_PetCash_Enabled = v end)
    makeToggle(petEspContent, "Tampilkan Speed", true, function(v) Shared.ESP_PetSpeed_Enabled = v end)

    registerTab("Visual", "◆", "Visual")

    -- ========================================================
    -- TAB AUTO — SPEED + AUTO FARM
    -- ========================================================
    local autoPage = createPage("Auto")
    pages.Auto = autoPage

    -- ==== SPEED ====
    local speedCard, speedContent = makeCard(autoPage, "SPEED", 1)
    makeToggle(speedContent, "Aktifkan Speed", false, function(v) Shared.Speed_Enabled = v end)

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

    -- ==== AUTO FARM ====
    local farmCard, farmContent = makeCard(autoPage, "AUTO FARM", 2)
    makeToggle(farmContent, "Aktifkan Auto Farm", false, function(v) Shared.AutoFarm_Enabled = v end)
    makeToggle(farmContent, "Auto Return ke Plot", true, function(v) Shared.AutoReturn_Enabled = v end)

    -- ==== RARITY DROPDOWN MULTI ====
    local rarTitle = Instance.new("TextLabel")
    rarTitle.Size = UDim2.new(1, 0, 0, 16)
    rarTitle.BackgroundTransparency = 1
    rarTitle.Text = "Pilih Rarity Egg:"
    rarTitle.TextColor3 = C.Muted
    rarTitle.Font = Enum.Font.GothamSemibold
    rarTitle.TextSize = CFG.FONT_MUTED
    rarTitle.TextXAlignment = Enum.TextXAlignment.Left
    rarTitle.LayoutOrder = 3
    rarTitle.Parent = farmContent

    makeDropdownMulti(farmContent, RarityList, Shared.SelectedRarities, RarityColors, function(t)
        -- callback kalau perlu
    end)

    -- ==== NOTIF THRESHOLD ====
    local notifTitle = Instance.new("TextLabel")
    notifTitle.Size = UDim2.new(1, 0, 0, 16)
    notifTitle.BackgroundTransparency = 1
    notifTitle.Text = "Notif cuma buat rarity:"
    notifTitle.TextColor3 = C.Muted
    notifTitle.Font = Enum.Font.GothamSemibold
    notifTitle.TextSize = CFG.FONT_MUTED
    notifTitle.TextXAlignment = Enum.TextXAlignment.Left
    notifTitle.LayoutOrder = 20
    notifTitle.Parent = farmContent

    makeDropdownGlobal(farmContent, RarityList, "Legendary", function(v)
        Shared.RarityNotifThreshold = v
    end)

    -- ==== AUTO LAINNYA ====
    local autoCard, autoContent = makeCard(autoPage, "AUTO LAINNYA", 3)
    makeToggle(autoContent, "Auto Ride Pet", false, function(v) Shared.AutoRidePet_Enabled = v end)
    makeToggle(autoContent, "Auto Equip Best", false, function(v) Shared.AutoEquipBest_Enabled = v end)

    registerTab("Auto", "▶", "Auto")

    -- ========================================================
    -- TAB SETTINGS
    -- ========================================================
    local setPage = createPage("Settings")
    pages.Settings = setPage

    local themeCard, themeContent = makeCard(setPage, "TEMA", 1)

    local themeLbl = Instance.new("TextLabel")
    themeLbl.Size = UDim2.new(1, 0, 0, 16)
    themeLbl.BackgroundTransparency = 1
    themeLbl.Text = "Pilih Tema:"
    themeLbl.TextColor3 = C.Muted
    themeLbl.Font = Enum.Font.GothamSemibold
    themeLbl.TextSize = CFG.FONT_MUTED
    themeLbl.TextXAlignment = Enum.TextXAlignment.Left
    themeLbl.ZIndex = 3
    themeLbl.Parent = themeContent

    local themeList = {"Brutal", "Ice", "Fire"}
    makeDropdownGlobal(themeContent, themeList, CurrentTheme, function(v)
        applyTheme(v)
        notify("Tema: " .. v, "success")
    end)

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
                notify("FPS Boost: " .. #hidden .. " part disembunyiin", "info")
            end)
            notify("FPS Boost aktif", "success")
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
            notify("FPS Boost nonaktif", "info")
        end
    end, "FPS Boost")

    makeToggle(fpsContent, "FPS Window", false, function(v)
        if fpsWin then fpsWin.Visible = v end
    end, "FPS Window")

    registerTab("Settings", "⚙", "Settings")

    pages.Info.Visible = true
    navs.Info.btn.BackgroundColor3 = C.Accent
    navs.Info.btn.BackgroundTransparency = 0
    navs.Info.ic.TextColor3 = Color3.new(1, 1, 1)
    if navs.Info.lbl then navs.Info.lbl.TextColor3 = Color3.new(1, 1, 1) end

    -- Drag header
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
-- UI.INIT
-- ============================================================
function UI.Init(sharedState)
    Shared = sharedState

    Shared.Notify = notify

    Shared.ESP_Eggs_Enabled = false
    Shared.ESP_EggName_Enabled = true
    Shared.ESP_EggLuck_Enabled = true
    Shared.ESP_Pets_Enabled = false
    Shared.ESP_PetName_Enabled = true
    Shared.ESP_PetCash_Enabled = true
    Shared.ESP_PetSpeed_Enabled = true
    Shared.AutoSteal_Enabled = false
    Shared.AutoReturn_Enabled = true
    Shared.AutoHatch_Enabled = false
    Shared.AutoRidePet_Enabled = false
    Shared.AutoEquipBest_Enabled = false
    Shared.SelectedEgg = "Cherub"
    Shared.EggPrediction_Enabled = true
    Shared.EggsInMap = {}
    Shared.EggPredictions = {}

    -- SPEED
    Shared.Speed_Enabled = false
    Shared.Speed_Value = 100

    -- AUTO FARM
    Shared.AutoFarm_Enabled = false
    Shared.SelectedRarities = {
        ["Legendary"] = true,
        ["Mythic"] = true,
        ["Divine"] = true,
        ["Ethereal"] = true,
        ["Secret"] = true,
    }
    Shared.RarityNotifThreshold = "Legendary"

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRILZHUB_RideAPet"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    setupNotifHolder(ScreenGui)
    setupDropdownLayer(ScreenGui)

    local loading = Instance.new("Frame")
    loading.Size = UDim2.fromOffset(IS_MOBILE and 340 or 400, IS_MOBILE and 220 or 240)
    loading.AnchorPoint = Vector2.new(0.5, 0.5)
    loading.Position = UDim2.fromScale(0.5, 0.5)
    loading.BackgroundColor3 = C.Surface
    loading.BorderSizePixel = 0
    loading.ZIndex = 200
    loading.Parent = ScreenGui
    registerTheme(loading, "Surface", "BackgroundColor3")

    local lc = Instance.new("UICorner"); lc.CornerRadius = UDim.new(0, 14); lc.Parent = loading
    local ls = Instance.new("UIStroke"); ls.Color = C.Accent; ls.Thickness = 2; ls.Transparency = 0.3; ls.Parent = loading

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 20, 0, 16)
    title.BackgroundTransparency = 1
    title.Text = "⚡ VRILZHUB"
    title.TextColor3 = C.Accent
    title.Font = Enum.Font.GothamBold
    title.TextSize = IS_MOBILE and 18 or 20
    title.ZIndex = 201
    title.Parent = loading
    registerTheme(title, "Accent", "TextColor3")

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -40, 0, 16)
    subtitle.Position = UDim2.new(0, 20, 0, 46)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Ride a Pet · Loading..."
    subtitle.TextColor3 = C.Muted
    subtitle.Font = Enum.Font.GothamSemibold
    subtitle.TextSize = IS_MOBILE and 10 or 11
    subtitle.ZIndex = 201
    subtitle.Parent = loading
    registerTheme(subtitle, "Muted", "TextColor3")

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -40, 0, 6)
    barBg.Position = UDim2.new(0, 20, 0, IS_MOBILE and 72 or 80)
    barBg.BackgroundColor3 = C.Surface3
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 201
    barBg.Parent = loading
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 3); bc.Parent = barBg

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = C.Accent
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 202
    barFill.Parent = barBg
    local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 3); fc.Parent = barFill
    registerTheme(barFill, "Accent", "BackgroundColor3")

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Size = UDim2.new(1, -40, 0, 16)
    statusLbl.Position = UDim2.new(0, 20, 0, IS_MOBILE and 92 or 100)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "0%"
    statusLbl.TextColor3 = C.Accent
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextSize = IS_MOBILE and 11 or 12
    statusLbl.TextXAlignment = Enum.TextXAlignment.Right
    statusLbl.ZIndex = 201
    statusLbl.Parent = loading
    registerTheme(statusLbl, "Accent", "TextColor3")

    task.spawn(function()
        local start = os.clock()
        while loading.Parent do
            local p = math.clamp((os.clock() - start) / 3, 0, 1)
            barFill.Size = UDim2.new(p, 0, 1, 0)
            statusLbl.Text = math.floor(p * 100) .. "%"
            if p >= 1 then break end
            task.wait(0.05)
        end
        task.wait(0.3)
        if loading then loading:Destroy() end
        buildMainWindow(ScreenGui)
        notify("Welcome, " .. LocalPlayer.DisplayName, "success")
    end)
end

return UI
