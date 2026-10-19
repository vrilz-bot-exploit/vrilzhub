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
-- 🏆 PLATINUM WEBHOOK — Premium Discord Notifications
-- ============================================================
local HttpService = game:GetService("HttpService")

-- Platinum color palette
local PLATINUM_COLORS = {
    hero    = 15859455,   -- platinum silver
    gold    = 16766720,   -- gold accent
    success = 5763719,    -- green
    fire    = 16747520,   -- orange
    danger  = 15548997,   -- red
    info    = 3447003,    -- blue
}

-- ⭐ Normalize egg name dari MeshPart (display) ke nama asli
local function normalizeEggName(rawName)
    if not rawName then return "?" end
    local n = tostring(rawName)
    -- Hapus suffix umum
    n = n:gsub("_Model$", "")
    n = n:gsub("_Preview$", "")
    n = n:gsub("%s*Egg%s*$", "")
    n = n:gsub("_", " ")
    n = n:gsub("^%s+", ""):gsub("%s+$", "")
    -- Kapitalisasi awal
    n = n:gsub("^%l", string.upper)
    -- Kalo kosong, return raw
    if n == "" then return rawName end
    return n .. " Egg"
end


-- ⭐ Helper: ambil Weight & Luck — PRIORITAS dari EGG YANG DI-STEAL (instance real)
local function getEggInfoForWebhook(eggName)
    local info = {
        weight = "?",
        luck = "?",
        rarity = "?",
        chance = "?",
        price = "?",
    }

    -- ═══ PRIORITY 1: Ambil dari EGG YANG DI-TANGAN (DisplayEgg) ═══
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local wooden = char:FindFirstChild("Wooden")
        if not wooden then return end
        local displayEgg = wooden:FindFirstChild("DisplayEgg")
        if not displayEgg then return end

        for _, eggPart in ipairs(displayEgg:GetChildren()) do
            if eggPart:IsA("MeshPart") and not eggPart.Name:lower():find("circle") then
                -- Coba ambil dari attribute
                local kg = eggPart:GetAttribute("KG")
                       or eggPart:GetAttribute("Weight")
                       or eggPart:GetAttribute("Mass")
                if kg then info.weight = tostring(kg) end

                local lk = eggPart:GetAttribute("Luck")
                if lk then info.luck = tostring(lk) end

                local rar = eggPart:GetAttribute("Rarity")
                if rar then info.rarity = tostring(rar) end

                -- Coba ambil dari TextLabel (UI di atas egg)
                for _, d in ipairs(eggPart:GetDescendants()) do
                    if d:IsA("TextLabel") then
                        local t = d.Text or ""
                        -- format "123.45KG" / "123 KG" / "KG: 123"
                        local m = t:match("([%d%.]+)%s*[Kk][Gg]")
                            or t:match("[Kk][Gg]%s*:?%s*([%d%.]+)")
                        if m and info.weight == "?" then
                            info.weight = m .. "KG"
                        end
                        local lm = t:match("[Ll]uck%s*:?%s*([%d%.x]+)")
                        if lm and info.luck == "?" then
                            info.luck = lm
                        end
                    end
                end

                -- Kalo udah dapet semua, break
                if info.weight ~= "?" and info.luck ~= "?" then break end
            end
        end
    end)

    -- ═══ PRIORITY 2: Ambil dari RenderedEggs (egg di map yang lagi di-steal) ═══
    pcall(function()
        local rendered = game:GetService("Workspace"):FindFirstChild("RenderedEggs")
        if not rendered then return end
        local egg = rendered:FindFirstChild(eggName)
        if not egg then return end

        -- Attribute
        local kg = egg:GetAttribute("KG")
               or egg:GetAttribute("Weight")
               or egg:GetAttribute("Mass")
        if kg and info.weight == "?" then info.weight = tostring(kg) end

        local lk = egg:GetAttribute("Luck")
        if lk and info.luck == "?" then info.luck = tostring(lk) end

        -- TextLabel (EggLuck GUI di atas egg)
        local luckGui = egg:FindFirstChild("EggLuck", true)
        if luckGui then
            local luckLabel = luckGui:FindFirstChild("Luck")
            if luckLabel and luckLabel:IsA("TextLabel") and info.luck == "?" then
                info.luck = luckLabel.Text
            end
            local weightLabel = luckGui:FindFirstChild("Weight")
            if weightLabel and weightLabel:IsA("TextLabel") and info.weight == "?" then
                info.weight = weightLabel.Text
            end
        end
    end)

    -- ═══ PRIORITY 3: Fallback ke GameData (statik) ═══
    if info.weight == "?" then
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            local GameData = RS:FindFirstChild("GameData")
            if not GameData then return end

            local eggsMod = GameData:FindFirstChild("Eggs")
            if not eggsMod then return end

            local ok, eggData = pcall(require, eggsMod)
            if not ok or type(eggData) ~= "table" then return end

            local eggInfo = eggData[eggName]
                or eggData[eggName:gsub(" Egg$", "")]
                or eggData[eggName:gsub(" Egg$", "") .. "Egg"]

            if not eggInfo or type(eggInfo) ~= "table" then return end

            if info.weight == "?" then
                info.weight = tostring(eggInfo.Weight or eggInfo.weight or eggInfo.Mass or eggInfo.mass or eggInfo.KG or "?")
            end
            if info.luck == "?" then
                info.luck = tostring(eggInfo.Luck or eggInfo.luck or "?")
            end
            if info.rarity == "?" then
                info.rarity = tostring(eggInfo.Rarity or eggInfo.rarity or "?")
            end
            if info.chance == "?" then
                info.chance = tostring(eggInfo.Chance or eggInfo.chance or eggInfo.SpawnChance or "?")
            end
            if info.price == "?" then
                info.price = tostring(eggInfo.Price or eggInfo.price or eggInfo.Cost or "?")
            end
        end)
    end

    return info
end

-- ⭐ Helper: ambil Luck realtime dari DisplayEgg di game
local function getRealtimeEggLuck(eggName)
    local result = nil
    pcall(function()
        local rendered = game:GetService("Workspace"):FindFirstChild("RenderedEggs")
        if not rendered then return end
        local egg = rendered:FindFirstChild(eggName)
        if not egg then return end

        local luckGui = egg:FindFirstChild("EggLuck", true)
        if luckGui then
            local luckLabel = luckGui:FindFirstChild("Luck")
            if luckLabel and luckLabel:IsA("TextLabel") then
                result = luckLabel.Text
            end
        end
    end)
    return result
end

