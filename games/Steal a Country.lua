-- Global Values
getgenv().AutoCollect = false
getgenv().AutoLock = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace["Player Bases"]:GetChildren()) do
      local id = plot:GetAttribute("UserId")
      if id and id == eu.UserId then
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
      for _, slot in pairs(Settings.Plot.Floor1:GetChildren()) do
        pcall(function()
          if slot:GetAttribute("Balance") > 0 then
            game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Base:CollectSlot"):FireServer(slot)
          end
        end)
      end
    end)
  end
end
local function AutoLock()
  while getgenv().AutoLock and task.wait(0.39) do
    pcall(function()
      if not Settings.Plot:GetAttribute("LockTimer") then
        game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Base:Lock"):FireServer(Settings.Plot.Floor1.Locker)
      end
    end)
  end
end

--[[
Game: 8070392042 | Place: 112076897193131
local args = {
    [1] = workspace:FindFirstChild("Player Bases"):FindFirstChild("HallowHub's Base").Floor1.Locker
}

game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Base:Lock"):FireServer(unpack(args))
local args = {
    [1] = workspace:FindFirstChild("Player Bases"):FindFirstChild("HallowHub's Base").Floor1.Slot4 Balance
}

game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Base:CollectSlot"):FireServer(unpack(args))
local args = {
    [1] = workspace.RunwayRigs.Romania
}

game:GetService("ReplicatedStorage").Remotes:FindFirstChild("Runway:Buy"):FireServer(unpack(args))
UserId LockTimer
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
  Title = "Auto Lock",
  Desc = "Automatically locks your plot.",
  Value = false,
  Callback = function(state)
    getgenv().AutoLock = state
    AutoLock()
  end
})