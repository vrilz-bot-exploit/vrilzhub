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
-- ANTI-AFK (FINAL v4) — Aman buat semua fitur
-- ============================================================
function Features.startAntiAFK()
    if Features._antiAFKStarted then return end
    Features._antiAFKStarted = true

    local VirtualUser = game:GetService("VirtualUser")

    if not Shared then Shared = {} end
    if Shared.AntiAFK_Enabled == nil then Shared.AntiAFK_Enabled = true end

    local hasMouseMove = (type(mousemoverel) == "function")

    -- ⭐ Cek apakah ada fitur lain yang lagi jalan
    local function isAnyFeatureBusy()
        if Shared.AutoFarm_Enabled then return true end
        if Shared.AutoSteal_Enabled then return true end
        if Shared.MutationSteal_Active then return true end
        if Shared.VolcanicHunt_Enabled then return true end
        if Shared.AutoMutation_Enabled then return true end
        if _G.VRILZ_HalloweenBusy then return true end
        if Shared.YinRitual_Enabled then
            local ys = Features.getYinRitualState and Features.getYinRitualState()
            if ys and ys.Active then return true end
        end
        return false
    end

    local function doAntiAFKAction()
        if Shared.AntiAFK_Enabled == false then return end

        -- 1) Capture controller
        local captured = pcall(function()
            VirtualUser:CaptureController()
        end)

        -- 2) Button2 down/up
        if captured then
            pcall(function()
                VirtualUser:Button2Down(Vector2.new(0, 0))
            end)
            task.wait(0.05)
            pcall(function()
                VirtualUser:Button2Up(Vector2.new(0, 0))
            end)
        end

        -- 3) Gerak karakter — CUMA kalo gak ada fitur aktif & gak naik pet
        if not isAnyFeatureBusy() then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and not hum.SeatPart then
                pcall(function()
                    hum:Move(Vector3.new(0, 0, -1), false)
                    task.wait(0.1)
                    hum:Move(Vector3.new(0, 0, 0), false)
                end)
            end
        end

        -- 4) Mousemoverel
        if hasMouseMove then
            pcall(function() mousemoverel(5, 5) end)
            task.wait(0.05)
            pcall(function() mousemoverel(-5, -5) end)
        end

        -- ⭐ 5) Kamera — DIHAPUS (bisa bikin glitch, gak perlu)
    end

    -- ⭐ 1) IDLED LISTENER
    task.spawn(function()
        while true do
            if not LocalPlayer or not LocalPlayer.Parent then
                task.wait(1)
                continue
            end

            local conn
            local ok = pcall(function()
                conn = LocalPlayer.Idled:Connect(function()
                    if Shared.AntiAFK_Enabled == false then return end
                    doAntiAFKAction()
                end)
            end)

            if ok and conn then
                while conn.Connected do
                    task.wait(1)
                end
                pcall(function() conn:Disconnect() end)
            end

            task.wait(1)
        end
    end)

    -- ⭐ 2) PERIODIC 60s
    task.spawn(function()
        while true do
            task.wait(60)
            if Shared.AntiAFK_Enabled == false then continue end
            doAntiAFKAction()
        end
    end)

    -- ⭐ 3) EXTRA SAFETY 5 MENIT — skip kalo ada fitur aktif
    task.spawn(function()
        while true do
            task.wait(300)
            if Shared.AntiAFK_Enabled == false then continue end
            if isAnyFeatureBusy() then continue end

            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and not hum.SeatPart then
                pcall(function()
                    hum:Move(Vector3.new(0, 0, -1), true)
                    task.wait(0.5)
                    hum:Move(Vector3.new(0, 0, 0), false)
                    hum.Jump = true
                end)
            end
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
-- TP GLIDE STEAL — step-by-step per 150 studs
-- ============================================================
local function doStealGlide(egg, prompt, eggPart)
    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot or not eggPart then return false end

    local GLIDE_STEP = 150
    local GLIDE_WAIT = 0.08

    local targetPos = eggPart.Position + Vector3.new(0, 3, 0)
    local startPos = myRoot.Position
    local totalDist = (targetPos - startPos).Magnitude
    local steps = math.ceil(totalDist / GLIDE_STEP)
    if steps < 1 then steps = 1 end

    for i = 1, steps do
        local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not curRoot then return false end
        if not eggPart or not eggPart.Parent then break end

        local dist = math.min(GLIDE_STEP * i, totalDist)
        local dir = (targetPos - startPos)
        if dir.Magnitude < 1 then break end
        dir = dir.Unit

        curRoot.CFrame = CFrame.new(startPos + dir * dist)
        curRoot.Velocity = Vector3.zero
        curRoot.AssemblyLinearVelocity = Vector3.zero
        task.wait(GLIDE_WAIT)
    end

    myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return false end

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

-- ⭐ INSTANT RETURN — TP langsung ke plot
local function instantReturnToPlot()
    if not Shared.MutationReturn_Enabled then return end

    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end
    if not isHoldingEggLocal() then return end

    local spawnPart = getMyPlotSpawn()
    if not spawnPart then return end

    clearForces(myRoot)
    myRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
    myRoot.Velocity = Vector3.zero
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.3)

    if isHoldingEggLocal() then
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("ProximityPrompt") and d.Name:lower():find("drop") then
                d.HoldDuration = 0
                if typeof(fireproximityprompt) == "function" then
                    pcall(fireproximityprompt, d)
                end
                break
            end
        end

        local dropRemote = getDropRemoteLocal()
        if dropRemote then
            pcall(function() dropRemote:FireServer() end)
            task.wait(0.2)
            if isHoldingEggLocal() then
                pcall(function() dropRemote:FireServer() end)
            end
        end
    end
    task.wait(0.3)
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

-- ⭐ WRAPPER — Auto pilih Step / Instant
local function doReturnToPlot()
    if not Shared.MutationReturn_Enabled then return end

    local mode = Shared.ReturnMode or "Step"

    if mode == "Instant" then
        -- Cek Premium
        local isPrem = false
        if Shared.KeyType then
            local kt = tostring(Shared.KeyType):upper()
            if kt == "PREMIUM" or kt == "OWNER" or kt == "VIP" then
                isPrem = true
            end
        end
        if LocalPlayer.UserId == 5126297278 then isPrem = true end

        if isPrem then
            instantReturnToPlot()
        else
            -- Fallback: free user → step
            local oldFlag = Shared.AutoReturn_Enabled
            Shared.AutoReturn_Enabled = true
            returnToMyPlot()
            Shared.AutoReturn_Enabled = oldFlag
        end
    else
        local oldFlag = Shared.AutoReturn_Enabled
        Shared.AutoReturn_Enabled = true
        returnToMyPlot()
        Shared.AutoReturn_Enabled = oldFlag
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
-- AUTO RIDE PET — Auto Equip Best KG → PetRideMode
-- ============================================================
-- ============================================================
-- FLYING PET BLACKLIST
-- ============================================================
local FLYING_BLACKLIST = {
    "phoenix", "dragon", "sky", "air", "cloud",
    "bird", "eagle", "hawk", "griffin", "pegasus",
    "fairy", "angel", "wing", "fly", "aero", "zephyr",
    "wyvern", "roc", "raven", "owl", "bat",
    "butterfly", "bee", "wasp", "moth", "hornet",
    "flying", "float", "hover", "soar", "glide",
    "celestial", "spirit", "ghost", "phantom",
    "vulture", "flamingo", "peacock", "manticore", "wukong",
    "hydra", "skeletal", "headless", "volkaris",
}

local function isFlyingPet(petName)
    local n = string.lower(petName)
    for _, kw in ipairs(FLYING_BLACKLIST) do
        if string.find(n, kw, 1, true) then return true end
    end
    return false
end

local AutoRideState = {
    Enabled = false,
    LastRideTime = 0,
    LastPetName = nil,
    IsRiding = false,
    Cooldown = 3.0,
    Status = "Idle",
    SelectedPet = "Auto (Best KG)",
    HasRiddenOnce = false,
    DismountTime = 0,           -- ⭐ BARU: waktu terakhir detect turun
    DismountGrace = 1.5,        -- ⭐ BARU: grace period konfirmasi turun
    ForceAction = false,        -- ⭐ BARU: trigger langsung eksekusi
}