-- ⭐ FUNGSI UTAMA — PLATINUM WEBHOOK
local function sendPlatinumWebhook(eventType, data)
    if not Shared or not Shared.WebhookURL or Shared.WebhookURL == "" then return end
    if not Shared.WebhookEnabled then return end

    local now = os.clock()
    if Shared.WebhookLastSend and (now - Shared.WebhookLastSend) < 2 then return end
    Shared.WebhookLastSend = now

    -- Emoji set per event
    local ICONS = {
        rare_egg = { "💎", "🥚", "⚖️" },
        mutation = { "🔥", "⚗️", "✨" },
        hatch    = { "🥚", "🐾", "🎉" },
    }
    local icons = ICONS[eventType] or { "ℹ️", "📌", "⚙️" }

            local embeds = {}

    -- ═══ SINGLE EMBED — CLEAN PREMIUM ═══
    -- ⭐ Sensor nama player
    local function censorName(name)
        name = tostring(name or "?")
        if #name <= 3 then
            return name:sub(1, 1) .. string.rep("*", math.max(#name - 1, 1))
        elseif #name <= 6 then
            return name:sub(1, 2) .. string.rep("*", #name - 2)
        else
            return name:sub(1, 3) .. string.rep("*", math.min(#name - 3, 4))
        end
    end

    local safeDisplay = censorName(LocalPlayer.DisplayName)
    local safeName = censorName(LocalPlayer.Name)

    table.insert(embeds, {
        author = {
            name = "VRILZHUB  ·  King R A P",
            icon_url = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/WhatsApp%20Image%202026-10-16%20at%2018.56.22.jpeg",
        },
        title = icons[1] .. "  " .. data.title,
        description = table.concat({
            "**─────────────────────────**",
            "",
            (data.description or "Event trigger"),
            "",
            "**─────────────────────────**",
        }, "\n"),
        color = PLATINUM_COLORS.hero,
        image = {
            url = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/WhatsApp%20Image%202026-10-16%20at%2019.12.33.jpeg",
        },
        fields = (function()
            local f = {}

            -- ─── Section: USER ───
            table.insert(f, {
                name = "👤   ` PLAYER `",
                value = table.concat({
                    "**Name**  : `" .. safeDisplay .. "`",
                    "**User**  : `@" .. safeName .. "`",
                }, "\n"),
                inline = true,
            })

            -- ─── Section: GAME ───
            table.insert(f, {
                name = "🎮   ` SERVER `",
                value = table.concat({
                    "**Place** : `" .. game.PlaceId .. "`",
                    "**Key**   : `" .. tostring(Shared.KeyType or "FREE") .. "`",
                }, "\n"),
                inline = true,
            })

            -- ─── Section: TIME ───
            table.insert(f, {
                name = "⏰   ` TIME `",
                value = table.concat({
                    "**Clock** : `" .. os.date("%H:%M:%S") .. "`",
                    "**Date**  : `" .. os.date("%d/%m/%Y") .. "`",
                }, "\n"),
                inline = true,
            })

            -- ─── Divider ───
            table.insert(f, {
                name = "​",
                value = "**━━━━━━━━━━━━━━━━━━━━━━━━━**",
                inline = false,
            })

            -- ─── Details ───
            if data.details and #data.details > 0 then
                for i, d in ipairs(data.details) do
                    if i > 20 then break end
                    table.insert(f, {
                        name = d.name,
                        value = d.value,
                        inline = d.inline ~= false,
                    })
                end
            end

            return f
        end)(),
        footer = {
            text = "🏆  VRILZHUB KING  ×  v2.0  ×  Ride a Pet      discord.gg/c6MG68gwA",
            icon_url = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/WhatsApp%20Image%202026-10-16%20at%2018.56.22.jpeg",
        },
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
    })

    local payload = HttpService:JSONEncode({
        username = "🏆 VRILZHUB KING",
                avatar_url = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/WhatsApp%20Image%202026-10-16%20at%2018.56.22.jpeg",
        embeds = embeds,
    })

    pcall(function()
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if req then
            req({
                Url = Shared.WebhookURL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = payload,
            })
        end
    end)
end

-- Compatibility — biar trigger lama tetap jalan
_G.VRILZ_SendWebhook = function(eventType, data)
    sendPlatinumWebhook(eventType, data)
end

-- Expose helper ke _G
_G.VRILZ_GetEggInfo = getEggInfoForWebhook
_G.VRILZ_GetRealtimeLuck = getRealtimeEggLuck

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

-- ⭐ HELPER BARU: Konfirmasi egg beneran udah di tangan (DisplayEgg stabil)
local function confirmEggInHand(timeout)
    timeout = timeout or 4
    local startTime = os.clock()
    local lastResult = false
    local stableCount = 0

    while os.clock() - startTime < timeout do
        local holding = isHoldingEggLocal()
        if holding then
            lastResult = true
            stableCount = stableCount + 1
            -- Butuh 2x cek berturut-turut biar yakin (server udah register)
            if stableCount >= 2 then
                return true, os.clock() - startTime
            end
        else
            lastResult = false
            stableCount = 0
        end
        task.wait(0.25)
    end

    return lastResult, os.clock() - startTime
end

-- ⭐ INSTANT RETURN — TP langsung ke plot (delay 6 detik khusus Instant)
local function instantReturnToPlot()
    if not Shared.MutationReturn_Enabled then return end

    local char = LocalPlayer.Character
    local myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- ⭐ STEP 0: Konfirmasi egg di tangan dulu (max 4 detik)
    local holding = isHoldingEggLocal()
    if not holding then
        local ok = confirmEggInHand(4)
        if not ok then return end
    end

    -- ⭐ STEP 1: Delay 6 detik total sejak egg di tangan (KHUSUS INSTANT)
    local delayStart = os.clock()
    local DELAY_TOTAL = 6.0                          -- ⬅️ 4.0 → 6.0
    local missStart = nil
    while os.clock() - delayStart < DELAY_TOTAL do
        if isHoldingEggLocal() then
            missStart = nil
        else
            if not missStart then
                missStart = os.clock()
            elseif os.clock() - missStart > 3.0 then
                return
            end
        end
        task.wait(0.1)
    end
    if not isHoldingEggLocal() then return end

    -- ⭐ STEP 2: Re-check egg masih di tangan setelah delay
    if not isHoldingEggLocal() then return end

    char = LocalPlayer.Character
    myRoot = char and char:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local spawnPart = getMyPlotSpawn()
    if not spawnPart then return end

    -- ⭐ STEP 3: TP ke plot
    clearForces(myRoot)
    myRoot.CFrame = spawnPart.CFrame + Vector3.new(0, 5, 0)
    myRoot.Velocity = Vector3.zero
    myRoot.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.3)

    -- ⭐ STEP 4: Drop egg
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
    if not holding then
        local ok = confirmEggInHand(4)
        if not ok then
            -- ⭐ Fallback: egg mungkin udah di-drop di tanah, coba pickup ulang
            local spawnPart = getMyPlotSpawn()
            if spawnPart then
                local myRoot2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if myRoot2 then
                    -- cek apakah ada egg di sekitar plot
                    local rendered = Workspace:FindFirstChild("RenderedEggs")
                    if rendered then
                        for _, egg in ipairs(rendered:GetChildren()) do
                            if egg:IsA("Model") then
                                local eggPart = egg:FindFirstChildWhichIsA("BasePart", true)
                                if eggPart and (eggPart.Position - spawnPart.Position).Magnitude < 30 then
                                    local prompt = egg:FindFirstChild("Pickup", true)
                                    if prompt and prompt:IsA("ProximityPrompt") then
                                        prompt.HoldDuration = 0
                                        if typeof(fireproximityprompt) == "function" then
                                            pcall(fireproximityprompt, prompt)
                                            task.wait(0.5)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if not isHoldingEggLocal() then return end
        end
        holding = true
    end

    -- ⭐ DELAY 4 DETIK — toleransi flicker 1.5s (egg sering flicker di server)
    local delayStart = os.clock()
    local missStart = nil
    while os.clock() - delayStart < 4.0 do
        if isHoldingEggLocal() then
            missStart = nil
        else
            if not missStart then
                missStart = os.clock()
                        elseif os.clock() - missStart > 3.0 then
                return  -- beneran lepas >3s → abort
            end
        end
        task.wait(0.1)
    end
    if not isHoldingEggLocal() then return end

    local spawnPart = getMyPlotSpawn()
    -- ... sisanya sama seperti aslinya
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
    if not Shared.MutationReturn_Enabled then 
        print("[RETURN] ❌ MutationReturn_Enabled = false")
        return 
    end

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
-- INFINITY JUMP (FIXED v2)
-- ============================================================
local InfinityJumpState = {
    Enabled = false,
    Height = 50,
    MinHeight = 10,
    MaxHeight = 50,
    InputConn = nil,
    MobileHooked = false,
}

-- ⭐ Konversi Height → JumpPower buat max 50 studs
-- Rumus fisika Roblox: JumpPower = sqrt(2 * gravity * height)
-- Gravity default = 196.2 studs/s²
local function heightToPower(h)
    h = math.clamp(h, 10, 50)          -- ⭐ hard cap 50 studs
    local gravity = 196.2
    return math.sqrt(2 * gravity * h)  -- ⭐ fisika bener
end

local function applyJumpHeight()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local height = math.clamp(InfinityJumpState.Height, 10, 50)  -- ⭐ cap
    local power = heightToPower(height)

    pcall(function()
        hum.UseJumpPower = true
        hum.JumpPower = power
        -- Fallback: set JumpHeight juga (kalo game support)
        pcall(function() hum.JumpHeight = height end)
    end)
end

local function doJump()
    if not InfinityJumpState.Enabled then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end

    -- ⭐ Pastiin JumpPower udah di-set (idempotent, aman)
    -- Cuma re-apply kalo beda (biar gak reset terus)
    local targetPower = heightToPower(InfinityJumpState.Height)
    if math.abs(hum.JumpPower - targetPower) > 1 then
        applyJumpHeight()
    end

    pcall(function()
        hum.Jump = true
    end)
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end)
end

            function Features.startInfinityJump()
    local UserInputService = game:GetService("UserInputService")

    -- ⭐ PC: Space trigger — SIMPAN CONN biar gak dobel
    if InfinityJumpState.InputConn then
        pcall(function() InfinityJumpState.InputConn:Disconnect() end)
    end
    InfinityJumpState.InputConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.Space then
            doJump()
        end
    end)

    -- ⭐ MOBILE: hook jump button (kalo ada)
    task.spawn(function()
        if not UserInputService.TouchEnabled then return end

        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return end

        while task.wait(0.5) do
            local touchGui = playerGui:FindFirstChild("TouchGui")
            local touchFrame = touchGui and touchGui:FindFirstChild("TouchControlFrame")
            local jumpBtn = touchFrame and touchFrame:FindFirstChild("JumpButton")
            if jumpBtn and jumpBtn:IsA("ImageButton") then
                if not jumpBtn:GetAttribute("VrilzInfinityHooked") then
                    jumpBtn:SetAttribute("VrilzInfinityHooked", true)
                    -- ⭐ PAKE SALAH SATU AJA — MouseButton1Down lebih reliable
                    jumpBtn.MouseButton1Down:Connect(function()
                        doJump()
                    end)
                end
            end
        end
    end)

    -- ⭐ Re-apply on respawn
    LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        if InfinityJumpState.Enabled then
            applyJumpHeight()
        end
    end)
end
                
function Features.setInfinityJumpEnabled(v)
    InfinityJumpState.Enabled = v
    if v then
        applyJumpHeight()
    else
        -- ⭐ Restore default JumpPower
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum.UseJumpPower = true
                hum.JumpPower = 50
            end)
        end
    end
