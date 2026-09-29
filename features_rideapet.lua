-- ============================================================
-- VRILZHUB FEATURES — RIDE A PET v4.0
-- + Speed + Auto Farm by Rarity + Instant Pickup + Notif Once
-- ============================================================

local Features = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- LOAD GAMEDATA (EGGS + PETS + RARITY)
-- ============================================================
local GameData = ReplicatedStorage:FindFirstChild("GameData")
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

local function getPetRarity(petName)
    local info = PetData[petName]
    return info and info.Rarity or "Common"
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
-- GET MY PLOT (FIX: pakai NestsOwnerLoaded)
-- ============================================================
local function getMyPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:GetAttribute("NestsOwnerLoaded") == LocalPlayer.UserId then
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
        or plot:FindFirstChildWhichIsA("BasePart", true)
    return spawnPart
end

-- ============================================================
-- GAME REMOTE HELPER
-- ============================================================
local function getGameRemote(name)
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    local gameRemotes = remotes:FindFirstChild("Game")
    if not gameRemotes then return nil end
    return gameRemotes:FindFirstChild(name)
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
                Features.setSpeed(Shared.Speed_Value or 50)
            end
        end
    end)
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
-- INSTANT PICKUP (SKIP PROMPT)
-- ============================================================
function Features.instantPickup(egg)
    local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not eggPart or not root then return false end

    root.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)

    local remote = getGameRemote("EggPickup")
    if remote then
        pcall(function() remote:FireServer(egg) end)
        return true
    end

    local prompt = egg:FindFirstChild("Pickup", true)
    if prompt and typeof(fireproximityprompt) == "function" then
        pcall(fireproximityprompt, prompt)
        return true
    end
    return false
end

-- ============================================================
-- AUTO STEAL (LEGACY - masih dipakai kalau toggle lama)
-- ============================================================
local lastNoEggNotif = 0

function Features.startAutoSteal()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.AutoSteal_Enabled then continue end

            local eggName = Shared.SelectedEgg or "Cherub Egg"
            local egg = findEggByName(eggName)

            if not egg then continue end

            local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
            local prompt = egg:FindFirstChild("Pickup", true)
            if not eggPart or not prompt then continue end

            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not myRoot then continue end

            myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)

            if typeof(fireproximityprompt) == "function" then
                pcall(fireproximityprompt, prompt)
            end
            task.wait(0.2)

            if Shared.AutoReturn_Enabled then
                local spawnPart = getMyPlotSpawn()
                if spawnPart then
                    myRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
                end
            end
        end
    end)
end

-- ============================================================
-- AUTO FARM v3 — BY RARITY, RETURN FIRST, NOTIF SEKALI
-- ============================================================
local NotifiedEggs = {}

local function getEggKey(egg)
    local part = egg:FindFirstChildWhichIsA("BasePart", true)
    if not part then return egg.Name end
    local p = part.Position
    return string.format("%s_%.0f_%.0f_%.0f", egg.Name, p.X, p.Y, p.Z)
end

local function getNotifThreshold()
    local thresholds = {
        Common = 1, Uncommon = 2, Rare = 3, Epic = 4,
        Legendary = 5, Mythic = 6, Divine = 7, Ethereal = 8, Secret = 9,
    }
    return thresholds[Shared.RarityNotifThreshold or "Legendary"] or 5
end

local function isRaritySelected(eggName)
    local rarity = getEggRarity(eggName)
    if not Shared.SelectedRarities then return false end
    return Shared.SelectedRarities[rarity] == true
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
    local spawnPart = plot and (
        plot:FindFirstChild("Spawn", true)
        or plot:FindFirstChildWhichIsA("SpawnLocation", true)
        or plot:FindFirstChildWhichIsA("BasePart", true)
    )
    if spawnPart then
        myRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
    end
end

function Features.startAutoFarm()
    task.spawn(function()
        while task.wait(0.4) do
            if not Shared.AutoFarm_Enabled then continue end

            -- Cleanup NotifiedEggs: hapus key yang egg-nya udah gak ada
            local rendered = Workspace:FindFirstChild("RenderedEggs")
            if rendered then
                local validKeys = {}
                for _, egg in ipairs(rendered:GetChildren()) do
                    if egg:IsA("Model") then
                        validKeys[getEggKey(egg)] = true
                    end
                end
                for key in pairs(NotifiedEggs) do
                    if not validKeys[key] then
                        NotifiedEggs[key] = nil
                    end
                end
            end

            local best = getBestEggInMap()

            -- Kalau gak ada egg target → DIAM
            if not best then continue end

            local egg = best.egg
            local eggName = egg.Name
            local eggRarity = best.rarity
            local eggKey = getEggKey(egg)

            -- Notif SEKALI AJA per egg (khusus rarity ≥ threshold)
            if (RARITY_ORDER[eggRarity] or 1) >= getNotifThreshold() then
                if not NotifiedEggs[eggKey] then
                    NotifiedEggs[eggKey] = true
                    if Shared.Notify then
                        Shared.Notify("🎯 " .. eggName .. " (" .. eggRarity .. ")", "success")
                    end
                end
            end

            -- Teleport ke egg
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
            if not myRoot or not eggPart then continue end

            myRoot.CFrame = eggPart.CFrame + Vector3.new(0, 3, 0)
            task.wait(0.1)

            -- Instant pickup
            Features.instantPickup(egg)
            task.wait(0.15)

            -- Return ke plot dulu
            returnToMyPlot()
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
-- AUTO RIDE PET (LEGACY)
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
-- AUTO RIDE BY RARITY
-- ============================================================
function Features.startAutoRideByRarity()
    task.spawn(function()
        while task.wait(1.5) do
            if not Shared.AutoRideRarity_Enabled then continue end

            local plot = getMyPlot()
            if not plot then continue end
            local pets = plot:FindFirstChild("Pets")
            if not pets then continue end

            local minRank = RARITY_ORDER[Shared.RideMinRarity or "Mythic"] or 6
            local bestPet, bestRank = nil, 0

            for _, pet in ipairs(pets:GetChildren()) do
                if pet:IsA("Model") then
                    local rar = getPetRarity(pet.Name)
                    local rank = RARITY_ORDER[rar] or 1
                    if rank >= minRank and rank > bestRank then
                        bestPet, bestRank = pet, rank
                    end
                end
            end

            if bestPet then
                local prompt = bestPet:FindFirstChild("RidePrompt", true)
                if prompt and prompt.Enabled and typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, prompt)
                end
            end
        end
    end)
end

-- ============================================================
-- EGG PREDICTION SYSTEM
-- ============================================================
local EggHistory = {}
local LastEggList = {}
local MAX_HISTORY = 50

function Features.startEggPrediction()
    task.spawn(function()
        while task.wait(1) do
            if not Shared.EggPrediction_Enabled then continue end

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
function Features.rideAlong()
    local remote = getGameRemote("RideAlong")
    if remote then
        remote:FireServer()
        return true
    end
    return false
end

function Features.petDismount()
    local remote = getGameRemote("PetDismount")
    if remote then
        remote:FireServer()
        return true
    end
    return false
end

function Features.pickupPet()
    local remote = getGameRemote("PickupPet")
    if remote then
        remote:FireServer()
        return true
    end
    return false
end

function Features.hatchEgg()
    local remote = getGameRemote("Hatch")
    if remote then
        remote:FireServer()
        return true
    end
    return false
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
    Features.startAutoFarm()
    Features.startAutoRideByRarity()

    print("[VRILZHUB] Ride a Pet Features v4.0 loaded")
end

return Features
