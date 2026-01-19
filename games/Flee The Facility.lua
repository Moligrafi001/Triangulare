-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

--[[
workspace["Shopping Center by D4niel_Foxy"].MirrorModel.TouchDetector.TouchInterest
workspace["Shopping Center by D4niel_Foxy"].MirrorModel.MirrorFace.ClickDetector
workspace["Shopping Center by D4niel_Foxy"].Heels.ClickPart.ClickDetector

workspace.Map:GetChildren()[117].DressClone.ClickPart.ClickDetector
workspace.GameplaySections.Task1.Complete.TouchInterest
workspace.GameplaySections.Task2.CompleteB.TouchInterest
workspace.GameplaySections.Task2.CompleteA.TouchInterest
]]--

-- Tabs
local Tabs = {
  Event = Window:Tab({ Title = "Event", Icon = "gift" })
}
Window:SelectTab(1)

-- Event
local ShoCen = Tabs.Event:Section({ Title = "Shopping Center", Opened = true })
ShoCen:Button({
  Title = "Collect Heels",
  Desc = "Step 1",
  Callback = function()
    fireclickdetector(workspace["Shopping Center by D4niel_Foxy"].Heels.ClickPart.ClickDetector)
  end
})
ShoCen:Button({
  Title = "Activate Mirror",
  Desc = "Step 2",
  Callback = function()
    fireclickdetector(workspace["Shopping Center by D4niel_Foxy"].MirrorModel.MirrorFace.ClickDetector)
  end
})
ShoCen:Button({
  Title = "Enter Mirror",
  Desc = "Step 3",
  Callback = function()
    local r, p = eu.Character.HumanoidRootPart, workspace["Shopping Center by D4niel_Foxy"].MirrorModel.TouchDetector
    firetouchinterest(r, p, 0)
    firetouchinterest(r, p, 1)
  end
})
local Forest = Tabs.Event:Section({ Title = "Forest", Opened = true })
Forest:Button({
  Title = "Mountain Climber",
  Desc = "Step 1",
  Callback = function()
    local r, p = eu.Character.HumanoidRootPart, workspace.GameplaySections.Task1.Complete
    firetouchinterest(r, p, 0)
    firetouchinterest(r, p, 1)
  end
})
Forest:Toggle({
  Title = "Hiker Hunter",
  Desc = "Step 2 (hit the npcs first)",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    while getgenv().AutoCollect do
      pcall(function()
        for _, npc in next, workspace:GetChildren() do
          pcall(function()
            local r = npc:FindFirstChild("HumanoidRootPart")
            -- if not r then continue end
            
            local pp = r:FindFirstChild("HikerProximityPrompt")
            if pp and pp.Enabled then fireproximityprompt(pp) end 
          end)
        end
      end)
    task.wait(0.1) end
  end
})
Forest:Button({
  Title = "Cave Spider",
  Desc = "Step 3",
  Callback = function()
    local r, p = eu.Character.HumanoidRootPart, workspace.GameplaySections.Task2.CompleteA
    firetouchinterest(r, p, 0)
    firetouchinterest(r, p, 1)
  end
})
Forest:Button({
  Title = "Cabin Dodger",
  Desc = "Step 4",
  Callback = function()
    local r, p = eu.Character.HumanoidRootPart, workspace.GameplaySections.Task2.CompleteB
    firetouchinterest(r, p, 0)
    firetouchinterest(r, p, 1)
  end
})
Forest:Button({
  Title = "Decisions",
  Desc = "Step 5",
  Callback = function()
    fireclickdetector(workspace.Map:GetChildren()[117].DressClone.ClickPart.ClickDetector)
  end
})