-- Global Values
getgenv().AutoCollect = false

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
  while getgenv().AutoCollect and task.wait(1) do
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