-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function AutoCollect()
  if not getgenv().AutoCollect and getgenv().ZombieConnection then
    getgenv().ZombieConnection:Disconnect()
  else
    getgenv().ZombieConnection = workspace.ChildAdded:Connect(function(obj)
      if getgenv().AutoCollect and obj.Name == "Powerup" then
        firetouchinterest(eu.Character.HumanoidRootPart, obj, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, obj, 1)
      end
    end)
  end
end

--[[
workspace:GetChildren()[42].TouchInterest
Game: 7661577083 | Place: 115338810233057
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Collect" })
Tabs.Menu:Toggle({
  Title = "Auto Collect Powerup",
  Desc = "Collects the powerups...",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})