-- ⭐ SAFE getPetKG — handle kalo fungsi asli gak ada
-- Coba ambil KG dari: attribute → nama tool → StringValue/NumberValue di dalam
local function getPetKG(tool)
    if not tool then return 0 end

    -- CARA 1: Attribute (paling reliable)
    local kg = tool:GetAttribute("KG")
             or tool:GetAttribute("Weight")
             or tool:GetAttribute("PetKG")
             or tool:GetAttribute("Mass")
    if kg and type(kg) == "number" then return kg end

    -- CARA 2: Dari nama tool — format "PetName_123KG" atau "PetName 123"
    local name = tostring(tool.Name)
    local num = name:match("(%d+%.?%d*)%s*[Kk][Gg]")   -- "123KG"
             or name:match("[Kk][Gg]%s*(%d+%.?%d*)")   -- "KG123"
             or name:match("_(%d+%.?%d*)$")            -- "_123" di akhir
    if num then
        local n = tonumber(num)
        if n then return n end
    end

    -- CARA 3: Cari StringValue/NumberValue di dalam tool
    for _, c in ipairs(tool:GetDescendants()) do
        if c:IsA("NumberValue") then
            local n = c.Name:lower()
            if n:find("kg") or n:find("weight") or n:find("mass") then
                return c.Value
            end
        elseif c:IsA("StringValue") then
            local n = c.Name:lower()
            if n:find("kg") or n:find("weight") or n:find("mass") then
                local v = tonumber(c.Value)
                if v then return v end
            end
        elseif c:IsA("TextLabel") or c:IsA("TextButton") then
            -- Kadang KG ada di UI text
            local t = c.Text
            local m = t and t:match("(%d+%.?%d*)%s*[Kk][Gg]")
            if m then
                local v = tonumber(m)
                if v then return v end
            end
        end
    end

    return 0
end

-- ⭐ CARI PET DENGAN KG TERTINGGI (gak peduli rarity)
local function findBestPetForRide()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return nil end

    local best, bestKG = nil, -1
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- ⭐ FLEKSIBEL: pake PetName kalo ada, fallback ke Name
            local pname = tool:GetAttribute("PetName") or tool.Name

            -- ⭐ Skip flying pet
            if not isFlyingPet(pname) then
                local kg = getPetKG(tool) or 0   -- ⭐ guard nil
                if kg > bestKG then
                    bestKG = kg
                    best = tool
                end
            end
        end
    end

    return best
end

local function isRidingPetAuto()
    local char = LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end

    -- CARA 1: SeatPart (paling reliable kalo game pake Seat)
    if hum.SeatPart ~= nil then return true end

    -- CARA 2: Cek attribute game (biasanya game Ride a Pet pake ini)
    if LocalPlayer:GetAttribute("Riding") == true then return true end
    if LocalPlayer:GetAttribute("IsRiding") == true then return true end
    if LocalPlayer:GetAttribute("CurrentPet") ~= nil then return true end
    if LocalPlayer:GetAttribute("MountedPet") ~= nil then return true end
    if LocalPlayer:GetAttribute("CurrentRidingPet") ~= nil then return true end

    -- CARA 3: Cek attribute di character
    if char:GetAttribute("Riding") == true then return true end
    if char:GetAttribute("IsRiding") == true then return true end

    return false
end

function Features.startAutoRidePet()
    task.spawn(function()
        while task.wait(0.3) do   -- ⬅️ lebih responsif dari 0.5
            if not AutoRideState.Enabled then
                AutoRideState.IsRiding = false
                AutoRideState.HasRiddenOnce = false
                AutoRideState.DismountTime = 0
                AutoRideState.ForceAction = false
                AutoRideState.Status = "Idle"
                continue
            end

            -- ═══════════════════════════════════════════════════════
            -- FORCE ACTION — skip semua cek, langsung eksekusi
            -- ═══════════════════════════════════════════════════════
            local force = AutoRideState.ForceAction
            AutoRideState.ForceAction = false

            if not force then
                local riding = isRidingPetAuto()

                if riding then
                    AutoRideState.IsRiding = true
                    AutoRideState.HasRiddenOnce = true
                    AutoRideState.DismountTime = 0
                    AutoRideState.Status = "✓ Riding " .. tostring(AutoRideState.LastPetName or "pet")
                    continue
                end

                AutoRideState.IsRiding = false

                -- Udah pernah naik & sekarang turun → grace period
                if AutoRideState.HasRiddenOnce then
                    if AutoRideState.DismountTime == 0 then
                        AutoRideState.DismountTime = os.clock()
                        AutoRideState.Status = "⏳ Turun terdeteksi..."
                        continue
                    end

                    local elapsed = os.clock() - AutoRideState.DismountTime
                    if elapsed < AutoRideState.DismountGrace then
                        AutoRideState.Status = string.format("⏳ Konfirmasi turun... (%.1fs)", AutoRideState.DismountGrace - elapsed)
                        continue
                    end

                    AutoRideState.HasRiddenOnce = false
                    AutoRideState.DismountTime = 0
                    AutoRideState.LastRideTime = 0
                    if Shared.Notify then
                        Shared.Notify("🔄 Turun dari pet — auto re-ride...", "info")
                    end
                end

                -- Cooldown
                if AutoRideState.LastRideTime > 0 and
                   os.clock() - AutoRideState.LastRideTime < AutoRideState.Cooldown then
                    continue
                end
            end

            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                AutoRideState.Status = "Waiting for character..."
                task.wait(1)
                continue
            end

            -- ═══════════════════════════════════════════════════════
            -- CARI PET
            -- ═══════════════════════════════════════════════════════
            local best

           if AutoRideState.SelectedPet and AutoRideState.SelectedPet ~= "Auto (Best KG)" then
    if not isFlyingPet(AutoRideState.SelectedPet) then
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local bestKG = -1
        if backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    local pname = tool:GetAttribute("PetName") or tool.Name   -- ⭐ FIX
                    if pname == AutoRideState.SelectedPet then
                        local kg = getPetKG(tool) or 0                        -- ⭐ FIX
                        if kg > bestKG then
                            bestKG = kg
                            best = tool
                        end
                    end
                end
            end
        end
    end
end
            if not best then
                best = findBestPetForRide()
            end

            if not best then
                AutoRideState.Status = "Gak ada pet darat di backpack"
                task.wait(1)
                continue
            end

            local petKey = best:GetAttribute("PetKey")
            local petName = best:GetAttribute("PetName") or best.Name

            if isFlyingPet(petName) then
                AutoRideState.Status = "Skip flying pet: " .. petName
                task.wait(1)
                continue
            end

            -- ═══════════════════════════════════════════════════════
            -- EQUIP + NAIKIN — FIRE MULTIPLE PAYLOAD
            -- ═══════════════════════════════════════════════════════
            AutoRideState.Status = "Equipping: " .. petName
            pcall(function() hum:EquipTool(best) end)
            task.wait(0.5)

            -- Fire remote dengan MULTIPLE payload (biar salah satu kena)
            local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
            local gameR = remotes and remotes:FindFirstChild("Game")
            local rideRemote = gameR and gameR:FindFirstChild("PetRideMode")
            local mountingRemote = gameR and gameR:FindFirstChild("Mounting")

            -- Coba sampe 6x dengan delay
            for attempt = 1, 6 do
                if rideRemote then
                    pcall(function() rideRemote:FireServer() end)
                    task.wait(0.1)
                    pcall(function() rideRemote:FireServer(petKey) end)
                    task.wait(0.1)
                    pcall(function() rideRemote:FireServer(petKey, true) end)
                    task.wait(0.1)
                    pcall(function() rideRemote:FireServer(true) end)
                    task.wait(0.1)
                end

                if mountingRemote then
                    pcall(function() mountingRemote:FireServer(petKey) end)
                    task.wait(0.1)
                    pcall(function() mountingRemote:FireServer() end)
                    task.wait(0.1)
                end

                task.wait(0.3)

                -- Cek apakah udah naik
                if isRidingPetAuto() then
                    break
                end
            end

            AutoRideState.LastRideTime = os.clock()
            AutoRideState.LastPetName = petName

            if isRidingPetAuto() then
                AutoRideState.Status = "✓ Riding " .. petName
                AutoRideState.HasRiddenOnce = true
                if Shared.Notify then
                    Shared.Notify("Riding " .. petName, "success")
                end
            else
                AutoRideState.Status = "Failed: " .. petName
            end
        end
    end)
end

function Features.setAutoRideEnabled(v)
    AutoRideState.Enabled = v
    if v then
        AutoRideState.HasRiddenOnce = false
        AutoRideState.IsRiding = false
        AutoRideState.LastRideTime = 0
        AutoRideState.DismountTime = 0
        AutoRideState.ForceAction = true
    else
        AutoRideState.DismountTime = 0
        AutoRideState.ForceAction = false
        AutoRideState.LastPetName = nil   -- ⭐ tambah baris ini
    end
end

-- ⬇️ TAMBAH 2 FUNGSI INI ⬇️
function Features.getPetListForDropdown()
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not backpack then return {} end

    local map = {}
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            -- ⭐ FLEKSIBEL: fallback ke tool.Name
            local pname = tool:GetAttribute("PetName") or tool.Name
            if pname and not isFlyingPet(pname) then
                local kg = getPetKG(tool) or 0   -- ⭐ guard nil
                if not map[pname] then
                    map[pname] = { name = pname, kg = kg, tool = tool, count = 0 }
                end
                map[pname].count = map[pname].count + 1
                if kg > map[pname].kg then
                    map[pname].kg = kg
                    map[pname].tool = tool
                end
            end
        end
    end

    local list = {}
    for _, info in pairs(map) do table.insert(list, info) end
    table.sort(list, function(a, b) return a.kg > b.kg end)
    return list