end

function Features.setInfinityJumpHeight(h)
    InfinityJumpState.Height = math.clamp(h, InfinityJumpState.MinHeight, InfinityJumpState.MaxHeight)
    if InfinityJumpState.Enabled then
        applyJumpHeight()
    end
end

function Features.getInfinityJumpState()
    return InfinityJumpState
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
-- CHARACTER FLY — Auto Fly + Height/Speed Dropdown
-- ============================================================
local FlyState = {
    Enabled = false,
    Flying = false,
    Height = 100,
    Speed = 300,
    VerticalSpeed = 150,
    BaseY = 0,
    BodyVelocity = nil,
    BodyGyro = nil,
    KeyStates = {},
    InputConn = nil,
    InputEndConn = nil,
    UpdateConn = nil,
}

local FLY_KEYS = {
    Up   = Enum.KeyCode.Space,
    Down = Enum.KeyCode.LeftControl,
}

local function fly_getRoot()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function fly_getHum()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

local function fly_cleanup()
    if FlyState.BodyVelocity then
        pcall(function() FlyState.BodyVelocity:Destroy() end)
        FlyState.BodyVelocity = nil
    end
    if FlyState.BodyGyro then
        pcall(function() FlyState.BodyGyro:Destroy() end)
        FlyState.BodyGyro = nil
    end

    local hum = fly_getHum()
    if hum then
        pcall(function()
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
        end)
    end

    FlyState.KeyStates = {}
end

local function fly_stop()
    FlyState.Flying = false
    if FlyState.UpdateConn then
        pcall(function() FlyState.UpdateConn:Disconnect() end)
        FlyState.UpdateConn = nil
    end
    fly_cleanup()
end

local function fly_start()
    if FlyState.Flying then return end
    local root = fly_getRoot()
    local hum = fly_getHum()
    if not root or not hum then return end

    fly_cleanup()

    FlyState.BaseY = root.Position.Y

    pcall(function()
        hum.PlatformStand = false
        hum:ChangeState(Enum.HumanoidStateType.Physics)
    end)

    local bv = Instance.new("BodyVelocity")
    bv.Name = "Vrilz_FlyBV"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.zero
    bv.Parent = root
    FlyState.BodyVelocity = bv

    local bg = Instance.new("BodyGyro")
    bg.Name = "Vrilz_FlyBG"
    bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bg.P = 5000
    bg.D = 500
    bg.CFrame = root.CFrame
    bg.Parent = root
    FlyState.BodyGyro = bg

    root.CFrame = CFrame.new(
        root.Position.X,
        FlyState.BaseY + FlyState.Height,
        root.Position.Z
    )

    FlyState.Flying = true

    if FlyState.UpdateConn then
        pcall(function() FlyState.UpdateConn:Disconnect() end)
    end
    FlyState.UpdateConn = RunService.RenderStepped:Connect(function()
        if not FlyState.Enabled then return end
        if not FlyState.Flying then return end

        local root2 = fly_getRoot()
        if not root2 or not FlyState.BodyVelocity then
            fly_stop()
            return
        end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local forward = 0
        local sideways = 0

        if FlyState.KeyStates[Enum.KeyCode.W] then forward = forward + 1 end
        if FlyState.KeyStates[Enum.KeyCode.S] then forward = forward - 1 end
        if FlyState.KeyStates[Enum.KeyCode.D] then sideways = sideways + 1 end
        if FlyState.KeyStates[Enum.KeyCode.A] then sideways = sideways - 1 end

        local camLook = cam.CFrame.LookVector
        camLook = Vector3.new(camLook.X, 0, camLook.Z)
        if camLook.Magnitude > 0.01 then camLook = camLook.Unit end

        local camRight = cam.CFrame.RightVector
        camRight = Vector3.new(camRight.X, 0, camRight.Z)
        if camRight.Magnitude > 0.01 then camRight = camRight.Unit end

        local horizVel = (camLook * forward + camRight * sideways)
        if horizVel.Magnitude > 0.01 then
            horizVel = horizVel.Unit * FlyState.Speed
        else
            horizVel = Vector3.zero
        end

        local vertVel = 0
        if FlyState.KeyStates[FLY_KEYS.Up] then
            vertVel = FlyState.VerticalSpeed
        elseif FlyState.KeyStates[FLY_KEYS.Down] then
            vertVel = -FlyState.VerticalSpeed
        end

                FlyState.BodyVelocity.Velocity = Vector3.new(
            horizVel.X,
            vertVel,
            horizVel.Z
        )

        -- ⭐ BARU: sync BaseY pas manual naik/turun (Space/LeftCtrl)
        if vertVel ~= 0 then
            FlyState.BaseY = root2.Position.Y - FlyState.Height
        end

        if camLook.Magnitude > 0.01 then
            FlyState.BodyGyro.CFrame = CFrame.lookAt(root2.Position, root2.Position + camLook)
        end
    end)
end

local function fly_setupInput()
    local UserInputService = game:GetService("UserInputService")

    if FlyState.InputConn then
        pcall(function() FlyState.InputConn:Disconnect() end)
    end
    if FlyState.InputEndConn then
        pcall(function() FlyState.InputEndConn:Disconnect() end)
    end

    FlyState.InputConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        FlyState.KeyStates[input.KeyCode] = true
    end)

    FlyState.InputEndConn = UserInputService.InputEnded:Connect(function(input)
        FlyState.KeyStates[input.KeyCode] = false
    end)
end

function Features.setFlyEnabled(v)
    FlyState.Enabled = v
    if v then
        fly_start()
        fly_setupInput()
    else
        fly_stop()
    end
end

function Features.setFlyHeight(h)
    local newH = math.clamp(h, 10, 1000)
    local oldH = FlyState.Height

    if FlyState.Flying then
        local root = fly_getRoot()
        if root then
            local delta = newH - oldH
            root.CFrame = CFrame.new(
                root.Position.X,
                root.Position.Y + delta,
                root.Position.Z
            )
            root.Velocity = Vector3.zero
            root.AssemblyLinearVelocity = Vector3.zero
            FlyState.BaseY = root.Position.Y - newH
        end
    end

    FlyState.Height = newH
end

function Features.setFlySpeed(s)
    FlyState.Speed = math.clamp(s, 10, 2000)
    FlyState.VerticalSpeed = math.clamp(s * 0.5, 20, 1000)
end

function Features.getFlyState()
    return FlyState
end

