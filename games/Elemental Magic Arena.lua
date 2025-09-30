-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  LastCFrame = CFrame.new(0, 0, 0)
}

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      for _, diamond in pairs(workspace:GetChildren()) do
        if diamond:IsA("MeshPart") and diamond.Name == "Diamond" and diamond:FindFirstChildOfClass("TouchTransmitter", true) then
          Settings.LastCFrame = eu.Character.HumanoidRootPart
          eu.Character.HumanoidRootPart.CFrame = diamond.CFrame
          task.wait(0.3)
          firetouchinterest(eu.Character.HumanoidRootPart, diamond, 0)
          firetouchinterest(eu.Character.HumanoidRootPart, diamond, 1)
        end
      end
    end)
  end
end

--[[
workspace:GetChildren()[37].Handle.TouchInterest
workspace.Emerald.Handle.TouchInterest
Game: 8118501380 | Place: 92304138580520
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
  Desc = "Automatically collects diamonds.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})