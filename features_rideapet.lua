-- ============================================================
-- VRILZHUB FEATURES — RIDE A PET v3.8
-- Halloween: Ambil SEMUA candy priority tertinggi → balik base → ulangi
-- ============================================================

local Features = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- ANTI-AFK
-- ============================================================
function Features.startAntiAFK()
    task.spawn(function()
        local vu = game:GetService("VirtualUser")

        LocalPlayer.Idled:Connect(function()
            if Shared.AntiAFK_Enabled == false then return end
            pcall(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end)

        while task.wait(60) do
            if Shared.AntiAFK_Enabled == false then continue end
            pcall(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
            pcall(function()
                mousemoverel(1, 0)
                task.wait(0.05)
                mousemoverel(-1, 0)
            end)
        end
    end)
end

-- ============================================================
-- FLY STEAL
-- ============================================================
local function clearForces(root)
    for _, c in ipairs(root:GetChildren()) do
        if c:IsA("BodyVelocity") or c:IsA("BodyPosition")
           or c:IsA("BodyGyro") or c:IsA("LinearVelocity") then
            c:Destroy()
        end
    end
end

local function doStealFly(egg, prompt, eggPart)
    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot or not eggPart then return false end

    clearForces(myRoot)

    local bvUp = Instance.new("BodyVelocity")
    bvUp.Name = "Vrilz_FlyUp"
    bvUp.MaxForce = Vector3.new(0, 1e5, 0)
    bvUp.Velocity = Vector3.new(0, 500, 0)
    bvUp.Parent = myRoot

    local targetY = myRoot.Position.Y + 350
    local t1 = tick()
    while myRoot.Parent and myRoot.Position.Y < targetY and (tick() - t1) < 5 do
        task.wait(0.03)
    end
    bvUp:Destroy()

    myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end

    myRoot.CFrame = CFrame.new(eggPart.Position + Vector3.new(0, 3, 0))
    myRoot.Velocity = Vector3.zero
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.15)

    for i = 1, 15 do
        if typeof(fireproximityprompt) == "function" then
            pcall(fireproximityprompt, prompt)
        end
        task.wait(0.15)
        if not egg.Parent then return true end
        if eggPart and eggPart.Parent then
            myRoot.CFrame = CFrame.new(eggPart.Position + Vector3.new(0, 3, 0))
        end
    end
    return not egg.Parent
end

-- ============================================================
-- GET EGG LUCK
-- ============================================================
local function getEggLuck(egg)
    local luckGui = egg:FindFirstChild("EggLuck", true)
    if luckGui then
        local luckLabel = luckGui:FindFirstChild("Luck")
        if luckLabel and luckLabel:IsA("TextLabel") then
            return luckLabel.Text
        end
    end
    return "?"
end

-- ============================================================
-- EGG ESP
-- ============================================================
local EggESPTracked = {}

function Features.startEggESP()
    task.spawn(function()
        while task.wait(0.3) do
            if Shared.ESP_Eggs_Enabled then
                local rendered = Workspace:FindFirstChild("RenderedEggs")
                if rendered then
                    for _, egg in ipairs(rendered:GetChildren()) do
                        if egg:IsA("Model") and not EggESPTracked[egg] then
                            local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
                            if eggPart then
                                local hl = Instance.new("Highlight")
                                hl.Name = "VRILZ_RideAPet_EggHL"
                                hl.FillColor = Color3.fromRGB(255, 215, 0)
                                hl.OutlineColor = Color3.new(1, 1, 1)
                                hl.FillTransparency = 0.5
                                hl.Adornee = egg
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = egg

                                local bb = Instance.new("BillboardGui")
                                bb.Name = "VRILZ_RideAPet_EggESP"
                                bb.Size = UDim2.fromOffset(200, 22)
                                bb.StudsOffset = Vector3.new(0, 2.5, 0)
                                bb.AlwaysOnTop = true
                                bb.MaxDistance = 500
                                bb.Adornee = eggPart
                                bb.Parent = eggPart

                                local lbl = Instance.new("TextLabel")
                                lbl.Name = "InfoLabel"
                                lbl.Size = UDim2.fromScale(1, 1)
                                lbl.BackgroundTransparency = 1
                                lbl.TextColor3 = Color3.fromRGB(255, 215, 0)
                                lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                                lbl.TextStrokeTransparency = 0.2
                                lbl.Font = Enum.Font.GothamBold
                                lbl.TextSize = 14
                                lbl.TextWrapped = false
                                lbl.Text = ""
                                lbl.Parent = bb

                                EggESPTracked[egg] = {hl = hl, bb = bb, lbl = lbl, part = eggPart}
                            end
                        end
                    end
                end
            else
                for egg, data in pairs(EggESPTracked) do
                    if data.hl then data.hl:Destroy() end
                    if data.bb then data.bb:Destroy() end
                    EggESPTracked[egg] = nil
                end
            end

            for egg, data in pairs(EggESPTracked) do
                if not egg.Parent then
                    if data.hl then data.hl:Destroy() end
                    if data.bb then data.bb:Destroy() end
                    EggESPTracked[egg] = nil
                elseif data.lbl then
                    local parts = {}
                    if Shared.ESP_EggName_Enabled then
                        table.insert(parts, "🥚 " .. egg.Name)
                    end
                    if Shared.ESP_EggLuck_Enabled then
                        table.insert(parts, "🍀 " .. getEggLuck(egg))
                    end
                    data.lbl.Text = "[ " .. table.concat(parts, "  ") .. " ]"
                end
            end
        end
    end)
end

-- ============================================================
-- PET ESP
-- ============================================================
local PetESPTracked = {}

local function getPetInfo(pet)
    local cash, speed = "?", "?"
    local cashGui = pet:FindFirstChild("PetCash", true)
    if cashGui then
        for _, desc in ipairs(cashGui:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Text:find("%$") and desc.Text:find("/s") then
                cash = desc.Text
                break
            end
        end
    end
    local speedGui = pet:FindFirstChild("PetSpeed", true)
    if speedGui then
        for _, desc in ipairs(speedGui:GetDescendants()) do
            if desc:IsA("TextLabel") and desc.Text ~= "" then
                speed = desc.Text
                break
            end
        end
    end
    return cash, speed
end

function Features.startPetESP()
    task.spawn(function()
        while task.wait(0.3) do
            if Shared.ESP_Pets_Enabled then
                local plots = Workspace:FindFirstChild("Plots")
                if plots then
                    for _, plot in ipairs(plots:GetChildren()) do
                        local pets = plot:FindFirstChild("Pets")
                        if pets then
                            for _, pet in ipairs(pets:GetChildren()) do
                                if pet:IsA("Model") and not PetESPTracked[pet] then
                                    local petPart = pet:FindFirstChildWhichIsA("BasePart", true)
                                    if petPart then
                                        local hl = Instance.new("Highlight")
                                        hl.Name = "VRILZ_RideAPet_PetHL"
                                        hl.FillColor = Color3.fromRGB(100, 200, 255)
                                        hl.OutlineColor = Color3.new(1, 1, 1)
                                        hl.FillTransparency = 0.5
                                        hl.Adornee = pet
                                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                        hl.Parent = pet

                                        local bb = Instance.new("BillboardGui")
                                        bb.Name = "VRILZ_RideAPet_PetESP"
                                        bb.Size = UDim2.fromOffset(220, 22)
                                        bb.StudsOffset = Vector3.new(0, 3, 0)
                                        bb.AlwaysOnTop = true
                                        bb.MaxDistance = 500
                                        bb.Adornee = petPart
                                        bb.Parent = petPart

                                        local lbl = Instance.new("TextLabel")
                                        lbl.Name = "InfoLabel"
                                        lbl.Size = UDim2.fromScale(1, 1)
                                        lbl.BackgroundTransparency = 1
                                        lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
                                        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                                        lbl.TextStrokeTransparency = 0.2
                                        lbl.Font = Enum.Font.GothamBold
                                        lbl.TextSize = 14
                                        lbl.TextWrapped = false
                                        lbl.Text = ""
                                        lbl.Parent = bb

                                        PetESPTracked[pet] = {hl = hl, bb = bb, lbl = lbl, part = petPart}
                                    end
                                end
                            end
                        end
                    end
                end
            else
                for pet, data in pairs(PetESPTracked) do
                    if data.hl then data.hl:Destroy() end
                    if data.bb then data.bb:Destroy() end
                    PetESPTracked[pet] = nil
                end
            end

            for pet, data in pairs(PetESPTracked) do
                if not pet.Parent then
                    if data.hl then data.hl:Destroy() end
                    if data.bb then data.bb:Destroy() end
                    PetESPTracked[pet] = nil
                elseif data.lbl then
                    local cash, speed = getPetInfo(pet)
                    local parts = {}
                    if Shared.ESP_PetName_Enabled then
                        table.insert(parts, "🐾 " .. pet.Name)
                    end
                    if Shared.ESP_PetCash_Enabled then
                        table.insert(parts, "💰 " .. cash)
                    end
                    if Shared.ESP_PetSpeed_Enabled then
                        table.insert(parts, "⚡ " .. speed)
                    end
                    data.lbl.Text = "[ " .. table.concat(parts, "  ") .. " ]"
                end
            end
        end
    end)
end

-- ============================================================
-- GET MY PLOT
-- ============================================================
local function getMyPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local owner = plot:GetAttribute("OwnerUserId") or plot:GetAttribute("Owner") or plot:GetAttribute("NestsOwnerLoaded")
        if owner == LocalPlayer.UserId or owner == LocalPlayer.Name then
            return plot
        end

        local data = plot:FindFirstChild("Data")
        if data then
            local ownerVal = data:FindFirstChild("Owner")
            if ownerVal and ownerVal:IsA("ObjectValue") and ownerVal.Value == LocalPlayer then
                return plot
            end
        end
    end
    return nil
end

local function getMyPlotSpawn()
    local plot = getMyPlot()
    if not plot then return nil end
    local spawnPart = plot:FindFirstChild("Spawn", true)
        or plot:FindFirstChildWhichIsA("SpawnLocation", true)
        or plot:FindFirstChild("Baseplate", true)
        or plot:FindFirstChildWhichIsA("BasePart", true)
    return spawnPart
end

-- ============================================================
-- FIND EGG BY NAME
-- ============================================================
local function findEggByName(eggName)
    local rendered = Workspace:FindFirstChild("RenderedEggs")
    if not rendered then return nil end

    local targetName = eggName:lower()
    local best, bestDist = nil, math.huge
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, egg in ipairs(rendered:GetChildren()) do
        if egg:IsA("Model") then
            local name = egg.Name:lower()
            if name == targetName or name:find(targetName, 1, true) then
                local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
                if eggPart then
                    local d = (eggPart.Position - myRoot.Position).Magnitude
                    if d < bestDist then
                        best, bestDist = egg, d
                    end
                end
            end
        end
    end
    return best
end

local function isEggStillInMap(egg)
    if not egg or not egg.Parent then return false end
    return true
end

-- ============================================================
-- AUTO RETURN
-- ============================================================
local ReturnCfg = {
    StepDistance = 100,
    TPHeight = 5,
    WaitBetweenTP = 0.08,
    MaxSteps = 300,
    FinalDropWait = 0.3,
}

local function isHoldingEggLocal()
    local char = LocalPlayer.Character
    if not char then return false, nil end
    local wooden = char:FindFirstChild("Wooden")
    if not wooden then return false, nil end
    local displayEgg = wooden:FindFirstChild("DisplayEgg")
    if not displayEgg then return false, nil end
    for _, c in ipairs(displayEgg:GetChildren()) do
        if c:IsA("MeshPart") and not c.Name:lower():find("circle") then
            return true, c.Name
        end
    end
    return false, nil
end

local function getDropRemoteLocal()
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    if not gameR then return nil end
    return gameR:FindFirstChild("BasketDrop")
        or gameR:FindFirstChild("DropEgg")
        or gameR:FindFirstChild("EggDrop")
        or gameR:FindFirstChild("Drop")
end

local function returnToMyPlot()
    if not Shared.AutoReturn_Enabled then return end

    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local holding = isHoldingEggLocal()
    if not holding then return end

    local spawnPart = getMyPlotSpawn()
    if not spawnPart then return end

    local startPos = myRoot.Position
    local basePos = spawnPart.Position
    local totalDist = (basePos - startPos).Magnitude
    local stepSize = ReturnCfg.StepDistance
    local steps = math.min(ReturnCfg.MaxSteps, math.ceil(totalDist / stepSize))

    local dir = (basePos - startPos)
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude < 1 then
        local ang = math.random() * math.pi * 2
        dir = Vector3.new(math.cos(ang), 0, math.sin(ang))
    else
        dir = dir.Unit
    end

    for i = 1, steps do
        myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        if not isHoldingEggLocal() then return end

        local dist = math.min(stepSize * i, totalDist)
        local targetPos = startPos + dir * dist + Vector3.new(0, ReturnCfg.TPHeight, 0)

        clearForces(myRoot)
        myRoot.CFrame = CFrame.new(targetPos)
        myRoot.Velocity = Vector3.zero
        myRoot.AssemblyLinearVelocity = Vector3.zero

        task.wait(ReturnCfg.WaitBetweenTP)
    end

    myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    clearForces(myRoot)
    myRoot.CFrame = spawnPart.CFrame + Vector3.new(0, ReturnCfg.TPHeight, 0)
    myRoot.Velocity = Vector3.zero
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(ReturnCfg.FinalDropWait)

    if not isHoldingEggLocal() then return end

    local dropRemote = getDropRemoteLocal()

    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d.Name:lower():find("drop") then
            d.HoldDuration = 0
            if typeof(fireproximityprompt) == "function" then
                pcall(fireproximityprompt, d)
                break
            end
        end
    end

    if dropRemote then
        pcall(function() dropRemote:FireServer() end)
    end

    task.wait(0.3)
    if isHoldingEggLocal() and dropRemote then
        pcall(function() dropRemote:FireServer() end)
        task.wait(0.2)
    end
end

-- ============================================================
-- AUTO STEAL
-- ============================================================
local lastNoEggNotif = 0

function Features.startAutoSteal()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.AutoSteal_Enabled then continue end

            local char = LocalPlayer.Character
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not myRoot or not hum or hum.Health <= 0 then
                task.wait(1)
                continue
            end

            local eggName = Shared.SelectedEgg or "Cherub"
            local egg = findEggByName(eggName)

            if not egg then
                local now = os.clock()
                if now - lastNoEggNotif > 5 then
                    lastNoEggNotif = now
                    if Shared.Notify then
                        Shared.Notify("Egg no spawn: " .. eggName, "warning")
                    end
                end
                continue
            end

            local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
            local prompt = egg:FindFirstChild("Pickup", true)
            if not eggPart or not prompt then continue end

            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end

            myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)

            local picked = false
            for i = 1, 10 do
                if typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, prompt)
                end
                task.wait(0.3)
                if not isEggStillInMap(egg) then
                    picked = true
                    break
                end
                if eggPart and eggPart.Parent then
                    myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.1)
                end
            end

            if picked and Shared.AutoReturn_Enabled then
                returnToMyPlot()
            end

            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- AUTO HATCH
