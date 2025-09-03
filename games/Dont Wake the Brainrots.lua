-- Global Values
getgenv().AutoCollect = false
getgenv().SilentSteal = false
getgenv().AntiRagdoll = false
getgenv().AutoPlace = false

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
local function AntiRagdoll()
  while getgenv().AntiRagdoll and task.wait(1) do
    pcall(function()
      if not eu.Character:GetAttribute("AntiRagdoll") then
        eu.Character:SetAttribute("AntiRagdoll", true)
        eu.Character:GetAttributeChangedSignal("Ragdolled"):Connect(function()
          if getgenv().AntiRagdoll and eu.Character:GetAttribute("Ragdolled") then
            eu.Character:SetAttribute("Ragdolled", false)
          end
        end)
      end
    end)
  end
end
local function AutoPlace()
  local function IsHoldingBrainrot()
    for _, tool in pairs(eu.Character:GetChildren()) do
      if tool:IsA("Tool") and string.find(tool.Name, "lvl") then
        return true
      end
    end
    return false
  end
  while getgenv().AutoPlace and task.wait(0.1) do
    pcall(function()
      if IsHoldingBrainrot() then
        for _, platform in pairs(Settings.Plot.Platforms:GetChildren()) do
          pcall(function()
            if #platform.Platform:GetChildren() == 0 then
              game:GetService("ReplicatedStorage").Remotes.PlaceBrainrotEvent:FireServer(tonumber(platform.Name))
            end
          end)
        end
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
  Title = "Auto Place",
  Desc = "Automatically places your brainrots.",
  Value = false,
  Callback = function(state)
    getgenv().AutoPlace = state
    AutoPlace()
  end
})
Tabs.Menu:Toggle({
  Title = "Silent Steal",
  Desc = "Won't wake up the brainrots.",
  Value = false,
  Callback = function(state)
    getgenv().SilentSteal = state
    SilentSteal()
  end
})
Tabs.Menu:Section({ Title = "Extra" })
Tabs.Menu:Toggle({
  Title = "Anti Ragdoll",
  Desc = "Prevents you from being ragdolled.",
  Value = false,
  Callback = function(state)
    getgenv().AntiRagdoll = state
    AntiRagdoll()
  end
})
