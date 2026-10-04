-- ============================================================
-- VRILZHUB FEATURES — RIDE A PET v3.2
-- + Egg Prediction System + Notif Egg No Spawn
-- + Speed + Instant Pickup (HoldDuration=0) + Auto Farm
-- + Volcanic Hunter (auto detect + travel + pickup + return)
-- ============================================================

local Features = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

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
                                bb.Size = UDim2.fromOffset(160, 50)
                                bb.StudsOffset = Vector3.new(0, 3, 0)
                                bb.AlwaysOnTop = true
                                bb.MaxDistance = 500
                                bb.Adornee = eggPart
                                bb.Parent = eggPart

                                local lbl = Instance.new("TextLabel")
                                lbl.Name = "InfoLabel"
                                lbl.Size = UDim2.fromScale(1, 1)
                                lbl.BackgroundTransparency = 0.3
                                lbl.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                                lbl.TextColor3 = Color3.fromRGB(255, 215, 0)
                                lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                                lbl.TextStrokeTransparency = 0.3
                                lbl.Font = Enum.Font.GothamBold
                                lbl.TextSize = 12
                                lbl.TextWrapped = true
                                lbl.Text = ""
                                lbl.Parent = bb

                                local cnr = Instance.new("UICorner")
                                cnr.CornerRadius = UDim.new(0, 6)
                                cnr.Parent = lbl

                                local str = Instance.new("UIStroke")
                                str.Color = Color3.fromRGB(255, 215, 0)
                                str.Thickness = 1
                                str.Transparency = 0.3
                                str.Parent = lbl

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
                    data.lbl.Text = table.concat(parts, "\n")
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
                                        bb.Size = UDim2.fromOffset(180, 70)
                                        bb.StudsOffset = Vector3.new(0, 3.5, 0)
                                        bb.AlwaysOnTop = true
                                        bb.MaxDistance = 500
                                        bb.Adornee = petPart
                                        bb.Parent = petPart

                                        local lbl = Instance.new("TextLabel")
                                        lbl.Name = "InfoLabel"
                                        lbl.Size = UDim2.fromScale(1, 1)
                                        lbl.BackgroundTransparency = 0.3
                                        lbl.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
                                        lbl.TextColor3 = Color3.fromRGB(100, 200, 255)
                                        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
                                        lbl.TextStrokeTransparency = 0.3
                                        lbl.Font = Enum.Font.GothamBold
                                        lbl.TextSize = 12
                                        lbl.TextWrapped = true
                                        lbl.Text = ""
                                        lbl.Parent = bb

                                        local cnr = Instance.new("UICorner")
                                        cnr.CornerRadius = UDim.new(0, 6)
                                        cnr.Parent = lbl

                                        local str = Instance.new("UIStroke")
                                        str.Color = Color3.fromRGB(100, 200, 255)
                                        str.Thickness = 1
                                        str.Transparency = 0.3
                                        str.Parent = lbl

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
                    data.lbl.Text = table.concat(parts, "\n")
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
                local spawnPart = getMyPlotSpawn()
                if spawnPart then
                    myRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
                else
                    local spawn = Workspace:FindFirstChild("Spawn")
                    if spawn then
                        local spawnLoc = spawn:FindFirstChildWhichIsA("SpawnLocation", true)
                        if spawnLoc then
                            myRoot.CFrame = spawnLoc.CFrame + Vector3.new(0, 5, 0)
                        end
                    end
                end
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
-- AUTO FARM — TELEPORT → PICKUP → CEK → RETURN
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

local function returnToMyPlot()
    if not Shared.AutoReturn_Enabled then return end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local plot = getMyPlot()
    local spawnPart = nil
    if plot then
        spawnPart = plot:FindFirstChild("Spawn", true)
            or plot:FindFirstChildWhichIsA("SpawnLocation", true)
            or plot:FindFirstChild("Baseplate", true)
            or plot:FindFirstChildWhichIsA("BasePart", true)
    end
    if not spawnPart then
        local spawn = Workspace:FindFirstChild("Spawn")
        if spawn then
            spawnPart = spawn:FindFirstChildWhichIsA("SpawnLocation", true)
                or spawn:FindFirstChildWhichIsA("BasePart", true)
        end
    end
    if spawnPart then
        myRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
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

            myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 5, 0)
            task.wait(0.1)

            local picked = false
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

            if picked and Shared.AutoReturn_Enabled then
                returnToMyPlot()
                task.wait(0.3)
            end

            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- VOLCANIC HUNTER — Auto detect + travel + pickup + return