end

function Features.setAutoRidePet(petName)
    AutoRideState.SelectedPet = petName or "Auto (Best KG)"
    AutoRideState.HasRiddenOnce = false
    AutoRideState.LastRideTime = 0
    AutoRideState.DismountTime = 0
    AutoRideState.ForceAction = true
    AutoRideState.LastPetName = nil   -- ⭐ tambah baris ini
end

-- ⬆️ SAMPAI SINI ⬆️

function Features.getAutoRideState()
    return AutoRideState
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
            elseif Shared.StealMode == "TP GLIDE" then
                picked = doStealGlide(egg, prompt, eggPart)
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
        -- ⭐ FIX: cek 3 flag — kalo salah satu on, tetep jalan
        local stillActive = Shared.VolcanicHunt_Enabled
                          or Shared.MutationSteal_Enabled
                          or Shared.AutoMutation_Enabled
        if not stillActive then return false end

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
    -- ⭐ FIX: cek 3 flag
    local stillActive = Shared.VolcanicHunt_Enabled
                      or Shared.MutationSteal_Enabled
                      or Shared.AutoMutation_Enabled
    if not stillActive then return false end
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

            -- ⭐ FIX: SKIP kalo Mutation Steal lagi aktif
            -- Biar Auto Mutation gak ganggu proses pickup + keluar cave
            if Shared.MutationSteal_Active and Shared.MutationSteal_Enabled then
                MutationState.Running = false
                task.wait(1)
                continue
            end

            if MutationState.Running then continue end

            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                task.wait(1)
                continue
            end

            -- ⭐ Cek egg di tangan
            if isHoldingEggMutation() then
                -- ⭐ Cek tambahan: kalo lagi di dalam cave, JANGAN dip dulu
                -- Tunggu sampe keluar cave (posisi Y > 41000 = di luar cave)
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot and myRoot.Position.Y < 41000 then
                    -- Masih di dalam cave → tunggu
                    task.wait(1)
                    continue
                end

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
-- MUTATION STEAL — VOLCANIC PRIORITY + STEAL BIASA
-- Volcanic Egg spawn → waypoint cave → magma → return
-- Egg biasa → TP langsung (by Rarity/Name filter)
-- ============================================================
function Features.startMutationSteal()
    task.spawn(function()
        while task.wait(0.5) do
            if not Shared.MutationSteal_Enabled then
                Shared.MutationSteal_Active = false
                continue
            end

            -- Kalo Auto Mutation lagi jalan, tunggu
            if Features.getMutationState and Features.getMutationState().Running then
                Shared.MutationSteal_Active = false
                task.wait(1)
                continue
            end

            -- Kalo Auto Volcanic Hunt aktif, skip (biar gak bentrok)
            if Shared.VolcanicHunt_Enabled then
                Shared.MutationSteal_Active = false
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

            -- Kalo udah bawa egg, tunggu
            if Features.isHoldingEgg and Features.isHoldingEgg() then
                Shared.MutationSteal_Active = false
                task.wait(0.5)
                continue
            end

            local basket = LocalPlayer:FindFirstChild("Basket")
            if basket and #basket:GetChildren() > 0 then
                Shared.MutationSteal_Active = false
                task.wait(0.5)
                continue
            end

            -- ⭐ PRIORITY 1: CEK VOLCANIC EGG DULUAN
            local volcanicEgg = getVolcanicEgg()

            if volcanicEgg and volcanicEgg.Parent then
                Shared.MutationSteal_Active = true

                local eggPart = volcanicEgg:FindFirstChildWhichIsA("BasePart", true)
                if not eggPart then
                    Shared.MutationSteal_Active = false
                    task.wait(1)
                    continue
                end

                -- Step 1: TP ke spawn Volcanic (kalo jauh)
                local spawnPart = getVolcanicSpawn()
                if spawnPart then
                    local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if curRoot then
                        local d = (spawnPart.Position - curRoot.Position).Magnitude
                        if d > 50 then
                            curRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
                            curRoot.Velocity = Vector3.zero
                            curRoot.AssemblyLinearVelocity = Vector3.zero
                            task.wait(0.5)
                        end
                    end
                end

                -- Step 2: Masuk cave pake waypoint
                local reachedEgg = false
                for i, wp in ipairs(VolcanicWaypoints) do
                    if not Shared.MutationSteal_Enabled then break end
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

                -- Step 3: SELALU TP langsung ke egg
do
    local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if curRoot and eggPart and eggPart.Parent then
        curRoot.CFrame = CFrame.lookAt(eggPart.Position + Vector3.new(0, 3, 0), eggPart.Position)
        curRoot.Velocity = Vector3.zero
        curRoot.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.3)
    end
end

                -- Step 4: Ambil egg (pake volcanicPickupVerified)
                local picked = false
                if volcanicEgg.Parent then
                    picked = volcanicPickupVerified(volcanicEgg)
                else
                    picked = isHoldingEggMutation()
                end

                if not picked or not isHoldingEggMutation() then
                    Shared.MutationSteal_Active = false
                    task.wait(2)
                    continue
                end

                -- Step 5: Keluar cave (reverse waypoint)
                local exited = exitCave()
                if not exited or not isHoldingEggMutation() then
                    Shared.MutationSteal_Active = false
                    task.wait(2)
                    continue
                end

                -- Step 6: KE MAGMA (drop)
                if isHoldingEggMutation() then
                    task.wait(0.5)
                    local safePos = findSafeVolcanoPos()
                    if safePos then
                        local rootLava = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if rootLava then
                            rootLava.CFrame = CFrame.new(safePos)
                            rootLava.Velocity = Vector3.zero
                            rootLava.AssemblyLinearVelocity = Vector3.zero
                        end
                    end
                    task.wait(1.5)

                    local dropWaited = 0
                    local eggReleased = false
                    while dropWaited < 15 do
                        if not Shared.MutationSteal_Enabled then break end
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
                            if not Shared.MutationSteal_Enabled then break end
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

                -- Step 7: AUTO RETURN ke plot (Step/Instant)
task.wait(0.4)
doReturnToPlot()

                Shared.MutationSteal_Active = false
                task.wait(3)
                continue  -- ⭐ Lanjut loop, cek volcanic lagi
            end

            -- ⭐ PRIORITY 2: KALO GAK ADA VOLCANIC → STEAL EGG BIASA (by Rarity/Name)
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
                Shared.MutationSteal_Active = false
                task.wait(0.5)
                continue
            end

            Shared.MutationSteal_Active = true

            local egg = targetEgg
            local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
            local prompt = egg:FindFirstChild("Pickup", true)
            if not eggPart or not prompt then
                Shared.MutationSteal_Active = false
                task.wait(0.5)
                continue
            end

            if prompt:IsA("ProximityPrompt") then
                prompt.HoldDuration = 0
            end

                        local picked = false

                        if Shared.StealMode == "Fly" then
                picked = doStealFly(egg, prompt, eggPart)
            elseif Shared.StealMode == "TP GLIDE" then
                picked = doStealGlide(egg, prompt, eggPart)
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

            -- ⭐ FIX: Kalo gagal pickup, skip
            if not picked or not isHoldingEggMutation() then
                Shared.MutationSteal_Active = false
                task.wait(1)
                continue
            end

            -- ⭐ STEP: TP KE LAVA (sama kayak Volcanic Step 6)
            task.wait(0.5)
            local safePos = findSafeVolcanoPos()
            if safePos then
                local rootLava = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootLava then
                    rootLava.CFrame = CFrame.new(safePos)
                    rootLava.Velocity = Vector3.zero
                    rootLava.AssemblyLinearVelocity = Vector3.zero
                end
            end
            task.wait(1.5)

            -- ⭐ STEP: DIP SAMPE EGG RELEASED
            local dropWaited = 0
            local eggReleased = false
            while dropWaited < 15 do
                if not Shared.MutationSteal_Enabled then break end
                fireVolcanoDip()
                task.wait(1.5)
                dropWaited = dropWaited + 1.5
                if not isHoldingEggMutation() then
                    eggReleased = true
                    break
                end
            end

            -- ⭐ STEP: TUNGGU EGG BALIK (mutation selesai)
            if eggReleased then
                local waitStart = os.clock()
                while os.clock() - waitStart < 20 do
                    if not Shared.MutationSteal_Enabled then break end
                    task.wait(1)
                    if isHoldingEggMutation() then
                        if Shared.Notify then
                            Shared.Notify("🔥 Mutation selesai!", "success")
                        end
                        break
                    end
                end
            end

            -- ⭐ STEP: RETURN KE PLOT (Step/Instant)
