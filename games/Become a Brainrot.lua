local isVisible = true
game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        isVisible = not isVisible
        Window:SetVisible(isVisible)
    end
end)

local player = game:GetService("Players").LocalPlayer

local CoinTab = Window:Tab({ Title = "COIN", Icon = "solar:dollar-bold" })
local CoinSec = CoinTab:Section({ Title = "Cash Collector", Opened = true })
CoinSec:Button({
    Title = "💰 Collect Cash (1-60)",
    Callback = function()
        local events = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        local collect = events and events:FindFirstChild("CollectCash")
        local stands = player:FindFirstChild("AnimalStands")
        if stands and collect then
            for i = 1, 60 do
                local s = stands:FindFirstChild(tostring(i))
                if s then collect:FireServer(s) end
                task.wait(0.05)
            end
            WindUI:Notify({ Title = "Done", Content = "Collected 1-60 💰", Duration = 2 })
        end
    end
})

local SpeedTab = Window:Tab({ Title = "SPEED", Icon = "solar:running-bold" })
local SpeedSec = SpeedTab:Section({ Title = "Speed Controller", Opened = true })

local function setSpeed(v)
    local s = player:FindFirstChild("Speed")
    if s then s.Value = v end
end

SpeedSec:Input({
    Title = "Set Speed",
    Placeholder = "16-500",
    Callback = function(v)
        local num = tonumber(v)
        if num then setSpeed(math.clamp(num, 16, 500)) end
    end
})
SpeedSec:Space()
local spSlider = SpeedSec:Slider({
    Title = "Speed Slider",
    Step = 1,
    Value = { Min = 16, Max = 500, Default = 16 },
    Callback = function(v) setSpeed(v) end
})

local TeleTab = Window:Tab({ Title = "TELEPORT", Icon = "solar:map-point-bold" })
local TeleSec = TeleTab:Section({ Title = "Teleport", Opened = true })

local petLoc = Vector3.new(51.686241, 4.107531, -30.778535)
local spawnLoc = Vector3.new(45.073818, 4.007531, 23.048212)
local lastBaseLoc = Vector3.new(46.514515, 4.107529, -1355.938843)

local function tp(pos)
    local r = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if r then r.CFrame = CFrame.new(pos) end
end

TeleSec:Button({ Title = "🏰 LAST BASE", Callback = function()
    tp(petLoc)
    WindUI:Notify({ Title = "Teleported", Content = "Pet Location", Duration = 1 })
    task.wait(0.5)
    tp(lastBaseLoc)
    WindUI:Notify({ Title = "Teleported", Content = "Last Base", Duration = 1 })
end })
TeleSec:Space()
TeleSec:Button({ Title = "🏠 Spawn Location", Callback = function() tp(spawnLoc) WindUI:Notify({ Title = "Teleported", Content = "Spawn location", Duration = 1 }) end })

local SpinTab = Window:Tab({ Title = "🎡 SPIN", Icon = "solar:gamepad-bold" })
local SpinSec = SpinTab:Section({ Title = "Spin Wheel", Opened = true })

local selectedSpin = 1

SpinSec:Dropdown({
    Title = "Select Prize Slot",
    Values = { "1", "2", "3", "4", "5", "6" },
    Value = "1",
    Callback = function(value)
        selectedSpin = tonumber(value)
    end
})

SpinSec:Space()
SpinSec:Space()

SpinSec:Button({
    Title = "🎡 SPIN NOW",
    Callback = function()
        local events = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
        if events then
            local spinRemote = events:FindFirstChild("Spin")
            if spinRemote then
                spinRemote:InvokeServer(selectedSpin)
                WindUI:Notify({ Title = "Spin", Content = "Selected prize slot " .. selectedSpin, Duration = 2 })
            else
                WindUI:Notify({ Title = "Error", Content = "Spin remote not found!", Duration = 2 })
            end
        else
            WindUI:Notify({ Title = "Error", Content = "Events not found!", Duration = 2 })
        end
    end
})

WindUI:Notify({ Title = "BRAINROT HUB", Content = "Loaded | Discord: discord-baranqqs", Duration = 4 })
