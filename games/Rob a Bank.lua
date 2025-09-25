-- Global Values
getgenv().AutoCollect = false
getgenv().AutoBeg = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

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
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.MoneyCollecter.Collect, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.MoneyCollecter.Collect, 1)
    end)
  end
end
local function AutoUpgrade()
  while getgenv().AutoUpgrade and task.wait(1) do
    pcall(function()
      for _, upgrade in pairs(Settings.Plot.Upgrades:GetChildren()) do
        if upgrade.ProximityPrompt.Enabled and upgrade.Price.Value <= eu.leaderstats.Dollars then
          game:GetService("ReplicatedStorage").Events.BuyEvent:FireServer(upgrade)
        end
      end
    end)
  end
end

--[[
local args = {
    [1] = workspace.Plots.Plot6.Upgrades:FindFirstChild("2")
}

game:GetService("ReplicatedStorage").Events.BuyEvent:FireServer(unpack(args))
Game: 8319782618 | Place: 107431063731700
workspace.Plots.Plot6.MoneyCollecter.Collect.TouchInterest
workspace.Plots.Plot6.Owner
workspace.Plots.Plot6.Upgrades["21"].Price
workspace.Plots.Plot6.Upgrades["21"].ProximityPrompt
]]--

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
  Title = "Auto Upgrade",
  Desc = "Automatically buys upgrades.",
  Value = false,
  Callback = function(state)
    getgenv().AutoUpgrade = state
    AutoUpgrade()
  end
})