-- Global Values
getgenv().AutoCollect = false
getgenv().AutoLock = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Bases:GetChildren()) do
      if plot:FindFirstChild("Configuration") and plot.Configuration:FindFirstChild("Player") and plot.Configuration.Player.Value == eu then
        Settings.Plot = plot
        return
      end
    end
  end
end)

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      for _, slot in pairs(Settings.Plot.Slots:GetChildren()) do
        pcall(function()
          if slot.Collect:FindFirstChild("TouchInterest") then
            firetouchinterest(eu.Character.HumanoidRootPart, slot.Collect, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, slot.Collect, 1)
          end
        end)
      end
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if Settings.Plot.Floors.Floor1.Doors.Door1.Lasers:GetChildren()[6].Transparency == 1 then
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.Lock, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.Lock, 1)
      end
    end)
  end
end

--[[
workspace.Bases.Base1.Slots.SlotA.Collect.TouchInterest
workspace.Bases.Base1.Configuration.Player
workspace.Bases.Base1.Floors.Floor1.Doors.Door1.Lasers:GetChildren()[6] Transparency
workspace.Bases.Base1.Lock.TouchInterest
Game: 8202759276 | Place: 125849730269464
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Auto Collect",
  Desc = "Automatically collects cash.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Lock",
  Desc = "Automatically locks your plot.",
  Value = false,
  Callback = function(state)
    getgenv().AutoLock = state
    AutoLock()
  end
})