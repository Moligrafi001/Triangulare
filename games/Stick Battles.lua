-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function CollectOrbs()
  for _, orb in pairs(workspace.__THINGS.Orbs:GetChildren()) do
    pcall(function()
      firetouchinterest(eu.Character.HumanoidRootPart, orb, 0)
      firetouchinterest(eu.Character.HumanoidRootPart, orb, 1)
    end)
  end
end
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      task.spawn(CollectOrbs)
      local folder = workspace.__THINGS.Orbs
      if not folder:GetAttribute("Connected") then
        folder:SetAttribute("Connected", true)
        folder.ChildAdded:Connect(function(orb)
          if getgenv().AutoCollect then
            firetouchinterest(eu.Character.HumanoidRootPart, orb, 0)
            firetouchinterest(eu.Character.HumanoidRootPart, orb, 1)
          end
        end)
      end
    end)
  end
end

--[[
workspace.__THINGS.Orbs["01ea4ef39eb247409a362c61c13e5ec4"].TouchInterest
Game: 7691800287 | Place: 136372246050123
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
  Desc = "Automatically collects orbs.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Button({
  Title = "Collect All Orbs",
  Desc = "Gets the orbs in the map.",
  Callback = function()
    CollectOrbs()
  end
})