task.wait(0.4)
doReturnToPlot()

            Shared.MutationSteal_Active = false
            task.wait(3)
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
-- AUTO HALLOWEEN — PRIORITY BY RARITY
-- Legendary (Candy_04) dulu, baru Epic, Rare, Common
-- TP GLIDE = step 100 (free) | TP FAST = step 150 (premium)
-- ============================================================
local HalloweenState = {
    Enabled = false,
    Status = "⏸️ Idle",
    Claimed = 0,
    RareClaimed = 0,
    CandyTypes = {},
    TPMethod = "TP100",   -- "TP100" (free) atau "TP180" (premium)
}

-- ⭐ RARITY MAPPING
local CANDY_RARITY = {
    ["Candy_01"] = 1,       -- Common
    ["Candy_02"] = 2,       -- Rare
    ["Candy_03"] = 3,       -- Epic
    ["Candy_04"] = 4,       -- Legendary
}

local function getCandyRarity(candyName)
    return CANDY_RARITY[candyName] or 0
end

-- ⭐ CEK PREMIUM
local OWNER_USERID = 5126297278
local function isPremiumUser()
    if LocalPlayer.UserId == OWNER_USERID then return true end
    if Shared and Shared.KeyType then
        local kt = tostring(Shared.KeyType):upper()
        if kt == "PREMIUM" or kt == "OWNER" or kt == "VIP" then
            return true
        end
    end
    return false
end

local HalloweenCfg = {
    TP_STEP_FREE = 55,
    TP_STEP_PREMIUM = 125,
    TP_HEIGHT = 5,
    TP_WAIT = 0.08,
    LOOP_WAIT = 0.3,
    CLAIM_WAIT = 0.5,
    RETURN_WAIT = 0.4,
}

local function getHalloweenBase()
    local candidates = {
        "HalloweenHomeAnchor", "HalloweenBase", "HalloweenSpawn",
        "HalloweenBaseplate", "HalloweenStart",
    }
    for _, name in ipairs(candidates) do
        local part = Workspace:FindFirstChild(name, true)
        if part and part:IsA("BasePart") then return part end
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
    -- Cek multiple attribute (biar gak salah baca)
    if LocalPlayer:GetAttribute("CarriedCandyModel") ~= nil then return true end
    if LocalPlayer:GetAttribute("CarryingCandy") == true then return true end
    if LocalPlayer:GetAttribute("HeldCandy") ~= nil then return true end
    if LocalPlayer:GetAttribute("CarriedCandy") ~= nil then return true end

    -- Cek di character (kalo ada model/tool candy)
    local char = LocalPlayer.Character
    if char then
        for _, c in ipairs(char:GetChildren()) do
            if (c:IsA("Model") or c:IsA("Tool")) and c.Name:lower():find("candy") then
                return true
            end
        end
    end

    return false
end

local function getHalloweenRemote(name)
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    if not gameR then return nil end
    return gameR:FindFirstChild(name)
end

-- ⭐ Filter candy cave/backdoor (Y tinggi)
-- Spawn biasa (area terbuka): Y 40345-40376
-- Cave/backdoor: Y 40512-40514
local CANDY_Y_MAX = 40400

