-- Global Values
getgenv().AutoCollect = false
getgenv().AutoDeliver = false
getgenv().AutoLock = false
getgenv().AutoRebirth = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil,
  LaserPart = nil,
  Number = 1000
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Bases:GetChildren()) do
      if plot:FindFirstChild("Owner") and plot.Owner.Value == eu then
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
      for _, stand in pairs(Settings.Plot.Stands:GetChildren()) do
        pcall(function()
          firetouchinterest(eu.Character.HumanoidRootPart, stand.Collect, 0)
          firetouchinterest(eu.Character.HumanoidRootPart, stand.Collect, 1)
        end)
      end
    end)
  end
end
local function AutoDeliver()
  while getgenv().AutoDeliver and task.wait(0.39) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.TouchingPart, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.TouchingPart, 1)
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if Settings.LaserPart then
        if Settings.LaserPart.Transparency == 1 then
          firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.Lock, 0)
          firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.Lock, 1)
        end
      else
        for _, laser in pairs(Settings.Plot.Lazer:GetChildren()) do
          if laser.Color == Color3.fromRGB(255, 0, 0) then
            Settings.LaserPart = laser
          end
        end
      end
    end)
  end
end
local function AutoRebirth()
  while getgenv().AutoRebirth and task.wait(1) do
    pcall(function()
      game:GetService("ReplicatedStorage").RebirthRemote:FireServer()
    end)
  end
end

--[[
workspace.Bases.Base3.Lock.TouchInterest
workspace.Bases.Base3.Owner
workspace.Bases.Base3.TouchingPart.TouchInterest
workspace.Bases.Base3.Stands.Stand1.Collect.TouchInterest
workspace.Bases.Base3.Lazer:GetChildren()[20]
Game: 8419247771 | Place: 74178616685491
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"})
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
Tabs.Menu:Toggle({
  Title = "Auto Deliver",
  Desc = "Automatically delivers stole pets.",
  Value = false,
  Callback = function(state)
    getgenv().AutoDeliver = state
    AutoDeliver()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Rebirth",
  Desc = "Automatically rebirths.",
  Value = false,
  Callback = function(state)
    getgenv().AutoRebirth = state
    AutoRebirth()
  end
})
Tabs.Menu:Section({ Title = "Advanced" })
Tabs.Menu:Input({
  Title = "Money (in millions)",
  Value = "1000",
  Placeholder = "numbers only",
  Callback = function(input)
    Settings.Number = tonumber(input) or 1
  end
})
Tabs.Menu:Button({
  Title = "Get Money",
  Desc = "Gives you the selected amount of millions.",
  Callback = function()
    for i = 1, Settings.Number do
      game:GetService("ReplicatedStorage").Playtime:FireServer(6)
    end
  end
})