-- ============================================================
function Features.startAutoHatch()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.AutoHatch_Enabled then continue end

            local plot = getMyPlot()
            if not plot then continue end

            local eggsFolder = plot:FindFirstChild("Eggs")
            if not eggsFolder then continue end

            for _, egg in ipairs(eggsFolder:GetChildren()) do
                if not Shared.AutoHatch_Enabled then break end
                if not egg:IsA("Model") then continue end

                local handle = egg:FindFirstChild("Handle")
                if not handle then continue end

                local hatchPrompt = handle:FindFirstChild("Hatch")
                if not hatchPrompt or not hatchPrompt:IsA("ProximityPrompt") then continue end

                hatchPrompt.Enabled = true
                hatchPrompt.MaxActivationDistance = math.huge
                hatchPrompt.RequiresLineOfSight = false
                hatchPrompt.HoldDuration = 0

                if typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, hatchPrompt)
                    task.wait(0.05)
                    pcall(fireproximityprompt, hatchPrompt)
                end
            end
        end
    end)
end

-- ============================================================
-- AUTO PLANT EGG
-- ============================================================
local AutoPlantState = {
    Enabled = false,
    EggFilter = "None",
    PlantedCount = 0,
    Status = "Idle",
}

local function findEggToolInBackpack(eggName)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end

    local function norm(s)
        s = tostring(s or "")
        s = s:lower()
        s = s:gsub("%s*egg%s*$", "")
        s = s:gsub("^%s+", "")
        s = s:gsub("%s+$", "")
        return s
    end

    local targetName = norm(eggName)
    if targetName == "" then return nil end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local cleanName = norm(tool.Name)
            if cleanName == targetName then
                return tool
            end
        end
    end
    return nil