local function getHalloweenCandyList()
    local f = Workspace:FindFirstChild("HalloweenCandy")
    if not f then return {} end
    local list = {}
    for _, c in ipairs(f:GetChildren()) do
        if c:IsA("BasePart") and HalloweenState.CandyTypes[c.Name] then
            -- ✅ Skip candy yang di cave/backdoor (Y tinggi)
            if c.Position.Y < CANDY_Y_MAX then
                table.insert(list, c)
            end
        end
    end
    table.sort(list, function(a, b)
        local ra = getCandyRarity(a.Name)
        local rb = getCandyRarity(b.Name)
        return ra > rb
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

-- ⭐ TP STEP (glide, per step 100 / 150)
local function halloweenTpStep(targetPos, stepSize, waitTime)
    waitTime = waitTime or HalloweenCfg.TP_WAIT
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local startPos = root.Position
    local totalDist = (targetPos - startPos).Magnitude
    local steps = math.ceil(totalDist / stepSize)

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
        local dist = math.min(stepSize * i, totalDist)
        local pos = startPos + dir * dist + Vector3.new(0, HalloweenCfg.TP_HEIGHT, 0)
        halloweenTpTo(pos)
        task.wait(waitTime)   -- ✅ pakai waitTime
    end
    return true
end

-- ⭐ TP MAIN FUNCTION — pilih metode
local function halloweenTpJumpTo(targetPos)
    local method = HalloweenState.TPMethod or "TP100"

    if method == "TP180" then
        if not isPremiumUser() then
            -- Fallback kalau bukan premium
            return halloweenTpStep(targetPos, HalloweenCfg.TP_STEP_FREE, 0.08)
        else
            -- PREMIUM: step 180, wait lebih cepat biar beda dari TP100
            return halloweenTpStep(targetPos, HalloweenCfg.TP_STEP_PREMIUM, 0.13)
        end
    end

    -- FREE: TP 100 studs step
    return halloweenTpStep(targetPos, HalloweenCfg.TP_STEP_FREE, 0.08)
end

local function halloweenReturnToBase()
    local base = getHalloweenBase()
    if not base then return false end

    -- ⭐ Handle kalo lagi naik pet — TP pet sekalian biar gak nyangkut
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if root and hum and hum.SeatPart then
        -- Player lagi naik pet — pake TP step yang handle vehicle
        local pet = hum.SeatPart:FindFirstAncestorOfClass("Model")
        if pet then
            -- Hitung offset pet ke root
            local seat = hum.SeatPart
            local offset = root.CFrame:ToObjectSpace(seat.CFrame)

            -- TP step by step
            local targetPos = base.Position + Vector3.new(0, HalloweenCfg.TP_HEIGHT, 0)
            local startPos = root.Position
            local totalDist = (targetPos - startPos).Magnitude
            local stepSize = HalloweenCfg.TP_STEP_FREE
            local steps = math.ceil(totalDist / stepSize)

            for i = 1, steps do
                local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not r then break end

                local dist = math.min(stepSize * i, totalDist)
                local dir = (targetPos - startPos)
                dir = Vector3.new(dir.X, 0, dir.Z)
                if dir.Magnitude > 1 then dir = dir.Unit end

                local newRootCF = CFrame.new(startPos + dir * dist + Vector3.new(0, HalloweenCfg.TP_HEIGHT, 0))

                -- Gerakin root
                r.CFrame = newRootCF
                r.Velocity = Vector3.zero
                r.AssemblyLinearVelocity = Vector3.zero

                                -- Gerakin pet model
                local newSeatCF = newRootCF * offset

                -- ⭐ Rumus bener: PivotTo harus pake PIVOT, bukan PrimaryPart
                local pivotToSeat = pet:GetPivot():ToObjectSpace(seat.CFrame)
                local targetPivot = newSeatCF * pivotToSeat:Inverse()
                pcall(function() pet:PivotTo(targetPivot) end)

                task.wait(HalloweenCfg.TP_WAIT)
            end

            task.wait(HalloweenCfg.RETURN_WAIT)
            return true
        end
    end

    -- ⭐ Gak naik pet — pake cara lama (step TP biasa)
    halloweenTpJumpTo(base.Position)
    task.wait(HalloweenCfg.RETURN_WAIT)
    return true
end

local function halloweenClaimCandy(candy)
    if not candy or not candy.Parent then return false end
    local collectRemote = getHalloweenRemote("CollectCandy")
    local stateRemote = getHalloweenRemote("CandyState")
    if not collectRemote then return false end

    -- Kalo udah bawa candy, gak bisa collect lagi
    if isCarryingCandy() then return false end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    -- Cek jarak — kalo jauh, TP dulu
    local d = (root.Position - candy.Position).Magnitude
    if d > 30 then
        root.CFrame = CFrame.new(candy.Position + Vector3.new(0, 3, 0))
        task.wait(0.3)
    end

    local spawnId = candy:GetAttribute("SpawnId") or candy.Name

    -- Fire state remote dulu
    if stateRemote then
        pcall(function() stateRemote:FireServer(spawnId) end)
        task.wait(0.1)
    end

    -- ⭐ FIRE 4x dengan payload beda (biar salah satu kena)
    pcall(function() collectRemote:FireServer(spawnId) end)
    task.wait(0.15)
    if isCarryingCandy() then return true end

    pcall(function() collectRemote:FireServer(candy) end)
    task.wait(0.15)
    if isCarryingCandy() then return true end

    pcall(function() collectRemote:FireServer() end)
    task.wait(0.15)
    if isCarryingCandy() then return true end

        pcall(function() collectRemote:FireServer(spawnId, candy) end)
    task.wait(0.3)

    return isCarryingCandy()
end

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

-- ⭐ HELPER: cari egg prioritas di luar Halloween (filter rarity / name)
local function findPriorityEggOutside()
    local rendered = Workspace:FindFirstChild("RenderedEggs")
    if not rendered then return nil end

    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local selectedRarities = Shared.SelectedRarities
    local selectedEggs = Shared.MutationSelectedEggs

    local best, bestDist = nil, math.huge

    for _, egg in ipairs(rendered:GetChildren()) do
        if egg:IsA("Model") then
            local pass = false

            if selectedRarities then
                local rarity = getEggRarity(egg.Name)
                if selectedRarities[rarity] == true then pass = true end
            end

            if not pass and selectedEggs and selectedEggs[egg.Name] == true then
                pass = true
            end

            if pass then
                local part = egg:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    local d = (part.Position - myRoot.Position).Magnitude
                    if d < bestDist then
                        best = egg
                        bestDist = d
                    end
                end
            end
        end
    end

    return best
end

-- ⭐ HELPER: keluar dari Halloween zone (portal di Workspace.HalloweenArea.Portal)
local function halloweenLeaveZone()
    if not isInHalloweenZone() then return true end

    local halloweenArea = Workspace:FindFirstChild("HalloweenArea")
    if not halloweenArea then return false end
    local portal = halloweenArea:FindFirstChild("Portal")
    if not portal then return false end

    local part = portal:FindFirstChildWhichIsA("BasePart", true)
    if not part then return false end

    halloweenTpTo(part.Position + Vector3.new(0, 5, 0))
    task.wait(0.5)

    local prompt = portal:FindFirstChild("HalloweenPortalPrompt", true)
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = math.huge
        prompt.RequiresLineOfSight = false
        pcall(function()
            if typeof(fireproximityprompt) == "function" then
                fireproximityprompt(prompt)
            end
        end)
        task.wait(1.5)
    end

    return not isInHalloweenZone()
end

function Features.startAutoHalloween()
    task.spawn(function()
        while task.wait(HalloweenCfg.LOOP_WAIT) do
            if not HalloweenState.Enabled then
                HalloweenState.Status = "⏸️ Idle"
                continue
            end

                        -- ⭐ PRIORITY 1: Auto Mutation — paling utama
if Shared.AutoMutation_Enabled then
    local mutState = Features.getMutationState and Features.getMutationState()
    if mutState and (mutState.Running or mutState.EggLocked or mutState.StealPaused) then
        HalloweenState.Status = "⏸️ Waiting Auto Mutation..."
        task.wait(1)
        continue
    end
end

-- ⭐ PRIORITY 2: Auto Yin Ritual — tunggu SAMPE SELESAI FULL
if Shared.YinRitual_Enabled then
    local yinState = Features.getYinRitualState and Features.getYinRitualState()

    -- Cek apakah Yin lagi aktif (scanning / collect / place / reward)
    if yinState and yinState.Active then
        HalloweenState.Status = "⏸️ Waiting Yin Ritual selesai..."
        task.wait(1)
        continue
    end

    -- Double-check: masih ada Yin/Yang di runtime = belum selesai
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    local rt = hr and hr:FindFirstChild("Runtime")
    if rt then
        for _, obj in ipairs(rt:GetChildren()) do
            if obj:IsA("Model") and (obj.Name == "Yin" or obj.Name == "Yang") then
                HalloweenState.Status = "⏸️ Waiting Yin Ritual (masih ada item)..."
                task.wait(1)
                continue
            end
        end
    end
end
                
-- ⭐ PRIORITY 3: Mutation Steal
if Shared.MutationSteal_Active and Shared.MutationSteal_Enabled then
    HalloweenState.Status = "⏳ Waiting for Mutation Steal..."
    task.wait(1)
    continue
end

                        -- ⭐ LEAVE LOGIC: cuma leave kalau ADA fitur steal lain yang nyala
            local stealFeatureOn = Shared.AutoSteal_Enabled
                or Shared.AutoFarm_Enabled
                or Shared.MutationSteal_Enabled

            if stealFeatureOn then
                local outsideEgg = findPriorityEggOutside()
                if outsideEgg and outsideEgg.Parent then
                    if isInHalloweenZone() then
                        HalloweenState.Status = "🥚 Egg spawn: " .. outsideEgg.Name .. " — leaving Halloween..."
                        halloweenLeaveZone()
                        task.wait(1)
                    else
                        HalloweenState.Status = "🥚 Egg spawn: " .. outsideEgg.Name .. " — waiting for steal..."
                        task.wait(2)
                    end
                    continue
                end
            end
                
            -- ⭐ SET FLAG GLOBAL kalo Halloween lagi aktif
_G.VRILZ_HalloweenBusy = true

local char = LocalPlayer.Character
local root = char and char:FindFirstChild("HumanoidRootPart")
if not root then 
    _G.VRILZ_HalloweenBusy = false
    task.wait(1) 
    continue 
end

                                    if not isInHalloweenZone() then
                HalloweenState.Status = "🚪 Entering area..."
                if not halloweenEnterZone() then
                    _G.VRILZ_HalloweenBusy = false
                    task.wait(2)
                    continue
                end
            end

            if isCarryingCandy() then
                HalloweenState.Status = "🎒 Carrying candy — processing..."
                _G.VRILZ_HalloweenBusy = false
                task.wait(1)
                continue
            end

            local candies = getHalloweenCandyList()
            if #candies == 0 then
                HalloweenState.Status = "⏳ Waiting for candy spawn... (" .. HalloweenState.Claimed .. " claimed)"
                _G.VRILZ_HalloweenBusy = false
                task.wait(2)
                continue
            end

            local highestRarity = getCandyRarity(candies[1].Name)
            local topRarityCandies = {}
            for _, c in ipairs(candies) do
                local r = getCandyRarity(c.Name)
                if r == highestRarity then
                    table.insert(topRarityCandies, c)
                end
            end

            if #topRarityCandies == 0 then
                task.wait(0.5)
                continue
            end

            local rarityName = ({
                [1] = "Common",
                [2] = "Rare",
                [3] = "Epic",
                [4] = "Legendary",
            })[highestRarity] or ("Tier " .. highestRarity)

            local methodLabel = HalloweenState.TPMethod == "TP180" and "TP FAST" or "TP GLIDE"

            HalloweenState.Status = string.format(
                "🎯 %s [%s] — %d candy",
                rarityName,
                methodLabel,
                #topRarityCandies
            )

                        -- ⭐ RETRY 3x per candy
            local collectedThisRound = 0

            for idx, candy in ipairs(topRarityCandies) do
                if not HalloweenState.Enabled then break end
                if not candy or not candy.Parent then continue end
                if isCarryingCandy() then break end

                HalloweenState.Status = string.format(
                    "🍬 %s (%d/%d) — %s [%s]",
                    candy.Name,
                    idx,
                    #topRarityCandies,
                    rarityName,
                    methodLabel
                )

                -- TP ke candy
                halloweenTpJumpTo(candy.Position)
                task.wait(0.4)

                -- ⭐ COBA COLLECT SAMPE 3x
                local ok = false
                for attempt = 1, 3 do
                    if not HalloweenState.Enabled then break end
                    if isCarryingCandy() then break end
                    if not candy.Parent then break end

                    ok = halloweenClaimCandy(candy)
                    if ok then break end

                    -- Re-TP kalo gagal
                    halloweenTpJumpTo(candy.Position)
                    task.wait(0.5)
                end

                if ok then
                    HalloweenState.Claimed = HalloweenState.Claimed + 1
                    collectedThisRound = collectedThisRound + 1
                    if highestRarity >= 3 then
                        HalloweenState.RareClaimed = HalloweenState.RareClaimed + 1
                    end

                    if isCarryingCandy() then break end
                end

                task.wait(HalloweenCfg.CLAIM_WAIT)
            end

                        -- ⭐ KALO GAK COLLECT APAPUN, JANGAN BALIK BASE — LOOP LAGI
            if collectedThisRound == 0 and not isCarryingCandy() then
                HalloweenState.Status = "⚠️ Failed to collect — retrying..."
                task.wait(1.5)
                continue
            end

                        HalloweenState.Status = "🏠 Returning to Halloween base..."
halloweenReturnToBase()
task.wait(HalloweenCfg.RETURN_WAIT)

_G.VRILZ_HalloweenBusy = false   -- ⭐ RESET FLAG
        end
    end)
end

function Features.getHalloweenState()
    return HalloweenState
end

-- ⭐ Expose premium check ke UI
function Features.isPremiumUser()
    return isPremiumUser()
end

-- ============================================================
-- AUTO YIN RITUAL — FIXED v3 (step 80 + verifikasi)
-- Prioritas: cek reward dulu → baru collect Yin/Yang
-- ============================================================
local YinRitualState = {
    Enabled = false,
    Status = "⏸️ Idle",
    YinCount = 0,
    YangCount = 0,
    RitualCount = 0,
    RewardCount = 0,
    Active = false,
}

local YinRitualCfg = {
    SCAN_INTERVAL = 0.4,
    TP_HEIGHT = 3,
    COLLECT_TIMEOUT = 8,
    PLACE_TIMEOUT = 8,
    REWARD_WAIT = 2,
    TP_STEP = 80,
}

-- ⭐ CARI ITEM (Yin/Yang) DI RUNTIME
local function findRitualItem(itemName)
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then return nil end
    local rt = hr:FindFirstChild("Runtime")
    if not rt then return nil end
    for _, obj in ipairs(rt:GetChildren()) do
        if obj:IsA("Model") and obj.Name:lower() == itemName:lower() then
            return obj
        end
    end
    return nil
end

-- ⭐ CEK PROMPT REWARD — SESUAI STRUKTUR GAME
-- Struktur: Runtime.Rewards_<uuid>.Pot1.Pickup [ActionText="Pick Up"]
local function findRewardPrompt()
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then return nil end
    local rt = hr:FindFirstChild("Runtime")
    if not rt then return nil end

    -- Cari folder Rewards_xxx (prefix "Rewards_")
    for _, folder in ipairs(rt:GetChildren()) do
        if folder:IsA("Folder") and folder.Name:lower():find("reward", 1, true) then
            for _, d in ipairs(folder:GetDescendants()) do
                if d:IsA("ProximityPrompt") then
                    local at = (d.ActionText or ""):lower()
                    local ot = (d.ObjectText or ""):lower()
                    -- "pick up" / "ritual candy pot"
                    if at:find("pick", 1, true) or ot:find("candy", 1, true) 
                       or ot:find("pot", 1, true) or ot:find("ritual", 1, true) then
                        return d
                    end
                end
            end
        end
    end

    return nil
end

-- ⭐ CEK YIN UDAH KE-PLACE (multi-source)
local function isYinPlaced()
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then return false end
    local rt = hr:FindFirstChild("Runtime")

    -- Cara 1: Yin GAK ADA di runtime = udah ke-place
    if rt then
        local yinInRT = rt:FindFirstChild("Yin")
        if not yinInRT then
            return true
        end
    end

    -- Cara 2: attribute player
    if LocalPlayer:GetAttribute("RitualYin") == true then return true end

    -- Cara 3: attribute slot
    local altar = hr:FindFirstChild("Altar")
    if altar then
        local slot = altar:FindFirstChild("YinPlacement")
        if slot then
            if slot:GetAttribute("Placed") == true then return true end
            for _, c in ipairs(slot:GetChildren()) do
                if c:IsA("Model") or c:IsA("BasePart") then
                    return true
                end
            end
        end
    end

    return false
end

-- ⭐ CEK YANG UDAH KE-PLACE (multi-source)
local function isYangPlaced()
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then return false end
    local rt = hr:FindFirstChild("Runtime")

    if rt then
        local yangInRT = rt:FindFirstChild("Yang")
        if not yangInRT then
            return true
        end
    end

    if LocalPlayer:GetAttribute("RitualYang") == true then return true end

    local altar = hr:FindFirstChild("Altar")
    if altar then
        local slot = altar:FindFirstChild("YangPlacement")
        if slot then
            if slot:GetAttribute("Placed") == true then return true end
            for _, c in ipairs(slot:GetChildren()) do
                if c:IsA("Model") or c:IsA("BasePart") then
                    return true
                end
            end
        end
    end

    return false
end

-- ⭐ FIRE PROMPT (paksa)
local function yinFirePrompt(prompt)
    if not prompt then return false end

    pcall(function()
        prompt.Enabled = true
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = math.huge
        prompt.RequiresLineOfSight = false
    end)

    if typeof(fireproximityprompt) == "function" then
        pcall(fireproximityprompt, prompt)
    end

    pcall(function()
        prompt:InputHoldBegin()
        task.wait(0.1)
        prompt:InputHoldEnd()
    end)

    return true
end

-- ⭐ TP STEP 80 STUDs
local function yinTp(pos)
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local targetPos = pos + Vector3.new(0, YinRitualCfg.TP_HEIGHT, 0)
    local startPos = root.Position
    local totalDist = (targetPos - startPos).Magnitude

    -- Jarak deket (< 80), langsung TP
    if totalDist <= YinRitualCfg.TP_STEP then
        root.CFrame = CFrame.new(targetPos)
        root.Velocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        return true
    end

    -- Step 80 studs
    local steps = math.ceil(totalDist / YinRitualCfg.TP_STEP)
    local dir = (targetPos - startPos)
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude > 1 then dir = dir.Unit end

    for i = 1, steps do
        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not r then return false end

        local dist = math.min(YinRitualCfg.TP_STEP * i, totalDist)
        local stepPos = startPos + dir * dist
        stepPos = Vector3.new(stepPos.X, targetPos.Y, stepPos.Z)

        r.CFrame = CFrame.new(stepPos)
        r.Velocity = Vector3.zero
        r.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.06)
    end

    -- Final TP
    local r2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r2 then
        r2.CFrame = CFrame.new(targetPos)
        r2.Velocity = Vector3.zero
        r2.AssemblyLinearVelocity = Vector3.zero
    end

    return true
