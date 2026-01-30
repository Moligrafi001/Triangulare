-- Global Values
getgenv().Money = false

-- Locals
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eu = game:GetService("Players").LocalPlayer

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
do
  local section = Tabs.Menu:Section({ Title = "Creatures", Icon = "fish", Opened = true })
  
  local creatures = (function()
    local names = {}
    
    for _, obj in ReplicatedStorage.Creatures:GetChildren() do
      table.insert(names, obj.Name)
    end
    
    return names
  end)()
  local selected = creatures[1]
  
  local function GetCreature(creature)
    ReplicatedStorage.GrantReward:InvokeServer({
      type = "SeaCreature",
      rarity = "Common",
      creatureId = 1,
      value = 1,
      color = Color3.fromRGB(255, 125, 0),
      icon = "\240\159\144\162",
      displayName = creature or selected
    })
  end
  
  section:Dropdown({
    Title = "Selected Creature",
    Values = creatures,
    Value = selected,
    Callback = function(option)
      selected = option
    end
  })
  section:Button({
  Title = "Get Creature",
  Desc = "Gives you the selected creature",
  Callback = GetCreature
})
  section:Divider()
  section:Button({
  Title = "Get All Creatures",
  Desc = "Gives you all available creatures",
  Callback = function()
    for _, creature in creatures do
      GetCreature(creature)
    end
  end
})
end

Tabs.Menu:Divider()

local section = Tabs.Menu:Section({ Title = "Money", Icon = "banknote", Opened = true })

local function GetMoney()
  ReplicatedStorage.GrantReward:InvokeServer({
    type = "Money",
    rarity = "Uncommon",
    value = 1000,
    color = Color3.fromRGB(255, 125, 0),
    icon = "\240\159\146\181",
    displayName = "1,000 Cash"
  })
end

section:Button({
  Title = "Get Money",
  Desc = "Gives you $1000",
  Callback = GetMoney
})
section:Toggle({
  Title = "Inf Money",
  Desc = "Auto gives you money",
  Callback = function(state)
    getgenv().Money = state
    
    while getgenv().Money do
      pcall(GetMoney)
    task.wait(0.1) end
  end
})