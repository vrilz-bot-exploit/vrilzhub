-- ============================================================
-- BUILD MAIN WINDOW
-- ============================================================
local function buildMainWindow(parent)
    local screenGui = parent

    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(800, 580)
    main.Position = UDim2.new(0.5, -400, 0.5, -290)
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

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 52)
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
    logo.Size = UDim2.fromOffset(36, 36)
    logo.Position = UDim2.fromOffset(12, 8)
    logo.BackgroundColor3 = C.Accent
    logo.Text = "⚡"
    logo.TextColor3 = Color3.new(1, 1, 1)
    logo.Font = Enum.Font.GothamBold
    logo.TextSize = 20
    logo.ZIndex = 11
    logo.Parent = header
    registerTheme(logo, "Accent", "BackgroundColor3")

    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 8)
    logoCorner.Parent = logo

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 300, 0, 20)
    title.Position = UDim2.fromOffset(58, 10)
    title.BackgroundTransparency = 1
    title.Text = "VRILZHUB"
    title.TextColor3 = C.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 11
    title.Parent = header
    registerTheme(title, "Text", "TextColor3")

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0, 300, 0, 14)
    subtitle.Position = UDim2.fromOffset(58, 28)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Ride a Pet · v5.1"
    subtitle.TextColor3 = C.Muted
    subtitle.Font = Enum.Font.GothamSemibold
    subtitle.TextSize = 10
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 11
    subtitle.Parent = header
    registerTheme(subtitle, "Muted", "TextColor3")

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.fromOffset(32, 32)
    minBtn.Position = UDim2.new(1, -78, 0.5, -16)
    minBtn.BackgroundColor3 = C.Surface3
    minBtn.Text = "−"
    minBtn.TextColor3 = C.Text
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextSize = 20
    minBtn.BorderSizePixel = 0
    minBtn.ZIndex = 11
    minBtn.Parent = header
    registerTheme(minBtn, "Surface3", "BackgroundColor3")
    registerTheme(minBtn, "Text", "TextColor3")

    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 8)
    minCorner.Parent = minBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(32, 32)
    closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
    closeBtn.BackgroundColor3 = C.Surface3
    closeBtn.Text = "×"
    closeBtn.TextColor3 = C.Text
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 22
    closeBtn.BorderSizePixel = 0
    closeBtn.ZIndex = 11
    closeBtn.Parent = header
    registerTheme(closeBtn, "Surface3", "BackgroundColor3")
    registerTheme(closeBtn, "Text", "TextColor3")

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 8)
    closeCorner.Parent = closeBtn

    -- Body
    local body = Instance.new("Frame")
    body.Size = UDim2.new(1, -20, 1, -72)
    body.Position = UDim2.new(0, 10, 0, 62)
    body.BackgroundTransparency = 1
    body.ZIndex = 2
    body.Parent = main

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 140, 1, 0)
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
    sidebarPad.PaddingTop = UDim.new(0, 10)
    sidebarPad.PaddingBottom = UDim.new(0, 10)
    sidebarPad.PaddingLeft = UDim.new(0, 8)
    sidebarPad.PaddingRight = UDim.new(0, 8)
    sidebarPad.Parent = sidebar

    -- Page Holder
    local pageHolder = Instance.new("ScrollingFrame")
    pageHolder.Size = UDim2.new(1, -150, 1, 0)
    pageHolder.Position = UDim2.new(0, 150, 0, 0)
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
    pageHolderPad.PaddingLeft = UDim.new(0, 10)
    pageHolderPad.PaddingRight = UDim.new(0, 10)
    pageHolderPad.Parent = pageHolder

    -- Resize
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
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = i.Position
            startSize = main.Size
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - resizeStart
            local newX = math.clamp(startSize.X.Offset + delta.X, 600, 1200)
            local newY = math.clamp(startSize.Y.Offset + delta.Y, 400, 800)
            main.Size = UDim2.fromOffset(newX, newY)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end)

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
            Size = UDim2.fromOffset(800, 580)
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

    -- ========================================================
    -- TAB SYSTEM
    -- ========================================================
    local pages = {}
    local navs = {}

    local function registerTab(id, icon, label)
        local tabH = 44
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
        ic.Size = UDim2.fromOffset(28, tabH)
        ic.Position = UDim2.fromOffset(10, 0)
        ic.BackgroundTransparency = 1
        ic.Text = icon
        ic.TextSize = 16
        ic.Font = Enum.Font.GothamBold
        ic.TextColor3 = C.Accent
        ic.ZIndex = 5
        ic.Parent = btn
        registerTheme(ic, "Accent", "TextColor3")

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -44, 1, 0)
        lbl.Position = UDim2.fromOffset(42, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = C.Muted
        lbl.TextSize = 12
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 5
        lbl.Parent = btn
        registerTheme(lbl, "Muted", "TextColor3")

        navs[id] = {btn = btn, ic = ic, lbl = lbl}

        local function switchTo()
            for n, p in pairs(pages) do
                if p then p.Visible = (n == id) end
            end
            for n, x in pairs(navs) do
                if n == id then
                    x.btn.BackgroundColor3 = C.Accent
                    x.btn.BackgroundTransparency = 0
                    x.lbl.TextColor3 = Color3.new(1, 1, 1)
                    x.ic.TextColor3 = Color3.new(1, 1, 1)
                else
                    x.btn.BackgroundColor3 = C.Surface3
                    x.btn.BackgroundTransparency = 0.5
                    x.lbl.TextColor3 = C.Muted
                    x.ic.TextColor3 = C.Accent
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
        layout.Padding = UDim.new(0, 12)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page
        return page
    end

    -- INFO
    local infoPage = createPage("Info")
    pages.Info = infoPage

    local infoCard, infoContent = makeCard(infoPage, "INFORMASI CLIENT", 1)

    local avRow = Instance.new("Frame")
    avRow.Size = UDim2.new(1, 0, 0, 70)
    avRow.BackgroundTransparency = 1
    avRow.LayoutOrder = 1
    avRow.Parent = infoContent

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(60, 60)
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
    nameLbl.Size = UDim2.new(1, -75, 0, 22)
    nameLbl.Position = UDim2.fromOffset(75, 12)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = LocalPlayer.DisplayName
    nameLbl.TextColor3 = C.Text
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextSize = 15
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left
    nameLbl.ZIndex = 3
    nameLbl.Parent = avRow
    registerTheme(nameLbl, "Text", "TextColor3")

    local userLbl = Instance.new("TextLabel")
    userLbl.Size = UDim2.new(1, -75, 0, 16)
    userLbl.Position = UDim2.fromOffset(75, 34)
    userLbl.BackgroundTransparency = 1
    userLbl.Text = "@" .. LocalPlayer.Name
    userLbl.TextColor3 = C.Muted
    userLbl.Font = Enum.Font.GothamSemibold
    userLbl.TextSize = 11
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
    sessionLbl.TextSize = 12
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

    -- PREDIKSI
    local predPage = createPage("Prediksi")
    pages.Prediksi = predPage

    local eggInMapCard, eggInMapContent = makeCard(predPage, "EGG SPAWN DI MAP", 1)

    local eggInMapList = Instance.new("ScrollingFrame")
    eggInMapList.Size = UDim2.new(1, 0, 0, 160)
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
    eggPredList.Size = UDim2.new(1, 0, 0, 160)
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
                    lbl.Size = UDim2.new(1, 0, 0, 28)
                    lbl.BackgroundColor3 = C.Surface3
                    lbl.BackgroundTransparency = 0.5
                    lbl.Text = "   Nggak ada egg di map"
                    lbl.TextColor3 = C.Muted
                    lbl.Font = Enum.Font.GothamSemibold
                    lbl.TextSize = 11
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
                        lbl.Size = UDim2.new(1, 0, 0, 28)
                        lbl.BackgroundColor3 = C.Surface3
                        lbl.BackgroundTransparency = 0.3
                        lbl.Text = "   🥚  " .. eggName
                        lbl.TextColor3 = C.Text
                        lbl.Font = Enum.Font.GothamSemibold
                        lbl.TextSize = 12
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
                    lbl.Size = UDim2.new(1, 0, 0, 28)
                    lbl.BackgroundColor3 = C.Surface3
                    lbl.BackgroundTransparency = 0.5
                    lbl.Text = "   Menunggu data..."
                    lbl.TextColor3 = C.Muted
                    lbl.Font = Enum.Font.GothamSemibold
                    lbl.TextSize = 11
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
                        lbl.Size = UDim2.new(1, 0, 0, 28)
                        lbl.BackgroundColor3 = C.Surface3
                        lbl.BackgroundTransparency = 0.3
                        lbl.Text = "   🎯  " .. eggName
                        lbl.TextColor3 = C.Text
                        lbl.Font = Enum.Font.GothamSemibold
                        lbl.TextSize = 12
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

    -- EGG
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
    eggNameLbl.TextSize = 11
    eggNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    eggNameLbl.ZIndex = 3
    eggNameLbl.Parent = autoStealContent

    makeDropdownGlobal(autoStealContent, EggNames, "Cherub", function(v)
        Shared.SelectedEgg = v
        notify("Egg: " .. v, "info")
    end)

    registerTab("Egg", "◯", "Egg")

    -- VISUAL
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

    -- AUTO
    local autoPage = createPage("Auto")
    pages.Auto = autoPage

    local autoCard, autoContent = makeCard(autoPage, "AUTO LAINNYA", 1)
    makeToggle(autoContent, "Auto Ride Pet", false, function(v) Shared.AutoRidePet_Enabled = v end)
    makeToggle(autoContent, "Auto Equip Best", false, function(v) Shared.AutoEquipBest_Enabled = v end)

    registerTab("Auto", "▶", "Auto")

    -- SETTINGS
    local setPage = createPage("Settings")
    pages.Settings = setPage

    local themeCard, themeContent = makeCard(setPage, "TEMA", 1)

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
    navs.Info.lbl.TextColor3 = Color3.new(1, 1, 1)
    navs.Info.ic.TextColor3 = Color3.new(1, 1, 1)

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

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VRILZHUB_RideAPet"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")

    setupNotifHolder(ScreenGui)
    setupDropdownLayer(ScreenGui)

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
    title.Text = "⚡ VRILZHUB"
    title.TextColor3 = C.Accent
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
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
    subtitle.TextSize = 11
    subtitle.ZIndex = 201
    subtitle.Parent = loading
    registerTheme(subtitle, "Muted", "TextColor3")

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -40, 0, 6)
    barBg.Position = UDim2.new(0, 20, 0, 80)
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
    statusLbl.Position = UDim2.new(0, 20, 0, 100)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text = "0%"
    statusLbl.TextColor3 = C.Accent
    statusLbl.Font = Enum.Font.GothamBold
    statusLbl.TextSize = 12
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