end

-- ⭐ COLLECT YIN/YANG (step 80 + verifikasi)
-- ⭐ CEK ITEM UDAH DI TANGAN (character)
local function isHoldingRitualItem(itemName)
    local char = LocalPlayer.Character
    if not char then return false end

    -- Cek di character (model/tool)
    for _, obj in ipairs(char:GetChildren()) do
        if (obj:IsA("Model") or obj:IsA("Tool")) then
            local name = obj.Name:lower()
            if name:find(itemName:lower()) then
                return true
            end
        end
    end

    -- Cek attribute player
    if itemName == "Yin" and LocalPlayer:GetAttribute("HoldingYin") == true then
        return true
    end
    if itemName == "Yang" and LocalPlayer:GetAttribute("HoldingYang") == true then
        return true
    end

    return false
end

-- ⭐ CEK ITEM UDAH DI TANGAN ATAU UDAH KE-PLACE
local function isItemHandled(itemName)
    -- Kalo udah di tangan
    if isHoldingRitualItem(itemName) then return true end

    -- Kalo udah ke-place di altar
    if itemName == "Yin" and isYinPlaced() then return true end
    if itemName == "Yang" and isYangPlaced() then return true end

    return false
end

-- ⭐ COLLECT YIN/YANG (step 80 + verifikasi + SKIP kalo udah di tangan)
local function yinCollect(itemName)
    -- ⭐ CEK DULU: kalo udah di tangan atau udah ke-place → SKIP
    if isItemHandled(itemName) then
        print("[YIN] ⏭️ " .. itemName .. " udah di tangan / udah ke-place — SKIP")
        return true
    end

    local item = findRitualItem(itemName)
    if not item then
        -- Gak ada di runtime & gak di tangan → gak ada apa-apa
        return false
    end

    local startTime = os.clock()

    while os.clock() - startTime < YinRitualCfg.COLLECT_TIMEOUT do
        if not YinRitualState.Enabled then return false end

        -- ⭐ Cek lagi: kalo udah di tangan → SUKSES
        if isHoldingRitualItem(itemName) then
            print("[YIN] ✅ " .. itemName .. " ke-tangan!")
            return true
        end

        -- Cek masih ada di runtime
        item = findRitualItem(itemName)
        if not item then
            -- Gak ada di runtime. Cek di tangan
            if isHoldingRitualItem(itemName) then
                print("[YIN] ✅ " .. itemName .. " ke-tangan!")
                return true
            end
            return false
        end

        -- Cari root part
        local rootPart = item:FindFirstChild("Root")
        if not rootPart then
            rootPart = item:FindFirstChildWhichIsA("BasePart", true)
        end
        if not rootPart then
            task.wait(0.2)
            continue
        end

        -- Cari prompt
        local prompt = rootPart:FindFirstChild("RitualPrompt")
        if not prompt then
            prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
        end

        -- TP step 80
        yinTp(rootPart.Position)
        task.wait(0.15)

        -- Fire prompt 3x
        if prompt then
            for fire = 1, 3 do
                if not YinRitualState.Enabled then return false end
                if isHoldingRitualItem(itemName) then return true end
                if not item.Parent then break end
                yinFirePrompt(prompt)
                task.wait(0.15)
            end
        end

        task.wait(0.15)
    end

    return isHoldingRitualItem(itemName) or findRitualItem(itemName) == nil
end

