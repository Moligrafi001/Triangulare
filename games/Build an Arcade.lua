-- Global Values
getgenv().AutoCollect = false
getgenv().AutoBuy = false

-- Locals
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  Settings.Plot = (function()
    for _, plot in next, workspace.Plots:GetChildren() do
      if plot.Owner == eu then
        Settings.Plot = plot
      end
    end
  end)()
end)

--[[
local args = {
    [1] = "2087/bAdaD58E1b7e35"
}

game:GetService("ReplicatedStorage").Network.Client.ClaimCashFromEquipmentRequest:InvokeServer(unpack(args))

workspace.Plots["3"].Owner

workspace.Plots["3"].Items["Street Brawlers"] UUID

game:GetService("Players").LocalPlayer.leaderstats.Money



workspace.Map.References.WheelSpinner.Hitbox.TouchInterest
workspace.Map.References.Decor.Hitbox.TouchInterest
workspace.Map.References.Equipment.Hitbox.TouchInterest
workspace.Map.References.Sell.Hitbox.TouchInterest

game:GetService("ReplicatedStorage").Assets.Equipment.Pakman

while true do
for _, arcade in next, workspace.Plots["2"].Items:GetChildren() do
game:GetService("ReplicatedStorage").Network.Client.ClaimCashFromEquipmentRequest:InvokeServer(arcade:GetAttribute("UUID"))
end
task.wait(1) end
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
do
  local section = Tabs.Menu:Section({ Title = "Helpful", Icon = "heart-handshake", Opened = true })
  
  section:Toggle({
    Title = "Auto Collect Cash",
    Desc = "Automatically collects cash",
    Callback = function(state)
      getgenv().AutoCollect = state
      
      while getgenv().AutoCollect do
        pcall(function()
          for _, arcade in next, Settings.Plot.Items:GetChildren() do
            ReplicatedStorage.Network.Client.ClaimCashFromEquipmentRequest:InvokeServer(arcade:GetAttribute("UUID"))
          end
        end)
      task.wait(1) end
    end
  })
end

Tabs.Menu:Divider()

do
  local section = Tabs.Menu:Section({ Title = "Auto Buy", Icon = "gamepad-2", Opened = true })
  
  local Arcades = (function()
    local Values = {}
    
    for _, arcade in next, ReplicatedStorage.Assets.Equipment:GetChildren() do
      local name = arcade.Name
      arcade = require(arcade)
      
      local final = string.format("%s [ %s ]", name, arcade.Price)
      if not table.find(Values, final) then
        table.insert(Values, final)
      end
    end
    
    return Values
  end)()
  local selected = Arcades[1]
  
  section:Dropdown({
    Title = "Selected Arcade",
    Values = Arcades,
    Value = selected,
    Callback = function(option)
      selected = option
    end
  })

  section:Divider()
  
  section:Toggle({
    Title = "Auto Buy",
    Callback = function(state)
      getgenv().AutoBuy = state
      
      while getgenv().AutoBuy do
        pcall(function()
          local price = selected:match("%[%s*(.-)%s*%]")
          
          if eu.leaderstats.Money.Value >= tonumber(price) then
            
          end
        end)
      task.wait(1) end
    end
  })
end
Tabs.Menu:Divider()