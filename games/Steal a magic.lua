-- Global Values
getgenv().AutoCollect = false
getgenv().AutoLock = false
getgenv().AutoUnlock = false
getgenv().KillAll = false

-- Locals
local ReplicatedStorage, Players = game:GetService("ReplicatedStorage"), game:GetService("Players")
local eu = Players.LocalPlayer
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

--[[
Game: 7911733012 | Place: 84467557068970
workspace.World.Map.Bases.Base4.Collecters.Collecter1.CollectPrt.TouchInterest
Owner, IsLocked
workspace.World.Map.Bases.Base4.LockBase.TouchInterest
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"}),
  Blatant = Window:Tab({ Title = "Blatant", Icon = "skull"}),
}
Window:SelectTab(1)

-- Menu
do
  local helpful = Tabs.Menu:Section({ Title = "Helpful", Opened = true })
  helpful:Toggle({
    Title = "Auto Collect",
    Desc = "Automatically collects cash.",
    Value = false,
    Callback = function(state)
      getgenv().AutoCollect = state
      
      while getgenv().AutoCollect do
        pcall(function()
          local r, p = eu.Character.HumanoidRootPart
          for _, collector in pairs(Settings.Plot.Collecters:GetChildren()) do
            pcall(function()
              p = collector.CollectPrt
              firetouchinterest(r, p, 0)
              firetouchinterest(r, p, 1)
            end)
          end
        end)
      task.wait(1) end
    end
  })
  helpful:Toggle({
    Title = "Auto Lock",
    Desc = "Automatically locks your plot.",
    Value = false,
    Callback = function(state)
      getgenv().AutoLock = state
      
      while getgenv().AutoLock do
        pcall(function()
          local r, p = eu.Character.HumanoidRootPart, Settings.Plot.LockBase
          if not Settings.Plot:GetAttribute("IsLocked") then
            firetouchinterest(r, p, 0)
            firetouchinterest(r, p, 1)
          end
        end)
      task.wait(0.1) end
    end
  })

  local advanced = Tabs.Menu:Section({ Title = "Advanced", Opened = true })
  advanced:Toggle({
    Title = "Auto Unlock",
    Desc = "Automatically unlocks the selected plot.",
    Value = false,
    Callback = function(state)
      getgenv().AutoUnlock = state
      
      while getgenv().AutoUnlock do
        pcall(function()
          local b = eu.PlayerGui.Main.UnLOckBseeThnn.Buy
          firesignal(b.MouseButton1Click)
        end)
      task.wait(1) end
    end
  })
  advanced:Button({
    Title = "Force Prompts",
    Desc = "Force steal prompts to enable.",
    Callback = function()
      for _, pp in pairs(workspace:GetDescendants()) do
        pcall(function()
          if pp:IsA("ProximityPrompt") and not pp.Enabled and not pp:IsDescendantOf(Settings.Plot) and pp.ActionText == "Steal" then
            pp.Enabled = true
            pp.MaxActivationDistance = 11
          end
        end)
      end
    end
  })
end