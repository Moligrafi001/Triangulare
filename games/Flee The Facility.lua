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
do
  local ShoCen = Tabs.Event:Section({ Title = "Shopping Center", Opened = true })
  ShoCen:Paragraph({
    Title = "How to Use",
    Desc = "When in the \"Shopping Center\" map click the button below or execute the specific action you need in the section below"
  })
  do
    local Steps = {
      ["1"] = function()
        fireclickdetector(workspace["Shopping Center by D4niel_Foxy"].Heels.ClickPart.ClickDetector)
      end,
      ["2"] = function()
        fireclickdetector(workspace["Shopping Center by D4niel_Foxy"].MirrorModel.MirrorFace.ClickDetector)
      end,
      ["3"] = function()
        local r, p = eu.Character.HumanoidRootPart, workspace["Shopping Center by D4niel_Foxy"].MirrorModel.TouchDetector
        firetouchinterest(r, p, 0)
        firetouchinterest(r, p, 1)
      end,
    }
    
    ShoCen:Button({
      Title = "Finish All Steps",
      Desc = "Finishes all steps, teleporting you to the event place.",
      Icon = "shell",
      Callback = function()
        pcall(Steps["1"])
        pcall(Steps["2"])
        task.wait(3)
        pcall(Steps["3"])
      end
    })
  
    local step = "1"
    local specific = ShoCen:Section({ Title = "Specific Action", Opened = true })
    specific:Dropdown({
      Title = "Selected Action",
      Desc = "Selects a specific action",
      Values = {
        {
          Title = "Collect Heels [ 1 / 3 ]",
          Desc = "Collects the heels from the stand",
          Icon = "footprints"
        },
        {
          Title = "Activate Mirror [ 2 / 3 ]",
          Desc = "Activates the portal so you can enter",
          Icon = "mouse-pointer"
        },
        {
          Title = "Enter Mirror [ 3 / 3 ]",
          Desc = "Teleports you to the event place",
          Icon = "log-in"
        }
      },
      Value = "Collect Heels [ 1 / 3 ]",
      Callback = function(option)
        option = option.Title:match("%d+")
        step = option
      end
    })
    specific:Button({
      Title = "Execute Action",
      Desc = "Executes the step selected above",
      Icon = "play",
      Callback = function()
        local action = Steps[step]
        action()
      end
    })
  end
end
Tabs.Event:Divider()
local Forest = Tabs.Event:Section({ Title = "Event Place", Opened = true })
Forest:Button({
  Title = "Mountain Climber",
  Desc = "Step 1",
  Callback = function()
    local r, p = eu.Character.HumanoidRootPart, workspace.GameplaySections.Task1.Complete
    firetouchinterest(r, p, 0)
    firetouchinterest(r, p, 1)
    r.CFrame = p.CFrame
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
Forest:Button({
  Title = "Finish Minigame",
  Desc = "Step 6 (click when minigame start)",
  Callback = function()
    game:GetService("ReplicatedStorage").Remotes.MinigameEvent:FireServer(true)
  end
})