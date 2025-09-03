-- Global Values
getgenv().AutoCollect = false
getgenv().SilentSteal = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    local base = eu:GetAttribute("Base")
    if base then
      Settings.Plot = workspace.Bases[tostring(base)]
    end
  end
end)

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      for _, platform in pairs(Settings.Plot.Platforms:GetChildren()) do
        pcall(function()
          if #platform.Platform:GetChildren() > 0 then
            firetouchinterest(eu.Character.HumanoidRootPart, platform.Collect, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, platform.Collect, 1)
          end
        end)
      end
    end)
  end
end
local function SilentSteal()
  if not eu:GetAttribute("SilentSteal") then
    eu:SetAttribute("SilentSteal", true)
    eu:GetAttributeChangedSignal("Stealing"):Connect(function()
      if getgenv().SilentSteal and eu:GetAttribute("Stealing") then
        eu:SetAttribute("Stealing", false)
      end
    end)
  end
end

--[[
local args = {
    [1] = 1
}
game:GetService("ReplicatedStorage").Remotes.UpgradeEvent:FireServer(unpack(args))
local args = {
    [1] = 2
}
game:GetService("ReplicatedStorage").Remotes.PlaceBrainrotEvent:FireServer(unpack(args))
workspace.Bases["3"].Platforms["4"].Collect:GetChildren()[2]

eu Base Stealingworkspace.Bases["3"].Platforms["4"].Platform["Rainbow Gorillo"]
Game: 8380556170 | Place: 118915549367482
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
  Title = "Silent Steal",
  Desc = "Steals in silent.",
  Value = false,
  Callback = function(state)
    getgenv().SilentSteal = state
    SilentSteal()
  end
})