end

local function findEmptyNest()
    local plot = getMyPlot()
    if not plot then return nil end
    local nests = plot:FindFirstChild("Nests")
    if not nests then return nil end

    for _, nest in ipairs(nests:GetChildren()) do
        if nest:IsA("Model") and not nest:FindFirstChild("Locked") then
            local hasEgg = false
            for _, child in ipairs(nest:GetChildren()) do
                if child:IsA("Model") and child.Name:lower() ~= "model" then
                    hasEgg = true
                    break
                end
            end
            if not hasEgg then return nest end
        end
    end
    return nil
end

function Features.startAutoPlantEgg()
    task.spawn(function()
        while task.wait(0.2) do
            if not AutoPlantState.Enabled then
                AutoPlantState.Status = "Idle"
                continue
            end

            if not AutoPlantState.EggFilter or AutoPlantState.EggFilter == "" or AutoPlantState.EggFilter == "None" then
                AutoPlantState.Status = "Pilih egg dulu di Plant Filter!"
                continue
            end

            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then continue end

            local eggTool = findEggToolInBackpack(AutoPlantState.EggFilter)
            if not eggTool then
                AutoPlantState.Status = "X " .. AutoPlantState.EggFilter .. " not in backpack"
                continue
            end
            pcall(function() hum:EquipTool(eggTool) end)

            local nest = findEmptyNest()
            if not nest then
                AutoPlantState.Status = "X No empty nest"
                continue
            end

            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            local gameR = remotes and remotes:FindFirstChild("Game")
            if gameR then
                local eggPlaced = gameR:FindFirstChild("EggPlaced")
                if eggPlaced then
                    pcall(function() eggPlaced:FireServer() end)
                    pcall(function() eggPlaced:FireServer(nest) end)
                    pcall(function() eggPlaced:FireServer(nest.Name) end)
                    pcall(function() eggPlaced:FireServer(AutoPlantState.EggFilter) end)
                end
                local plotF = gameR:FindFirstChild("Plot")
                if plotF then
                    local nestsR = plotF:FindFirstChild("Nests")
                    if nestsR then
                        pcall(function() nestsR:FireServer(nest) end)
                        pcall(function() nestsR:FireServer(nest.Name) end)
                    end
                end
            end

            pcall(function() eggTool:Activate() end)

            local prompt = nest:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt then
                prompt.HoldDuration = 0
                prompt.MaxActivationDistance = math.huge
                if typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, prompt)
                end
            end

            AutoPlantState.PlantedCount = AutoPlantState.PlantedCount + 1
            AutoPlantState.Status = "OK " .. AutoPlantState.EggFilter .. " (" .. AutoPlantState.PlantedCount .. ")"
        end
    end)
end

function Features.getAutoPlantState()
    return AutoPlantState
end

function Features.setAutoPlantFilter(eggName)
    AutoPlantState.EggFilter = eggName or ""
end

-- ============================================================
-- AUTO RIDE PET
-- ============================================================
function Features.startAutoRidePet()
    task.spawn(function()
        while task.wait(1) do
            if not Shared.AutoRidePet_Enabled then continue end
            local plot = getMyPlot()
            if not plot then continue end
            local pets = plot:FindFirstChild("Pets")
            if not pets then continue end
            for _, pet in ipairs(pets:GetChildren()) do
                local prompt = pet:FindFirstChild("RidePrompt", true)
                if prompt and prompt.Enabled then
                    if typeof(fireproximityprompt) == "function" then
                        pcall(fireproximityprompt, prompt)
                    end
                    break
                end
            end
        end
    end)
end

-- ============================================================
-- EGG PREDICTION
-- ============================================================
local EggHistory = {}
local LastEggList = {}
local MAX_HISTORY = 50

function Features.startEggPrediction()
    task.spawn(function()
        while task.wait(1) do
            local rendered = Workspace:FindFirstChild("RenderedEggs")
            if not rendered then continue end

            local currentEggs = {}
            for _, egg in ipairs(rendered:GetChildren()) do
                if egg:IsA("Model") then
                    table.insert(currentEggs, egg.Name)
                end
            end

            for _, eggName in ipairs(currentEggs) do
                local found = false
                for _, lastEgg in ipairs(LastEggList) do
                    if lastEgg == eggName then
                        found = true
                        break
                    end
                end
                if not found then
                    table.insert(EggHistory, {
                        name = eggName,
                        time = os.time(),
                    })
                    if #EggHistory > MAX_HISTORY then
                        table.remove(EggHistory, 1)
                    end
                end
            end

            LastEggList = currentEggs
            Shared.EggsInMap = currentEggs
            Shared.EggHistory = EggHistory

            local eggCount = {}
            for _, entry in ipairs(EggHistory) do
                eggCount[entry.name] = (eggCount[entry.name] or 0) + 1
            end

            local sorted = {}
            for name, count in pairs(eggCount) do
                table.insert(sorted, {name = name, count = count})
            end
            table.sort(sorted, function(a, b) return a.count > b.count end)

            local predictions = {}
            for _, entry in ipairs(sorted) do
                local alreadyInMap = false
                for _, eggName in ipairs(currentEggs) do
                    if eggName == entry.name then
                        alreadyInMap = true
                        break
                    end
                end
                if not alreadyInMap then
                    table.insert(predictions, entry.name)
                end
                if #predictions >= 5 then break end
            end

            Shared.EggPredictions = predictions
        end
    end)