-- ⭐ PLACE YIN/YANG — Cari prompt "Place" di SELURUH HeadlessRitual
local function yinPlace(itemName)
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then return false end

    -- Cek udah ke-place
    if itemName == "Yin" and isYinPlaced() then
        print("[YIN PLACE] ⏭️ Yin udah ke-place")
        return true
    end
    if itemName == "Yang" and isYangPlaced() then
        print("[YIN PLACE] ⏭️ Yang udah ke-place")
        return true
    end

    print("[YIN PLACE] 🎯 Try place " .. itemName)
    local startTime = os.clock()
    local fireCount = 0

    while os.clock() - startTime < YinRitualCfg.PLACE_TIMEOUT do
        if not YinRitualState.Enabled then return false end

        if itemName == "Yin" and isYinPlaced() then
            print("[YIN PLACE] ✅ Yin placed! (setelah " .. fireCount .. " fire)")
            return true
        end
        if itemName == "Yang" and isYangPlaced() then
            print("[YIN PLACE] ✅ Yang placed! (setelah " .. fireCount .. " fire)")
            return true
        end

        -- ⭐ CARI PROMPT "Place X" di SELURUH HeadlessRitual
        local targetPrompt = nil
        local targetPos = nil
        local matchItem = itemName:lower()

        for _, d in ipairs(hr:GetDescendants()) do
            if d:IsA("ProximityPrompt") and d.Enabled then
                local at = d.ActionText:lower()
                local ot = d.ObjectText:lower()

                -- Cek prompt "place" + "yin"/"yang"
                if at:find("place") and (at:find(matchItem) or ot:find(matchItem)) then
                    targetPrompt = d
                    local p = d.Parent
                    while p and not targetPos do
                        if p:IsA("BasePart") then targetPos = p.Position
                        elseif p:IsA("Model") then
                            local ok, pivot = pcall(function() return p:GetPivot().Position end)
                            if ok then targetPos = pivot end
                        end
                        p = p.Parent
                    end
                    if targetPos then break end
                end
            end
        end

        -- Fallback: prompt apapun yang ada "place"
        if not targetPrompt then
            for _, d in ipairs(hr:GetDescendants()) do
                if d:IsA("ProximityPrompt") and d.Enabled and d.ActionText:lower():find("place") then
                    targetPrompt = d
                    local p = d.Parent
                    while p and not targetPos do
                        if p:IsA("BasePart") then targetPos = p.Position
                        elseif p:IsA("Model") then
                            local ok, pivot = pcall(function() return p:GetPivot().Position end)
                            if ok then targetPos = pivot end
                        end
                        p = p.Parent
                    end
                    if targetPos then break end
                end
            end
        end

        -- Fallback terakhir: pake posisi slot
        if not targetPos then
            local altar = hr:FindFirstChild("Altar")
            if altar then
                local slot = altar:FindFirstChild(itemName .. "Placement")
                if slot then
                    if slot:IsA("Attachment") then targetPos = slot.WorldPosition
                    elseif slot:IsA("BasePart") then targetPos = slot.Position
                    end
                end
            end
        end

        if not targetPos then
            print("[YIN PLACE] ❌ Gak ada prompt/posisi buat " .. itemName)
            return false
        end

        -- ⭐ TP LANGSUNG ke posisi
        local char = LocalPlayer.Character
        if not char then return false end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return false end

        root.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
        root.Velocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.15)

        -- ⭐ FIRE PROMPT
        if targetPrompt then
            pcall(function()
                targetPrompt.Enabled = true
                targetPrompt.HoldDuration = 0
                targetPrompt.MaxActivationDistance = math.huge
                targetPrompt.RequiresLineOfSight = false
            end)

            if typeof(fireproximityprompt) == "function" then
                pcall(fireproximityprompt, targetPrompt)
                fireCount = fireCount + 1
            end
            task.wait(0.05)

            pcall(function()
                targetPrompt:InputHoldBegin()
                task.wait(0.08)
                targetPrompt:InputHoldEnd()
            end)
            fireCount = fireCount + 1
            task.wait(0.1)
        end

        task.wait(0.1)
    end

    if itemName == "Yin" then
        local r = isYinPlaced()
        print("[YIN PLACE] ⚠️ Timeout. isYinPlaced() = " .. tostring(r) .. " | Total: " .. fireCount)
        return r
    end
    if itemName == "Yang" then
        local r = isYangPlaced()
        print("[YIN PLACE] ⚠️ Timeout. isYangPlaced() = " .. tostring(r) .. " | Total: " .. fireCount)
        return r
    end
    return false
end

-- ⭐ COLLECT REWARD — TP + FIRE, sesuai struktur game
local function yinCollectReward()
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then 
        print("[YIN REWARD] HeadlessRitual gak ada")
        return false 
    end

    -- Cari prompt reward (retry 10x kalo belum spawn)
    local prompt, pos
    for try = 1, 10 do
        prompt = findRewardPrompt()
        if prompt then
            local p = prompt.Parent
            while p and p ~= hr and not pos do
                if p:IsA("BasePart") then
                    pos = p.Position
                elseif p:IsA("Model") then
                    local ok, pivot = pcall(function() return p:GetPivot().Position end)
                    if ok then pos = pivot end
                end
                p = p.Parent
            end
            if pos then break end
        end
        task.wait(0.3)
    end

    -- ⭐ FALLBACK: pake RewardPoints folder
    if not pos then
        local rp = hr:FindFirstChild("RewardPoints")
        if rp then
            for _, d in ipairs(rp:GetChildren()) do
                if d:IsA("BasePart") then
                    pos = d.Position
                    break
                elseif d:IsA("Attachment") then
                    pos = d.WorldPosition
                    break
                end
            end
        end
    end

    -- ⭐ FALLBACK 2: pake Altar position
    if not pos then
        local altar = hr:FindFirstChild("Altar")
        if altar and altar:IsA("BasePart") then
            pos = altar.Position + Vector3.new(0, 10, 0)
        end
    end

    if not pos then
        print("[YIN REWARD] ❌ Gak dapet posisi reward")
        return false
    end

    print("[YIN REWARD] 📍 Pos:", tostring(pos))

    -- TP + fire loop
    for attempt = 1, 20 do
        if not YinRitualState.Enabled then return false end

        -- Cek masih ada prompt?
        local curPrompt = findRewardPrompt()
        if not curPrompt then
            print("[YIN REWARD] ✅ Reward ke-tangan (attempt " .. attempt .. ")")
            return true
        end
        prompt = curPrompt

        -- Update posisi dari prompt terkini
        local p = prompt.Parent
        while p and p ~= hr and not p:IsA("BasePart") and not p:IsA("Model") do
            p = p.Parent
        end
        if p then
            if p:IsA("BasePart") then
                pos = p.Position
            elseif p:IsA("Model") then
                local ok, pivot = pcall(function() return p:GetPivot().Position end)
                if ok then pos = pivot end
            end
        end

        -- TP ke reward
        local char = LocalPlayer.Character
        if not char then return false end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return false end

        local targetCF = CFrame.new(pos + Vector3.new(0, 3, 0))

        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
            -- Handle naik pet
            local pet = hum.SeatPart:FindFirstAncestorOfClass("Model")
            if pet then
                local seat = hum.SeatPart
                local offset = root.CFrame:ToObjectSpace(seat.CFrame)
                root.CFrame = targetCF
                root.Velocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.05)
                local newSeatCF = targetCF * offset
                local pivotToSeat = pet:GetPivot():ToObjectSpace(seat.CFrame)
                local targetPivot = newSeatCF * pivotToSeat:Inverse()
                pcall(function() pet:PivotTo(targetPivot) end)
            else
                root.CFrame = targetCF
                root.Velocity = Vector3.zero
                root.AssemblyLinearVelocity = Vector3.zero
            end
        else
            root.CFrame = targetCF
            root.Velocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
        end

        task.wait(0.15)

        -- ⭐ FORCE ENABLE + FIRE
        pcall(function()
            prompt.Enabled = true
            prompt.HoldDuration = 0
            prompt.MaxActivationDistance = math.huge
            prompt.RequiresLineOfSight = false
        end)

        if typeof(fireproximityprompt) == "function" then
            pcall(fireproximityprompt, prompt)
        end
        task.wait(0.1)

        pcall(function()
            prompt:InputHoldBegin()
            task.wait(0.1)
            prompt:InputHoldEnd()
        end)
        task.wait(0.2)
    end

    if not findRewardPrompt() then
        print("[YIN REWARD] ✅ Reward ke-tangan (final)")
        return true
    end
    warn("[YIN REWARD] ❌ Gagal collect reward setelah 20 attempt")
    return false
end

