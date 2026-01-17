-- Global Values
getgenv().AutoCollect = false
getgenv().AutoBuy = false
getgenv().Crates = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot do
    for _, plot in next, workspace.Tycoons:GetChildren() do
      local own1 = plot:FindFirstChild("Owner1")
      if own1 and own1.Value == eu then
        Settings.Plot = plot.Player1
        return
      end
      
      local own2 = plot:FindFirstChild("Owner2")
      if own2 and own1.Value == eu then
        Settings.Plot = plot.Player2
        return
      end
    end
  task.wait(1) end
end)

-- Functions
local function CollectCrates()
  local r = eu.Character.HumanoidRootPart
  
  for _, crate in next, workspace:GetChildren() do
    if crate.Name == "MoneyCrate" and crate:IsA("UnionOperation") and crate:FindFirstChild("Prompt") then
      local backup = r.CFrame
      r.CFrame = crate.CFrame * CFrame.new(0, 3, 0)
      
      task.wait(0.3)
      fireproximityprompt(crate.Prompt)
      
      r.CFrame = backup
    end
  end
end

--[[
local r = game.Players.LocalPlayer.Character.HumanoidRootPart
local p = game:GetService("Workspace").Tycoons["Pizza Team"].Player1.Essential.ATM.Touch
while task.wait(1) do
firetouchinterest(r, p, 0)
firetouchinterest(r, p, 1)
end

workspace.Tycoons["Burger Team"].Owner1 2
workspace.Tycoons["Burger Team"].Player1.Essential.ATM.Touch.TouchInterest
game:GetService("Players").LocalPlayer.leaderstats.Cash.Value
workspace.Tycoons["Burger Team"].Player1.Buttons["Front Counter 3"] Price
workspace.Tycoons["Burger Team"].Player1.Buttons["Front Counter 3"].Head.TouchInterest
7957168819/118022306740532
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
    while getgenv().AutoCollect do
      pcall(function()
        local r, p = eu.Character.HumanoidRootPart, Settings.Plot.Essential.ATM.Touch
        firetouchinterest(r, p, 0)
        firetouchinterest(r, p, 1)
      end)
    task.wait(1) end
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Buy Buttons",
  Desc = "Automatically buys buttons.",
  Value = false,
  Callback = function(state)
    getgenv().AutoBuy = state
    while getgenv().AutoBuy do
      pcall(function()
        for _, button in next, Settings.Plot.Buttons:GetChildren() do
          pcall(function()
            if button:GetAttribute("Price") <= eu.leaderstats.Cash.Value then
              local r, p = eu.Character.HumanoidRootPart, button.Head
              firetouchinterest(r, p, 0)
              firetouchinterest(r, p, 1)
              
              task.wait(1)
            end
          end)
        end
      end)
    task.wait(1) end
  end
})
local Crates = Tabs.Menu:Section({ Title = "Crates", Opened = true })
Crates:Button({
  Title = "Collect Crates",
  Desc = "Collects all crates",
  Callback = CollectCrates
})
Crates:Toggle({
  Title = "Auto Crates",
  Desc = "Auto collects crates.",
  Value = false,
  Callback = function(state)
    getgenv().Crates = state
    while getgenv().Crates do
      pcall(CollectCrates)
    task.wait(1) end
  end
})