end

-- ============================================================
-- REMOTE ACTIONS
-- ============================================================
local function getRemote(name)
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if not remotes then return nil end
    local gameRemotes = remotes:FindFirstChild("Game")
    if not gameRemotes then return nil end
    return gameRemotes:FindFirstChild(name)
end

function Features.rideAlong()
    local remote = getRemote("RideAlong")
    if remote then remote:FireServer() return true end
    return false
end

function Features.petDismount()
    local remote = getRemote("PetDismount")
    if remote then remote:FireServer() return true end
    return false
end

function Features.pickupPet()
    local remote = getRemote("PickupPet")
    if remote then remote:FireServer() return true end
    return false
end

function Features.hatchEgg()
    local remote = getRemote("Hatch")
    if remote then remote:FireServer() return true end
    return false
end

-- ============================================================
-- GAMEDATA
-- ============================================================
local GameData = game:GetService("ReplicatedStorage"):FindFirstChild("GameData")
local EggData, PetData = {}, {}

if GameData then
    local eggsMod = GameData:FindFirstChild("Eggs")
    if eggsMod then
        local ok, data = pcall(require, eggsMod)
        if ok and type(data) == "table" then EggData = data end
    end
    local petsMod = GameData:FindFirstChild("Pets")
    if petsMod then
        local ok, data = pcall(require, petsMod)
        if ok and type(data) == "table" then PetData = data end
    end
end

local RARITY_ORDER = {
    Common = 1, Uncommon = 2, Rare = 3, Epic = 4,
    Legendary = 5, Mythic = 6, Divine = 7, Ethereal = 8, Secret = 9,
}

local function getEggRarity(eggName)
    local info = EggData[eggName]
    return info and info.Rarity or "Common"
end

local function isRaritySelected(eggName)
    local rarity = getEggRarity(eggName)
    if not Shared.SelectedRarities then return false end
    return Shared.SelectedRarities[rarity] == true
end

-- ============================================================
-- SPEED
-- ============================================================
function Features.setSpeed(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end

function Features.startSpeed()
    task.spawn(function()
        while task.wait(0.3) do
            if Shared.Speed_Enabled then
                Features.setSpeed(Shared.Speed_Value or 100)
            end
        end
    end)
end

-- ============================================================
-- INSTANT PICKUP
-- ============================================================
function Features.startInstantPickup()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.InstantPickup_Enabled then continue end

            local rendered = Workspace:FindFirstChild("RenderedEggs")
            if not rendered then continue end

            for _, egg in ipairs(rendered:GetChildren()) do
                if egg:IsA("Model") then
                    local prompt = egg:FindFirstChild("Pickup", true)
                    if prompt and prompt:IsA("ProximityPrompt") then
                        if prompt.HoldDuration > 0 then
                            prompt.HoldDuration = 0
                        end
                    end
                end
            end
        end
    end)
end

-- ============================================================
-- AUTO FARM
-- ============================================================
local NotifiedEggs = {}

local function getEggKey(egg)
    local part = egg:FindFirstChildWhichIsA("BasePart", true)
    if not part then return egg.Name end
    local p = part.Position
    return string.format("%s_%.0f_%.0f_%.0f", egg.Name, p.X, p.Y, p.Z)
end

local function getNotifThreshold()
    local t = {
        Common = 1, Uncommon = 2, Rare = 3, Epic = 4,
        Legendary = 5, Mythic = 6, Divine = 7, Ethereal = 8, Secret = 9,
    }
    return t[Shared.RarityNotifThreshold or "Legendary"] or 5
end

local function getBestEggInMap()
    local rendered = Workspace:FindFirstChild("RenderedEggs")
    if not rendered then return nil end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local best, bestRank = nil, 0
    for _, egg in ipairs(rendered:GetChildren()) do
        if egg:IsA("Model") and isRaritySelected(egg.Name) then
            local rarity = getEggRarity(egg.Name)
            local rank = RARITY_ORDER[rarity] or 1
            local part = egg:FindFirstChildWhichIsA("BasePart", true)
            if part then
                local d = (part.Position - myRoot.Position).Magnitude
                if rank > bestRank or (rank == bestRank and (not best or d < best.dist)) then
                    best = {egg = egg, dist = d, rarity = rarity, rank = rank}
                    bestRank = rank
                end
            end
        end
    end
    return best
end

function Features.startAutoFarm()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.AutoFarm_Enabled then continue end

            local char = LocalPlayer.Character
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not myRoot or not hum or hum.Health <= 0 then
                task.wait(1)
                continue
            end

            local rendered = Workspace:FindFirstChild("RenderedEggs")
            if rendered then
                local validKeys = {}
                for _, egg in ipairs(rendered:GetChildren()) do
                    if egg:IsA("Model") then
                        validKeys[getEggKey(egg)] = true
                    end
                end
                for key in pairs(NotifiedEggs) do
                    if not validKeys[key] then NotifiedEggs[key] = nil end
                end
            end

            local best = getBestEggInMap()
            if not best then continue end

            local egg = best.egg
            local eggName = egg.Name
            local eggRarity = best.rarity
            local eggKey = getEggKey(egg)

            if (RARITY_ORDER[eggRarity] or 1) >= getNotifThreshold() then
                if not NotifiedEggs[eggKey] then
                    NotifiedEggs[eggKey] = true
                    if Shared.Notify then
                        Shared.Notify("🎯 " .. eggName .. " (" .. eggRarity .. ")", "success")
                    end
                end
            end

            local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
            if not eggPart then continue end

            local prompt = egg:FindFirstChild("Pickup", true)
            if prompt and prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end

            local picked = false

            if Shared.StealMode == "Fly" then
                picked = doStealFly(egg, prompt, eggPart)
            else
                myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 5, 0)
                task.wait(0.1)

                for i = 1, 10 do
                    if prompt and typeof(fireproximityprompt) == "function" then
                        pcall(fireproximityprompt, prompt)
                    end
                    task.wait(0.3)
                    if not isEggStillInMap(egg) then
                        picked = true
                        break
                    end
                    if eggPart and eggPart.Parent then
                        myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 5, 0)
                        task.wait(0.1)
                    end
                end
            end

            if picked and Shared.AutoReturn_Enabled then
                returnToMyPlot()
                task.wait(0.3)
            end

            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- HELPER: CEK HOLDING EGG
-- ============================================================
local function isHoldingEggMutation()
    local char = LocalPlayer.Character
    if not char then return false end
    local wooden = char:FindFirstChild("Wooden")
    if not wooden then return false end
    local displayEgg = wooden:FindFirstChild("DisplayEgg")
    if not displayEgg then return false end
    for _, c in ipairs(displayEgg:GetChildren()) do
        if c:IsA("MeshPart") and not c.Name:lower():find("circle") then
            return true, c.Name
        end
    end
    return false
end

-- ============================================================
-- VOLCANIC HUNTER
-- ============================================================
local VolcanicState = {
    Enabled = false,
    Hunting = false,
}

