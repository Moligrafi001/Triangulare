-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Map = nil
}

-- Almost
local function ScanNewMap()
  for _, map in pairs({"Chaos", "Classic", "Showdown"}) do
    if workspace:FindFirstChild(map) and workspace[map]:IsA("Folder") then
      Settings.Map = map
      return true
    end
  end
end

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(0.375) do
    pcall(function()
      if Settings.Map and workspace:FindFirstChild(Settings.Map) then
        local Team = eu:GetAttribute("TeamName")
        if Team and eu.BrickCount.Value < 1 and eu.Character then
          local root = eu.Character.HumanoidRootPart
          local OldCFrame = root.CFrame
          local giver = workspace[Settings.Map][Team].BlockMain.Giver
          root.CFrame = giver.CFrame * CFrame.new(0, 3, 0)
          
          while eu.BrickCount.Value < tonumber(eu:GetAttribute("MaxBricks")) and task.wait(0.1) do
            firetouchinterest(root, giver, 0)
            firetouchinterest(root, giver, 1)
          end
          
          task.wait(1)
          root.CFrame = OldCFrame
        end
      else
        ScanNewMap()
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