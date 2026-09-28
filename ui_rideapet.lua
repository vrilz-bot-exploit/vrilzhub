-- ============================================================
-- VRILZHUB UI — RIDE A PET v4.0
-- Fix: Layout presisi, window resizeable, card auto-size
-- ============================================================

local UI = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- EGG NAMES
-- ============================================================
local EggNames = {
    "Cherub", "Volcanic", "Blackhole", "Solaris", "Galaxy",
    "Crystal", "Golden", "Glass", "Skull", "Sinister",
    "Soul", "Dominus", "Slime", "Flower", "Leaf",
    "Stone", "Easter", "Cracked", "Ice", "Tidal",
    "Bloom", "Aurora", "White", "Brown"
}

-- ============================================================
-- BRUTAL THEME
-- ============================================================
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
        Glow = Color3.fromRGB(255, 100, 150),
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
        Glow = Color3.fromRGB(200, 240, 255),
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
        Glow = Color3.fromRGB(255, 150, 80),
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
-- NOTIFICATION
-- ============================================================
local NotifHolder = nil

local function setupNotifHolder(parent)
    NotifHolder = Instance.new("Frame")
    NotifHolder.Name = "NotifHolder"
    NotifHolder.AnchorPoint = Vector2.new(0.5, 0)
    NotifHolder.Position = UDim2.new(0.5, 0, 0, 20)
    NotifHolder.Size = UDim2.fromOffset(400, 300)
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
    if type == "success" then color = C.Success; icon = "✅"
    elseif type == "error" then color = C.Error; icon = "❌"
    elseif type == "warning" then color = Color3.fromRGB(255, 200, 50); icon = "⚠️"
    elseif type == "predict" then color = C.Accent3; icon = "🎯"
    else color = C.Accent; icon = "ℹ️" end

    local notif = Instance.new("Frame")
    notif.Size = UDim2.fromOffset(360, 56)
    notif.BackgroundColor3 = C.Surface
    notif.BackgroundTransparency = 0.05
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
    stroke.Transparency = 0.2
    stroke.Parent = notif

    local iconLbl = Instance.new("TextLabel")
    iconLbl.Size = UDim2.fromOffset(40, 56)
    iconLbl.Position = UDim2.fromOffset(6, 0)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Text = icon
    iconLbl.TextSize = 20
    iconLbl.Font = Enum.Font.GothamBold
    iconLbl.ZIndex = 502
    iconLbl.Parent = notif

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -56, 1, 0)
    label.Position = UDim2.fromOffset(50, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.Text
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    label.ZIndex = 502
    label.Parent = notif
    registerTheme(label, "Text", "TextColor3")

    notif.Position = UDim2.fromOffset(0, -80)
    notif.BackgroundTransparency = 1
    TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 0.05
    }):Play()

    task.delay(3, function()
        if notif and notif.Parent then
            TweenService:Create(notif, TweenInfo.new(0.3), {
                Position = UDim2.fromOffset(0, -80),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.35)
            if notif then notif:Destroy() end
        end
    end)
end

-- ============================================================
-- WIDGET FACTORY (CARD AUTO-SIZE)
-- ============================================================
local function makeCard(parent, title)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y
    card.BackgroundColor3 = C.Surface
    card.BorderSizePixel = 0
    card.ClipsDescendants = false
    card.ZIndex = 1
    card.Parent = parent
    registerTheme(card, "Surface", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 2
    stroke.Transparency = 0.3
    stroke.Parent = card
    registerTheme(stroke, "Accent", "Color")

    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Surface),
        ColorSequenceKeypoint.new(1, C.Surface2)
    })
    grad.Rotation = 45
    grad.Parent = card

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 12)
    padding.PaddingBottom = UDim.new(0, 12)
    padding.PaddingLeft = UDim.new(0, 14)
    padding.PaddingRight = UDim.new(0, 14)
    padding.Parent = card

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 22)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = C.Accent
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.ZIndex = 2
    titleLabel.Parent = card
    registerTheme(titleLabel, "Accent", "TextColor3")

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, 0, 0, 0)
    content.Position = UDim2.new(0, 0, 0, 28)
    content.AutomaticSize = Enum.AutomaticSize.Y
    content.BackgroundTransparency = 1
    content.ZIndex = 2
    content.Parent = card

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content

    return card, content
end