local VolcanicWaypoints = {
    Vector3.new(-4902.3, 41396.1, -3751.4),
    Vector3.new(-4908.1, 41365.0, -3742.9),
    Vector3.new(-4909.5, 41357.4, -3740.8),
    Vector3.new(-4923.0, 41299.5, -3719.6),
    Vector3.new(-4927.1, 41293.3, -3712.6),
    Vector3.new(-4951.4, 41287.6, -3669.6),
    Vector3.new(-4973.1, 41283.3, -3643.8),
    Vector3.new(-4995.2, 41285.0, -3620.6),
    Vector3.new(-5010.8, 41279.5, -3597.9),
    Vector3.new(-5020.6, 41275.2, -3582.6),
    Vector3.new(-5032.2, 41272.9, -3564.8),
    Vector3.new(-5062.9, 41262.1, -3542.1),
    Vector3.new(-5070.9, 41262.3, -3537.0),
    Vector3.new(-5079.4, 41265.2, -3533.3),
    Vector3.new(-5088.6, 41240.3, -3525.3),
    Vector3.new(-5096.8, 41228.7, -3520.1),
    Vector3.new(-5101.5, 41197.4, -3514.3),
    Vector3.new(-5103.3, 41165.1, -3511.6),
    Vector3.new(-5112.5, 41164.5, -3551.9),
    Vector3.new(-5157.0, 41159.7, -3588.1),
    Vector3.new(-5165.4, 41158.0, -3594.1),
    Vector3.new(-5211.0, 41150.0, -3569.9),
    Vector3.new(-5248.0, 41147.5, -3580.6),
    Vector3.new(-5256.8, 41143.1, -3581.9),
    Vector3.new(-5260.1, 41122.3, -3580.1),
    Vector3.new(-5268.7, 41062.3, -3575.5),
    Vector3.new(-5259.1, 41050.3, -3586.2),
    Vector3.new(-5269.5, 41047.7, -3640.0),
    Vector3.new(-5264.0, 41042.3, -3655.1),
    Vector3.new(-5218.7, 41023.5, -3659.7),
    Vector3.new(-5188.9, 41037.1, -3635.5),
    Vector3.new(-5147.5, 41037.4, -3589.8),
    Vector3.new(-5123.4, 41037.2, -3550.7),
    Vector3.new(-5123.0, 41033.8, -3503.2),
    Vector3.new(-5094.9, 41037.6, -3486.6),
    Vector3.new(-5081.6, 41035.8, -3474.5),
    Vector3.new(-5040.8, 41048.6, -3433.1),
    Vector3.new(-4990.3, 41050.6, -3391.9),
    Vector3.new(-4949.3, 41057.1, -3400.0),
    Vector3.new(-4908.1, 41036.5, -3439.7),
    Vector3.new(-4869.4, 41000.1, -3474.8),
    Vector3.new(-4880.2, 40975.6, -3528.0),
    Vector3.new(-4930.9, 40973.3, -3563.7),
    Vector3.new(-4966.2, 40960.4, -3610.8),
    Vector3.new(-5016.4, 40943.8, -3648.2),
    Vector3.new(-5072.8, 40929.0, -3667.8),
    Vector3.new(-5136.3, 40922.9, -3656.4),
    Vector3.new(-5151.8, 40914.2, -3681.0),
    Vector3.new(-5209.2, 40907.2, -3677.5),
    Vector3.new(-5267.7, 40907.3, -3651.2),
    Vector3.new(-5282.4, 40908.9, -3632.6),
    Vector3.new(-5270.4, 40907.1, -3619.5),
}

local function getVolcanicEgg()
    local rendered = Workspace:FindFirstChild("RenderedEggs")
    if not rendered then return nil end
    for _, egg in ipairs(rendered:GetChildren()) do
        if egg:IsA("Model") and egg.Name:lower():find("volcan", 1, true) then
            return egg
        end
    end
    return nil
end

local function getVolcanicSpawn()
    local spawns = Workspace:FindFirstChild("EggSpawns")
    if not spawns then return nil end
    local v = spawns:FindFirstChild("Volcanic")
    if v and v:IsA("BasePart") then return v end
    return nil
end

local function tpWaypoint(wp)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    root.CFrame = CFrame.new(wp + Vector3.new(0, 5, 0))
    root.Velocity = Vector3.zero
    root.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.12)
    return true
end

local function exitCave()
    if not isHoldingEggMutation() then return false end

    for i = #VolcanicWaypoints, 1, -1 do
        if not Shared.VolcanicHunt_Enabled then return false end

        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if not isHoldingEggMutation() then return false end

        tpWaypoint(VolcanicWaypoints[i])
    end

    task.wait(0.5)
    return isHoldingEggMutation()
end

local function volcanicPickupVerified(egg)
    if isHoldingEggMutation() then return true end
    if not egg or not egg.Parent then
        task.wait(0.3)
        return isHoldingEggMutation()
    end

    local part = egg:FindFirstChildWhichIsA("BasePart", true)
    if not part then
        task.wait(0.2)
        part = egg:FindFirstChildWhichIsA("BasePart", true)
        if not part then return isHoldingEggMutation() end
    end

    local prompt = egg:FindFirstChild("Pickup", true)
        or egg:FindFirstChild("Collect", true)
        or egg:FindFirstChildWhichIsA("ProximityPrompt", true)

    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = math.huge
        prompt.RequiresLineOfSight = false
    end

    for i = 1, 25 do
        if not Shared.VolcanicHunt_Enabled then return false end
        if isHoldingEggMutation() then return true end

        if not egg.Parent then
            task.wait(0.3)
            return isHoldingEggMutation()
        end

        local lastPos = part and part.Parent and part.Position or egg:GetPivot().Position
        local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if curRoot then
            curRoot.CFrame = CFrame.lookAt(lastPos + Vector3.new(0, 3, 0), lastPos)
            curRoot.Velocity = Vector3.zero
            curRoot.AssemblyLinearVelocity = Vector3.zero
        end

        if prompt and typeof(fireproximityprompt) == "function" then
            pcall(fireproximityprompt, prompt)
        end
        task.wait(0.1)
        if prompt and typeof(fireproximityprompt) == "function" then
            pcall(fireproximityprompt, prompt)
        end
        task.wait(0.25)
    end

    return isHoldingEggMutation()
end

