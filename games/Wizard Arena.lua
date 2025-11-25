-- Locals
local eu = game:GetService("Players").LocalPlayer
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Settings = {
  Spells = { "Fireball", "Magic Missile", "Rock", "Void", "Shield", "Repair", "Lightning", "Holy Light" },
  FireRemote = "",
  Slots = {
    {
      "Fireball", "ButtonX"
    },
    {
      "Shield", "ButtonY"
    },
    {
      "Void", "ButtonB"
    },
    {
      "Rock", "R"
    }
  }
}

-- Functions
local function ReturnSpells()
  local Names = { "Trace" }
  
  local Blacklist = { "Seek" }
  for _, spell in pairs(ReplicatedStorage.SpellUtility:GetChildren()) do
    if not table.find(Names, spell.Name) and not table.find(Blacklist, spell.Name) then
      table.insert(Names, spell.Name)
    end
  end
  
  return Names
end

-- Load
task.spawn(function()
  game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp or not Settings.FireRemote or not ReplicatedStorage.ClientRemotes:FindFirstChild(Settings.FireRemote) or not eu.Character or not eu.Character:FindFirstChild("SpellBook") then return end
    
    for _, slot in pairs(Settings.Slots) do
      local bind = Enum.KeyCode[slot[2]]
      
      if bind and input.KeyCode == bind then
        local camera = workspace.CurrentCamera
        local rayOrigin = camera.CFrame.Position
        local rayDirection = camera.CFrame.LookVector * 1000
        
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = { eu.Character }
        params.FilterType = Enum.RaycastFilterType.Blacklist
        
        local result = workspace:Raycast(rayOrigin, rayDirection, params)
        local hitPosition = result and result.Position or rayOrigin + rayDirection
        
        ReplicatedStorage.ClientRemotes:FindFirstChild(Settings.FireRemote):FireServer(slot[1], hitPosition)
      end
    end
  end)
end)

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Setup" })
Tabs.Menu:Input({
  Title = "Fire Remote",
  Value = tostring(Settings.FireRemote),
  Placeholder = "Remote event that fires the spells.",
  Callback = function(input)
    Settings.FireRemote = input
  end
})
do
  Settings.Spells = ReturnSpells()
  for i = 1, 4 do
    Tabs.Menu:Section({ Title = "Slot " .. i })
    Tabs.Menu:Dropdown({
      Title = "Selected Spell",
      Values = Settings.Spells,
      Value = Settings.Slots[i][1],
      Callback = function(option)
        Settings.Slots[i][1] = option
      end
    })
    Tabs.Menu:Keybind({
      Title = "Selected Keybind",
      Value = Settings.Slots[i][2],
      Callback = function(v)
        Settings.Slots[i][2] = v
      end
    })
  end
end