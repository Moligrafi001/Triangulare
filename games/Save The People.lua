-- Global Values
getgenv().KillAura = false
getgenv().KillAll = false

-- Locals
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function GetEnemies()
  local enemies = {}
  
  for _, enemy in pairs(workspace:GetChildren()) do
    if string.find(enemy.Name, "Enemy") then
      table.insert(enemies, enemy)
    end
  end
  
  return enemies
end

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
local blatant = Tabs.Menu:Section({ Title = "Blatant", Icon = "skull", Opened = true })
blatant:Toggle({
  Title = "Kill Aura",
  Desc = "Kills nearby enemies using axe",
  Value = false,
  Callback = function(state)
    getgenv().KillAura = state
    
    while getgenv().KillAura do
      pcall(function()
        local tool, enemies = eu.Character.Axe, GetEnemies()
        if not tool or #enemies == 0 then return end
        
        ReplicatedStorage.RemoteEvents.MeleeHit:FireServer(tool, enemies)
      end)
    task.wait(0.05) end
  end
})
blatant:Toggle({
  Title = "Kill All",
  Desc = "Kills all enemies using pistol",
  Value = false,
  Callback = function(state)
    getgenv().KillAll = state
    
    while getgenv().KillAll do
      pcall(function()
        local enemies = GetEnemies()
        if #enemies == 0 then return end
        
        for _, enemy in pairs(enemies) do
          pcall(function()
            ReplicatedStorage.RemoteEvents.GunHit:FireServer("enemy", enemy, "Head", enemy.Head.CFrame.Position)
          end)
        end
      end)
    task.wait(0.1) end
  end
})

local food = Tabs.Menu:Section({ Title = "Food", Icon = "utensils", Opened = true })
food:Button({
  Title = "Collect Food",
  Desc = "Collects all the food in the map",
  Icon = "truck",
  Callback = function()
    local r = eu.Character.HumanoidRootPart
    local backup = r.CFrame
    
    for _, food in pairs(workspace.Items:GetChildren()) do
      if food:IsA("Model") then
        local pp = food:FindFirstChild("ProximityPrompt", true)
        if pp then
          r.CFrame = CFrame.new(food.WorldPivot.Position)
          task.wait(0.3)
          fireproximityprompt(pp)
        end
      end
    end
    
    r.CFrame = backup
  end
})