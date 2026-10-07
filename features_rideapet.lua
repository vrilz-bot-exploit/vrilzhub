-- ============================================================
-- VRILZHUB FEATURES — RIDE A PET v3.5
-- Auto Return: Drop 100 → Pickup ulang (WAJIB) → TP base
-- ============================================================

local Features = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- HATCH LUCK STATE
-- ============================================================
local HatchLuckState = {
    Enabled = false,
    Mode = "Max",
    Cooldown = 2.0,
    LastClick = 0,
    MaxCount = 0,
    CicilCount = 0,
}

-- ============================================================
-- ANTI-AFK — Cegah kick karena idle 20 menit
-- ============================================================
function Features.startAntiAFK()
    task.spawn(function()
        local VirtualUser = game:GetService("VirtualUser")
        local vu = game:GetService("VirtualUser")

        LocalPlayer.Idled:Connect(function()
            if Shared.AntiAFK_Enabled == false then return end
            pcall(function()
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
            print("[ANTI-AFK] Idle terdeteksi — activity dikirim")
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
-- FLY STEAL (BARU) — Naik 350 → TP ke egg
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

    print("[FLY] 🛫 Naik 350 studs")
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

    print("[FLY] ⚡ TP ke egg dari Y:", math.floor(myRoot.Position.Y))

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
-- EGG ESP (TRANSPARENT — NO BOX)
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
-- PET ESP (TRANSPARENT — NO BOX)
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

-- ============================================================
-- CEK EGG MASIH DI MAP
-- ============================================================
local function isEggStillInMap(egg)
    if not egg or not egg.Parent then return false end
    return true
end

-- ============================================================
-- AUTO STEAL + NOTIF "EGG NO SPAWN"
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
            local maxTries = 10
            for i = 1, maxTries do
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
        while task.wait(1) do
            if not Shared.AutoHatch_Enabled then continue end
            local plot = getMyPlot()
            if not plot then continue end
            local eggs = plot:FindFirstChild("Eggs")
            if not eggs then continue end
            for _, egg in ipairs(eggs:GetChildren()) do
                local prompt = egg:FindFirstChild("Hatch", true)
                if prompt and prompt.Enabled then
                    if typeof(fireproximityprompt) == "function" then
                        pcall(fireproximityprompt, prompt)
                    end
                end
            end
        end
    end)
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
-- EGG PREDICTION SYSTEM — SELALU JALAN
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
    if remote then
        remote:FireServer()
        return true
    end
    return false
end

function Features.petDismount()
    local remote = getRemote("PetDismount")
    if remote then
        remote:FireServer()
        return true
    end
    return false
end

function Features.pickupPet()
    local remote = getRemote("PickupPet")
    if remote then
        remote:FireServer()
        return true
    end
    return false
end

function Features.hatchEgg()
    local remote = getRemote("Hatch")
    if remote then
        remote:FireServer()
        return true
    end
    return false
end

-- ============================================================
-- GAMEDATA (EGGS + PETS)
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
-- INSTANT PICKUP — HoldDuration = 0
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

-- ============================================================
-- AUTO RETURN (FIX) — DROP 100 → PICKUP ULANG → TP BASE
-- ============================================================
local ReturnCfg = {
    DropDistanceFromPlot = 100,
    DropHeight = 5,
    DropWait = 0.3,
    DropSpamCount = 3,
    DropSpamInterval = 0.05,
    PostDropVerifyWait = 0.4,
    RePickupWait = 0.4,
    RePickupMaxTries = 50,
    RePickupScanRadius = 150,
    RePickupTPHeight = 3,
    RePickupRetryWait = 0.08,
    RePickupRetryRadii = { 150, 250, 400, 600 },
    BaseTPHeight = 5,
}

local function getMyPlotCenterPos()
    local plot = getMyPlot()
    if not plot then return nil end
    local bp = plot:FindFirstChild("Baseplate", true)
        or plot:FindFirstChild("BasePlate", true)
        or plot:FindFirstChildWhichIsA("SpawnLocation", true)
    if bp then return bp.Position end
    local ok, modelCF = pcall(function() return plot:GetBoundingBox() end)
    if ok and modelCF then return modelCF.Position end
    return nil
end

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

local function rePickupSameEgg(myRoot, dropPos, targetEggName, radius)
    if not dropPos then return false, "no dropPos", 0 end
    task.wait(ReturnCfg.RePickupWait)

    local tries = 0
    while tries < ReturnCfg.RePickupMaxTries do
        tries = tries + 1

        local holding, heldName = isHoldingEggLocal()
        if holding then
            return true, tostring(heldName), tries
        end

        local rendered = Workspace:FindFirstChild("RenderedEggs")
        if not rendered then
            task.wait(ReturnCfg.RePickupRetryWait)
            continue
        end

        local targetEgg = nil
        local targetDist = math.huge
        local closestEgg = nil
        local closestDist = math.huge

        for _, egg in ipairs(rendered:GetChildren()) do
            if egg:IsA("Model") then
                local part = egg:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    local d = (part.Position - dropPos).Magnitude

                    if d <= radius and d < closestDist then
                        closestEgg = egg
                        closestDist = d
                    end

                    if targetEggName and egg.Name == targetEggName then
                        if d <= radius and d < targetDist then
                            targetEgg = egg
                            targetDist = d
                        end
                    end
                end
            end
        end

        local pickEgg = targetEgg or closestEgg
        local pickDist = targetEgg and targetDist or closestDist

        if pickEgg then
            local eggPart = pickEgg:FindFirstChildWhichIsA("BasePart", true)
            local prompt = pickEgg:FindFirstChild("Pickup", true)
                or pickEgg:FindFirstChild("Collect", true)
                or pickEgg:FindFirstChildWhichIsA("ProximityPrompt", true)

            if eggPart and prompt then
                if prompt:IsA("ProximityPrompt") then
                    prompt.HoldDuration = 0
                end

                myRoot.CFrame = CFrame.lookAt(
                    eggPart.Position + Vector3.new(0, ReturnCfg.RePickupTPHeight, 0),
                    eggPart.Position)
                myRoot.Velocity = Vector3.zero
                myRoot.AssemblyLinearVelocity = Vector3.zero

                task.wait(0.05)

                if typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, prompt)
                end

                task.wait(0.08)

                local h, hn = isHoldingEggLocal()
                if h then
                    return true, tostring(hn), tries
                end

                if not pickEgg.Parent then
                    task.wait(0.15)
                    local h2, hn2 = isHoldingEggLocal()
                    if h2 then return true, tostring(hn2), tries end
                    return true, "picked-in-map", tries
                end
            end
        end

        task.wait(ReturnCfg.RePickupRetryWait)
    end

    return false, "not found", tries
end

local function returnToMyPlot()
    if not Shared.AutoReturn_Enabled then return end

    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local holding, heldEggName = isHoldingEggLocal()

    if holding and heldEggName then
        local plotCenter = getMyPlotCenterPos()
        if not plotCenter then return end

        local dir = (myRoot.Position - plotCenter)
        dir = Vector3.new(dir.X, 0, dir.Z)
        if dir.Magnitude < 1 then
            local ang = math.random() * math.pi * 2
            dir = Vector3.new(math.cos(ang), 0, math.sin(ang))
        else
            dir = dir.Unit
        end

        local dropPos = Vector3.new(
            plotCenter.X + dir.X * ReturnCfg.DropDistanceFromPlot,
            plotCenter.Y + ReturnCfg.DropHeight,
            plotCenter.Z + dir.Z * ReturnCfg.DropDistanceFromPlot
        )

        myRoot.CFrame = CFrame.new(dropPos)
        myRoot.Velocity = Vector3.zero
        myRoot.AssemblyLinearVelocity = Vector3.zero
        task.wait(ReturnCfg.DropWait)

        local dropRemote = getDropRemoteLocal()
        if dropRemote then
            for i = 1, ReturnCfg.DropSpamCount do
                pcall(function() dropRemote:FireServer() end)
                task.wait(ReturnCfg.DropSpamInterval)
            end
        end

        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("ProximityPrompt") and d.Name:lower():find("drop") then
                d.HoldDuration = 0
                if typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, d)
                end
            end
        end

        task.wait(ReturnCfg.PostDropVerifyWait)

        if isHoldingEggLocal() then
            for i = 1, 5 do
                if dropRemote then
                    pcall(function() dropRemote:FireServer() end)
                end
                task.wait(0.1)
                if not isHoldingEggLocal() then break end
            end
        end

        local reOk, reName, reTries = rePickupSameEgg(myRoot, dropPos, heldEggName, ReturnCfg.RePickupScanRadius)

        if not reOk then
            for i, radius in ipairs(ReturnCfg.RePickupRetryRadii) do
                if reOk then break end
                task.wait(0.4)
                reOk, reName, reTries = rePickupSameEgg(myRoot, dropPos, heldEggName, radius)
            end
        end

        if not reOk or not isHoldingEggLocal() then            print("[RETURN] Pickup ulang gagal — skip TP base")
            return
        end

        print("[RETURN] Pickup ulang OK: " .. tostring(reName))
    end

    if not isHoldingEggLocal() then
        return
    end

    local spawnPart = getMyPlotSpawn()
    if not spawnPart then
        local spawn = Workspace:FindFirstChild("Spawn")
        if spawn then
            spawnPart = spawn:FindFirstChildWhichIsA("SpawnLocation", true)
                or spawn:FindFirstChildWhichIsA("BasePart", true)
        end
    end

    if spawnPart then
        local rootFinal = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if rootFinal then
            rootFinal.CFrame = spawnPart.CFrame + Vector3.new(0, ReturnCfg.BaseTPHeight, 0)
            rootFinal.Velocity = Vector3.zero
            rootFinal.AssemblyLinearVelocity = Vector3.zero
            print("[RETURN] TP base OK")
        end
    end
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
            if not best then
                continue
            end

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

                local maxTries = 10
                for i = 1, maxTries do
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
-- SHARED HELPERS — dipakai Volcanic Hunt & Auto Mutation
-- ============================================================

