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
  Menu = Window:Tab({ Title = "Main", Icon = "house"}),
  Vault = Window:Tab({ Title = "Vault", Icon = "vault"}),
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Collect" })
Tabs.Menu:Toggle({
  Title = "Auto Collect Sales",
  Desc = "Collects the money from sales..",
  Value = false,
  Callback = function(state)
    getgenv().CollectCash = state
    CollectCash()
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
Tabs.Menu:Section({ Title = "Sell" })
Tabs.Menu:Button({
  Title = "Sell Furniture",
  Desc = "Sells your stuff [RISKY]",
  Callback = function()
    for _, item in pairs(workspace.Debris.Items:GetChildren()) do
      if item:GetAttribute("Owner") == eu.UserId and not item:GetAttribute("Carrying") and not item:GetAttribute("Vaulted") then
        game:GetService("ReplicatedStorage").Network.Items.Price:InvokeServer(item:GetAttribute("UniqueId"), tonumber(tonumber((tonumber(item:GetAttribute("Float")) * tonumber(item:GetAttribute("Weight"))) * 3) * 10))
      end
    end
  end
})

-- Vault
Tabs.Vault:Section({ Title = "Collect" })
Tabs.Vault:Toggle({
  Title = "Auto Collect Vault",
  Desc = "Collects the money from vault..",
  Value = false,
  Callback = function(state)
    getgenv().CollectVault = state
    CollectVault()
  end
})
Tabs.Vault:Section({ Title = "Safety" })
Tabs.Vault:Button({
  Title = "Open Vault",
  Callback = function()
    game:GetService("ReplicatedStorage").Network.Plot.OpenVault:FireServer(true)
  end
})
Tabs.Vault:Button({
  Title = "Close Vault",
  Callback = function()
    game:GetService("ReplicatedStorage").Network.Plot.OpenVault:FireServer(false)
  end
})