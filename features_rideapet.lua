-- ============================================================
-- VRILZHUB FEATURES — RIDE A PET v3.3
-- + Auto Mutation (VolcanoDip)
-- ============================================================

local Features = {}
local Shared = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
                    table.insert(EggHistory, {name = eggName, time = os.time()})
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
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    if not remotes then return nil end
    local gameRemotes = remotes:FindFirstChild("Game")
    if not gameRemotes then return nil end
    return gameRemotes:FindFirstChild(name)
end

function Features.rideAlong()
    local remote = getRemote("RideAlong")
    if remote then remote:FireServer(); return true end
    return false
end

function Features.petDismount()
    local remote = getRemote("PetDismount")
    if remote then remote:FireServer(); return true end
    return false
end

function Features.pickupPet()
    local remote = getRemote("PickupPet")
    if remote then remote:FireServer(); return true end
    return false
end

function Features.hatchEgg()
    local remote = getRemote("Hatch")
    if remote then remote:FireServer(); return true end
    return false
end

-- ============================================================
-- GAMEDATA
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
-- ⭐ AUTO MUTATION (NEW)
-- ============================================================
local VOLCANO_TOP_FALLBACK = Vector3.new(-5102.84, 41405.63, -3489.11)
local TP_ABOVE_TOP = 200
local DROP_TIMEOUT = 15
local RETURN_TIMEOUT = 45
local MIN_WAIT_RETURN = 5

local _mutRunning = false

-- Net module
local Net = nil
task.spawn(function()
    local packages = ReplicatedStorage:WaitForChild("packages", 10)
    if packages then
        local netModule = packages:FindFirstChild("Net")
        if netModule then
            local ok, result = pcall(require, netModule)
            if ok then
                Net = result
                print("[VRILZHUB] ✅ Net module loaded")
            end
        end
    end
end)

local function getVolcanoDip()
    if Net then
        local ok, remote = pcall(function() return Net:RemoteEvent("VolcanoDip") end)
        if ok and remote then return remote end
    end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
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
        return VOLCANO_TOP_FALLBACK + Vector3.new(0, TP_ABOVE_TOP, 0)
    end

    local bestTop = nil
    local bestSize = 0
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
        return bestTop.Position + Vector3.new(0, TP_ABOVE_TOP, 0)
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
        return Vector3.new(VOLCANO_TOP_FALLBACK.X, lavaTop + TP_ABOVE_TOP, VOLCANO_TOP_FALLBACK.Z)
    end

    return VOLCANO_TOP_FALLBACK + Vector3.new(0, TP_ABOVE_TOP, 0)
end

local function isHoldingEggFeature()
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
    local remote = getVolcanoDip()
    if remote then
        local ok = pcall(function() remote:FireServer() end)
        if ok then
            print("[VRILZHUB] Drop: VolcanoDip fired")
            return true
        end
    end
    return false
end

local function fireBasketDrop()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    if not gameR then return false end
    local bd = gameR:FindFirstChild("BasketDrop")
    if not bd then return false end
    return pcall(function() bd:FireServer() end)
end

local function tpToSafeFeature(pos)
    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end
    myRoot.CFrame = CFrame.new(pos)
    task.wait(0.3)

    local charAfter = LocalPlayer.Character
    local rootAfter = charAfter and charAfter:FindFirstChild("HumanoidRootPart")
    if rootAfter and rootAfter.Position.Y < pos.Y - 50 then
        rootAfter.CFrame = CFrame.new(pos + Vector3.new(0, 50, 0))
        task.wait(0.3)
    end
    return true
end

local function runMutationOnce()
    _mutRunning = true

    local holding, eggName = isHoldingEggFeature()
    if not holding then
        _mutRunning = false
        return false
    end

    print("[VRILZHUB] Mut: 🎯 holding " .. (eggName or "?"))

    local safePos = findSafeVolcanoPos()
    print("[VRILZHUB] Mut: STEP 1 — TP lahar: " .. tostring(safePos))
    tpToSafeFeature(safePos)
    task.wait(2)

    print("[VRILZHUB] Mut: STEP 2 — drop")
    local dropWaited = 0
    local eggReleased = false
    local lastFire = 0

    while dropWaited < DROP_TIMEOUT do
        if tick() - lastFire > 2 then
            local ok = fireVolcanoDip()
            if not ok then fireBasketDrop() end
            lastFire = tick()
            print("[VRILZHUB] Mut: fired @ " .. dropWaited .. "s")
        end
        task.wait(0.5)
        dropWaited = dropWaited + 0.5
        if not isHoldingEggFeature() then
            eggReleased = true
            print("[VRILZHUB] Mut: ✅ egg LEPAS @ " .. dropWaited .. "s")
            break
        end
    end

    if not eggReleased then
        print("[VRILZHUB] Mut: ⚠️ egg GAK LEPAS")
        _mutRunning = false
        return false
    end

    print("[VRILZHUB] Mut: STEP 3 — tunggu balik")
    local retWaited = 0
    local gotBack = false

    while retWaited < RETURN_TIMEOUT do
        task.wait(1)
        retWaited = retWaited + 1

        -- ⭐ Baru cek egg balik setelah MIN_WAIT_RETURN
        if retWaited >= MIN_WAIT_RETURN and isHoldingEggFeature() then
            gotBack = true
            print("[VRILZHUB] Mut: ✅ egg BALIK @ " .. retWaited .. "s")
            break
        end
        if retWaited % 5 == 0 then
            print("[VRILZHUB] Mut: waiting... " .. retWaited .. "s")
        end
    end

    if Shared.AutoReturn_Enabled then
        task.wait(0.5)
        returnToMyPlot()
        print("[VRILZHUB] Mut: ✅ returned to plot")
    end

    task.wait(2)
    _mutRunning = false
    print("[VRILZHUB] Mut: 🔓 DONE")
    return true
end

function Features.startAutoMutation()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.AutoMutation_Enabled then
                task.wait(0.5)
                continue
            end

            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                task.wait(1)
                continue
            end

            if isHoldingEggFeature() and not _mutRunning then
                print("[VRILZHUB] Mut: egg held, starting")
                pcall(runMutationOnce)
                task.wait(2)
            else
                task.wait(0.5)
            end
        end
    end)
end

-- ============================================================
-- FEATURES.INIT
-- ============================================================
function Features.Init(sharedState)
    local env = getgenv and getgenv() or _G
    Shared = env.Shared or sharedState

    Features.startEggESP()
    Features.startPetESP()
    Features.startAutoSteal()
    Features.startAutoHatch()
    Features.startAutoRidePet()
    Features.startEggPrediction()
    Features.startSpeed()
    Features.startInstantPickup()
    Features.startAutoFarm()
    Features.startAutoMutation()

    print("[VRILZHUB] Features v3.3 loaded — Shared synced")
end

return Features