-- Auto-stop fly kalo fitur lain aktif + handle respawn
task.spawn(function()
    while task.wait(0.5) do
        if not FlyState.Enabled then continue end

        -- ⭐ Handle karakter respawn / mati / force hilang
        local root = fly_getRoot()
        local hum = fly_getHum()
        local forceLost = FlyState.Flying and (
            not root or 
            not hum or 
            hum.Health <= 0 or 
            not FlyState.BodyVelocity or
            not FlyState.BodyVelocity.Parent
        )

        if forceLost then
            fly_stop()
            task.wait(0.3)
            if FlyState.Enabled then
                fly_start()
            end
            continue
        end

        local shouldStop = false
        if Shared.AutoSteal_Enabled then shouldStop = true end
        if Shared.AutoFarm_Enabled then shouldStop = true end
        if Shared.AutoHatch_Enabled then shouldStop = true end
        if Shared.AutoPlantEgg_Enabled then shouldStop = true end
        if Shared.MutationSteal_Active then shouldStop = true end
        if Shared.VolcanicHunt_Enabled then shouldStop = true end
        if Shared.AutoMutation_Enabled then shouldStop = true end
        if Shared.YinRitual_Enabled then
            local ys = Features.getYinRitualState and Features.getYinRitualState()
            if ys and ys.Active then shouldStop = true end
        end

        if shouldStop and FlyState.Flying then
            fly_stop()
            if Shared.Notify then
                Shared.Notify("🛸 Fly auto-OFF — fitur lain aktif", "warning")
            end
        elseif not shouldStop and FlyState.Enabled and not FlyState.Flying then
            fly_start()
        end
    end
end)

-- ⭐ Re-fly pas respawn
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(2)
    if FlyState.Enabled and not FlyState.Flying then
        fly_start()
    end
end)

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
                    -- 🏆 PLATINUM WEBHOOK TRIGGER
                    if _G.VRILZ_SendWebhook then
                        local eggInfo = _G.VRILZ_GetEggInfo and _G.VRILZ_GetEggInfo(eggName) or {}
                        local realtimeLuck = _G.VRILZ_GetRealtimeLuck and _G.VRILZ_GetRealtimeLuck(eggName) or nil
                        local luckValue = realtimeLuck or eggInfo.luck or "?"

                        _G.VRILZ_SendWebhook("rare_egg", {
                            title = "RARE EGG DETECTED",
                            description = "**" .. eggName .. "** telah muncul di server!\n*Auto-steal akan segera dijalankan...*",
                            details = {
                                { name = "🥚  **EGG NAME**", value = "```yaml\n" .. eggName .. "\n```", inline = true },
                                { name = "💎  **RARITY**", value = "```yaml\n" .. eggRarity .. "\n```", inline = true },
                                { name = "⚖️  **WEIGHT**", value = "```yaml\n" .. (eggInfo.weight or "?") .. "\n```", inline = true },
                                { name = "🍀  **LUCK**", value = "```yaml\n" .. luckValue .. "\n```", inline = true },
                                { name = "🎲  **CHANCE**", value = "```yaml\n" .. (eggInfo.chance or "?") .. "\n```", inline = true },
                                { name = "📏  **DISTANCE**", value = "```yaml\n" .. math.floor(best.dist) .. " studs\n```", inline = true },
                            },
                        })
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
                                            Shared.Notify("🔥 Wait 4 seconds!", "success")
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

    -- ⭐ STABILIZE: toleransi flicker 3s
    local stableStart = os.clock()
    local missStart = nil
    local stableOk = false
    while os.clock() - stableStart < 4.0 do
        if isHoldingEggMutation() then
            missStart = nil
            stableOk = true
        else
            if not missStart then
                missStart = os.clock()
            elseif os.clock() - missStart > 3.0 then
                stableOk = false
                break
            end
        end
        task.wait(0.2)
    end
    if not stableOk or not isHoldingEggMutation() then
        MutationState.Running = false
        MutationState.StealPaused = false
        MutationState.EggLocked = false
        return false
    end

              -- 🏆 PLATINUM WEBHOOK TRIGGER
    if _G.VRILZ_SendWebhook then
        local cleanEggName = normalizeEggName(eggName)
        local eggInfo = _G.VRILZ_GetEggInfo and _G.VRILZ_GetEggInfo(cleanEggName) or {}
        
        _G.VRILZ_SendWebhook("mutation", {
            title = "MUTATION COMPLETE",
            description = "Egg berhasil di-mutasi! 🎉\n*Reward telah diklaim*",
            details = {
                { name = "🥚  **EGG NAME**", value = "```yaml\n" .. tostring(cleanEggName or "Unknown") .. "\n```", inline = true },
                { name = "⚖️  **WEIGHT**", value = "```yaml\n" .. (eggInfo.weight or "?") .. "\n```", inline = true },
                { name = "🍀  **LUCK**", value = "```yaml\n" .. (eggInfo.luck or "?") .. "\n```", inline = true },
                { name = "🔥  **MUTATION INFO**", value = "```yaml\nSource: Auto Mutation\nStatus: SUCCESS\nMethod: " .. tostring(Shared.StealMode or "TP") .. "\n```", inline = false },
            },
        })
    end

            if Shared.MutationReturn_Enabled then
        task.wait(0.5)  -- jeda webhook
        local oldFlag = Shared.AutoReturn_Enabled
        Shared.AutoReturn_Enabled = true
        doReturnToPlot()  -- delay 4s udah ada di dalam returnToMyPlot/instantReturnToPlot
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
                                    Shared.Notify("🔥 Wait 4 seconds!", "success")
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
                            Shared.Notify("🔥 Wait 4 seconds!", "success")
                        end
                                                -- 🏆 PLATINUM WEBHOOK TRIGGER
                                                if _G.VRILZ_SendWebhook then
                            local cleanEggName = normalizeEggName(egg.Name)
                            local eggInfo = _G.VRILZ_GetEggInfo and _G.VRILZ_GetEggInfo(cleanEggName) or {}

                            _G.VRILZ_SendWebhook("mutation", {
                                title = "MUTATION COMPLETE",
                                description = "Egg dari steal berhasil di-mutasi! 🔥",
                                details = {
                                    { name = "🥚  **EGG NAME**", value = "```yaml\n" .. tostring(cleanEggName or "Unknown") .. "\n```", inline = true },
                                    { name = "⚖️  **WEIGHT**", value = "```yaml\n" .. (eggInfo.weight or "?") .. "\n```", inline = true },
                                    { name = "🍀  **LUCK**", value = "```yaml\n" .. (eggInfo.luck or "?") .. "\n```", inline = true },
                                    { name = "🔥  **MUTATION INFO**", value = "```yaml\nSource: Mutation Steal\nStatus: SUCCESS\n```", inline = false },
                                },
                            })
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

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root then return false end

    -- ⭐ Config
    local FLY_HEIGHT = 40        -- terbang naik 30 studs dari tanah
    local FLY_STEP = 75         -- jarak per step terbang (studs)
    local FLY_WAIT = 0.08        -- delay per step

    -- ⭐ STEP 1: Terbang naik 30 studs dulu
    local startY = root.Position.Y
    local targetY = startY + FLY_HEIGHT

    while root and root.Parent and root.Position.Y < targetY do
        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not r then break end

        r.CFrame = r.CFrame + Vector3.new(0, 15, 0)
        r.Velocity = Vector3.zero
        r.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.03)

        root = r
    end

    task.wait(0.15)

    -- ⭐ STEP 2: Kalo naik pet → fly pet bareng
    char = LocalPlayer.Character
    root = char and char:FindFirstChild("HumanoidRootPart")
    hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root then return false end

    if hum and hum.SeatPart then
        local pet = hum.SeatPart:FindFirstAncestorOfClass("Model")
        if pet then
            local seat = hum.SeatPart
            local offset = root.CFrame:ToObjectSpace(seat.CFrame)

            -- ⭐ FLY STEP-BY-STEP ke base
            local targetPos = base.Position + Vector3.new(0, FLY_HEIGHT, 0)
            local startPos = root.Position
            local totalDist = (targetPos - startPos).Magnitude
            local steps = math.ceil(totalDist / FLY_STEP)

            local dir = (targetPos - startPos)
            if dir.Magnitude > 1 then dir = dir.Unit
            else dir = Vector3.new(0, 0, 0) end

            for i = 1, steps do
                local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not r then break end

                local dist = math.min(FLY_STEP * i, totalDist)
                local newRootCF = CFrame.new(startPos + dir * dist)

                -- Gerakin root
                r.CFrame = newRootCF
                r.Velocity = Vector3.zero
                r.AssemblyLinearVelocity = Vector3.zero

                -- Gerakin pet model bareng
                local newSeatCF = newRootCF * offset
                local pivotToSeat = pet:GetPivot():ToObjectSpace(seat.CFrame)
                local targetPivot = newSeatCF * pivotToSeat:Inverse()
                pcall(function() pet:PivotTo(targetPivot) end)

                task.wait(FLY_WAIT)
            end

            -- ⭐ Turun ke base
            local rFinal = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rFinal then
                rFinal.CFrame = base.CFrame + Vector3.new(0, HalloweenCfg.TP_HEIGHT, 0)
                rFinal.Velocity = Vector3.zero
                rFinal.AssemblyLinearVelocity = Vector3.zero
            end

            task.wait(HalloweenCfg.RETURN_WAIT)
            return true
        end
    end

    -- ⭐ STEP 3: Gak naik pet — FLY STEP-BY-STEP
    local targetPos = base.Position + Vector3.new(0, FLY_HEIGHT, 0)
    local startPos = root.Position
    local totalDist = (targetPos - startPos).Magnitude
    local steps = math.ceil(totalDist / FLY_STEP)

    local dir = (targetPos - startPos)
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude > 1 then dir = dir.Unit
    else
        local ang = math.random() * math.pi * 2
        dir = Vector3.new(math.cos(ang), 0, math.sin(ang))
    end

    for i = 1, steps do
        local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not r then break end

        local dist = math.min(FLY_STEP * i, totalDist)
        local pos = startPos + dir * dist

        -- Posisi Y tetap di ketinggian FLY_HEIGHT
        local flyPos = Vector3.new(pos.X, startPos.Y, pos.Z)

        r.CFrame = CFrame.new(flyPos)
        r.Velocity = Vector3.zero
        r.AssemblyLinearVelocity = Vector3.zero

        task.wait(FLY_WAIT)
    end

    -- ⭐ Turun ke base
    local rFinal = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if rFinal then
        rFinal.CFrame = base.CFrame + Vector3.new(0, HalloweenCfg.TP_HEIGHT, 0)
        rFinal.Velocity = Vector3.zero
        rFinal.AssemblyLinearVelocity = Vector3.zero
    end

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
    _G.VRILZ_HalloweenBusy = false   -- ⭐ FIX: reset flag pas OFF
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
    _lastRewardTime = 0,
    _collectingReward = false,
    _forcedHolding = {}, -- ⭐ Paksa inget state
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

