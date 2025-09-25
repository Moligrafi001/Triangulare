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
    for _, plot in pairs(workspace:GetChildren()) do
      if plot:IsA("Model") and plot:FindFirstChild("Owner") and plot.Owner.Value == eu.Name then
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
      for _, slot in pairs(Settings.Plot:GetChildren()) do
        pcall(function()
          if slot.CurrentUnit.Value then
            firetouchinterest(eu.Character.HumanoidRootPart, slot.Part, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, slot.Part, 1)
          end
        end)
      end
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if not Settings.Plot.LockBase.IsLocked.Value then
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockBase, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.LockBase, 1)
      end
    end)
  end
end

--[[
Game: 8101424623 | Place: 75235622760301
workspace.Base1.Slot1.Part.TouchInterest
workspace.Base1.Owner
workspace.Base1.LockBase.IsLocked
workspace.Base1.LockBase.TouchInterest
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