-- ⭐ RETURN KE BASE
local function yinReturnToBase()
    local base = nil
    local candidates = {
        "HalloweenHomeAnchor", "HalloweenBase", "HalloweenSpawn",
        "HalloweenBaseplate", "HalloweenStart",
    }
    for _, name in ipairs(candidates) do
        local part = Workspace:FindFirstChild(name, true)
        if part and part:IsA("BasePart") then
            base = part
            break
        end
    end
    if not base then
        local hf = Workspace:FindFirstChild("Halloween")
        if hf then
            local sp = hf:FindFirstChildWhichIsA("SpawnLocation", true)
            if sp then base = sp
            else
                local bp = hf:FindFirstChildWhichIsA("BasePart", true)
                if bp then base = bp end
            end
        end
    end
    if not base then return false end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local startPos = root.Position
    local targetPos = base.Position + Vector3.new(0, 5, 0)
    local totalDist = (targetPos - startPos).Magnitude
    local stepSize = 100
    local steps = math.ceil(totalDist / stepSize)

    for i = 1, steps do
        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not r then break end
        local dist = math.min(stepSize * i, totalDist)
        local dir = (targetPos - startPos)
        dir = Vector3.new(dir.X, 0, dir.Z)
        if dir.Magnitude > 1 then dir = dir.Unit end
        r.CFrame = CFrame.new(startPos + dir * dist + Vector3.new(0, 5, 0))
        r.Velocity = Vector3.zero
        r.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.08)
    end
    task.wait(0.3)
    return true
end

-- ⭐ LOOP UTAMA
function Features.startAutoYinRitual()
    task.spawn(function()
        while task.wait(YinRitualCfg.SCAN_INTERVAL) do
            if not YinRitualState.Enabled then
                YinRitualState.Status = "⏸️ Idle"
                YinRitualState.Active = false
                continue
            end

            -- Priority check
            if Shared.AutoMutation_Enabled then
                local ms = Features.getMutationState and Features.getMutationState()
                if ms and (ms.Running or ms.EggLocked or ms.StealPaused) then
                    YinRitualState.Status = "⏸️ Waiting Auto Mutation..."
                    YinRitualState.Active = false
                    continue
                end
            end
            if _G.VRILZ_HalloweenBusy then
                YinRitualState.Status = "⏸️ Waiting Auto Halloween..."
                YinRitualState.Active = false
                continue
            end
            if Shared.MutationSteal_Active and Shared.MutationSteal_Enabled then
                YinRitualState.Status = "⏳ Waiting Mutation Steal..."
                YinRitualState.Active = false
                continue
            end

            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then
                YinRitualState.Status = "⏳ Waiting character..."
                task.wait(1)
                continue
            end

            -- ═══════════════════════════════════════════════
            -- STEP 1: CEK REWARD DULU
            -- ═══════════════════════════════════════════════
            if findRewardPrompt() then
                YinRitualState.Active = true
                YinRitualState.Status = "🎁 Collecting reward..."
                task.wait(0.5)

                local got = yinCollectReward()

                if got then
                    YinRitualState.RewardCount = YinRitualState.RewardCount + 1
                    YinRitualState.RitualCount = YinRitualState.RitualCount + 1
                    YinRitualState.Status = "✅ Reward #" .. YinRitualState.RewardCount .. " ke-tangan!"
                    task.wait(0.5)
                    YinRitualState.Status = "🏠 Returning..."
                    yinReturnToBase()
                    task.wait(YinRitualCfg.REWARD_WAIT)
                else
                    YinRitualState.Status = "⚠️ Reward retry..."
                    task.wait(1)
                end
                continue
            end

                        -- ═══════════════════════════════════════════════
            -- STEP 2: PRIORITAS YANG BELUM DI-HANDLE
            -- ═══════════════════════════════════════════════
            local yinItem = findRitualItem("Yin")
            local yangItem = findRitualItem("Yang")
            local yinPlaced = isYinPlaced()
            local yangPlaced = isYangPlaced()
            local yinHolding = isHoldingRitualItem("Yin")
            local yangHolding = isHoldingRitualItem("Yang")

            -- Yin: handle kalo BELUM di-place DAN BELUM di tangan
            if yinItem and not yinPlaced and not yinHolding then
                YinRitualState.Active = true
                YinRitualState.Status = "🔵 Collecting Yin..."
                if yinCollect("Yin") then
                    YinRitualState.YinCount = YinRitualState.YinCount + 1
                    YinRitualState.Status = "🔮 Placing Yin..."
                    task.wait(0.3)
                    if yinPlace("Yin") then
                        YinRitualState.Status = "✅ Yin placed!"
                    else
                        YinRitualState.Status = "⚠️ Yin place gagal"
                    end
                    task.wait(0.5)
                end
                continue
            end

            -- Yin udah di tangan tapi belum ke-place → place
            if yinHolding and not yinPlaced then
                YinRitualState.Active = true
                YinRitualState.Status = "🔮 Placing Yin (udah di tangan)..."
                if yinPlace("Yin") then
                    YinRitualState.Status = "✅ Yin placed!"
                else
                    YinRitualState.Status = "⚠️ Yin place gagal"
                end
                task.wait(0.5)
                continue
            end

            -- Yang: handle kalo BELUM di-place DAN BELUM di tangan
            if yangItem and not yangPlaced and not yangHolding then
                YinRitualState.Active = true
                YinRitualState.Status = "🔴 Collecting Yang..."
                if yinCollect("Yang") then
                    YinRitualState.YangCount = YinRitualState.YangCount + 1
                    YinRitualState.Status = "🔮 Placing Yang..."
                    task.wait(0.3)
                    if yinPlace("Yang") then
                        YinRitualState.Status = "✅ Yang placed!"
                    else
                        YinRitualState.Status = "⚠️ Yang place gagal"
                    end
                    task.wait(0.5)
                end
                continue
            end

            -- Yang udah di tangan tapi belum ke-place → place
            if yangHolding and not yangPlaced then
                YinRitualState.Active = true
                YinRitualState.Status = "🔮 Placing Yang (udah di tangan)..."
                if yinPlace("Yang") then
                    YinRitualState.Status = "✅ Yang placed!"
                else
                    YinRitualState.Status = "⚠️ Yang place gagal"
                end
                task.wait(0.5)
                continue
            end
            -- ═══════════════════════════════════════════════
            -- STEP 4: SCAN LAGI
            -- ═══════════════════════════════════════════════
            YinRitualState.Active = false
            YinRitualState.Status = "🔍 Scanning Yin & Yang..."
            task.wait(0.5)
        end
    end)
end

function Features.getYinRitualState()
    return YinRitualState
end

function Features.setYinRitualEnabled(v)
    YinRitualState.Enabled = v
    if v then
        YinRitualState.Status = "▶️ Starting..."
        YinRitualState.Active = true
    else
        YinRitualState.Status = "⏸️ Idle"
        YinRitualState.Active = false
    end
end

-- ============================================================
-- FEATURES.INIT
-- ============================================================
function Features.Init(sharedState)
    Shared = sharedState

    -- ⭐ SET DEFAULT BIAR AMAN
    if Shared.AntiAFK_Enabled == nil then Shared.AntiAFK_Enabled = true end
    if Shared.MutationSteal_Active == nil then Shared.MutationSteal_Active = false end
    if Shared.AutoRidePet_Enabled == nil then Shared.AutoRidePet_Enabled = true end
    if Shared.YinRitual_Enabled == nil then Shared.YinRitual_Enabled = false end

    -- ⭐ Guard: cegah double-start anti-AFK
    if not Features._antiAFKStarted then
        Features._antiAFKStarted = true
        Features.startAntiAFK()
    end

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
    Features.startAutoYinRitual()

           -- ⭐ AUTO-ENABLE AUTO RIDE PET — LANGSUNG ON
    Shared.AutoRidePet_Enabled = true
    Features.setAutoRideEnabled(true)

    task.spawn(function()
        -- Tunggu character loaded
        local timeout = 0
        while not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")) do
            task.wait(0.2)
            timeout = timeout + 0.2
            if timeout > 10 then break end
        end

        -- Tunggu sampe ada pet di backpack (max 15 detik)
        local petTimeout = 0
        while petTimeout < 15 do
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                local hasPet = false
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:GetAttribute("PetName") then
                        hasPet = true
                        break
                    end
                end
                if hasPet then break end
            end
            task.wait(0.5)
            petTimeout = petTimeout + 0.5
        end

        task.wait(0.3)
        Shared.AutoRidePet_Enabled = true
        Features.setAutoRideEnabled(true)
        if Shared.Notify then
            Shared.Notify("🐉 Auto Ride Pet: AUTO-ON", "success")
        end
    end)

    -- ⭐ RE-TRIGGER PAS RESPAWN
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(3)
        AutoRideState.LastPetName = nil
        if Shared and Shared.AutoRidePet_Enabled ~= false then
            if Features.setAutoRideEnabled then
                Features.setAutoRideEnabled(true)
            end
        end
    end)
    
    _G.VRILZ_Features = Features
_G.VRILZ_Shared = Shared
_G.VRILZ_UI_Shared = Shared
print("[VRILZHUB] Ride a Pet Features v3.8 loaded")
end

return Features