-- ============================================================
local VolcanicState = {
    Enabled = false,
    Hunting = false,
}

-- Waypoint dari rekaman (52 titik)
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

local function volcanicPickup(egg)
    local part = egg:FindFirstChildWhichIsA("BasePart", true)
    if not part then return false end
    local prompt = egg:FindFirstChild("Pickup", true)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
    end
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    myRoot.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    task.wait(0.1)
    for i = 1, 15 do
        if prompt and typeof(fireproximityprompt) == "function" then
            pcall(fireproximityprompt, prompt)
        end
        task.wait(0.2)
        if not egg.Parent then return true end
        if part and part.Parent then
            myRoot.CFrame = part.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)
        end
    end
    return false
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

                    if egg then
                        print("[VOLCANIC] ✅ Egg volcanic spawn! Travel & pickup...")
                        if Shared.Notify then
                            Shared.Notify("🌋 Volcanic Egg spawn!", "success")
                        end

                        local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
                        for i, wp in ipairs(VolcanicWaypoints) do
                            if not Shared.VolcanicHunt_Enabled then break end
                            if not egg.Parent then break end
                            local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if curRoot and eggPart then
                                local d = (eggPart.Position - curRoot.Position).Magnitude
                                if d <= 40 then break end
                            end
                            if curRoot then
                                curRoot.CFrame = CFrame.new(wp + Vector3.new(0, 5, 0))
                                curRoot.Velocity = Vector3.zero
                            end
                            task.wait(0.12)
                        end

if egg.Parent then
    local picked = volcanicPickup(egg)
    if picked then
        print("[VOLCANIC] ✅ Pickup berhasil!")

        -- ============================================
        -- STEP 5: KELUAR GOA (REVERSE WAYPOINT)
        -- ============================================
        print("[VOLCANIC] 🚶 Keluar goa via waypoint reverse...")
        for i = #VolcanicWaypoints, 1, -1 do
            if not Shared.VolcanicHunt_Enabled then break end
            local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if curRoot then
                curRoot.CFrame = CFrame.new(VolcanicWaypoints[i] + Vector3.new(0, 5, 0))
                curRoot.Velocity = Vector3.zero
            end
            task.wait(0.12)
        end
        print("[VOLCANIC] ✅ Keluar goa, di waypoint #1")

        -- ============================================
        -- STEP 6: TELEPORT KE LAVA
        -- ============================================
        task.wait(0.5)
        print("[VOLCANIC] 🔥 Teleport ke lava...")
        local safePos = findSafeVolcanoPos()
        if safePos then
            local rootLava = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootLava then
                rootLava.CFrame = CFrame.new(safePos)
                rootLava.Velocity = Vector3.zero
            end
        end
        task.wait(1.5)

        -- ============================================
        -- STEP 7: DROP EGG VIA VOLCANODIP
        -- ============================================
        print("[VOLCANIC] 💧 Drop egg via VolcanoDip...")
        local dropWaited = 0
        local eggReleased = false
        while dropWaited < 15 do
            if not Shared.VolcanicHunt_Enabled then break end
            fireVolcanoDip()
            task.wait(1.5)
            dropWaited = dropWaited + 1.5
            if not isHoldingEggMutation() then
                eggReleased = true
                print("[VOLCANIC] 💧 Egg dropped @ " .. dropWaited .. "s")
                break
            end
        end

        if not eggReleased then
            print("[VOLCANIC] ⚠️ Egg gak lepas (timeout), tetep return")
        end

        -- ============================================
        -- STEP 8: TUNGGU EGG BALIK (MUTATION SELESAI)
        -- ============================================
        if eggReleased then
            print("[VOLCANIC] ⏳ Nunggu egg balik...")
            local waitStart = os.clock()
            local eggBack = false
            while os.clock() - waitStart < 20 do
                if not Shared.VolcanicHunt_Enabled then break end
                task.wait(1)
                if isHoldingEggMutation() then
                    eggBack = true
                    print("[VOLCANIC] ✅ Egg balik! Mutation selesai!")
                    if Shared.Notify then
                        Shared.Notify("🔥 Mutation selesai!", "success")
                    end
                    break
                end
            end
            if not eggBack then
                print("[VOLCANIC] ⚠️ Egg gak balik (timeout), tetep return")
            end
        end

        -- ============================================
        -- STEP 9: RETURN KE PLOT (APAPUN KONDISI)
        -- ============================================
        if Shared.VolcanicReturn_Enabled then
            task.wait(0.4)
            print("[VOLCANIC] 🏠 Return ke plot")
            local plot = getMyPlot()
            if plot then
                local spawn = plot:FindFirstChild("Spawn", true)
                    or plot:FindFirstChildWhichIsA("SpawnLocation", true)
                    or plot:FindFirstChild("Baseplate", true)
                    or plot:FindFirstChildWhichIsA("BasePart", true)
                if spawn then
                    local root2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root2 then
                        root2.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
                        print("[VOLCANIC] 🏠 Balik ke plot")
                    end
                end
            else
                local spawnFallback = Workspace:FindFirstChild("Spawn")
                if spawnFallback then
                    local spawnLoc = spawnFallback:FindFirstChildWhichIsA("SpawnLocation", true)
                    if spawnLoc then
                        local root2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if root2 then
                            root2.CFrame = spawnLoc.CFrame + Vector3.new(0, 5, 0)
                            print("[VOLCANIC] 🏠 Balik ke plot (fallback)")
                        end
                    end
                end
            end
        end

        task.wait(3)
    end