function Features.startVolcanicHunt()
    task.spawn(function()
        while task.wait(1) do
            if not Shared.VolcanicHunt_Enabled then
                VolcanicState.Hunting = false
                continue
            end

            if VolcanicState.Hunting then continue end
            VolcanicState.Hunting = true

            task.spawn(function()
                while Shared.VolcanicHunt_Enabled do
                    local char = LocalPlayer.Character
                    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    if not myRoot or not hum or hum.Health <= 0 then
                        task.wait(1)
                        continue
                    end

                    local egg = getVolcanicEgg()
                    if not egg then
                        local spawnPart = getVolcanicSpawn()
                        if spawnPart then
                            local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if curRoot then
                                local d = (spawnPart.Position - curRoot.Position).Magnitude
                                if d > 50 then
                                    curRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
                                    curRoot.Velocity = Vector3.zero
                                end
                            end
                        end
                        task.wait(2)
                        continue
                    end

                    if Shared.Notify then
                        Shared.Notify("🌋 Volcanic Egg spawn!", "success")
                    end

                    local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
                    local reachedEgg = false
                    for i, wp in ipairs(VolcanicWaypoints) do
                        if not Shared.VolcanicHunt_Enabled then break end
                        tpWaypoint(wp)
                        local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if curRoot and eggPart and eggPart.Parent then
                            local d = (eggPart.Position - curRoot.Position).Magnitude
                            if d <= 40 then
                                reachedEgg = true
                                break
                            end
                        end
                    end

                    if not reachedEgg then
                        local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if curRoot and eggPart and eggPart.Parent then
                            curRoot.CFrame = CFrame.lookAt(eggPart.Position + Vector3.new(0, 3, 0), eggPart.Position)
                            curRoot.Velocity = Vector3.zero
                            task.wait(0.3)
                        end
                    end

                    local picked = false
                    if egg.Parent then
                        picked = volcanicPickupVerified(egg)
                    else
                        picked = isHoldingEggMutation()
                    end

                    if not picked or not isHoldingEggMutation() then
                        task.wait(2)
                        continue
                    end

                    local exited = exitCave()
                    if not exited or not isHoldingEggMutation() then
                        task.wait(2)
                        continue
                    end

                    if Shared.VolcanicMutation_Enabled then
                        task.wait(0.5)
                        local safePos = findSafeVolcanoPos()
                        if safePos then
                            local rootLava = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if rootLava then
                                rootLava.CFrame = CFrame.new(safePos)
                                rootLava.Velocity = Vector3.zero
                            end
                        end
                        task.wait(1.5)

                        if isHoldingEggMutation() then
                            local dropWaited = 0
                            local eggReleased = false
                            while dropWaited < 15 do
                                if not Shared.VolcanicHunt_Enabled then break end
                                fireVolcanoDip()
                                task.wait(1.5)
                                dropWaited = dropWaited + 1.5
                                if not isHoldingEggMutation() then
                                    eggReleased = true
                                    break
                                end
                            end

                            if eggReleased then
                                local waitStart = os.clock()
                                while os.clock() - waitStart < 20 do
                                    if not Shared.VolcanicHunt_Enabled then break end
                                    task.wait(1)
                                    if isHoldingEggMutation() then
                                        if Shared.Notify then
                                            Shared.Notify("🔥 Mutation selesai!", "success")
                                        end
                                        break
                                    end
                                end
                            end
                        end
                    end

                    if Shared.VolcanicReturn_Enabled then
                        task.wait(0.4)
                        local oldFlag = Shared.AutoReturn_Enabled
                        Shared.AutoReturn_Enabled = true
                        returnToMyPlot()
                        Shared.AutoReturn_Enabled = oldFlag
                    end

                    task.wait(3)
                end

                VolcanicState.Hunting = false
            end)
        end
    end)
end

-- ============================================================
-- AUTO MUTATION
-- ============================================================
local MutationState = {
    Running = false,
    StealPaused = false,
    BasketFull = false,
    EggLocked = false,
    LastFire = 0,
}

local MUT_CONFIG = {
    DROP_TIMEOUT = 15,
    RETURN_TIMEOUT = 13,
    TP_ABOVE_TOP = 200,
}

local NetModule = nil
task.spawn(function()
    local packages = game:GetService("ReplicatedStorage"):FindFirstChild("packages")
    if packages then
        local netMod = packages:FindFirstChild("Net")
        if netMod then
            local ok, result = pcall(require, netMod)
            if ok then
                NetModule = result
            end
        end
    end
end)

local function getVolcanoDipRemote()
    if NetModule then
        local ok, remote = pcall(function() return NetModule:RemoteEvent("VolcanoDip") end)
        if ok and remote then return remote end
    end
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    if gameR then
        local vd = gameR:FindFirstChild("VolcanoDip")
        if vd and vd:IsA("RemoteEvent") then return vd end
    end
    return nil
end

local function findSafeVolcanoPos()
    local volcano = Workspace:FindFirstChild("Volcano")
    if not volcano then
        return Vector3.new(-5102.84, 41700, -3489.11)
    end
    local bestTop, bestSize = nil, 0
    for _, d in ipairs(volcano:GetDescendants()) do
        if d:IsA("BasePart") then
            local n = d.Name:lower()
            if n:find("top") or n == "volcanotop" then
                local size = d.Size.X * d.Size.Z
                if size > bestSize then
                    bestTop = d
                    bestSize = size
                end
            end
        end
    end
    if bestTop then
        return bestTop.Position + Vector3.new(0, MUT_CONFIG.TP_ABOVE_TOP, 0)
    end
    local lavaTop = -math.huge
    for _, d in ipairs(volcano:GetDescendants()) do
        if d:IsA("BasePart") then
            local n = d.Name:lower()
            if n:find("lava") or n:find("magma") or n:find("volcan") then
                local top = d.Position.Y + d.Size.Y / 2
                if top > lavaTop then lavaTop = top end
            end
        end
    end
    if lavaTop > -math.huge then
        return Vector3.new(-5102.84, lavaTop + MUT_CONFIG.TP_ABOVE_TOP, -3489.11)
    end
    return Vector3.new(-5102.84, 41700, -3489.11)
end

local function fireVolcanoDip()
    local remote = getVolcanoDipRemote()
    if remote then
        local ok = pcall(function() remote:FireServer() end)
        if ok then return true end
    end
    return false
end

local function fireBasketDrop()
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    if not gameR then return false end
    local bd = gameR:FindFirstChild("BasketDrop")
    if not bd then return false end
    return pcall(function() bd:FireServer() end)
end

local function tpToSafe(pos)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end

    local highPos = pos + Vector3.new(0, 250, 0)
    myRoot.CFrame = CFrame.new(highPos)
    myRoot.Velocity = Vector3.zero
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.8)

    local root2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root2 then return false end
    root2.CFrame = CFrame.new(pos)
    root2.Velocity = Vector3.zero
    root2.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.5)

    local rootAfter = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rootAfter and rootAfter.Position.Y < pos.Y - 50 then
        rootAfter.CFrame = CFrame.new(pos + Vector3.new(0, 50, 0))
        task.wait(0.4)
    end

    return true
end

local function runMutationOnce()
    MutationState.Running = true

    local holding, eggName = isHoldingEggMutation()
    if not holding then
        MutationState.Running = false
        MutationState.EggLocked = false
        return false
    end

    MutationState.StealPaused = true
    task.wait(1.5)

    local safePos = findSafeVolcanoPos()
    tpToSafe(safePos)
    task.wait(2)

    local dropWaited = 0
    local eggReleased = false
    MutationState.LastFire = 0

    while dropWaited < MUT_CONFIG.DROP_TIMEOUT do
        if os.clock() - MutationState.LastFire > 2 then
            local ok = fireVolcanoDip()
            if not ok then fireBasketDrop() end
            MutationState.LastFire = os.clock()
        end
        task.wait(0.5)
        dropWaited = dropWaited + 0.5
        if not isHoldingEggMutation() then
            eggReleased = true
            break
        end
    end

    if not eggReleased then
        MutationState.Running = false
        MutationState.StealPaused = false
        MutationState.EggLocked = false
        return false
    end

    local retWaited = 0
    while retWaited < MUT_CONFIG.RETURN_TIMEOUT do
        task.wait(1)
        retWaited = retWaited + 1
        if isHoldingEggMutation() then break end
    end

    if Shared.MutationReturn_Enabled then
        task.wait(0.5)
        local oldFlag = Shared.AutoReturn_Enabled
        Shared.AutoReturn_Enabled = true
        returnToMyPlot()
        Shared.AutoReturn_Enabled = oldFlag
    end

    task.wait(2)
    MutationState.Running = false
    MutationState.StealPaused = false
    MutationState.EggLocked = false
    return true
end

function Features.startAutoMutation()
    task.spawn(function()
        while task.wait(1) do
            if not Shared.AutoMutation_Enabled then
                MutationState.Running = false
                continue
            end
            if MutationState.Running then continue end

            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                task.wait(1)
                continue
            end

            if isHoldingEggMutation() then
                pcall(runMutationOnce)
                task.wait(2)
            end
        end
    end)
