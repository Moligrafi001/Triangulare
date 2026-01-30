-- Global Values
getgenv().KillAura = false

-- Locals
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eu = game:GetService("Players").LocalPlayer

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
local killaura = Tabs.Menu:Section({ Title = "Kill Aura", Icon = "skull", Opened = true })

local attacks = (function()
  local names = {}
  
  for _, obj in ReplicatedStorage.WeaponEvents:GetChildren() do
    if obj.Name:find("Attack") then
      table.insert(names, obj.Name)
    end
  end
  
  return names
end)()
local selected, sword = ReplicatedStorage.WeaponEvents:FindFirstChild(attacks[1]), nil

killaura:Dropdown({
  Title = "Selected Sword",
  Values = attacks,
  Value = selected.Name,
  Callback = function(option)
    selected = ReplicatedStorage.WeaponEvents:FindFirstChild(option)
  end

})
killaura:Toggle({
  Title = "Kill Aura",
  Desc = "Kills enemies around you",
  Value = false,
  Callback = function(state)
    getgenv().KillAura = state
    
    while getgenv().KillAura do
      pcall(function()
        if not sword or not sword.Parent then
          sword = eu.Character:FindFirstChildOfClass("Tool")
          if not sword then return end
        end
        
        selected:FireServer(sword.Handle.Swing, sword.Handle.HitSound, sword.Handle:FindFirstChildOfClass("Attachment"), sword.Highlight)
      end)
    task.wait(0.05) end
  end
})