end
                    else
                        local spawnPart = getVolcanicSpawn()
                        if spawnPart then
                            local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                            if curRoot then
                                local d = (spawnPart.Position - curRoot.Position).Magnitude
                                if d > 50 then
                                    curRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
                                    print("[VOLCANIC] 🚀 Teleport ke spawn point volcanic")
                                end
                            end
                        end
                    end

                    task.wait(2)
                end

                VolcanicState.Hunting = false
                print("[VOLCANIC] ⏹️ Hunt berhenti")
            end)
        end
    end)
end

-- ============================================================
-- AUTO MUTATION — KHUSUS TAB EGG MUTATION
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
                print("[MUTATION] Net module loaded")
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
    myRoot.CFrame = CFrame.new(pos)
    task.wait(0.3)
    local rootAfter = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rootAfter and rootAfter.Position.Y < pos.Y - 50 then
        print("[MUTATION] Kecebur! Retry TP...")
        rootAfter.CFrame = CFrame.new(pos + Vector3.new(0, 50, 0))
        task.wait(0.3)
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

    print("[MUTATION] holding " .. (eggName or "?") .. ", starting")

    MutationState.StealPaused = true
    task.wait(1.5)

    local safePos = findSafeVolcanoPos()
    print("[MUTATION] STEP 1 — TP ke lahar")
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
        local spawn = getMyPlotSpawn()
        if spawn then
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot then
                myRoot.CFrame = spawn.CFrame + Vector3.new(0, 5, 0)
                print("[MUTATION] Balik ke plot")
            end
        end
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
-- Gak nyentuh startAutoSteal yang asli
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

            myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)

            local picked = false
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

            if picked then
                print("[MUTATION-STEAL] picked " .. egg.Name .. " (" .. best.rarity .. ")")
            end

            task.wait(0.3)
        end
    end)
end

-- ============================================================
-- FEATURES.INIT
-- ============================================================
function Features.Init(sharedState)
    Shared = sharedState

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

    print("[VRILZHUB] Ride a Pet Features loaded")
end

return Features
