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
    for _, plot in pairs(workspace.World.Map.Bases:GetChildren()) do
      if plot:GetAttribute("Owner") == eu.UserId then
        Settings.Plot = plot
        return
      end
    end
  end
end)

local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      for _, collector in pairs(Settings.Plot.Collecters:GetChildren()) do
        pcall(function()
          firetouchinterest(eu.Character.HumanoidRootPart, collector.CollectPrt, 0)
          firetouchinterest(eu.Character.HumanoidRootPart, collector.CollectPrt, 1)
        end)
      end
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if Settings.Plot:GetAttribute("IsLocked") then
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockBase, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockBase, 1)
      end
    end)
  end
end

--[[
Game: 7911733012 | Place: 84467557068970
workspace.World.Map.Bases.Base4.Collecters.Collecter1.CollectPrt.TouchInterest
Owner, IsLocked
workspace.World.Map.Bases.Base4.LockBase.TouchInterest
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