local function makeToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 28)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 3
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = C.Text
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = frame
    registerTheme(label, "Text", "TextColor3")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(44, 24)
    btn.Position = UDim2.new(1, -44, 0.5, -12)
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
    knob.Size = UDim2.fromOffset(18, 18)
    knob.Position = default and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
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
            Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        }):Play()
        if callback then callback(state) end
    end)
end

local function makeTextBox(parent, label, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 44)
    frame.BackgroundTransparency = 1
    frame.ZIndex = 3
    frame.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 16)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = C.Muted
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 4
    lbl.Parent = frame
    registerTheme(lbl, "Muted", "TextColor3")

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, 0, 0, 24)
    box.Position = UDim2.new(0, 0, 0, 18)
    box.BackgroundColor3 = C.Surface2
    box.TextColor3 = C.Text
    box.PlaceholderText = placeholder or ""
    box.PlaceholderColor3 = C.Muted
    box.Font = Enum.Font.Gotham
    box.TextSize = 12
    box.Text = ""
    box.BorderSizePixel = 0
    box.ZIndex = 4
    box.Parent = frame
    registerTheme(box, "Surface2", "BackgroundColor3")
    registerTheme(box, "Text", "TextColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = box

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = box

    box.FocusLost:Connect(function()
        if callback then callback(box.Text) end
    end)
end

-- ============================================================
-- DROPDOWN (AUTO DETECT SPACE)
-- ============================================================
local function makeDropdown(parent, items, default, onSelect)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 34)
    container.BackgroundColor3 = C.Surface3
    container.BorderSizePixel = 0
    container.ClipsDescendants = false
    container.ZIndex = 999
    container.Parent = parent
    registerTheme(container, "Surface3", "BackgroundColor3")

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = C.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = container

    local selectedLbl = Instance.new("TextLabel")
    selectedLbl.Size = UDim2.new(1, -36, 1, 0)
    selectedLbl.Position = UDim2.fromOffset(10, 0)
    selectedLbl.BackgroundTransparency = 1
    selectedLbl.Text = default or items[1] or "Pilih..."
    selectedLbl.TextColor3 = C.Text
    selectedLbl.Font = Enum.Font.GothamSemibold
    selectedLbl.TextSize = 12
    selectedLbl.TextXAlignment = Enum.TextXAlignment.Left
    selectedLbl.ZIndex = 1000
    selectedLbl.Parent = container
    registerTheme(selectedLbl, "Text", "TextColor3")

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.fromOffset(26, 34)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = C.Accent
    arrow.TextSize = 10
    arrow.ZIndex = 1000
    arrow.Parent = container
    registerTheme(arrow, "Accent", "TextColor3")

    local listFrame = Instance.new("ScrollingFrame")
    listFrame.Size = UDim2.new(1, 0, 0, 0)
    listFrame.BackgroundColor3 = C.Surface2
    listFrame.BorderSizePixel = 0
    listFrame.ScrollBarThickness = 4
    listFrame.ScrollBarImageColor3 = C.Accent
    listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    listFrame.Visible = false
    listFrame.ZIndex = 1001
    listFrame.Parent = container
    registerTheme(listFrame, "Surface2", "BackgroundColor3")

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 6)
    listCorner.Parent = listFrame

    local listStroke = Instance.new("UIStroke")
    listStroke.Color = C.Accent
    listStroke.Transparency = 0.3
    listStroke.Thickness = 2
    listStroke.Parent = listFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 2)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listFrame

    local listPad = Instance.new("UIPadding")
    listPad.PaddingTop = UDim.new(0, 3)
    listPad.PaddingBottom = UDim.new(0, 3)
    listPad.PaddingLeft = UDim.new(0, 3)
    listPad.PaddingRight = UDim.new(0, 3)
    listPad.Parent = listFrame

    local isOpen = false
    local itemHeight = 26
    local maxH = math.min(#items * (itemHeight + 2) + 8, 180)

    local function closeList()
        isOpen = false
        TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
        task.delay(0.2, function()
            if not isOpen then listFrame.Visible = false end
        end)
        arrow.Text = "▼"
    end

    local function openList()
        isOpen = true
        listFrame.Visible = true

        local containerAbsY = container.AbsolutePosition.Y
        local containerAbsH = container.AbsoluteSize.Y
        local screenH = workspace.CurrentCamera.ViewportSize.Y
        local spaceBelow = screenH - (containerAbsY + containerAbsH)
        local spaceAbove = containerAbsY

        if spaceBelow >= maxH or spaceBelow >= spaceAbove then
            listFrame.Position = UDim2.fromOffset(0, 37)
            listFrame.AnchorPoint = Vector2.new(0, 0)
        else
            listFrame.Position = UDim2.fromOffset(0, -3)
            listFrame.AnchorPoint = Vector2.new(0, 1)
        end

        TweenService:Create(listFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, maxH)}):Play()
        arrow.Text = "▲"
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
        opt.TextSize = 11
        opt.AutoButtonColor = false
        opt.ZIndex = 1002
        opt.LayoutOrder = i
        opt.Parent = listFrame
        registerTheme(opt, "Surface3", "BackgroundColor3")
        registerTheme(opt, "Text", "TextColor3")

        local optCorner = Instance.new("UICorner")
        optCorner.CornerRadius = UDim.new(0, 5)
        optCorner.Parent = opt

        opt.MouseButton1Click:Connect(function()
            selectedLbl.Text = item
            closeList()
            if onSelect then onSelect(item) end
        end)
    end

    return container
