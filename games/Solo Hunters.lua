-- Global Values
getgenv().KillAura = false
getgenv().AutoCollect = false
getgenv().ClaimChest = false
getgenv().ClaimDrops = false

-- Locals
local ReplicatedStorage, Players, Gokka = game:GetService("ReplicatedStorage"), game:GetService("Players")
local Gokka = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Gokka.lua"))()
local eu = Players.LocalPlayer

local Settings; Settings = {
  MinToEat = 100,
  Connections = {
    AutoHeal = function()
      Gokka:Connect({
        Name = "AutoHeal",
        Parent = eu.Character.Humanoid,
        Signal = "HealthChanged",
        Callback = function(health)
          if not getgenv().AutoHeal or health > Settings.MinToEat or not (eu.Backpack:FindFirstChild("Potion") or eu.Character:FindFirstChild("Potion")) then return end
          ReplicatedStorage.RemoteServices.HealingService.RF.UseHeal:InvokeServer()
        end
      })
    end
  }
}

-- Load
Gokka:Connect({
  Name = "SetEatOnLoad",
  Parent = eu,
  Signal = "CharacterAdded",
  Callback = function(char)
    if getgenv().AutoHeal and char:WaitForChild("Humanoid") then
      Settings.Connections.AutoHeal()
    end
  end
})

--[[
workspace.Camera.Drops.Epic.Center.ProximityPrompt

workspace.SerpentChest.Root.ProximityPrompt

game:GetService("ReplicatedStorage").RemoteServices.HealingService.RF.UseHeal:InvokeServer()
game:GetService("Players").LocalPlayer.Backpack.Potion

game:GetService("ReplicatedStorage").RemoteServices.HealingService.RF.UseMana:InvokeServer()
game:GetService("Players").LocalPlayer.Backpack.ManaPotion

game:GetService("ReplicatedStorage").RemoteServices.SummoningService.RF.SummonOne:InvokeServer()

local args = {
    [1] = "N_Subway-57"
}

game:GetService("ReplicatedStorage").RemoteServices.PortalService.RF.QueuePortal:InvokeServer(unpack(args))
local args = {
    [1] = "N_Subway-57"
}

game:GetService("ReplicatedStorage").RemoteServices.PortalService.RF.EnterPortal:InvokeServer(unpack(args))
game:GetService("ReplicatedStorage").RemoteServices.DungeonService.RF.StartDungeon:InvokeServer()
Game: 7394964165 | Place: 136599248168660
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"}),
  Potion = Window:Tab({ Title = "Potion", Icon = "sparkles"})
}
Window:SelectTab(1)

-- Menu
do
  local killaura = Tabs.Menu:Section({ Title = "Kill Aura", Icon = "skull", Opened = true })
  killaura:Toggle({
    Title = "Kill Aura",
    Desc = "Kills enemies around you",
    Value = false,
    Callback = function(state)
      getgenv().KillAura = state
      
      while getgenv().KillAura do
        pcall(function()
          local Mobs = (function()
            local Mobs = {}
            
            local MyDungeon = eu:GetAttribute("DungeonId")
            for _, mob in workspace.Mobs:GetChildren() do
              if mob:GetAttribute("DungeonId") == MyDungeon then
                table.insert(Mobs, mob)
              end
            end
            
            return Mobs
          end)()
          if not Mobs or #Mobs == 0 then return end
          
          ReplicatedStorage.RemoteServices.CombatService.RF.UseWeapon:InvokeServer(0, Mobs, 1)
        end)
      task.wait(0.05) end
    end
  })
end
Tabs.Menu:Divider()
do
  local section = Tabs.Menu:Section({ Title = "Collect Chests", Icon = "package", Opened = true })
  
  local mode = "Slow [ Legit ]"
  section:Dropdown({
    Title = "Collect Mode",
    Values = { "Slow [ Legit ]", "Instant [ Detectable ]" },
    Value = mode,
    Callback = function(option)
      mode = option
    end
  })

  local function ClaimChests()
    local MyDungeon = eu:GetAttribute("DungeonId")
    
    for _, chest in workspace:GetChildren() do
      if chest:FindFirstChild("Highlight") and chest.Highlight.Enabled and chest:GetAttribute("DungeonId") == MyDungeon and chest:GetAttribute("Owner") == eu.Name then
        if mode == "Slow [ Legit ]" then
          fireproximityprompt(chest.Root.ProximityPrompt)
        else
          ReplicatedStorage.RemoteServices.BossDropsService.RF.OpenChest:InvokeServer(chest:GetAttribute("ChestUUID"))
        end
      end
    end
  end

  section:Button({
    Title = "Claim Chests",
    Desc = "Collect all available chests",
    Icon = "gift",
    Callback = ClaimChests
  })
  section:Toggle({
    Title = "Auto Claim",
    Desc = "Automatically claim chests",
    Value = false,
    Callback = function(state)
      getgenv().ClaimChest = state
      
      while getgenv().ClaimChest do
        pcall(ClaimChests)
      task.wait(1) end
    end
  })
end
Tabs.Menu:Divider()
do
  local section = Tabs.Menu:Section({ Title = "Collect Drops", Icon = "box", Opened = true })
  
  local Allowed = {
    "Epic", "Rare"
  }
  
  local function ClaimDrops()
    -- workspace.Camera.Drops.Epic.Center.ProximityPrompt
    for _, drop in workspace.Camera.Drops:GetChildren() do
      pcall(function()
        if table.find(Allowed, drop.Name) then
          fireproximityprompt(drop.Center.ProximityPrompt)
        end
      end)
    end
  end

  section:Button({
    Title = "Claim Drops",
    Desc = "Collect all available chests",
    Icon = "gift",
    Callback = ClaimDrops
  })
  section:Toggle({
    Title = "Auto Claim",
    Desc = "Automatically claims drops",
    Value = false,
    Callback = function(state)
      getgenv().ClaimDrops = state
      
      while getgenv().ClaimDrops do
        pcall(ClaimDrops)
      task.wait(1) end
    end
  })
end

-- Potion
do
  local section = Tabs.Potion:Section({ Title = "Health Potion", Icon = "heart-plus", Opened = true })
  
  section:Toggle({
    Title = "Auto Drink",
    Desc = "Drinks potion when needed",
    Callback = function(state)
      getgenv().AutoHeal = state
      if not state then return end
      
      Settings.Connections.AutoHeal()
    end
  })
  section:Input({
    Title = "Min HP to Drink",
    Value = tostring(Settings.MinToEat),
    Placeholder = "Numbers only, ex.: 15",
    Callback = function(input)
      Settings.MinToEat = tonumber(input) or 100
    end
  })
end
Tabs.Potion:Divider()
do
  local section = Tabs.Potion:Section({ Title = "Mana Potion", Icon = "flame", Opened = true })
  
  section:Toggle({
    Title = "Auto Drink",
    Desc = "Drinks potion when needed",
    Callback = function(state)
      getgenv().AutoHeal = state
      if not state then return end
      
      Settings.Connections.AutoHeal()
    end
  })
  section:Input({
    Title = "Min MP to Drink",
    Value = tostring(Settings.MinToEat),
    Placeholder = "Numbers only, ex.: 15",
    Callback = function(input)
      Settings.MinToEat = tonumber(input) or 100
    end
  })
end