local _cachedRewardPrompt = nil

local function findRewardPrompt()
    if _cachedRewardPrompt and _cachedRewardPrompt.Parent then
        return _cachedRewardPrompt
    end
    _cachedRewardPrompt = nil

    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then return nil end

    -- 1. Scan SEMUA ProximityPrompt di HeadlessRitual
    for _, d in ipairs(hr:GetDescendants()) do
        if d:IsA("ProximityPrompt") then
            local at = (d.ActionText or ""):lower()
            local ot = (d.ObjectText or ""):lower()
            if at:find("pick", 1, true) or ot:find("candy", 1, true)
               or ot:find("pot", 1, true) or ot:find("ritual", 1, true)
               or at:find("collect", 1, true) then
                _cachedRewardPrompt = d
                return d
            end
        end
    end

    -- 2. Fallback: cari prompt di dalam folder "Rewards_"
    local rt = hr:FindFirstChild("Runtime")
    if rt then
        for _, folder in ipairs(rt:GetChildren()) do
            if folder:IsA("Folder") and folder.Name:lower():find("reward", 1, true) then
                for _, d in ipairs(folder:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then
                        _cachedRewardPrompt = d
                        return d
                    end
                end
            end
        end
    end

    -- 3. Fallback: cek RewardPoints
    local rp = hr:FindFirstChild("RewardPoints")
    if rp then
        for _, d in ipairs(rp:GetChildren()) do
            if d:IsA("ProximityPrompt") then
                _cachedRewardPrompt = d
                return d
            end
        end
    end

    return nil
end
-- ═══════════════════════════════════════════════════════════
-- CACHE SCAN UI — biar gak freeze (max 1x/detik)
-- ═══════════════════════════════════════════════════════════
local _yinUICache = { t = 0, yin = false, yang = false, yinP = false, yangP = false }

local function _refreshYinUICache()
    if os.clock() - _yinUICache.t < 1.0 then return end
    _yinUICache.t = os.clock()
    _yinUICache.yin, _yinUICache.yang, _yinUICache.yinP, _yinUICache.yangP = false, false, false, false

    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end

    for _, gui in ipairs(playerGui:GetChildren()) do
        if gui:IsA("ScreenGui") then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text then
                    local txt = d.Text:lower()
                    if txt:find("already have") then
                        if txt:find("yin") then _yinUICache.yin = true end
                        if txt:find("yang") then _yinUICache.yang = true end
                    end
                    if txt:find("already placed") then
                        if txt:find("yin") then _yinUICache.yinP = true end
                        if txt:find("yang") then _yinUICache.yangP = true end
                    end
                end
            end
        end
    end
end

local function isHoldingRitualItem(itemName)
    -- ⭐ 1. CEK ATTRIBUTE PLAYER (Paling akurat)
    if itemName == "Yin" and LocalPlayer:GetAttribute("RitualYin") == true then return true end
    if itemName == "Yang" and LocalPlayer:GetAttribute("RitualYang") == true then return true end

    -- ⭐ 2. Cek UI Game (cached)
    _refreshYinUICache()
    if itemName == "Yin" and _yinUICache.yin then return true end
    if itemName == "Yang" and _yinUICache.yang then return true end

    -- ⭐ 3. Cek normal (Character & Backpack)
    local lowerName = itemName:lower()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    if char then
        for _, obj in ipairs(char:GetChildren()) do
            if (obj:IsA("Model") or obj:IsA("Tool")) and obj.Name:lower():find(lowerName, 1, true) then
                return true
            end
        end
    end

    if backpack then
        for _, obj in ipairs(backpack:GetChildren()) do
            if (obj:IsA("Tool") or obj:IsA("Model")) and obj.Name:lower():find(lowerName, 1, true) then
                return true
            end
        end
    end

    return false
end

local function isYinPlaced()
    _refreshYinUICache()
    if _yinUICache.yinP then return true end

    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if hr then
        local rt = hr:FindFirstChild("Runtime")
        if rt and rt:FindFirstChild("Yin") == nil then
            if not isHoldingRitualItem("Yin") then
                return true
            end
        end
    end

    return false
end

local function isYangPlaced()
    _refreshYinUICache()
    if _yinUICache.yangP then return true end

    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if hr then
        local rt = hr:FindFirstChild("Runtime")
        if rt and rt:FindFirstChild("Yang") == nil then
            if not isHoldingRitualItem("Yang") then
                return true
            end
        end
    end

        return false
end

-- 3) CEK ITEM HANDLED
local function isItemHandled(itemName)
    if isHoldingRitualItem(itemName) then return true end
    if itemName == "Yin" and isYinPlaced() then return true end
    if itemName == "Yang" and isYangPlaced() then return true end
    return false
end

-- 4) FIRE PROMPT
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

-- 5) TP STEP 80
local function yinTp(pos)
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

    local targetPos = pos + Vector3.new(0, YinRitualCfg.TP_HEIGHT, 0)
    local startPos = root.Position
    local totalDist = (targetPos - startPos).Magnitude

    if totalDist <= YinRitualCfg.TP_STEP then
        root.CFrame = CFrame.new(targetPos)
        root.Velocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        return true
    end

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

    local r2 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r2 then
        r2.CFrame = CFrame.new(targetPos)
        r2.Velocity = Vector3.zero
        r2.AssemblyLinearVelocity = Vector3.zero
    end

    return true
end

