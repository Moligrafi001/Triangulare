-- Global Values
getgenv().AutoSell = false
getgenv().CollectBoxes = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Tycoons:GetChildren()) do
      if plot.Properties.Owner.Value == eu then
        Settings.Plot = plot
        return
      end
    end
  end
end)

-- Functions
local function CollectBoxes()
  for _, box in pairs(Settings.Plot.Supplies:GetChildren()) do
    pcall(function()
      game:GetService("ReplicatedStorage").Remotes.Supply:FireServer(box)
    end)
  end
end
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      CollectBoxes()
    end)
  end
end
local function SellBoxes()
  firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.Build.Sellers.SellZoneOrigin, 0)
  firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.Build.Sellers.SellZoneOrigin, 1)
end
local function AutoSell()
  while getgenv().AutoSell and task.wait(1) do
    pcall(function()
      SellBoxes()
    end)
  end
end

--[[
workspace.Tycoons["Tycoon#1"].Build.Sellers.SellZoneOrigin.TouchInterest
workspace.Tycoons["Tycoon#1"].Properties.Owner
game:GetService("Players").LocalPlayer.leaderstats.Cash
local args = {
    [1] = workspace.Tycoons:FindFirstChild("Tycoon#1").Supplies:FindFirstChild("32")
}

game:GetService("ReplicatedStorage").Remotes.Supply:FireServer(unpack(args))
for _, box in pairs(workspace.Tycoons:FindFirstChild("Tycoon#1").Supplies:GetChildren()) do
game:GetService("ReplicatedStorage").Remotes.Supply:FireServer(box)
end
Game: 7261382479 | Place: 118975157774793
--]]

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Sell" })
Tabs.Menu:Toggle({
  Title = "Auto Sell",
  Desc = "Automatically sells boxes.",
  Value = false,
  Callback = function(state)
    getgenv().AutoSell = state
    AutoSell()
  end
})
Tabs.Menu:Button({
  Title = "Sell Boxes",
  Desc = "Sells your boxes.",
  Callback = function()
    pcall(SellBoxes)
  end
})
Tabs.Menu:Section({ Title = "Collect" })
Tabs.Menu:Toggle({
  Title = "Auto Collect",
  Desc = "Automatically collects boxes.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Button({
  Title = "Collect Boxes",
  Desc = "Collects your boxes.",
  Callback = function()
    pcall(CollectBoxes)
  end
})