-- Locals
local eu = game:GetService("Players").LocalPlayer
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Settings = {
  Spells = { "Fireball", "Magic Missile", "Rock", "Void", "Shield", "Repair", "Lightning", "Holy Light" },
  FireRemote = "",
  Slots = {
    {
      "Fireball", "F"
    },
    {
      "Magic Missile", "R"
    },
    {
      "Rock", "G"
    },
    {
      "Void", "V"
    }
  }
}

-- Functions
task.spawn(function()
  game:GetService("UserInputService").InputBegan:Connect(function(input, gp)
    if gp or not Settings.FireRemote or not ReplicatedStorage.ClientRemotes:FindFirstChild(Settings.FireRemote) then return end
    
    for _, slot in pairs(Settings.Slots) do
      if input.KeyCode == Enum.KeyCode[slot[2]] then
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
Tabs.Menu:Section({ Title = "Slot 1" })
Tabs.Menu:Dropdown({
  Title = "Selected Spell",
  Values = Settings.Spells,
  Value = Settings.Slots[1][1],
  Callback = function(option)
    Settings.Slots[1][1] = option
  end
})
Tabs.Menu:Keybind({
  Title = "Selected Keybind",
  Value = Settings.Slots[1][2],
  Callback = function(v)
    Settings.Slots[1][2] = v
  end
})
Tabs.Menu:Section({ Title = "Slot 2" })
Tabs.Menu:Dropdown({
  Title = "Selected Spell",
  Values = Settings.Spells,
  Value = Settings.Slots[2][1],
  Callback = function(option)
    Settings.Slots[2][1] = option
  end
})
Tabs.Menu:Keybind({
  Title = "Selected Keybind",
  Value = Settings.Slots[2][2],
  Callback = function(v)
    Settings.Slots[2][2] = v
  end
})
Tabs.Menu:Section({ Title = "Slot 3" })
Tabs.Menu:Dropdown({
  Title = "Selected Spell",
  Values = Settings.Spells,
  Value = Settings.Slots[3][1],
  Callback = function(option)
    Settings.Slots[3][1] = option
  end
})
Tabs.Menu:Keybind({
  Title = "Selected Keybind",
  Value = Settings.Slots[3][2],
  Callback = function(v)
    Settings.Slots[3][2] = v
  end
})
Tabs.Menu:Section({ Title = "Slot 4" })
Tabs.Menu:Dropdown({
  Title = "Selected Spell",
  Values = Settings.Spells,
  Value = Settings.Slots[4][1],
  Callback = function(option)
    Settings.Slots[4][1] = option
  end
})
Tabs.Menu:Keybind({
  Title = "Selected Keybind",
  Value = Settings.Slots[4][2],
  Callback = function(v)
    Settings.Slots[4][2] = v
  end
})