end

function Features.getMutationState()
    return MutationState
end

function Features.isHoldingEgg()
    return isHoldingEggMutation()
end

-- ============================================================
-- MUTATION STEAL
-- ============================================================
function Features.startMutationSteal()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.MutationSteal_Enabled then continue end

            if Features.getMutationState and Features.getMutationState().Running then
                task.wait(1)
                continue
            end

            local char = LocalPlayer.Character
            local myRoot = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not myRoot or not hum or hum.Health <= 0 then
                task.wait(1)
                continue
            end

            if Features.isHoldingEgg and Features.isHoldingEgg() then
                task.wait(0.5)
                continue
            end

            local basket = LocalPlayer:FindFirstChild("Basket")
            if basket and #basket:GetChildren() > 0 then
                task.wait(0.5)
                continue
            end

            local stealMode = Shared.MutationStealMode or "Rarity"
            local targetEgg = nil

            if stealMode == "Name" then
                local rendered = Workspace:FindFirstChild("RenderedEggs")
                if rendered then
                    local myRoot2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local bestDist = math.huge
                    for _, egg in ipairs(rendered:GetChildren()) do
                        if egg:IsA("Model") and Shared.MutationSelectedEggs[egg.Name] then
                            local part = egg:FindFirstChildWhichIsA("BasePart", true)
                            if part and myRoot2 then
                                local d = (part.Position - myRoot2.Position).Magnitude
                                if d < bestDist then
                                    bestDist = d
                                    targetEgg = egg
                                end
                            end
                        end
                    end
                end
            else
                local best = getBestEggInMap()
                if best then targetEgg = best.egg end
            end

            if not targetEgg then
                task.wait(0.5)
                continue
            end

            local egg = targetEgg
            local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
            local prompt = egg:FindFirstChild("Pickup", true)
            if not eggPart or not prompt then continue end

            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end

            local picked = false

            if Shared.StealMode == "Fly" then
                picked = doStealFly(egg, prompt, eggPart)
            else
                myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
                task.wait(0.1)

                for i = 1, 15 do
                    if typeof(fireproximityprompt) == "function" then
                        pcall(fireproximityprompt, prompt)
                    end
                    task.wait(0.25)
                    if not isEggStillInMap(egg) then
                        picked = true
                        break
                    end
                    if eggPart and eggPart.Parent then
                        myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
                        task.wait(0.1)
                    end
                end
            end

            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- AUTO HATCH LUCK
-- ============================================================
local HatchLuckState = {
    Enabled = false,
    Mode = "Max",
    Cooldown = 2.0,
    LastClick = 0,
    MaxCount = 0,
    CicilCount = 0,
    LastError = nil,
}

local HatchLuckRS = game:GetService("ReplicatedStorage")
local HatchLuckRemoteCache = nil
local HatchLuckLastScan = 0

local function findHatchLuckRemotes()
    local found = {}
    for _, d in ipairs(HatchLuckRS:GetDescendants()) do
        if d:IsA("RemoteEvent") or d:IsA("RemoteFunction") then
            local n = d.Name:lower()
            if n:find("upgrade") or n:find("luck") or n:find("hatch") then
                table.insert(found, d)
            end
        end
    end
    return found
end

local function fireHatchLuckUpgrade(mode)
    if not HatchLuckRemoteCache or #HatchLuckRemoteCache == 0 or (os.clock() - HatchLuckLastScan) > 60 then
        HatchLuckRemoteCache = findHatchLuckRemotes()
        HatchLuckLastScan = os.clock()
    end

    if #HatchLuckRemoteCache == 0 then
        return false, "no remote found"
    end

    local payloads
    if mode == "Max" then
        payloads = {
            {"HatchLuck", "Max"},
            {"HatchLuck", true},
            {"HatchLuck", 0},
            {"MaxHatchLuck"},
            {"HatchLuckMax"},
            {"Upgrade", "HatchLuck", "Max"},
            {"Max"},
            {Action = "Max", Type = "HatchLuck"},
            {Type = "HatchLuck", Max = true},
        }
    else
        payloads = {
            {"HatchLuck"},
            {"HatchLuck", 1},
            {"Upgrade", "HatchLuck"},
            {Type = "HatchLuck"},
            {UpgradeType = "HatchLuck"},
        }
    end

    for _, remote in ipairs(HatchLuckRemoteCache) do
        for i, payload in ipairs(payloads) do
            pcall(function()
                if type(payload) == "table" and #payload > 0 then
                    remote:FireServer(table.unpack(payload))
                else
                    remote:FireServer(payload)
                end
            end)
            task.wait(0.05)
        end
    end

    return true, "fired"
end

function Features.startAutoHatchLuck()
    task.spawn(function()
        while task.wait(0.3) do
            if not HatchLuckState.Enabled then continue end
            if os.clock() - HatchLuckState.LastClick < HatchLuckState.Cooldown then continue end
            HatchLuckState.LastClick = os.clock()

            local ok, reason = fireHatchLuckUpgrade(HatchLuckState.Mode)
            if ok then
                if HatchLuckState.Mode == "Max" then
                    HatchLuckState.MaxCount = HatchLuckState.MaxCount + 1
                else
                    HatchLuckState.CicilCount = HatchLuckState.CicilCount + 1
                end
            else
                HatchLuckState.LastError = reason
            end
        end
    end)
end

function Features.getHatchLuckState()
    return HatchLuckState
end

function Features.setHatchLuckMode(mode)
    HatchLuckState.Mode = mode
    HatchLuckState.Cooldown = (mode == "Max") and 2.0 or 1.0
end

-- ============================================================
-- AUTO HALLOWEEN — AMBIL SEMUA PRIORITY TERTINGGI
-- ============================================================
local HalloweenState = {
    Enabled = false,
    Status = "⏸️ Idle",
    Claimed = 0,
    RareClaimed = 0,
    CandyTypes = {},
    CandyPriority = {},
}

local HalloweenCfg = {
    TP_STEP = 100,
    TP_HEIGHT = 5,
    TP_WAIT = 0.08,
    LOOP_WAIT = 0.3,
    CLAIM_WAIT = 0.5,
    RETURN_WAIT = 0.4,
}

-- Cari base Halloween
local function getHalloweenBase()
    local candidates = {
        "HalloweenHomeAnchor",
        "HalloweenBase",
        "HalloweenSpawn",
        "HalloweenBaseplate",
        "HalloweenStart",
    }

    for _, name in ipairs(candidates) do
        local part = Workspace:FindFirstChild(name, true)
        if part and part:IsA("BasePart") then
            return part
        end
    end

    local halloweenFolder = Workspace:FindFirstChild("Halloween")
    if halloweenFolder then
        local spawn = halloweenFolder:FindFirstChildWhichIsA("SpawnLocation", true)
        if spawn then return spawn end
        local bp = halloweenFolder:FindFirstChildWhichIsA("BasePart", true)
        if bp then return bp end
    end

    return nil
end

local function isInHalloweenZone()
    return LocalPlayer:GetAttribute("InHalloweenZone") == true
end

local function isCarryingCandy()
    return LocalPlayer:GetAttribute("CarriedCandyModel") ~= nil
end

local function getHalloweenRemote(name)
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    if not gameR then return nil end
    return gameR:FindFirstChild(name)
end

