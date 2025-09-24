-- Global Values
getgenv().AutoCollect = false
getgenv().AutoDeliver = false
getgenv().AutoWin = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(0.09) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, workspace.IMPORTANT.BLOCKS, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, workspace.IMPORTANT.BLOCKS, 1)
    end)
  end
end
local function AutoDeliver()
  while getgenv().AutoDeliver and task.wait(0.09) do
    pcall(function()
      local Team = eu.Team
      firetouchinterest(eu.Character.HumanoidRootPart, workspace.IMPORTANT.BUNKERS[Team].TOUCH, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, workspace.IMPORTANT.BUNKERS[Team].TOUCH, 1)
    end)
  end
end
local function AutoWin()
  while getgenv().AutoWin and task.wait(0.09) do
    pcall(function()
      if not eu.Team then
        firetouchinterest(eu.Character.HumanoidRootPart, workspace.Lobby.Folder.WIN, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, workspace.Lobby.Folder.WIN, 1)
      end
    end)
  end
end

--[[
local eu = game.Players.LocalPlayer
while task.wait(0.1) do
firetouchinterest(eu.Character.HumanoidRootPart, workspace.IMPORTANT.BLOCKS, 0)
firetouchinterest(eu.Character.HumanoidRootPart, workspace.IMPORTANT.BLOCKS, 1)
firetouchinterest(eu.Character.HumanoidRootPart, workspace.IMPORTANT.BUNKERS.Blue.TOUCH, 0)
firetouchinterest(eu.Character.HumanoidRootPart, workspace.IMPORTANT.BUNKERS.Blue.TOUCH, 1)
end
Game: 8366180257 | Place: 84767406892643
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
  Desc = "Automatically collects blocks.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Deliver",
  Desc = "Automatically delivers blocks.",
  Value = false,
  Callback = function(state)
    getgenv().AutoDeliver = state
    AutoDeliver()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Win",
  Desc = "Automatically wins obby.",
  Value = false,
  Callback = function(state)
    getgenv().AutoWin = state
    AutoWin()
  end
})