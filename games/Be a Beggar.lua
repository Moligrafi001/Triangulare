-- Global Values
getgenv().AutoCollect = false
getgenv().AutoBeg = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot and task.wait(1) do
    for _, plot in pairs(workspace.Bases:GetChildren()) do
      if plot:FindFirstChild("Owner") and plot.Owner.Value == eu.UserId then
        Settings.Plot = plot
        return
      end
    end
  end
end)

-- Functions
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(0.39) do
    pcall(function()
      for _, money in pairs(workspace.Money:GetChildren()) do
        pcall(function()
          if (eu.Character.HumanoidRootPart.Position - money.Position).Magnitude <= 10 then
            fireproximityprompt(money.Template2)
          end
        end)
      end
    end)
  end
end
local function AutoBeg()
  while getgenv().AutoBeg and task.wait(0.39) do
    pcall(function()
      for _, npc in pairs(workspace.NPCs:GetChildren()) do
        pcall(function()
          if (eu.Character.HumanoidRootPart.Position - npc.HumanoidRootPart.Position).Magnitude <= 10 then
            fireproximityprompt(npc.HumanoidRootPart.Template)
          end
        end)
      end
    end)
  end
end

--[[
Game: 8305240030 | Place: 119574637420814
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Auto Collect Cash",
  Desc = "Automatically collects cash from the floor.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Beg",
  Desc = "Automatically begs for NPCs.",
  Value = false,
  Callback = function(state)
    getgenv().AutoBeg = state
    AutoBeg()
  end
})
Tabs.Menu:Section({ Title = "Gamepasses" })
Tabs.Menu:Button({
  Title = "Get All Gamepasses [ not 100% ]",
  Desc = "Gives you all the gamepasses.",
  Callback = function()
    for _, g in pairs(eu.PlayerData.Gamepasses:GetChildren()) do
      if g.Value == false then
        g.Value = true
      end
    end
  end
})