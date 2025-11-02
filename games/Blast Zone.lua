-- Global Values
getgenv().AutoHeal = false
getgenv().InfStamina = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function AutoHeal()
  local function FinEat(humanoid)
    local function Eat(foods)
      local function SearchForFood(path)
        if not path then return false end
        for _, food in ipairs(foods) do
          for _, giver in pairs(path:GetChildren()) do
            if giver:FindFirstChild("Item") and giver:GetAttribute("PowerUp") == food then
              firetouchinterest(eu.Character.HumanoidRootPart, giver.Item, 0)
              firetouchinterest(eu.Character.HumanoidRootPart, giver.Item, 1)
              return true
            end
          end
        end
        return false
      end
      
      if SearchForFood(workspace.Map.Interactives.Givers) then return true end
      
      local map = workspace.Map:GetAttribute("Name")
      if map == "Lunar Arena" and SearchForFood(workspace.Map.Towers.RisingModel) then
        return true
      elseif map == "Bamboo Beach" and SearchForFood(workspace.Map.Environment.Event.Model) then
        return true
      elseif map == "Reactor Core" and (SearchForFood(workspace.Map.Environment.Event.RisingModel.Boat.Interactives) or SearchForFood(workspace.Map.Environment.Event.LoweringRocks)) then
        return true
      elseif map == "Crossroads" then
        local part = workspace.Map.Interactives["Spase Aliens"].Josh.HealPart
        firetouchinterest(eu.Character.HumanoidRootPart, part, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, part, 1)
        return true
      end
      
      return false
    end
    
    local missing = humanoid.MaxHealth - humanoid.Health
    if missing > 50 then
      Eat({ "Heart", "Burger", "Donut", "BlastBurger" })
    elseif missing > 25 then
      Eat({ "Burger", "Donut", "BlastBurger" })
    elseif missing > 10 then
      Eat({ "Donut", "BlastBurger", "Burger" })
    elseif missing > 0 then
      Eat({ "BlastBurger", "Donut", "Burger" })
    end
  end
  while getgenv().AutoHeal and task.wait(1) do
    pcall(function()
      local char = eu.Character
      local humanoid = char and char:FindFirstChildOfClass("Humanoid")
      if not humanoid then return end
      
      if humanoid.Health < humanoid.MaxHealth then
        FinEat(humanoid)
      end
      if not char:GetAttribute("Triangulare") then
        char:SetAttribute("Triangulare", true)
        humanoid.HealthChanged:Connect(function()
          if getgenv().AutoHeal and eu.Character.Humanoid.Health < eu.Character.Humanoid.MaxHealth then
            FinEat(eu.Character.Humanoid)
          end
        end)
      end
    end)
  end
end
local function InfStamina()
  while getgenv().InfStamina and task.wait(1) do
    pcall(function()
      if eu.Character:GetAttribute("Stamina") < 1 then
        eu.Character:SetAttribute("Stamina", 1)
      end
    end)
  end
end

--[[
Game: 3408154779 | Place: 9058310544
workspace.Map.Environment.Event.RisingModel.Boat.Interactives:GetChildren()[11]
-- Reactor
workspace.Map.Environment.Event.LoweringRocks.Giver
-- Bamboo Beach
workspace.Map.Environment.Event.Model:GetChildren()[4].Item.TouchInterest
-- Blackrock Castle
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Auto Heal",
  Desc = "Automatically heals your health.",
  Value = false,
  Callback = function(state)
    getgenv().AutoHeal = state
    AutoHeal()
  end
})
Tabs.Menu:Toggle({
  Title = "Inf Stamina",
  Desc = "Automatically reloads your stamina.",
  Value = false,
  Callback = function(state)
    getgenv().InfStamina = state
    InfStamina()
  end
})