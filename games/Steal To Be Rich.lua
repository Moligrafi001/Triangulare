-- Global Values
getgenv().CollectCash = false
getgenv().CollectVault = false
getgenv().AutoLock = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Map.Plots:GetChildren()) do
      if plot:GetAttribute("Owner") == eu.UserId then
        Settings.Plot = plot
        return
      end
    end
  end
end)

-- Functions
local function CollectCash()
  while getgenv().CollectCash and task.wait(1) do
    pcall(function()
      game:GetService("ReplicatedStorage").Network.Plot.Collect:InvokeServer("Sales")
    end)
  end
end
local function CollectVault()
  while getgenv().CollectVault and task.wait(1) do
    pcall(function()
      game:GetService("ReplicatedStorage").Network.Plot.Collect:InvokeServer("Vault")
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if not Settings.Plot:GetAttribute("Locked") then
        game:GetService("ReplicatedStorage").Network.Plot.Lock:FireServer()
      end
    end)
  end
end

--[[
Game: 7778459210 | Place: 133945484297240
workspace.Map.Plots["2"] Locked Owner
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "houseMenu"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Sell" })
Tabs.Menu:Toggle({
  Title = "Auto Collect Sales",
  Desc = "Collects the money from sales..",
  Value = false,
  Callback = function(state)
    getgenv().CollectCash = state
    CollectCash()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Collect Vault",
  Desc = "Collects the money from vault..",
  Value = false,
  Callback = function(state)
    getgenv().CollectVault = state
    CollectVault()
  end
})
Tabs.Menu:Section({ Title = "Safety" })
Tabs.Menu:Toggle({
  Title = "Auto Lock",
  Desc = "Automatically locks your plot.",
  Value = false,
  Callback = function(state)
    getgenv().AutoLock = state
    AutoLock()
  end
})