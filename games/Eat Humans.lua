-- Global Values
getgenv().AutoCollect = false
getgenv().AutoRebirth = false

-- Locals
local ReplicatedStorage, Players = game:GetService("ReplicatedStorage"), game:GetService("Players")
local eu = Players.LocalPlayer

--[[
game:GetService("ReplicatedStorage").Remote.Rebirth:FireServer()
game:GetService("ReplicatedStorage").Remote.Gacha:FireServer()
workspace.Preset.SpawnItems.SpeedPotion.touchZone.TouchInterest
-- Game: 9478941302 | Place: 130177490176175
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
local helpful = Tabs.Menu:Section({ Title = "Helpful", Opened = true })

local function CollectPotion()
  local r, p = eu.Character.HumanoidRootPart
  for _, potion in pairs(workspace.Preset.SpawnItems:GetChildren()) do
    if potion.Transparency and potion:FindFirstChild("touchZone") then
      p = potion.touchZone
      return firetouchinterest(r, p, 0), firetouchinterest(r, p, 1)
    end
  end
end

helpful:Button({
  Title = "Collect Potion",
  Desc = "Collects a speed potion",
  Callback = CollectPotion
})
helpful:Toggle({
  Title = "Auto Collect",
  Desc = "Automatically collects potions",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    
    while getgenv().AutoCollect do
      pcall(CollectPotion)
    task.wait(1) end
  end
})

helpful:Divider()

local min = 1
helpful:Toggle({
  Title = "Auto Rebirth",
  Desc = "Automatically rebirths",
  Value = false,
  Callback = function(state)
    getgenv().AutoRebirth = state
    
    while getgenv().AutoRebirth do
      pcall(function()
        if eu:GetAttribute("boxes") < min then return end
        ReplicatedStorage.Remote.Rebirth:FireServer()
        ReplicatedStorage.Remote.Gacha:FireServer()
        local b = eu.PlayerGui.ScreenGui.GachaUI.Inset.Close.TextButton
        firesignal(b.MouseButton1Click)
      end)
    task.wait(1) end
  end
})
helpful:Input({
  Title = "Min Crates",
  Desc = "Min amount of crates to rebirth",
  Value = tostring(min),
  Placeholder = "Numbers only, ex.: 15",
  Callback = function(input)
    min = tonumber(input) or 1
  end
})