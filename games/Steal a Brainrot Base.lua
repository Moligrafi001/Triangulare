local isVisible = true
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        isVisible = not isVisible
        Window:SetVisible(isVisible)
    end
end)


local watchedSpawns = {}

local function EnablePromptFromSpawn(spawn)
    local spawnedItem = spawn:FindFirstChild("SpawnedItem")
    if not spawnedItem then return false end
    local part = spawnedItem:FindFirstChild("Part")
    if not part then return false end
    local prompt = part:FindFirstChild("ProximityPrompt")
    if not prompt then return false end
    prompt.Enabled = true
    task.spawn(function()
        while prompt and prompt.Parent do
            if not prompt.Enabled then
                prompt.Enabled = true
            end
            task.wait(0.2)
        end
    end)
    return true
end

local function WatchSpawn(baseNum, slotNum)
    local base = workspace:FindFirstChild("Bases"):FindFirstChild("Base" .. baseNum)
    if not base then return false end
    local slots = base:FindFirstChild("Slots")
    if not slots then return false end
    local slot = slots:FindFirstChild("Slot" .. slotNum)
    if not slot then return false end
    local spawn = slot:FindFirstChild("Spawn")
    if not spawn then return false end
    EnablePromptFromSpawn(spawn)
    if watchedSpawns[spawn] then return true end
    watchedSpawns[spawn] = true
    spawn.ChildAdded:Connect(function(child)
        if child.Name == "SpawnedItem" then
            task.wait(0.1)
            EnablePromptFromSpawn(spawn)
        end
    end)
    return true
end

local function EnableAllPrompts()
    local count = 0
    local failed = 0
    for base = 1, 13 do
        for slot = 1, 10 do
            if WatchSpawn(base, slot) then
                count = count + 1
            else
                failed = failed + 1
            end
            task.wait()
        end
    end
    return count, failed
end


local eu = game:GetService("Players").LocalPlayer

local function CollectItems()
    local r = eu.Character and eu.Character:FindFirstChild("HumanoidRootPart")
    if not r then return 0 end
    
    local plotName = "Plot_" .. eu.Name
    local plot = workspace:FindFirstChild(plotName)
    if not plot then return 0 end
    
    local collected = 0
    
    for floorNum = 1, 30 do
        local floor = plot:FindFirstChild("Floor" .. floorNum)
        if floor then
            local slots = floor:FindFirstChild("Slots")
            if slots then
                for _, slot in pairs(slots:GetChildren()) do
                    if slot:GetAttribute("HasItem") then
                        local collectButton = slot:FindFirstChild("CollectButton")
                        if collectButton then
                            local touchPart = collectButton:FindFirstChild("Touch")
                            if touchPart then
                                firetouchinterest(r, touchPart, 1)
                                firetouchinterest(r, touchPart, 0)
                                collected = collected + 1
                                task.wait(0.05)
                            end
                        end
                    end
                end
            end
        end
    end
    
    return collected
end


local MainTab = Window:Tab({ Title = "PET", Icon = "solar:brain-bold", Border = true })
local MainSection = MainTab:Section({ Title = "ACCESS", Opened = true })
MainSection:Button({
    Title = "ENABLE ALL",
    Color = Color3.fromRGB(52, 199, 89),
    Justify = "Center",
    Callback = function()
        local count, failed = EnableAllPrompts()
        WindUI:Notify({ Title = "DONE", Content = count .. " / " .. failed, Duration = 2 })
    end
})

local ProtectTab = Window:Tab({ Title = "CLEAN", Icon = "solar:shield-bold", Border = true })
local ProtectSection = ProtectTab:Section({ Title = "REMOVE", Opened = true })
ProtectSection:Button({
    Title = "GUARDS & LASERS",
    Color = Color3.fromRGB(239, 79, 29),
    Justify = "Center",
    Callback = function()
        local guardCount = 0
        local guardsFolder = workspace:FindFirstChild("LocalNPCs")
        if guardsFolder then
            for _, obj in pairs(guardsFolder:GetChildren()) do
                if obj:IsA("Model") then
                    obj:Destroy()
                    guardCount = guardCount + 1
                end
            end
        end
        local laserCount = 0
        local bases = workspace:FindFirstChild("Bases")
        if bases then
            for i = 1, 13 do
                local base = bases:FindFirstChild("Base" .. i)
                if base then
                    local lasers = base:FindFirstChild("Lasers")
                    if lasers then
                        for _, laser in pairs(lasers:GetChildren()) do
                            laser:Destroy()
                            laserCount = laserCount + 1
                        end
                    end
                end
            end
        end
        WindUI:Notify({ Title = "DONE", Content = guardCount .. " / " .. laserCount, Duration = 2 })
    end
})

local CollectTab = Window:Tab({ Title = "FARM", Icon = "solar:dollar-bold", Border = true })
local CollectSection = CollectTab:Section({ Title = "AUTO", Opened = true })
CollectSection:Button({
    Title = "COLLECT ALL",
    Color = Color3.fromRGB(52, 199, 89),
    Justify = "Center",
    Callback = function()
        local count = CollectItems()
        WindUI:Notify({ Title = "DONE", Content = count .. " collected", Duration = 2 })
    end
})

local TeleportTab = Window:Tab({ Title = "TP", Icon = "solar:map-point-bold", Border = true })
local TeleportSection = TeleportTab:Section({ Title = "LOCATIONS", Opened = true })

TeleportSection:Button({
    Title = "LAB",
    Color = Color3.fromRGB(0, 122, 255),
    Justify = "Center",
    Callback = function()
        local char = eu.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(3, -179, 220)
                WindUI:Notify({ Title = "DONE", Content = "Laboratory", Duration = 1 })
            end
        end
    end
})

TeleportSection:Space()
TeleportSection:Button({
    Title = "EASTER",
    Color = Color3.fromRGB(255, 200, 100),
    Justify = "Center",
    Callback = function()
        local char = eu.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(4, -115, 222)
                WindUI:Notify({ Title = "DONE", Content = "Easter", Duration = 1 })
            end
        end
    end
})

TeleportSection:Space()
TeleportSection:Button({
    Title = "SPAWN",
    Color = Color3.fromRGB(100, 200, 100),
    Justify = "Center",
    Callback = function()
        local char = eu.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(1, 3, 4)
                WindUI:Notify({ Title = "DONE", Content = "Spawn", Duration = 1 })
            end
        end
    end
})

TeleportSection:Space()
TeleportSection:Button({
    Title = "🏰 ANCIENT KNIGHT'S BASE",
    Color = Color3.fromRGB(150, 100, 200),
    Justify = "Center",
    Callback = function()
        local char = eu.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(1, 15, 452)
                WindUI:Notify({ Title = "DONE", Content = "Ancient Knight's Base", Duration = 1 })
            end
        end
    end
})

WindUI:Notify({ Title = "READY", Content = "Right Shift", Duration = 2 })