-- 6) COLLECT YIN/YANG
local function yinCollect(itemName)
    if isHoldingRitualItem(itemName) then
        print("[YIN] ⏭️ " .. itemName .. " udah di tangan — SKIP collect")
        return true
    end

    local item = findRitualItem(itemName)
    if not item then return false end

    local startTime = os.clock()

    while os.clock() - startTime < YinRitualCfg.COLLECT_TIMEOUT do
        if not YinRitualState.Enabled then return false end

        if isHoldingRitualItem(itemName) then return true end

        item = findRitualItem(itemName)
        if not item then
            task.wait(0.3)
            if isHoldingRitualItem(itemName) then return true end
            return false
        end

        local rootPart = item:FindFirstChild("Root") or item:FindFirstChildWhichIsA("BasePart", true)
        if not rootPart then task.wait(0.2) continue end

        local prompt = rootPart:FindFirstChild("RitualPrompt") or item:FindFirstChildWhichIsA("ProximityPrompt", true)

        yinTp(rootPart.Position)
        task.wait(0.15)

        if prompt then
            for fire = 1, 3 do
                if not YinRitualState.Enabled then return false end
                -- ⭐ Set paksa biar langsung nyadar kalo udah dapet
                YinRitualState._forcedHolding[itemName] = true
                yinFirePrompt(prompt)
                task.wait(0.2)
            end
        end
        task.wait(0.15)
    end
    return isHoldingRitualItem(itemName)
end

-- 7) PLACE YIN/YANG — SMART COOLDOWN DETECTOR (FINAL & BERSIH)
local function yinPlace(itemName)
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then return false end

    if itemName == "Yin" and isYinPlaced() then return true end
    if itemName == "Yang" and isYangPlaced() then return true end

    print("[YIN PLACE] 🎯 Mencari prompt 'Place " .. itemName .. "'...")
    local startTime = os.clock()
    local lastFireTime = 0

    local function isOnCooldown()
        local phase = hr:GetAttribute("Phase")
        local cdUntil = hr:GetAttribute("CooldownUntil")
        if phase == "Cooldown" then return true end
        if cdUntil and typeof(cdUntil) == "number" and os.time() < cdUntil then return true end
        return false
    end

    local function findPlacementPrompt()
        local targetAction = "place " .. itemName:lower()
        for _, d in ipairs(hr:GetDescendants()) do
            if d:IsA("ProximityPrompt") and (d.ActionText or ""):lower():find(targetAction, 1, true) then
                return d
            end
        end
        return nil
    end

    local function getPromptPos(prompt)
        local p = prompt.Parent
        while p and p ~= hr do
            if p:IsA("BasePart") then return p.Position end
            if p:IsA("Model") then
                local ok, pivot = pcall(function() return p:GetPivot().Position end)
                if ok then return pivot end
            end
            p = p.Parent
        end
        return nil
    end

    while os.clock() - startTime < 20 do
        if not YinRitualState.Enabled then return false end

if itemName == "Yin" and isYinPlaced() then
    YinRitualState._forcedHolding["Yin"] = nil
    print("[YIN PLACE] ✅ Yin BERHASIL DI-PLACE!")
    return true
end
if itemName == "Yang" and isYangPlaced() then
    YinRitualState._forcedHolding["Yang"] = nil
    print("[YIN PLACE] ✅ Yang BERHASIL DI-PLACE!")
    return true
end

        if isOnCooldown() then
            local sisa = math.max(0, math.floor((hr:GetAttribute("CooldownUntil") or 0) - os.time()))
            print("[YIN PLACE] ⏳ Cave Cooldown! Nunggu " .. sisa .. " detik...")
            task.wait(3)
            startTime = os.clock() 
            continue
        end

        local prompt = findPlacementPrompt()
        if not prompt then task.wait(0.5) continue end

        local pos = getPromptPos(prompt)
        if pos then
            local curRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if curRoot then
                -- ⭐ 1. TP SEKALI AJA LANGSUNG KE ALTAR (Gak pake step-step)
                -- Kalo masih patah-patah, berarti game-nya emang nge-lag / anti-cheat-nya ketat.
                curRoot.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
                curRoot.Velocity = Vector3.zero
                curRoot.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.5) -- Jeda 0.5 detik biar server baca posisi lo
            end
        end

        pcall(function()
            prompt.Enabled = true
            prompt.HoldDuration = 0
            prompt.MaxActivationDistance = 50
            prompt.RequiresLineOfSight = false
        end)

                -- ⭐ 2. KLIK PROMPT (VIM dihapus)
        if os.clock() - lastFireTime > 1.5 then
            if typeof(fireproximityprompt) == "function" then
                pcall(fireproximityprompt, prompt)
            end

            lastFireTime = os.clock()
        end

        task.wait(0.5)
    end

    return (itemName == "Yin") and isYinPlaced() or isYangPlaced()
end

-- 8) COLLECT REWARD — juga HILANG di file lo!
local function yinCollectReward()
    local hr = Workspace:FindFirstChild("HeadlessRitual")
    if not hr then
        print("[YIN REWARD] HeadlessRitual gak ada")
        return false
    end

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
        -- ⭐ hapus task.wait(0.3) — langsung loop
    end

    if not pos then
        local rp = hr:FindFirstChild("RewardPoints")
        if rp then
            for _, d in ipairs(rp:GetChildren()) do
                if d:IsA("BasePart") then pos = d.Position; break end
                if d:IsA("Attachment") then pos = d.WorldPosition; break end
            end
        end
    end

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

    for attempt = 1, 20 do
        if not YinRitualState.Enabled then return false end

        local curPrompt = findRewardPrompt()
        if not curPrompt then
            print("[YIN REWARD] ✅ Reward ke-tangan (attempt " .. attempt .. ")")
            return true
        end
        prompt = curPrompt

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

        local char = LocalPlayer.Character
        if not char then return false end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return false end

        local targetCF = CFrame.new(pos + Vector3.new(0, 3, 0))
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.SeatPart then
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
        print("[YIN REWARD] ✅ Reward ke-tangan (prompt hilang)")
        return true
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if backpack then
        for _, obj in ipairs(backpack:GetChildren()) do
            if (obj:IsA("Tool") or obj:IsA("Model")) and obj.Name:lower():find("candy") then
                print("[YIN REWARD] ✅ Reward ada di backpack")
                return true
            end
        end
    end

    local hr2 = Workspace:FindFirstChild("HeadlessRitual")
    if hr2 then
        local rt2 = hr2:FindFirstChild("Runtime")
        if rt2 then
            local hasRewardFolder = false
            for _, f in ipairs(rt2:GetChildren()) do
                if f:IsA("Folder") and f.Name:lower():find("reward", 1, true) then
                    hasRewardFolder = true
                    break
                end
            end
            if not hasRewardFolder then
                print("[YIN REWARD] ✅ Gak ada reward folder → reward ke-ambil")
                return true
            end
        end
    end

    local char = LocalPlayer.Character
    if char then
        for _, obj in ipairs(char:GetChildren()) do
            if (obj:IsA("Model") or obj:IsA("Tool")) and obj.Name:lower():find("candy") then
                print("[YIN REWARD] ✅ Reward ke-tangan (candy di character)")
                return true
            end
        end
    end

    warn("[YIN REWARD] ❌ Gagal collect reward")
    return false
end

-- 9) RETURN TO BASE — juga HILANG!
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
            print("[YIN RETURN] Base:", part:GetFullName())
            break
        end
    end

    if not base then
        local hf = Workspace:FindFirstChild("Halloween")
        if hf then
            local sp = hf:FindFirstChildWhichIsA("SpawnLocation", true)
            if sp then
                base = sp
            else
                local bp = hf:FindFirstChildWhichIsA("BasePart", true)
                if bp then base = bp end
            end
        end
    end

    if not base then
        local Plots = Workspace:FindFirstChild("Plots")
        if Plots then
            for _, plot in ipairs(Plots:GetChildren()) do
                local owner = plot:GetAttribute("OwnerUserId") or plot:GetAttribute("Owner")
                if owner == LocalPlayer.UserId or owner == LocalPlayer.Name then
                    local sp = plot:FindFirstChild("Spawn", true)
                            or plot:FindFirstChildWhichIsA("SpawnLocation", true)
                            or plot:FindFirstChild("Baseplate", true)
                            or plot:FindFirstChildWhichIsA("BasePart", true)
                    if sp then base = sp end
                    break
                end
            end
        end
    end

    if not base then
        local hr = Workspace:FindFirstChild("HeadlessRitual")
        if hr then
            local origin = hr:FindFirstChild("Origin")
            if origin and origin:IsA("BasePart") then base = origin end
        end
    end

    if not base then
        warn("[YIN RETURN] ❌ GAK ADA base — skip return")
        return false
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end

        local startPos = root.Position
    local targetPos = base.Position + Vector3.new(0, 5, 0)

    -- ⭐ LANGSUNG TP SEKALI — tanpa step, tanpa delay
    local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if r then
        r.CFrame = CFrame.new(targetPos)
        r.Velocity = Vector3.zero
        r.AssemblyLinearVelocity = Vector3.zero
    end

    print("[YIN RETURN] ✅ Selesai")
    return true
