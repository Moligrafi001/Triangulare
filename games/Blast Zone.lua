-- Global Values
getgenv().AutoHeal = false
getgenv().InfStamina = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Plots:GetChildren()) do
      if plot:FindFirstChild("Owner") and plot.Owner.Value == eu.Name then
        Settings.Plot = plot
        return
      end
    end
  end
end)

-- Functions
local function AutoHeal()
  local function FinEat(humanoid)
    local function Eat(type)
      local function SearchForFood(path)
        if not path then return false end
        for _, giver in pairs(path:GetChildren()) do
          if giver:FindFirstChild("Item") and giver:GetAttribute("PowerUp") == type then
            firetouchinterest(eu.Character.HumanoidRootPart, giver.Item, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, giver.Item, 1)
            return true
          end
        end
        return false
      end
      
      if SearchForFood(workspace.Map.Interactives.Givers) then
        return true
      elseif workspace.Map:GetAttribute("Name") == "Lunar Arena" and SearchForFood(workspace.Map.Towers.Sand) then
        return true
      end
      
      return false
    end
    local missing = humanoid.MaxHealth - humanoid.Health
    if missing > 50 then
      if not Eat("Heart") then
        if not Eat("Burger") then
          Eat("Donut")
        end
      end
    elseif missing > 25 then
      if not Eat("Burger") then
        Eat("Donut")
      end
    elseif missing > 0 then
      if not Eat("Donut") then
        Eat("Burger")
      end
    end
  end
  while getgenv().AutoHeal and task.wait(1) do
    -- pcall(function()
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
    -- end)
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