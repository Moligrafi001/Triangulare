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

   
    if watchedSpawns[spawn] then
        return true
    end

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

local success, failed = EnableAllPrompts()
print("Enabled:", success, "Failed:", failed)

local MainTab = Window:Tab({ Title = "MAIN", Icon = "solar:home-bold", Border = true })

local AccessSection = MainTab:Section({ Title = "🐾 PET ACCESS", Opened = true })

AccessSection:Button({
    Title = "🔓 ENABLE ALL PROXIMITY PROMPTS",
    Desc = "Enables all prompts from Base1-13, Slot1-10",
    Icon = "solar:hand-palm-bold",
    Color = Color3.fromRGB(52, 199, 89),
    Justify = "Center",
    Callback = function()
        local count, failed = EnableAllPrompts()
        WindUI:Notify({ Title = "✅ PROMPTS ENABLED", Content = count .. " activated, " .. failed .. " failed", Duration = 3, Icon = "solar:check-circle-bold" })
    end
})

local ProtectSection = MainTab:Section({ Title = "🛡️ PROTECTIONS", Opened = true })

ProtectSection:Button({
    Title = "🧹 REMOVE GUARDS & LASERS",
    Desc = "Removes LocalNPCs and all lasers from Base1-13",
    Icon = "solar:trash-bin-trash-bold",
    Color = Color3.fromRGB(255, 80, 80),
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
        
        WindUI:Notify({ Title = "🗑️ REMOVED", Content = guardCount .. " guards, " .. laserCount .. " lasers", Duration = 3, Icon = "solar:trash-bin-trash-bold" })
    end
})

local InfoTab = Window:Tab({ Title = "INFO", Icon = "solar:info-square-bold", Border = true })
local InfoSec = InfoTab:Section({ Title = "📌 STEAL THE BRAINROT BASE", Opened = true })

InfoSec:Section({ Title = "📢 CREDITS", TextSize = 18 })
InfoSec:Section({ Title = "Game: Steal The Brainrot Base", TextSize = 15, TextTransparency = 0.35 })
InfoSec:Section({ Title = "Discord: discord-baranqqs", TextSize = 15, TextTransparency = 0.35 })
InfoSec:Section({ Title = "Version: 2.0", TextSize = 14, TextTransparency = 0.5 })

InfoTab:Space()
InfoTab:Button({
    Title = "❌ DESTROY GUI",
    Icon = "solar:trash-bin-trash-bold",
    Color = Color3.fromRGB(239, 79, 29),
    Justify = "Center",
    Callback = function()
        Window:Destroy()
    end
})

WindUI:Notify({ Title = "STEAL THE BRAINROT BASE", Content = "Ready | Right Shift to toggle", Duration = 3, Icon = "solar:brain-bold" })
