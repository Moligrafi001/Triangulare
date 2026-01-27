-- Global Values
getgenv().KillAura = false
getgenv().AutoCollect = false

-- Locals
local ReplicatedStorage, Players = game:GetService("ReplicatedStorage"), game:GetService("Players")
local eu = Players.LocalPlayer

-- Functions

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
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Kill Aura
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
Tabs.Menu:Toggle({
  Title = "Auto claim chest",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    
    while getgenv().AutoCollect do
      local MyDungeon = eu:GetAttribute("DungeonId")
      
      for _, chest in workspace:GetChildren() do
        if chest:FindFirstChild("Highlight") and chest.Highlight.Enabled and chest:GetAttribute("DungeonId") == MyDungeon and chest:GetAttribute("Owner") == eu.Name then
          ReplicatedStorage.RemoteServices.BossDropsService.RF.OpenChest:InvokeServer(chest:GetAttribute("ChestUUID"))
        end
      end
    task.wait(1) end
  end
})