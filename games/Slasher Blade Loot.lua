-- Global Values
getgenv().KillAura = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
 Distance = 20
}

-- Functions
local function KillAura()
  local function GetNearby()
    local Detected = {}
    for _, enemy in pairs(workspace:GetPartBoundsInBox(eu.Character.HumanoidRootPart.CFrame, Vector3.new(Settings.Distance, 20, Settings.Distance), nil)) do
      local model = enemy:IsDescendantOf(workspace.Live.MobModel) and enemy:FindFirstAncestorWhichIsA("Model")
      
      if model and model.Parent == workspace.Live.MobModel and not table.find(Detected, model.Name) then
        table.insert(Detected, model.Name)
      end
    end
    return Detected
  end
  while getgenv().KillAura and task.wait(0.19) do
    pcall(function()
      local Enemies = GetNearby()
      if #Enemies > 0 then
        game:GetService("ReplicatedStorage").Remote.Event.Combat.M1:FireServer(Enemies)
      end
    end)
  end
end

--[[
-- workspace.Live.MobModel["ad1af47c-c97a-4c88-a26e-aa3921651301"]
local Mobs = {}
    for _, mob in pairs(workspace.Live.MobModel:GetChildren()) do
    if mob:GetAttribute("Id") then
    table.insert(Mobs, mob.Name)
    end
    end
    game:GetService("ReplicatedStorage").Remote.Event.Combat.M1:FireServer(Mobs)
      end
Game: 8796373417 | Place: 99827026339186
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Kill Aura",
  Desc = "Attacks enemies nearby.",
  Value = false,
  Callback = function(state)
    getgenv().KillAura = state
    KillAura()
  end
})
Tabs.Menu:Slider({
  Title = "Aura Distance",
  Step = 1,
  Value = {
    Min = 10,
    Max = 50,
    Default = Settings.Distance / 2,
  },
  Callback = function(value)
    Settings.Distance = (tonumber(value) * 2) or 1
  end
})