-- Scan semua candy yang enabled + ada priority
local function getHalloweenCandyList()
    local f = Workspace:FindFirstChild("HalloweenCandy")
    if not f then return {} end
    local list = {}
    for _, c in ipairs(f:GetChildren()) do
        if c:IsA("BasePart") and HalloweenState.CandyTypes[c.Name] then
            table.insert(list, c)
        end
    end
    -- Sort by priority DESC
    table.sort(list, function(a, b)
        local pa = HalloweenState.CandyPriority[a.Name] or 1
        local pb = HalloweenState.CandyPriority[b.Name] or 1
        return pa > pb
    end)
    return list
end

local function halloweenTpTo(pos)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    root.CFrame = CFrame.new(pos)
    root.Velocity = Vector3.zero
    root.AssemblyLinearVelocity = Vector3.zero
    return true
end

local function halloweenTpJumpTo(targetPos)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local startPos = root.Position
    local totalDist = (targetPos - startPos).Magnitude
    local steps = math.ceil(totalDist / HalloweenCfg.TP_STEP)
    if steps <= 1 then
        halloweenTpTo(targetPos + Vector3.new(0, HalloweenCfg.TP_HEIGHT, 0))
        task.wait(0.15)
        return true
    end
    local dir = (targetPos - startPos)
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude > 1 then
        dir = dir.Unit
    else
        local ang = math.random() * math.pi * 2
        dir = Vector3.new(math.cos(ang), 0, math.sin(ang))
    end
    for i = 1, steps do
        local dist = math.min(HalloweenCfg.TP_STEP * i, totalDist)
        local pos = startPos + dir * dist + Vector3.new(0, HalloweenCfg.TP_HEIGHT, 0)
        halloweenTpTo(pos)
        task.wait(HalloweenCfg.TP_WAIT)
    end
    return true
end

-- Balik ke base Halloween
local function halloweenReturnToBase()
    local base = getHalloweenBase()
    if not base then return false end
    halloweenTpJumpTo(base.Position)
    task.wait(HalloweenCfg.RETURN_WAIT)
    return true
end

local function halloweenClaimCandy(candy)
    if not candy or not candy.Parent then return false end
    local collectRemote = getHalloweenRemote("CollectCandy")
    local stateRemote = getHalloweenRemote("CandyState")
    if not collectRemote then return false end

    if isCarryingCandy() then return false end

    halloweenTpTo(candy.Position + Vector3.new(0, 2, 0))
    task.wait(0.3)

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local d = (root.Position - candy.Position).Magnitude
        if d > 30 then return false end
    end

    local spawnId = candy:GetAttribute("SpawnId") or candy.Name
    if stateRemote then
        pcall(function() stateRemote:FireServer(spawnId) end)
        task.wait(0.1)
    end

    pcall(function() collectRemote:FireServer(spawnId) end)
    task.wait(0.3)
    if isCarryingCandy() then return true end

    pcall(function() collectRemote:FireServer(candy) end)
    task.wait(0.3)
    return isCarryingCandy()
end

-- Masuk zona Halloween via portal
local function halloweenEnterZone()
    if isInHalloweenZone() then return true end

    local map = Workspace:FindFirstChild("Map")
    if map then
        local portal = map:FindFirstChild("Portal", true)
        if portal then
            local part = portal:FindFirstChildWhichIsA("BasePart", true)
            if part then
                halloweenTpTo(part.Position + Vector3.new(0, 5, 0))
                task.wait(0.5)

                local prompt = portal:FindFirstChild("HalloweenPortalPrompt", true)
                if prompt and prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                    prompt.MaxActivationDistance = math.huge
                    pcall(function()
                        if typeof(fireproximityprompt) == "function" then
                            fireproximityprompt(prompt)
                        end
                    end)
                    task.wait(1.5)
                end
            end
        end
    end

    return isInHalloweenZone()
end

-- MAIN LOOP
function Features.startAutoHalloween()
    task.spawn(function()
        while task.wait(HalloweenCfg.LOOP_WAIT) do
            if not HalloweenState.Enabled then
                HalloweenState.Status = "⏸️ Idle"
                continue
            end

            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then task.wait(1) continue end

            -- STEP 0: masuk area kalau belum
            if not isInHalloweenZone() then
                HalloweenState.Status = "🚪 Masuk area..."
                if not halloweenEnterZone() then
                    task.wait(2)
                    continue
                end
            end

            -- STEP 1: kalau lagi bawa candy, tunggu
            if isCarryingCandy() then
                HalloweenState.Status = "🎒 Bawa candy — nunggu proses..."
                task.wait(1)
                continue
            end

            -- STEP 2: scan candy
            local candies = getHalloweenCandyList()
            if #candies == 0 then
                HalloweenState.Status = "⏳ Nunggu candy spawn... (" .. HalloweenState.Claimed .. " claimed)"
                task.wait(2)
                continue
            end

            -- STEP 3: kumpulin SEMUA candy dengan priority tertinggi
            local bestPriority = HalloweenState.CandyPriority[candies[1].Name] or 1

            local topPriorityCandies = {}
            for _, c in ipairs(candies) do
                local p = HalloweenState.CandyPriority[c.Name] or 1
                if p == bestPriority then
                    table.insert(topPriorityCandies, c)
                end
            end

            if #topPriorityCandies == 0 then
                task.wait(0.5)
                continue
            end

            -- STEP 4: loop semua candy top priority — TP satu-satu
            HalloweenState.Status = string.format(
                "🍬 [P%d] %d candy prioritas tertinggi",
                bestPriority,
                #topPriorityCandies
            )

            for idx, candy in ipairs(topPriorityCandies) do
                if not HalloweenState.Enabled then break end
                if not candy or not candy.Parent then continue end
                if isCarryingCandy() then break end

                HalloweenState.Status = string.format(
                    "🍬 [P%d] %s (%d/%d) — %d sisa",
                    bestPriority,
                    candy.Name,
                    idx,
                    #topPriorityCandies,
                    #candies
                )

                halloweenTpJumpTo(candy.Position)
                task.wait(0.3)

                local ok = halloweenClaimCandy(candy)
                if ok then
                    HalloweenState.Claimed = HalloweenState.Claimed + 1
                    if candy.Name == "Candy_02" then
                        HalloweenState.RareClaimed = HalloweenState.RareClaimed + 1
                    end
                end

                task.wait(HalloweenCfg.CLAIM_WAIT)
            end

            -- STEP 5: balik ke base Halloween
            HalloweenState.Status = "🏠 Balik ke base Halloween..."
            halloweenReturnToBase()

            task.wait(HalloweenCfg.RETURN_WAIT)
        end
    end)
end

function Features.getHalloweenState()
    return HalloweenState
end

-- ============================================================
-- FEATURES.INIT
-- ============================================================
function Features.Init(sharedState)
    Shared = sharedState

    Features.startAntiAFK()

    Features.startEggESP()
    Features.startPetESP()
    Features.startAutoSteal()
    Features.startAutoHatch()
    Features.startAutoPlantEgg()
    Features.startAutoRidePet()
    Features.startEggPrediction()
    Features.startSpeed()
    Features.startInstantPickup()
    Features.startAutoFarm()
    Features.startVolcanicHunt()
    Features.startAutoMutation()
    Features.startMutationSteal()
    Features.startAutoHatchLuck()
    Features.startAutoHalloween()

    _G.VRILZ_Features = Features
    print("[VRILZHUB] Ride a Pet Features v3.8 loaded")
end

return Features