end

-- ============================================================
-- BUILD MAIN WINDOW (RESIZEABLE)
-- ============================================================
local function buildMainWindow(parent)
    local screenGui = parent

    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(620, 520)
    main.Position = UDim2.new(0.5, -310, 0.5, -260)
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
    stroke.Transparency = 0.3
    stroke.Parent = main
    registerTheme(stroke, "Accent", "Color")

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
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

    local headerGrad = Instance.new("UIGradient")
    headerGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, C.Accent),
        ColorSequenceKeypoint.new(1, C.Accent2)
    })
    headerGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.7),
        NumberSequenceKeypoint.new(1, 0)
    })
    headerGrad.Rotation = 90
    headerGrad.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -180, 1, 0)
    title.Position = UDim2.new(0, 16, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "⚡ VRILZHUB · Ride a Pet"
    title.TextColor3 = C.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 11
    title.Parent = header
    registerTheme(title, "Text", "TextColor3")

    -- Minimize
    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(28, 28)
    minBtn.Position = UDim2.new(1, -70, 0.5, -14)
    minBtn.BackgroundColor3 = C.Surface3
    minBtn.Text = "—"
    minBtn.TextColor3 = C.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 16
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 11
    minBtn.Parent = header
    registerTheme(minBtn, "Surface3", "BackgroundColor3")
    registerTheme(minBtn, "Text", "TextColor3")

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minBtn

    -- Close
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(28, 28)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -14)
    closeBtn.BackgroundColor3 = C.Surface3
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = C.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 14
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 11
    closeBtn.Parent = header
    registerTheme(closeBtn, "Surface3", "BackgroundColor3")
    registerTheme(closeBtn, "Text", "TextColor3")

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn

    -- Open Button
    local openBtn = Instance.new("TextButton")
    openBtn.Size = UDim2.fromOffset(56, 56)
    openBtn.Position = UDim2.fromOffset(20, 20)
    openBtn.BackgroundColor3 = C.Surface
    openBtn.Text = "⚡"
    openBtn.TextColor3 = C.Accent
    openBtn.Font = Enum.Font.GothamBold
    openBtn.TextSize = 28
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

    task.spawn(function()
        while openBtn.Parent do
            TweenService:Create(openStroke, TweenInfo.new(1.5), {Transparency = 0.7}):Play()
            task.wait(1.5)
            TweenService:Create(openStroke, TweenInfo.new(1.5), {Transparency = 0.3}):Play()
            task.wait(1.5)
        end
    end)

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
            Size = UDim2.fromOffset(620, 520)
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
        notify("Di-minimize ke ⚡", "info")
    end)

    closeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(main, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.fromOffset(0, 0)
        }):Play()
        task.delay(0.3, function()
            screenGui:Destroy()
        end)
    end)

    -- Body
    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -20, 1, -70)
    body.Position = UDim2.new(0, 10, 0, 60)
    body.BackgroundTransparency = 1
    body.ZIndex = 2
    body.Parent = main

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 90, 1, 0)
    sidebar.BackgroundColor3 = C.Surface
    sidebar.BorderSizePixel = 0
    sidebar.ZIndex = 3
    sidebar.Parent = body
    registerTheme(sidebar, "Surface", "BackgroundColor3")

    local sidebarCorner = Instance.new("UICorner")
    sidebarCorner.CornerRadius = UDim.new(0, 10)
    sidebarCorner.Parent = sidebar

    local sidebarLayout = Instance.new("UIListLayout")
    sidebarLayout.Padding = UDim.new(0, 4)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
    sidebarLayout.Parent = sidebar

    local sidebarPad = Instance.new("UIPadding")
    sidebarPad.PaddingTop = UDim.new(0, 8)
    sidebarPad.PaddingBottom = UDim.new(0, 8)
    sidebarPad.Parent = sidebar

    -- Page Holder
    local pageHolder = Instance.new("ScrollingFrame")
    pageHolder.Size = UDim2.new(1, -100, 1, 0)
    pageHolder.Position = UDim2.new(0, 100, 0, 0)
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
    pageHolderPad.PaddingBottom = UDim.new(0, 60)
    pageHolderPad.PaddingLeft = UDim.new(0, 8)
    pageHolderPad.PaddingRight = UDim.new(0, 8)
    pageHolderPad.Parent = pageHolder

    -- ========================================================
    -- RESIZE HANDLE
    -- ========================================================
    local resizeHandle = Instance.new("TextButton")
    resizeHandle.Size = UDim2.fromOffset(20, 20)
    resizeHandle.Position = UDim2.new(1, -22, 1, -22)
    resizeHandle.BackgroundTransparency = 1
    resizeHandle.Text = ""
    resizeHandle.AutoButtonColor = false
    resizeHandle.ZIndex = 100
    resizeHandle.Parent = main

    local resizeIcon = Instance.new("TextLabel")
    resizeIcon.Size = UDim2.fromScale(1, 1)
    resizeIcon.BackgroundTransparency = 1
    resizeIcon.Text = "◢"
    resizeIcon.TextColor3 = C.Accent
    resizeIcon.TextSize = 14
    resizeIcon.Font = Enum.Font.GothamBold
    resizeIcon.ZIndex = 101
    resizeIcon.Parent = resizeHandle

    local resizing = false
    local resizeStart, startSize

    resizeHandle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = i.Position
            startSize = main.Size
        end
    end)

    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - resizeStart
            local newX = math.clamp(startSize.X.Offset + delta.X, 400, 1100)
            local newY = math.clamp(startSize.Y.Offset + delta.Y, 350, 800)
            main.Size = UDim2.fromOffset(newX, newY)
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

    -- ========================================================
    -- PAGES
    -- ========================================================
    local pages = {}
    local navs = {}

    local function registerTab(id, icon, label)
        local tabH = 40
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -8, 0, tabH)
        btn.BackgroundColor3 = C.Surface3
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 4
        btn.Parent = sidebar
        registerTheme(btn, "Surface3", "BackgroundColor3")

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = btn

        local ic = Instance.new("TextLabel")
        ic.Size = UDim2.fromOffset(28, tabH)
        ic.Position = UDim2.fromOffset(4, 0)
        ic.BackgroundTransparency = 1
        ic.Text = icon
        ic.TextSize = 16
        ic.Font = Enum.Font.GothamBold
        ic.TextColor3 = C.Accent
        ic.ZIndex = 5
        ic.Parent = btn
        registerTheme(ic, "Accent", "TextColor3")

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -34, 1, 0)
        lbl.Position = UDim2.fromOffset(34, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.Muted
        lbl.TextSize = 9
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5
        lbl.Parent = btn
        registerTheme(lbl, "Muted", "TextColor3")

        navs[id] = btn

        local function switchTo()
            for n, p in pairs(pages) do
                if p then p.Visible = (n == id) end
            end
            for n, x in pairs(navs) do
                x.BackgroundColor3 = (n == id) and C.Accent or C.Surface3
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
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = C.Accent
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = false
        page.ZIndex = 6
        page.Parent = pageHolder
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 10)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page
        return page
    end

    -- ========================================================
    -- TAB INFO
    -- ========================================================
    local infoPage = createPage("Info")
    pages.Info = infoPage

    local infoCard, infoContent = makeCard(infoPage, "👤 INFORMASI CLIENT")
    infoCard.LayoutOrder = 1

    local avSz = 60
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(avSz, avSz)
    avatar.BackgroundColor3 = C.Surface3
    avatar.BorderSizePixel = 0
    avatar.LayoutOrder = 1
    avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LocalPlayer.UserId .. "&w=150&h=150"
    avatar.ZIndex = 3
    avatar.Parent = infoContent

    local avCorner = Instance.new("UICorner")
    avCorner.CornerRadius = UDim.new(1, 0)
    avCorner.Parent = avatar

    local avStroke = Instance.new("UIStroke")
    avStroke.Color = C.Accent
    avStroke.Thickness = 2
    avStroke.Parent = avatar

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 0, 20)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = "Nama: " .. LocalPlayer.DisplayName
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 13
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.LayoutOrder = 2
    nameLbl.ZIndex = 3
    nameLbl.Parent = infoContent
    registerTheme(nameLbl, "Text", "TextColor3")

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, 0, 0, 18)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = "Username: @" .. LocalPlayer.Name
    userLbl.TextColor3 = C.Muted
    userLbl.Font = Enum.Font.GothamSemibold
    userLbl.TextSize = 11
    userLbl.TextXAlignment = Enum.TextXAlignment.Left
    userLbl.LayoutOrder = 3
    userLbl.ZIndex = 3
    userLbl.Parent = infoContent

    local sessionLbl = Instance.new("TextLabel")
    sessionLbl.Size = UDim2.new(1, 0, 0, 18)
    sessionLbl.BackgroundTransparency = 1
    sessionLbl.Text = "Sesi: 00:00"
    sessionLbl.TextColor3 = C.Text
    sessionLbl.Font = Enum.Font.GothamSemibold
    sessionLbl.TextSize = 11
    sessionLbl.TextXAlignment = Enum.TextXAlignment.Left
    sessionLbl.LayoutOrder = 4
    sessionLbl.ZIndex = 3
    sessionLbl.Parent = infoContent

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

    registerTab("Info", "ℹ️", "Info")

    -- ========================================================
    -- TAB PREDIKSI
    -- ========================================================
    local predPage = createPage("Prediksi")
    pages.Prediksi = predPage

    -- Card Egg Spawn
    local eggInMapCard, eggInMapContent = makeCard(predPage, "🥚 EGG SPAWN DI MAP")
    eggInMapCard.LayoutOrder = 1

    local eggInMapList = Instance.new("ScrollingFrame")
    eggInMapList.Size = UDim2.new(1, 0, 0, 130)
    eggInMapList.BackgroundTransparency = 1
    eggInMapList.BorderSizePixel = 0
    eggInMapList.ScrollBarThickness = 3
    eggInMapList.ScrollBarImageColor3 = C.Success
    eggInMapList.CanvasSize = UDim2.new(0, 0, 0, 0)
    eggInMapList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    eggInMapList.ZIndex = 3
    eggInMapList.Parent = eggInMapContent

    local eggInMapLayout = Instance.new("UIListLayout")
    eggInMapLayout.Padding = UDim.new(0, 2)
    eggInMapLayout.SortOrder = Enum.SortOrder.LayoutOrder
    eggInMapLayout.Parent = eggInMapList

    -- Card Prediksi
    local eggPredCard, eggPredContent = makeCard(predPage, "🎯 PREDIKSI EGG BERIKUTNYA")
    eggPredCard.LayoutOrder = 2

    local eggPredList = Instance.new("ScrollingFrame")
    eggPredList.Size = UDim2.new(1, 0, 0, 130)
    eggPredList.BackgroundTransparency = 1
    eggPredList.BorderSizePixel = 0
    eggPredList.ScrollBarThickness = 3
    eggPredList.ScrollBarImageColor3 = C.Accent3
    eggPredList.CanvasSize = UDim2.new(0, 0, 0, 0)
    eggPredList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    eggPredList.ZIndex = 3
    eggPredList.Parent = eggPredContent

    local eggPredLayout = Instance.new("UIListLayout")
    eggPredLayout.Padding = UDim.new(0, 2)
    eggPredLayout.SortOrder = Enum.SortOrder.LayoutOrder
    eggPredLayout.Parent = eggPredList

    -- Update list
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
                    lbl.Size = UDim2.new(1, 0, 0, 20)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "  Nggak ada egg di map"
                    lbl.TextColor3 = C.Muted
                    lbl.Font = Enum.Font.GothamSemibold
                    lbl.TextSize = 11
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.LayoutOrder = 1
                    lbl.ZIndex = 4
                    lbl.Parent = eggInMapList
                else
                    for i, eggName in ipairs(eggsInMap) do
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 0, 22)
                        lbl.BackgroundColor3 = C.Success
                        lbl.BackgroundTransparency = 0.85
                        lbl.Text = "  🥚 " .. eggName
                        lbl.TextColor3 = C.Text
                        lbl.Font = Enum.Font.GothamSemibold
                        lbl.TextSize = 11
                        lbl.TextXAlignment = Enum.TextXAlignment.Left
                        lbl.LayoutOrder = i
                        lbl.ZIndex = 4
                        lbl.Parent = eggInMapList
                        local c = Instance.new("UICorner")
                        c.CornerRadius = UDim.new(0, 4)
                        c.Parent = lbl
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
                    lbl.Size = UDim2.new(1, 0, 0, 20)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "  Menunggu data..."
                    lbl.TextColor3 = C.Muted
                    lbl.Font = Enum.Font.GothamSemibold
                    lbl.TextSize = 11
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.LayoutOrder = 1
                    lbl.ZIndex = 4
                    lbl.Parent = eggPredList
                else
                    for i, eggName in ipairs(preds) do
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 0, 22)
                        lbl.BackgroundColor3 = C.Accent3
                        lbl.BackgroundTransparency = 0.85
                        lbl.Text = "  🎯 " .. eggName
                        lbl.TextColor3 = C.Text
                        lbl.Font = Enum.Font.GothamSemibold
                        lbl.TextSize = 11
                        lbl.TextXAlignment = Enum.TextXAlignment.Left
                        lbl.LayoutOrder = i
                        lbl.ZIndex = 4
                        lbl.Parent = eggPredList
                        local c = Instance.new("UICorner")
                        c.CornerRadius = UDim.new(0, 4)
                        c.Parent = lbl
                    end
                end
            end
        end
    end)

    registerTab("Prediksi", "🎯", "Prediksi")

    -- ========================================================
    -- TAB EGG
    -- ========================================================
    local eggPage = createPage("Egg")
    pages.Egg = eggPage

    local eggEspCard, eggEspContent = makeCard(eggPage, "🥚 EGG ESP")
    eggEspCard.LayoutOrder = 1
    makeToggle(eggEspContent, "Aktifkan Egg ESP", false, function(v) Shared.ESP_Eggs_Enabled = v end)
    makeToggle(eggEspContent, "Tampilkan Nama", true, function(v) Shared.ESP_EggName_Enabled = v end)
    makeToggle(eggEspContent, "Tampilkan Luck", true, function(v) Shared.ESP_EggLuck_Enabled = v end)

    local autoStealCard, autoStealContent = makeCard(eggPage, "🥚 AUTO STEAL")
    autoStealCard.LayoutOrder = 2
    makeToggle(autoStealContent, "Aktifkan Auto Steal", false, function(v) Shared.AutoSteal_Enabled = v end)
    makeToggle(autoStealContent, "Auto Return ke Plot", true, function(v) Shared.AutoReturn_Enabled = v end)
    makeToggle(autoStealContent, "Auto Hatch", false, function(v) Shared.AutoHatch_Enabled = v end)

    local eggNameLbl = Instance.new("TextLabel")
    eggNameLbl.Size = UDim2.new(1, 0, 0, 16)
    eggNameLbl.BackgroundTransparency = 1
    eggNameLbl.Text = "Pilih Egg (Nama):"
    eggNameLbl.TextColor3 = C.Muted
    eggNameLbl.Font = Enum.Font.GothamSemibold
    eggNameLbl.TextSize = 11
    eggNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    eggNameLbl.ZIndex = 3
    eggNameLbl.Parent = autoStealContent

    makeDropdown(autoStealContent, EggNames, "Cherub", function(v)
        Shared.SelectedEgg = v
        notify("Egg: " .. v, "info")
    end)

    registerTab("Egg", "🥚", "Egg")

    -- ========================================================
    -- TAB VISUAL
    -- ========================================================
    local visualPage = createPage("Visual")
    pages.Visual = visualPage

    local pEspCard, pEspContent = makeCard(visualPage, "👤 PLAYER ESP")
    pEspCard.LayoutOrder = 1
    makeToggle(pEspContent, "Player ESP", false, function(v) Shared.ESP_Players_Enabled = v end)
    makeToggle(pEspContent, "Player Chams", true, function(v) Shared.ESP_PlayerChams_Enabled = v end)
    makeToggle(pEspContent, "Player Studs", true, function(v) Shared.ESP_PlayerStuds_Enabled = v end)

    local petEspCard, petEspContent = makeCard(visualPage, "🐾 PET ESP")
    petEspCard.LayoutOrder = 2
    makeToggle(petEspContent, "Pet ESP", false, function(v) Shared.ESP_Pets_Enabled = v end)
    makeToggle(petEspContent, "Tampilkan Nama", true, function(v) Shared.ESP_PetName_Enabled = v end)
    makeToggle(petEspContent, "Tampilkan Cash", true, function(v) Shared.ESP_PetCash_Enabled = v end)
    makeToggle(petEspContent, "Tampilkan Speed", true, function(v) Shared.ESP_PetSpeed_Enabled = v end)

    registerTab("Visual", "🎮", "Visual")

    -- ========================================================
    -- TAB AUTO
    -- ========================================================
    local autoPage = createPage("Auto")
    pages.Auto = autoPage

    local autoCard, autoContent = makeCard(autoPage, "⚙️ AUTO LAINNYA")
    autoCard.LayoutOrder = 1
    makeToggle(autoContent, "Auto Ride Pet", false, function(v) Shared.AutoRidePet_Enabled = v end)
    makeToggle(autoContent, "Auto Equip Best", false, function(v) Shared.AutoEquipBest_Enabled = v end)

    registerTab("Auto", "⚡", "Auto")

    -- ========================================================
    -- TAB SETTINGS
    -- ========================================================
    local setPage = createPage("Settings")
    pages.Settings = setPage

    local themeCard, themeContent = makeCard(setPage, "🎨 TEMA")
    themeCard.LayoutOrder = 1

    local themeLbl = Instance.new("TextLabel")
    themeLbl.Size = UDim2.new(1, 0, 0, 16)
    themeLbl.BackgroundTransparency = 1
    themeLbl.Text = "Pilih Tema:"
    themeLbl.TextColor3 = C.Muted
    themeLbl.Font = Enum.Font.GothamSemibold
    themeLbl.TextSize = 11
    themeLbl.TextXAlignment = Enum.TextXAlignment.Left
    themeLbl.ZIndex = 3
    themeLbl.Parent = themeContent

    local themeList = {"Brutal", "Ice", "Fire"}
    makeDropdown(themeContent, themeList, CurrentTheme, function(v)
        applyTheme(v)
        notify("Tema: " .. v, "success")
    end)

    local fpsCard, fpsContent = makeCard(setPage, "⚡ FPS BOOST")
    fpsCard.LayoutOrder = 2
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
                            local isDecorative = false
                            if obj.Transparency >= 0.5 then isDecorative = true end
                            if name:find("tree") or name:find("rock") or name:find("bush") then isDecorative = true end
                            if name:find("grass") or name:find("flower") or name:find("cloud") then isDecorative = true end

                            if isDecorative and obj.Size.Magnitude < 50 then
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
            notify("FPS Boost aktif!", "success")
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

    registerTab("Settings", "⚙️", "Settings")

    pages.Info.Visible = true
    navs.Info.BackgroundColor3 = C.Accent

    -- Drag
    local dragging, dragInput, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRILZHUB_RideAPet"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    setupNotifHolder(ScreenGui)

    -- Loading 3 detik
    local loading = Instance.new("Frame")
    loading.Size = UDim2.fromOffset(400, 240)
    loading.Position = UDim2.new(0.5, -200, 0.5, -120)
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
    title.Text = "⚡ VRILZHUB · Ride a Pet"
    title.TextColor3 = C.Accent
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.ZIndex = 201
    title.Parent = loading
    registerTheme(title, "Accent", "TextColor3")

    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -40, 0, 20)
    status.Position = UDim2.new(0, 20, 0, 60)
    status.BackgroundTransparency = 1
    status.Text = "Loading..."
    status.TextColor3 = C.Muted
    status.Font = Enum.Font.GothamSemibold
    status.TextSize = 11
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.ZIndex = 201
    status.Parent = loading

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -40, 0, 6)
    barBg.Position = UDim2.new(0, 20, 0, 90)
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

    task.spawn(function()
        local start = os.clock()
        while loading.Parent do
            local p = math.clamp((os.clock() - start) / 3, 0, 1)
            barFill.Size = UDim2.new(p, 0, 1, 0)
            status.Text = "Loading... " .. math.floor(p * 100) .. "%"
            if p >= 1 then break end
            task.wait(0.05)
        end
        task.wait(0.3)
        if loading then loading:Destroy() end
        buildMainWindow(ScreenGui)
        notify("Selamat datang, " .. LocalPlayer.DisplayName .. "!", "success")
    end)
end

return UI