local NetModule = nil
task.spawn(function()
    local packages = game:GetService("ReplicatedStorage"):FindFirstChild("packages")
    if packages then
        local netMod = packages:FindFirstChild("Net")
        if netMod then
            local ok, result = pcall(require, netMod)
            if ok then
                NetModule = result
                print("[SHARED] Net module loaded")
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

local function isHoldingEggMutation()
    local char = LocalPlayer.Character
    if not char then return false, nil end

    local wooden = char:FindFirstChild("Wooden")
    if wooden then
        local displayEgg = wooden:FindFirstChild("DisplayEgg")
        if displayEgg then
            for _, c in ipairs(displayEgg:GetChildren()) do
                if (c:IsA("MeshPart") or c:IsA("Part") or c:IsA("UnionOperation"))
                   and not c.Name:lower():find("circle")
                   and c.Transparency < 1 then
                    return true, c.Name
                end
            end
        end
        for _, c in ipairs(wooden:GetChildren()) do
            if (c:IsA("MeshPart") or c:IsA("Part"))
               and not c.Name:lower():find("circle")
               and c.Transparency < 1 then
                return true, c.Name
            end
        end
    end

    for _, c in ipairs(char:GetDescendants()) do
        if (c:IsA("MeshPart") or c:IsA("Part") or c:IsA("UnionOperation"))
           and c.Name:lower():find("egg")
           and c.Transparency < 1
           and c ~= char:FindFirstChild("HumanoidRootPart") then
            return true, c.Name
        end
    end

    local heldEgg = char:GetAttribute("HeldEgg")
    if heldEgg and heldEgg ~= "" then
        return true, tostring(heldEgg)
    end

    return false, nil
end

local function fireVolcanoDip()
    local remote = getVolcanoDipRemote()
    if remote then
        local ok = pcall(function() remote:FireServer() end)
        if ok then
            print("[MUTATION] Drop: VolcanoDip fired")
            return true
        end
    end
    return false
end

local function findSafeVolcanoPos()
    local volcano = Workspace:FindFirstChild("Volcano")
    if not volcano then
        return Vector3.new(-5102.84, 41396.1, -3489.11)
    end

    local bestLava, bestScore = nil, -math.huge
    for _, d in ipairs(volcano:GetDescendants()) do
        if d:IsA("BasePart") then
            local n = d.Name:lower()
            if n:find("lava") or n:find("magma") then
                local top = d.Position.Y + d.Size.Y / 2
                if top > bestScore then
                    bestLava = d
                    bestScore = top
                end
            end
        end
    end
    if bestLava then
        return bestLava.Position + Vector3.new(0, bestLava.Size.Y / 2 + 15, 0)
    end

    local bestTop, bestSize = nil, 0
    for _, d in ipairs(volcano:GetDescendants()) do
        if d:IsA("BasePart") then
            local n = d.Name:lower()
            if n:find("top") then
                local size = d.Size.X * d.Size.Z
                if size > bestSize then
                    bestTop = d
                    bestSize = size
                end
            end
        end
    end
    if bestTop then
        return bestTop.Position + Vector3.new(0, bestTop.Size.Y / 2 + 15, 0)
    end

    return Vector3.new(-5102.84, 41396.1, -3489.11)
end

local function tpToSafe(targetPos)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end

    local highPos = targetPos + Vector3.new(0, 200, 0)
    myRoot.CFrame = CFrame.new(highPos)
    myRoot.Velocity = Vector3.zero
    myRoot.AssemblyLinearVelocity = Vector3.zero
    print("[MUTATION] TP step 1 — ke atas (render)")
    task.wait(0.8)

    local root2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root2 then return false end
    root2.CFrame = CFrame.new(targetPos)
    root2.Velocity = Vector3.zero
    root2.AssemblyLinearVelocity = Vector3.zero
    print("[MUTATION] TP step 2 — ke target Y: " .. math.floor(targetPos.Y))
    task.wait(0.5)

    local rootAfter = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rootAfter and rootAfter.Position.Y < targetPos.Y - 50 then
        print("[MUTATION] Kecebur! Retry TP...")
        rootAfter.CFrame = CFrame.new(targetPos + Vector3.new(0, 30, 0))
        task.wait(0.4)
    end

    return true
end

-- ============================================================
-- VOLCANIC HUNTER (FIXED v7 — REAL FIX)
-- ============================================================

local VolcanicState = {
    Enabled = false,
    Hunting = false,
    ThreadId = 0,
}

local VolcanicWaypoints = {
    Vector3.new(-4902.3, 41396.1, -3751.4),
    Vector3.new(-4923.0, 41299.5, -3719.6),
    Vector3.new(-4973.1, 41283.3, -3643.8),
    Vector3.new(-5020.6, 41275.2, -3582.6),
    Vector3.new(-5062.9, 41262.1, -3542.1),
    Vector3.new(-5096.8, 41228.7, -3520.1),
    Vector3.new(-5103.3, 41165.1, -3511.6),
    Vector3.new(-5157.0, 41159.7, -3588.1),
    Vector3.new(-5248.0, 41147.5, -3580.6),
    Vector3.new(-5260.1, 41122.3, -3580.1),
    Vector3.new(-5259.1, 41050.3, -3586.2),
    Vector3.new(-5218.7, 41023.5, -3659.7),
    Vector3.new(-5123.4, 41037.2, -3550.7),
    Vector3.new(-5081.6, 41035.8, -3474.5),
    Vector3.new(-4990.3, 41050.6, -3391.9),
    Vector3.new(-4880.2, 40975.6, -3528.0),
    Vector3.new(-4966.2, 40960.4, -3610.8),
    Vector3.new(-5072.8, 40929.0, -3667.8),
    Vector3.new(-5151.8, 40914.2, -3681.0),
    Vector3.new(-5267.7, 40907.3, -3651.2),
    Vector3.new(-5270.4, 40907.1, -3619.5),
}

local function getVolcanicEgg()
    local candidates = {}

    local rendered = Workspace:FindFirstChild("RenderedEggs")
    if rendered then
        for _, egg in ipairs(rendered:GetChildren()) do
            if egg:IsA("Model") and egg.Name:lower():find("volcan", 1, true) then
                table.insert(candidates, egg)
            end
        end
    end

    local spawns = Workspace:FindFirstChild("EggSpawns")
    if spawns then
        for _, egg in ipairs(spawns:GetChildren()) do
            if egg:IsA("Model") and egg.Name:lower():find("volcan", 1, true) then
                table.insert(candidates, egg)
            end
            if egg.Name:lower() == "volcanic" then
                for _, sub in ipairs(egg:GetChildren()) do
                    if sub:IsA("Model") and sub.Name:lower():find("egg") then
                        table.insert(candidates, sub)
                    end
                end
            end
        end
    end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local best, bestDist = nil, math.huge
    for _, egg in ipairs(candidates) do
        local part = egg:FindFirstChildWhichIsA("BasePart", true)
        if part and myRoot then
            local d = (part.Position - myRoot.Position).Magnitude
            if d < bestDist then
                best, bestDist = egg, d
            end
        elseif part then
            best = egg
            break
        end
    end

    return best
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
    task.wait(0.1)
    return true
end

local function exitCave()
    print("[VOLCANIC] Keluar goa via waypoint reverse...")
    for i = #VolcanicWaypoints, 1, -1 do
        if not Shared.VolcanicHunt_Enabled then return false end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false end
        if not isHoldingEggMutation() then
            print("[VOLCANIC] ⚠️ Egg hilang di tengah jalan keluar goa!")
            return false
        end
        tpWaypoint(VolcanicWaypoints[i])
    end
    print("[VOLCANIC] Keluar goa OK")
    return true
end

local function volcanicPickupVerified(egg)
    local part = egg:FindFirstChildWhichIsA("BasePart", true)
    if not part then return false end

    local prompt = egg:FindFirstChild("Pickup", true)
        or egg:FindFirstChild("Collect", true)
        or egg:FindFirstChildWhichIsA("ProximityPrompt", true)

    if not prompt then
        print("[VOLCANIC] ⚠️ Prompt gak ketemu!")
        return false
    end

    if prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
        prompt.Enabled = true
        prompt.MaxActivationDistance = math.huge
        prompt.RequiresLineOfSight = false
    end

    local lastPos = part.Position

    for i = 1, 30 do
        if not Shared.VolcanicHunt_Enabled then return false end

        local holding = isHoldingEggMutation()
        if holding then
            print("[VOLCANIC] ✅ Verified holding @ try " .. i)
            return true
        end

        if not egg.Parent then
            task.wait(0.3)
            if isHoldingEggMutation() then
                print("[VOLCANIC] Egg hilang & holding OK")
                return true
            end
        end

        if part and part.Parent then
            lastPos = part.Position
        end

        local curChar = LocalPlayer.Character
        local curRoot = curChar and curChar:FindFirstChild("HumanoidRootPart")
        local curHum = curChar and curChar:FindFirstChildOfClass("Humanoid")
        if curRoot then
            curRoot.CFrame = CFrame.lookAt(
                lastPos + Vector3.new(0, 3, 0),
                lastPos)
            curRoot.Velocity = Vector3.zero
            curRoot.AssemblyLinearVelocity = Vector3.zero
            if curHum then
                pcall(function()
                    curHum:MoveTo(lastPos + Vector3.new(0, 3, 0))
                end)
            end
        end

        if typeof(fireproximityprompt) == "function" then
            for k = 1, 3 do
                pcall(fireproximityprompt, prompt)
                task.wait(0.05)
            end
        end

        if not isHoldingEggMutation() then
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            local gameR = remotes and remotes:FindFirstChild("Game")
            if gameR then
                local pickupRemote = gameR:FindFirstChild("PickupEgg") or gameR:FindFirstChild("CollectEgg")
                if pickupRemote and pickupRemote:IsA("RemoteEvent") then
                    pcall(function() pickupRemote:FireServer(egg) end)
                end
            end
        end

        task.wait(0.15)
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
            VolcanicState.ThreadId = VolcanicState.ThreadId + 1
            local myThreadId = VolcanicState.ThreadId

            task.spawn(function()
                while Shared.VolcanicHunt_Enabled and VolcanicState.ThreadId == myThreadId do
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
                                    print("[VOLCANIC] TP ke spawn point")
                                end
                            end
                        end
                        task.wait(2)
                        continue
                    end

                    print("[VOLCANIC] 🎯 Egg volcanic spawn! Mulai hunt...")
                    if Shared.Notify then
                        Shared.Notify("🌋 Volcanic Egg spawn!", "success")
                    end

                    print("[VOLCANIC] STEP 1 — Masuk goa...")
                    local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
                    for i, wp in ipairs(VolcanicWaypoints) do
                        if not Shared.VolcanicHunt_Enabled then break end
                        if VolcanicState.ThreadId ~= myThreadId then break end

                        local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if curRoot and eggPart and eggPart.Parent then
                            local d = (eggPart.Position - curRoot.Position).Magnitude
                            if d <= 25 then break end
                        end
                        tpWaypoint(wp)
                    end

                    print("[VOLCANIC] STEP 2 — Pickup egg...")
                    local picked = false
                    if egg.Parent then
                        picked = volcanicPickupVerified(egg)
                    else
                        picked = isHoldingEggMutation()
                    end

                    if not picked or not isHoldingEggMutation() then
                        print("[VOLCANIC] ❌ Gagal pickup — skip")
                        task.wait(2)
                        continue
                    end
                    print("[VOLCANIC] ✅ Pickup OK — Holding egg")

                    print("[VOLCANIC] STEP 3 — Keluar goa...")
                    local exited = exitCave()

                    if not exited then
                        print("[VOLCANIC] ⚠️ Gagal keluar goa — skip")
                        task.wait(2)
                        continue
                    end

                    if not isHoldingEggMutation() then
                        print("[VOLCANIC] ⚠️ Egg hilang setelah keluar goa — skip")
                        task.wait(2)
                        continue
                    end

                    if Shared.VolcanicMutation_Enabled then
                        print("[VOLCANIC] STEP 4 — Auto Mutation ON")

                        task.wait(0.5)
                        local lavaPos = findSafeVolcanoPos()
                        print("[VOLCANIC] TP ke lava surface Y: " .. math.floor(lavaPos.Y))
                        tpToSafe(lavaPos)
                        task.wait(1.5)

                        if not isHoldingEggMutation() then
                            print("[VOLCANIC] ⚠️ Egg hilang sebelum drop")
                        else
                            print("[VOLCANIC] Drop egg via VolcanoDip...")
                            local dropWaited = 0
                            local eggReleased = false
                            while dropWaited < 15 do
                                if not Shared.VolcanicHunt_Enabled then break end
                                if VolcanicState.ThreadId ~= myThreadId then break end

                                fireVolcanoDip()
                                task.wait(1.5)
                                dropWaited = dropWaited + 1.5

                                if not isHoldingEggMutation() then
                                    eggReleased = true
                                    print("[VOLCANIC] Egg dropped @ " .. dropWaited .. "s")
                                    break
                                end
                            end

                            if not eggReleased then
                                print("[VOLCANIC] ⚠️ Egg gak lepas (timeout)")
                            else
                                print("[VOLCANIC] Nunggu egg balik...")
                                local waitStart = os.clock()
                                local eggBack = false
                                while os.clock() - waitStart < 20 do
                                    if not Shared.VolcanicHunt_Enabled then break end
                                    if VolcanicState.ThreadId ~= myThreadId then break end
                                    task.wait(1)
                                    if isHoldingEggMutation() then
                                        eggBack = true
                                        print("[VOLCANIC] 🔥 Egg balik! Mutation selesai!")
                                        if Shared.Notify then
                                            Shared.Notify("🔥 Mutation selesai!", "success")
                                        end
                                        break
                                    end
                                end
                                if not eggBack then
                                    print("[VOLCANIC] ⚠️ Egg gak balik (timeout)")
                                end
                            end
                        end
                    else
                        print("[VOLCANIC] STEP 4 — Auto Mutation OFF, skip")
                    end

                    if Shared.VolcanicReturn_Enabled then
                        task.wait(0.4)
                        print("[VOLCANIC] STEP 5 — Return ke plot")
                        local oldFlag = Shared.AutoReturn_Enabled
                        Shared.AutoReturn_Enabled = true
                        returnToMyPlot()
                        Shared.AutoReturn_Enabled = oldFlag
                    else
                        print("[VOLCANIC] STEP 5 — Return OFF, skip")
                    end

                    task.wait(3)
                end

                VolcanicState.Hunting = false
                print("[VOLCANIC] Hunt berhenti")
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

-- NetModule, getVolcanoDipRemote, isHoldingEggMutation,
-- fireVolcanoDip, findSafeVolcanoPos, tpToSafe
-- SUDAH DIDEfinisikan di SHARED HELPERS (di atas Volcanic Hunt)
-- Jadi DI SINI GAK PERLU didefinisikan lagi.

local function fireBasketDrop()
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    if not gameR then return false end
    local bd = gameR:FindFirstChild("BasketDrop")
    if not bd then return false end
    return pcall(function() bd:FireServer() end)
end

local function runMutationOnce()
    MutationState.Running = true

    local holding, eggName = isHoldingEggMutation()
    if not holding then
        MutationState.Running = false
        MutationState.EggLocked = false
        return false
    end

    print("[MUTATION] holding " .. (eggName or "?") .. ", starting")

    MutationState.StealPaused = true
    task.wait(1.5)

    local safePos = findSafeVolcanoPos()
    print("[MUTATION] STEP 1 — TP ke lahar (2-step)")
    tpToSafe(safePos)
    task.wait(2)

    print("[MUTATION] STEP 2 — drop via VolcanoDip")
    local dropWaited = 0
    local eggReleased = false
    MutationState.LastFire = 0

    while dropWaited < MUT_CONFIG.DROP_TIMEOUT do
        if os.clock() - MutationState.LastFire > 2 then
            local ok = fireVolcanoDip()
            if not ok then fireBasketDrop() end
            MutationState.LastFire = os.clock()
            print("[MUTATION] fired @ " .. dropWaited .. "s")
        end
        task.wait(0.5)
        dropWaited = dropWaited + 0.5
        if not isHoldingEggMutation() then
            eggReleased = true
            print("[MUTATION] egg LEPAS @ " .. dropWaited .. "s")
            break
        end
    end

    if not eggReleased then
        print("[MUTATION] egg GAK LEPAS")
        MutationState.Running = false
        MutationState.StealPaused = false
        MutationState.EggLocked = false
        return false
    end

    print("[MUTATION] STEP 3 — tunggu egg balik")
    local retWaited = 0
    while retWaited < MUT_CONFIG.RETURN_TIMEOUT do
        task.wait(1)
        retWaited = retWaited + 1
        if isHoldingEggMutation() then
            print("[MUTATION] egg BALIK @ " .. retWaited .. "s")
            break
        end
        if retWaited % 5 == 0 then
            print("[MUTATION] waiting... " .. retWaited .. "s")
        end
    end

    if Shared.MutationReturn_Enabled then
        task.wait(0.5)
        print("[MUTATION] STEP 4 — Return ke plot (drop + pickup + TP)")
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
                print("[MUTATION] egg held, starting")
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
-- MUTATION STEAL — KHUSUS TAB EGG MUTATION (by RARITY)
-- ============================================================
function Features.startMutationSteal()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.MutationSteal_Enabled then continue end

            if Features.hasVolcanicEgg and Features.hasVolcanicEgg() then
                task.wait(1)
                continue
            end
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

            local best = getBestEggInMap()
            if not best then
                task.wait(0.5)
                continue
            end

            local egg = best.egg
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

            if picked then
                print("[MUTATION-STEAL] picked " .. egg.Name .. " (" .. best.rarity .. ")")
            end

            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- AUTO HATCH LUCK — JARAK JAUH (FIRE REMOTE LANGSUNG)
-- ============================================================
local HatchLuckRS = game:GetService("ReplicatedStorage")

local function getHatchLuckRemote()
    local remotes = HatchLuckRS:FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    local plotR = gameR and gameR:FindFirstChild("Plot")
    return plotR and plotR:FindFirstChild("Upgrades")
end

local function fireHatchLuckUpgrade(mode)
    local remote = getHatchLuckRemote()
    if not remote then
        return false, "remote gak ada"
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

    for i, payload in ipairs(payloads) do
        local ok = pcall(function()
            if type(payload) == "table" and #payload > 0 then
                remote:FireServer(table.unpack(payload))
            else
                remote:FireServer(payload)
            end
        end)
        if ok then
            task.wait(0.1)
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
                    print("[HATCH LUCK] ⚡ MAX fired #" .. HatchLuckState.MaxCount)
                else
                    HatchLuckState.CicilCount = HatchLuckState.CicilCount + 1
                    print("[HATCH LUCK] 🔄 CICIL fired #" .. HatchLuckState.CicilCount)
                end
            else
                print("[HATCH LUCK] ❌ " .. reason)
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
-- FEATURES.INIT
-- ============================================================
function Features.Init(sharedState)
    Shared = sharedState

    Features.startAntiAFK()

    Features.startEggESP()
    Features.startPetESP()
    Features.startAutoSteal()
    Features.startAutoHatch()
    Features.startAutoRidePet()
    Features.startEggPrediction()
    Features.startSpeed()
    Features.startInstantPickup()
    Features.startAutoFarm()
    Features.startVolcanicHunt()
    Features.startAutoMutation()
    Features.startMutationSteal()
    Features.startAutoHatchLuck()

    _G.VRILZ_Features = Features
    print("[VRILZHUB] Ride a Pet Features v3.5 loaded")
end

return Features