end

function Features.startAutoYinRitual()
    task.spawn(function()
        while task.wait(YinRitualCfg.SCAN_INTERVAL) do
            if not YinRitualState.Enabled then
                YinRitualState.Status = "⏸️ Idle"
                YinRitualState.Active = false
                continue
            end

            -- Global cooldown reward
            local _now = os.clock()
            if YinRitualState._lastRewardTime and (_now - YinRitualState._lastRewardTime) < 20 then
                YinRitualState.Status = "⏳ Reward cooldown... (" ..
                    math.floor(20 - (_now - YinRitualState._lastRewardTime)) .. "s)"
                YinRitualState.Active = false
                task.wait(1)
                continue
            end

            -- Priority checks
            if Shared.AutoMutation_Enabled then
                local ms = Features.getMutationState and Features.getMutationState()
                if ms and (ms.Running or ms.EggLocked or ms.StealPaused) then
                    YinRitualState.Status = "⏸️ Waiting Auto Mutation..."
                    YinRitualState.Active = false
                    continue
                end
            end

            local hs = Features.getHalloweenState and Features.getHalloweenState()
            if hs and hs.Enabled and _G.VRILZ_HalloweenBusy then
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

                        -- ═══ STEP 1: REWARD ═══
            if findRewardPrompt() then
                YinRitualState.Active = true
                YinRitualState.Status = "🎁 Collecting reward..."

                local got = yinCollectReward()

                if got then
                    YinRitualState._lastRewardTime = os.clock()
                    YinRitualState.RewardCount = YinRitualState.RewardCount + 1
                    YinRitualState.RitualCount = YinRitualState.RitualCount + 1
                    YinRitualState.Status = "✅ Reward #" .. YinRitualState.RewardCount .. " ke-tangan!"
                    YinRitualState.Status = "🏠 Returning to base..."
                    yinReturnToBase()
                    YinRitualState._lastRewardTime = os.clock()
                    YinRitualState.Status = "⏳ Cooldown 20s..."
                else
                    YinRitualState.Status = "⚠️ Reward retry..."
                end
                continue
            end

            -- ═══ STEP 2: PRIORITAS MUTLAK ═══
local yinHolding  = isHoldingRitualItem("Yin")
local yangHolding = isHoldingRitualItem("Yang")
local yinPlaced   = isYinPlaced()
local yangPlaced  = isYangPlaced()

-- PRIORITAS #1: Yin di tangan & BELUM placed
if yinHolding and not yinPlaced then
    YinRitualState.Active = true
    YinRitualState.Status = "🔮 Placing Yin (di tangan)..."
    local ok = yinPlace("Yin")
    if ok then
        YinRitualState.Status = "✅ Yin placed!"
        YinRitualState._forcedHolding["Yin"] = nil -- ⭐ HAPUS STATE PAKSA
    else
        YinRitualState.Status = "⚠️ Yin place gagal — retry..."
    end
    task.wait(0.5)
    continue
end

-- PRIORITAS #2: Yang di tangan & BELUM placed
if yangHolding and not yangPlaced then
    YinRitualState.Active = true
    YinRitualState.Status = "🔮 Placing Yang (di tangan)..."
    local ok = yinPlace("Yang")
    if ok then
        YinRitualState.Status = "✅ Yang placed!"
        YinRitualState._forcedHolding["Yang"] = nil -- ⭐ HAPUS STATE PAKSA
    else
        YinRitualState.Status = "⚠️ Yang place gagal — retry..."
    end
    task.wait(0.5)
    continue
end

            -- PRIORITAS #3: Yin ada di runtime & belum di-place & belum di tangan → collect
            local yinItem = findRitualItem("Yin")
            local yangItem = findRitualItem("Yang")

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

                        -- PRIORITAS #4: Yang ada di runtime & belum di-place & belum di tangan → collect
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

            -- STEP 4: SCAN LAGI
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
    if Shared.Fly_Enabled == nil then Shared.Fly_Enabled = false end
    if Shared.Fly_Height == nil then Shared.Fly_Height = 100 end
    if Shared.Fly_Speed == nil then Shared.Fly_Speed = 300 end

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
    Features.startInfinityJump()

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
end   -- ⭐⭐⭐ TUTUP Features.Init DI SINI ⭐⭐⭐

-- ============================================================
-- AUTO OBBY (TALK + FLY TO FINISH + 30 MIN COOLDOWN)
-- ============================================================
local ObbyState = {
    Running = false,
}

function Features.startAutoObby()
    if ObbyState.Running then return end
    ObbyState.Running = true

    task.spawn(function()
        local player = game.Players.LocalPlayer
        local char = player.Character or player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        local VIM = game:GetService("VirtualInputManager")
        local COOLDOWN = 30 * 60 -- 30 menit

        -- ═══ CEK COOLDOWN ═══
        local lastFinish = 0
        if isfile and readfile then
            if isfile("vrilz_obby_time.txt") then
                local ok, content = pcall(readfile, "vrilz_obby_time.txt")
                if ok and tonumber(content) then
                    lastFinish = tonumber(content)
                end
            end
        end

        local now = os.time()
        local timePassed = now - lastFinish
        
        if timePassed < COOLDOWN then
            local sisaMenit = math.ceil((COOLDOWN - timePassed) / 60)
            if Shared.Notify then
                Shared.Notify("⏳ Cooldown! Tunggu " .. sisaMenit .. " menit lagi.", "warning")
            end
            ObbyState.Running = false
            return
        end
        
        -- ═══ 1. TALK KE SKELETON ═══
        local npc = workspace:FindFirstChild("SkeletonNPC")
        if not npc then 
            ObbyState.Running = false
            return 
        end
        local rig = npc:FindFirstChild("Rig")
        if not rig then 
            ObbyState.Running = false
            return 
        end
        local prompt = rig:FindFirstChildWhichIsA("ProximityPrompt", true)
        
        print("[AUTO OBBY] Talk ke Skeleton...")
        local rigRoot = rig:FindFirstChild("HumanoidRootPart") 
    or rig:FindFirstChild("Torso") 
    or rig:FindFirstChild("UpperTorso")
    or rig:FindFirstChildWhichIsA("BasePart")

if not rigRoot then
    print("[AUTO OBBY] NPC gak punya part buat dideketin!")
    ObbyState.Running = false
    return
end

hrp.CFrame = rigRoot.CFrame * CFrame.new(0, 0, 3)
        task.wait(0.5)
        if prompt then fireproximityprompt(prompt) end
        task.wait(1.5)
        
        -- ═══ 2. KLIK "LET'S GO" ═══
print("[AUTO OBBY] Milih Let's go...")
local startTime = tick()
local clicked = false

while tick() - startTime < 4 do
    for _, gui in ipairs(player.PlayerGui:GetDescendants()) do
        -- Pastiin gui itu TextButton/ImageButton dan punya Visible
        if (gui:IsA("TextButton") or gui:IsA("ImageButton")) and gui:IsA("GuiObject") then
            local isVisible = gui.Visible
            if isVisible then
                local isTarget = false
                
                -- Cek nama
                local guiName = string.lower(gui.Name or "")
                if guiName:find("let", 1, true) or guiName:find("go", 1, true) then 
                    isTarget = true 
                end
                
                -- Cek teks (khusus TextButton)
                if not isTarget and gui:IsA("TextButton") then
                    local guiText = string.lower(gui.Text or "")
                    if guiText:find("let", 1, true) or guiText:find("go", 1, true) then 
                        isTarget = true 
                    end
                end
                
                if isTarget then
                    -- Cek AbsolutePosition & AbsoluteSize valid
                    local absPos = gui.AbsolutePosition
                    local absSize = gui.AbsoluteSize
                    
                    if absPos and absSize then
                        local cx = absPos.X + (absSize.X / 2)
                        local cy = absPos.Y + (absSize.Y / 2)
                        
                        -- Pastiin cx, cy itu number valid
                        if type(cx) == "number" and type(cy) == "number" and cx > 0 and cy > 0 then
                            print("[AUTO OBBY] Klik tombol:", gui:GetFullName())
                            
                            pcall(function() gui.MouseButton1Click:Fire() end)
                            pcall(function() gui.Activated:Fire() end)
                            
                            pcall(function()
                                VIM:SendMouseMoveEvent(cx, cy, 0)
                            end)
                            task.wait(0.05)
                            pcall(function()
                                VIM:SendMouseButtonEvent(cx, cy, 0, true, game, 1)
                            end)
                            task.wait(0.05)
                            pcall(function()
                                VIM:SendMouseButtonEvent(cx, cy, 0, false, game, 1)
                            end)
                            
                            clicked = true
                        end
                    end
                end
            end
        end
    end
    
    if clicked then break end
    task.wait(0.2)
end

if clicked then
    print("[AUTO OBBY] ✅ Berhasil klik Let's go")
else
    print("[AUTO OBBY] ⚠️ Gak nemu tombol Let's go yang valid")
end

        -- ═══ 3. TUNGGU MENTAL KE OBBY ═══
        print("[AUTO OBBY] Nunggu mental ke obby...")
        local waitStart = tick()
        while tick() - waitStart < 15 do
            if hrp.Position.X > 20000 then break end
            task.wait(0.5)
        end

        -- ⭐ DELAY 8 DETIK — biar obby load dulu sebelum terbang
        print("[AUTO OBBY] ⏳ Delay 8 detik — nunggu obby load...")
        task.wait(8)

        -- ⭐ Refresh char & hrp setelah delay
        char = player.Character or player.CharacterAdded:Wait()
        hrp = char:WaitForChild("HumanoidRootPart")

        -- ═══ 4. TP GLIDE KE FINISH ═══
        print("[AUTO OBBY] Terbang ke Finish...")
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
        
        local obbyFolder = workspace:FindFirstChild("HalloweenObbyRuns")
        if not obbyFolder then 
            ObbyState.Running = false
            return 
        end
        local activeFolder = obbyFolder:FindFirstChild("5126297278")
        if not activeFolder then 
            ObbyState.Running = false
            return 
        end
        local finishModel = activeFolder:FindFirstChild("Finish")
        if not finishModel then 
            ObbyState.Running = false
            return 
        end
        
        local finishPos = finishModel:GetPivot().Position
        local flyHeight = math.max(hrp.Position.Y, finishPos.Y) + 50
        
        while hrp and hrp.Position.Y < flyHeight do
            hrp.CFrame = hrp.CFrame + Vector3.new(0, 20, 0)
            hrp.Velocity = Vector3.zero
            task.wait(0.05)
            hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        end
        task.wait(0.5)
        
        local startP = hrp.Position
        local totalDist = (finishPos - startP).Magnitude
        local steps = math.ceil(totalDist / 40)
        local dir = (finishPos - startP).Unit
        
        for i = 1, steps do
            local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not r then break end
            local dist = math.min(40 * i, totalDist)
            local newPos = Vector3.new(startP.X + dir.X * dist, flyHeight, startP.Z + dir.Z * dist)
            r.CFrame = CFrame.new(newPos)
            r.Velocity = Vector3.zero
            r.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.05)
        end
        task.wait(0.5)
        
        local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local currentY = r.Position.Y
        while currentY > finishPos.Y + 5 do
            currentY = currentY - 10
            if currentY < finishPos.Y + 5 then currentY = finishPos.Y + 5 end
            r.CFrame = CFrame.new(r.Position.X, currentY, r.Position.Z)
            r.Velocity = Vector3.zero
            task.wait(0.05)
            r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        end
        
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
        
        -- ═══ 5. VERIFIKASI FINISH + TRIGGER DELIVERY ═══
print("[AUTO OBBY] Verifikasi finish...")

-- 5a. Cek player beneran deket Finish model
local function isNearFinish()
    local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not r then return false end
    if not finishModel or not finishModel.Parent then return false end
    local finishPos2 = finishModel:GetPivot().Position
    local dist = (r.Position - finishPos2).Magnitude
    return dist <= 25  -- toleransi 25 studs
end

-- 5b. Cari ProximityPrompt / TouchPart di Finish & trigger manual
local function triggerFinishDelivery()
    if not finishModel or not finishModel.Parent then return false end

    -- Cari prompt di dalam finish
    local prompt = finishModel:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt then
        prompt.HoldDuration = 0
        prompt.MaxActivationDistance = math.huge
        prompt.RequiresLineOfSight = false
        if typeof(fireproximityprompt) == "function" then
            pcall(fireproximityprompt, prompt)
            task.wait(0.3)
            pcall(fireproximityprompt, prompt)
        end
        return true
    end

    -- Fallback: cari RemoteEvent delivery
    local remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    local gameR = remotes and remotes:FindFirstChild("Game")
    if gameR then
        for _, name in ipairs({"ObbyFinish", "FinishObby", "CompleteObby", "ObbyComplete", "DeliveryComplete"}) do
            local r = gameR:FindFirstChild(name)
            if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then
                pcall(function() r:FireServer() end)
                task.wait(0.3)
                return true
            end
        end
    end

    return false
end

-- 5c. Loop verifikasi: TP ulang kalo belum nyampe, trigger delivery, tunggu konfirmasi
local verified = false
local startVerify = tick()

while tick() - startVerify < 20 do
    if not ObbyState.Running then break end

    -- Refresh char/hrp
    local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not r then task.wait(0.5) continue end

    -- TP ulang ke finish kalo masih jauh
    if not isNearFinish() then
        local fp = finishModel:GetPivot().Position
        r.CFrame = CFrame.new(fp + Vector3.new(0, 5, 0))
        r.Velocity = Vector3.zero
        r.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.5)
        continue
    end

    -- Udah deket finish → trigger delivery
    triggerFinishDelivery()
    task.wait(0.8)

    -- ⭐ Cek konfirmasi: attribute / folder / UI
    local confirmed = false

    -- (1) Attribute player
    if LocalPlayer:GetAttribute("ObbyCompleted") == true then confirmed = true end
    if LocalPlayer:GetAttribute("ObbyFinished") == true then confirmed = true end
    if LocalPlayer:GetAttribute("DeliveryCompleted") == true then confirmed = true end

    -- (2) Folder HalloweenObbyRuns hilang / Finish dihapus = udah selesai
    local obbyFolder2 = workspace:FindFirstChild("HalloweenObbyRuns")
    local activeFolder2 = obbyFolder2 and obbyFolder2:FindFirstChild("5126297278")
    if not activeFolder2 then
        -- folder hilang → server udah bersihin = sukses
        confirmed = true
    else
        local finishModel2 = activeFolder2:FindFirstChild("Finish")
        if not finishModel2 then
            confirmed = true
        end
    end

    -- (3) UI text konfirmasi
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        for _, gui in ipairs(pg:GetDescendants()) do
            if gui:IsA("TextLabel") and gui.Text then
                local t = gui.Text:lower()
                if t:find("finish") or t:find("complete") or t:find("delivery") then
                    if t:find("✅") or t:find("success") or t:find("done") then
                        confirmed = true
                        break
                    end
                end
            end
        end
    end

    if confirmed then
        verified = true
        break
    end

    task.wait(0.5)
end

-- ═══ 6. SIMPAN COOLDOWN — CUMA KALO VERIFIED ═══
if verified then
    print("[AUTO OBBY] ✅ FINISH VERIFIED! Menyimpan cooldown 30 menit.")
    if writefile then
        pcall(writefile, "vrilz_obby_time.txt", tostring(os.time()))
    end
    if Shared.Notify then
        Shared.Notify("🏁 Auto Obby Selesai! Cooldown 30 menit.", "success")
    end
else
    print("[AUTO OBBY] ❌ Gagal verifikasi finish — cooldown TIDAK disimpan, bisa retry.")
    if Shared.Notify then
        Shared.Notify("⚠️ Auto Obby gagal finish — gak kena cooldown, coba lagi.", "warning")
    end
end

-- Restore collision (AMAN)
local restoreChar = player.Character
if restoreChar then
    for _, part in ipairs(restoreChar:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = true end
    end
end

        ObbyState.Running = false
    end)
end

    _G.VRILZ_Features = Features
_G.VRILZ_Shared = Shared
_G.VRILZ_UI_Shared = Shared
print("[VRILZHUB] Ride a Pet Features v3.8 loaded")

return Features
