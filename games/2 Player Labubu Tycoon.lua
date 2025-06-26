-- Global Values
getgenv().AutoCollect = false
getgenv().CollectCoins = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace["Tycoon Kit"].Tycoons:GetChildren()) do
      if plot:FindFirstChild("Owner") and plot.Owner.Value == eu then
        Settings.Plot = plot
        return
      end
    end
  end
end)

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      local CollectPart = Settings.Plot.Essentials.Giver
      firetouchinterest(eu.Character.HumanoidRootPart, CollectPart, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, CollectPart, 1)
    end)
  end
end
local function CollectCoins()
  while getgenv().CollectCoins and task.wait(1) do
    pcall(function()
      for _, coin in pairs(workspace.Coins:GetChildren()) do
        firetouchinterest(eu.Character.HumanoidRootPart, coin.MeshPart, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, coin.MeshPart, 1)
      end
      if not workspace.Coins:GetAttribute("Connected") then
        workspace.Coins:SetAttribute("Connected", true)
        workspace.Coins.ChildAdded:Connect(function(coin)
          if getgenv().CollectCoins then
            firetouchinterest(eu.Character.HumanoidRootPart, coin.MeshPart, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, coin.MeshPart, 1)
          end
        end)
      end
    end)
  end
end
local function AutoBuy()
  while getgenv().AutoBuy and task.wait(1) do
    pcall(function()
      for _, button in pairs(Settings.Plot.Buttons:GetChildren()) do
        pcall(function()
          if not button:FindFirstChild("Gamepass") and button.Head.Transparency == 0 then
            firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, button.Head, 1)
            task.wait(1)
          end
        end)
      end
    end)
  end
end

--[[
Game: 7750682571 | Place: 133335273076187
workspace["Tycoon Kit"].Tycoons["Pink Labubu 1"].Owner
workspace["Tycoon Kit"].Tycoons["Pink Labubu 1"].Buttons["Buy Stairs"].Price
workspace["Tycoon Kit"].Tycoons["Pink Labubu 1"].Buttons["Buy Stairs"].Head
workspace["Tycoon Kit"].Tycoons["Pink Labubu 1"].Essentials.Giver.TouchInterest
workspace.Coins:GetChildren()[3].MeshPart.TouchInterest
--]]

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Auto Collect",
  Desc = "Automatically collects cash.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Toggle({
  Title = "Collect Coins",
  Desc = "Automatically collects coins.",
  Value = false,
  Callback = function(state)
    getgenv().CollectCoins = state
    CollectCoins()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Buy Buttons",
  Desc = "Automatically buys buttons.",
  Value = false,
  Callback = function(state)
    getgenv().AutoBuy = state
    AutoBuy()
  end
})