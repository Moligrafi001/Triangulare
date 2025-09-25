-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(0.09) do
    pcall(function()
      local Team = eu.Team
      if Team and eu.BrickCount.Value < 1 and eu.Character then
        local root = eu.Character.HumanoidRootPart
        local OldCFrame = root.CFrame
        root.CFrame = workspace.Classic[Team].BlockMain.Giver * CFrame.new(0, 3, 0)
        task.wait(0.1)
        root.CFrame = OldCFrame
      end
    end)
  end
end

--[[
local eu = game.Players.LocalPlayer
local part = workspace.Classic.Yellow.BlockMain.Giver
while task.wait(0.1) do
firetouchinterest(eu.Character.HumanoidRootPart, part, 0)
firetouchinterest(eu.Character.HumanoidRootPart, part, 1)
end
game:GetService("Players").LocalPlayer.BrickCount
Game: 7960300951 | Place: 87531672335231
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