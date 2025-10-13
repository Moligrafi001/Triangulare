-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Plots:GetChildren()) do
      if plot:GetAttribute("OwnerId") == eu.UserId then
        Settings.Plot = plot.Tycoon
        return
      end
    end
  end
end)

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.Collect.Main, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, Settings.Plot.Collect.Main, 1)
    end)
  end
end

--[[
Game: 8744069930 | Place: 119396523930335
workspace.Plots.Plot2.Tycoon.Collect.Main.TouchInterest
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"})
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