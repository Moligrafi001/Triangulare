-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  AntiDouble = false,
  Items = { "NetheriteSword", "WoodenSword", "Rose", "GhostSword", "Stick", "DiamondSword", "Netherite", "EmeraldSword", "Ghost", "Diamond", "Regen1", "PhoenixBladeH", "RottenApple", "Tsunami", "Gap", "StoneSword", "NightfallBlade", "Emerald", "NightmareBladeST", "Infinity", "Iron", "Strength", "Jump2" },
  Ignore = {}
}

-- Functions
local function AutoCollect()
  local function Collect(item)
    if item:IsA("Tool") then
      local touch = item:FindFirstChild("TouchInterest", true)
      if touch and not table.find(Settings.Ignore, item.Name) and (not Settings.AntiDouble or (not eu.Character:FindFirstChild(item.Name) and not eu.Backpack:FindFirstChild(item.Name))) then
        firetouchinterest(eu.Character.HumanoidRootPart, touch.Parent, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, touch.Parent, 1)
      end
    end
  end
  while getgenv().AutoCollect and task.wait(1) do
    pcall(function()
      for _, item in pairs(workspace:GetChildren()) do
        Collect(item)
      end
      if not workspace:GetAttribute("Triangulare") then
        workspace:SetAttribute("Triangulare", true)
        workspace.ChildAdded:Connect(function(item)
          if getgenv().AutoCollect then Collect(item) end
        end)
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
  Desc = "Automatically collects items.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Toggle({
  Title = "Anti Double",
  Desc = "Avoid duplicated items.",
  Value = false,
  Callback = function(state)
    Settings.AntiDouble = state
  end
})