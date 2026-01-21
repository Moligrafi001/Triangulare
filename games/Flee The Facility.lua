-- Global Values
getgenv().PlayerESP = false
getgenv().ComputerESP = false

getgenv().SlowBeast = false
getgenv().BreakRope = false
getgenv().ForceAbility = false

getgenv().AntiSlow = false
getgenv().HitAura = false
getgenv().AutoTie = false

getgenv().NeverFail = false
getgenv().AutoEscape = false
getgenv().AlertUse = false
getgenv().AutoHide = false

getgenv().AutoCollect = false

-- Locals
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local eu = Players.LocalPlayer
local Settings = {
  Colors = {
    Survivor = Color3.fromRGB(16, 239, 0),
    Beast = Color3.fromRGB(255, 0, 0)
  },
  GetBeastEvent = function(parent, event, dski)
    for _, p in pairs(Players:GetPlayers()) do
      if not dski and p == eu then continue end
      
      local char = p.Character
      if char and char:FindFirstChild("BeastPowers") then
        local s1 = char:FindFirstChild(parent)
        if s1 then
          local ev = s1:FindFirstChild(event)
          if ev then return ev end
        end
      end
    end
  end
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
  Roles = Window:Section({ Title = "Roles", Icon = "user-lock", Opened = true }),
  Window:Divider(),
  Visuals = Window:Tab({ Title = "Visuals", Icon = "eye" }),
  Troll = Window:Tab({ Title = "Troll", Icon = "laugh" }),
  Window:Divider(),
  Event = Window:Tab({ Title = "Event", Icon = "gift" })
}
Window:SelectTab(1)

-- Roles
do
  local survivor = Tabs.Roles:Tab({ Title = "Survivor", Icon = "smile-plus" })
  
  local info = survivor:Section({ Title = "Beast", Icon = "gavel", Opened = true })
  local abco = info:Paragraph({
    Title = "Ability and Cooldown Progress",
    Desc = "Loading..."
  })

  task.spawn(function()
    local GetBeastEvent = Settings.GetBeastEvent
    while true do
      local temp = GetBeastEvent("BeastPowers", "PowerProgressPercent", true)
      
      abco:SetDesc(string.format("Ability: %s | Progress: %s", (ReplicatedStorage.CurrentPower.Value or "Undefined"), (temp and temp.Value or "Undefined")))
    task.wait(0.1) end
  end)
  
  survivor:Divider()
  
  local undtc = survivor:Section({ Title = "Undetectable", Icon = "bell-off", Opened = true })
  undtc:Toggle({
    Title = "Never Fail Hacking",
    Desc = "Nevers fails while hacking computers",
    Value = false,
    Callback = function(state)
      getgenv().NeverFail = state
      while getgenv().NeverFail do
        pcall(function()
          if not eu.Character:FindFirstChild("BeastPowers") then
            ReplicatedStorage.RemoteEvent:FireServer("SetPlayerMinigameResult", true)
          end
        end)
      task.wait(0.1) end
    end
  })

  survivor:Divider()
  
  local HidAl = survivor:Section({ Title = "Hide", Icon = "eye-closed", Opened = true })
  HidAl:Button({
    Title = "Hide",
    Desc = "Teleports you to a random locker",
    Icon = "eye-off",
    Callback = function()
      local map = ReplicatedStorage.CurrentMap.Value
      if not map then return end
      
      local r = eu.Character.HumanoidRootPart
      local backup = r.CFrame
      
      local function GetRandomLocker()
        for _, locker in pairs(map:GetChildren()) do
          if locker.Name == "Locker" or locker.Name == "Closet" then
            return locker
          end
        end
      end
      
      local locker = GetRandomLocker()
      if not locker then return end
      
      r.CFrame = CFrame.new(locker.WorldPivot.Position)
      task.wait(0.3)
      r.CFrame = backup
    end
  })
  do
    local Gokka = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Gokka.lua"))()
    info:Toggle({
      Title = "Alert Ability",
      Desc = "Alerts you when the beast use the ability",
      Value = false,
      Callback = function(state)
        getgenv().AlertUse = state
        if not state then return end
        
        local Alerts = {
          Seeker = "Beast is trying to blend in",
          Seer = "Use the hide feature before beast find you",
          Runner = "Beast is faster now, jump a window"
        }
        Gokka:Connect({
          Name = "AbilityUsed",
          Parent = ReplicatedStorage.PowerActive,
          Signal = "Changed",
          Callback = function(value)
            if not getgenv().AlertUse or not value or eu.Character:FindFirstChild("BeastPowers") then return end
            
            local ability = ReplicatedStorage.CurrentPower.Value
            WindUI:Notify({
              Title = "Beast activated ability!",
              Content = string.format("Ability: %s | %s!", ability, Alerts[ability] or "Be careful"),
              Icon = "triangle-alert",
              Duration = 5
            })
          end
        })
      end
    })
  end

  survivor:Divider()
  
  local escape = survivor:Section({ Title = "Escape", Icon = "door-open", Opened = true })
  
  local function Escape()
    if ReplicatedStorage.ComputersLeft.Value ~= 0 or eu.Character:FindFirstChild("BeastPowers") then return end
    
    local map = ReplicatedStorage.CurrentMap.Value
    if not map then return end
    
    local r, backup = eu.Character.HumanoidRootPart
    for _, door in pairs(map:GetChildren()) do
      if door.Name == "ExitDoor" and door:FindFirstChild("ExitArea") then
        backup, r.CFrame = r.CFrame, door.ExitArea.CFrame
        task.wait(0.1)
        r.CFrame = backup
      end
    end
  end
  escape:Button({
    Title = "Escape",
    Desc = "Escapes, basically",
    Icon = "log-out",
    Callback = Escape
  })
  escape:Toggle({
    Title = "Auto Escape",
    Desc = "Automatically escapes",
    Value = false,
    Callback = function(state)
      getgenv().AutoEscape = state
      
      while getgenv().AutoEscape do
        pcall(Escape)
      task.wait(3) end
    end
  })
end
do
  local beast = Tabs.Roles:Tab({ Title = "Beast", Icon = "gavel" })
  
  local hitaura = beast:Section({ Title = "Hit Aura", Icon = "gavel", Opened = true })
  hitaura:Slider({
    Title = "Aura Range",
    Desc = "Max range to hit survivors",
    Step = 1,
    Value = {
      Min = 5,
      Max = 15,
      Default = 10
    },
    Callback = function(value)
    end
  })
  hitaura:Toggle({
    Title = "Hit Aura",
    Callback = function(state)
    end
  })

  beast:Divider()

  local autotie = beast:Section({ Title = "Auto Tie", Icon = "link", Opened = true })
  autotie:Slider({
    Title = "Tie Range",
    Desc = "Max range to tie survivors",
    Step = 1,
    Value = {
      Min = 5,
      Max = 50,
      Default = 5
    },
    Callback = function(value)
    end
  })
  autotie:Toggle({
    Title = "Hit Aura",
    Callback = function(state)
    end
  })
  
  beast:Divider()
  
  local antislow = beast:Section({ Title = "Anti Slow", Icon = "fast-forward", Opened = true })
  antislow:Toggle({
    Title = "Anti Slow",
    Desc = "Never gets slow after jumping",
    Callback = function(state)
      getgenv().AntiSlow = state
      
      while getgenv().AntiSlow do
        pcall(function()
          local char = eu.Character
          if not char:FindFirstChild("BeastPowers") then return end
          
          local humanoid = char:FindFirstChild("Humanoid")
          if not humanoid or humanoid:GetAttribute("AntiSlow") then return end
          humanoid:SetAttribute("AntiSlow", true)
          
          humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if not getgenv().AntiSlow or not humanoid.Parent:FindFirstChild("BeastPowers") then return end
            if humanoid.WalkSpeed < 17 then
              humanoid.WalkSpeed = 17
            end
          end)
        end)
      task.wait(1) end
    end
  })
end

-- Visuals
do
  local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/lasp.lua"))()
  
  local esp = Tabs.Visuals:Section({ Title = "Extra Sensorial Experience", Icon = "scan-eye", Opened = true })
  esp:Toggle({
    Title = "Player ESP",
    Value = false,
    Callback = function(state)
      getgenv().PlayerESP = state
      
      local function Set(boolean)
        for _, p in pairs(Players:GetPlayers()) do
          if p ~= eu then
            local char = p.Character
            if char then
              if char:FindFirstChild("BeastPowers") then
                Lib:BasicESP({
                  Parent = char,
                  Name = "Player",
                  
                  Highlight = {
                    Enabled = boolean,
                    Color = Settings.Colors.Beast
                  }
                })
              else
                Lib:BasicESP({
                  Parent = char,
                  Name = "Player",
                  
                  Highlight = {
                    Enabled = boolean,
                    Color = Settings.Colors.Survivor
                  }
                })
              end
            end
          end
        end
      end
      
      if not state then return Set(false) end
      
      while getgenv().PlayerESP do
        Set(true)
      task.wait(0.3) end
    end
  })
  esp:Colorpicker({
    Title = "Survivor Color",
    Default = Settings.Colors.Survivor,
    Callback = function(color)
      Settings.Colors.Survivor = color
    end
  })
  esp:Colorpicker({
    Title = "Beast Color",
    Default = Settings.Colors.Beast,
    Callback = function(color)
      Settings.Colors.Beast = color
    end
  })

  esp:Divider()
  
  esp:Toggle({
    Title = "Computer ESP",
    Value = false,
    Callback = function(state)
      getgenv().ComputerESP = state
      
      local function Set(boolean)
        local map = ReplicatedStorage.CurrentMap.Value
        if not map then return end
        
        for _, pc in pairs(map:GetChildren()) do
          if pc.Name == "ComputerTable" then
            local screen = pc:FindFirstChild("Screen")
            if screen then
              Lib:BasicESP({
                Parent = pc,
                Name = "Computer",
                
                Highlight = {
                  Enabled = boolean,
                  Color = screen.Color
                }
              })
            end
          end
        end
      end
      
      if not state then return Set(false) end
      
      while getgenv().ComputerESP do
        Set(true)
      task.wait(0.3) end
    end
  })
end

-- Troll
do
  local troll = Tabs.Troll:Section({ Title = "Troll Beast", Icon = "angry", Opened = true })
  
  local GetBeastEvent = Settings.GetBeastEvent
  
  local function SlowBeast()
    local event = GetBeastEvent("BeastPowers", "PowersEvent")
    if event then event:FireServer("Jumped") end 
  end
  troll:Button({
    Title = "Slow Beast",
    Desc = "Makes beast slow",
    Icon = "snail",
    Callback = SlowBeast
  })
  troll:Toggle({
    Title = "Auto Slow",
    Desc = "Constantly slows beast",
    Value = false,
    Callback = function(state)
      getgenv().SlowBeast = state
      
      while getgenv().SlowBeast do
        pcall(SlowBeast)
      task.wait(0.05) end
    end
  })

  troll:Divider()
  
  local function DisableRope()
    local event = GetBeastEvent("Hammer", "HammerEvent")
    if event then event:FireServer("HammerClick", true) end
  end
  troll:Button({
    Title = "Disable Rope",
    Icon = "unlink",
    Desc = "Disables beast rope",
    Callback = DisableRope
  })
  troll:Toggle({
    Title = "Auto Disable",
    Desc = "Constantly disables rope",
    Value = false,
    Callback = function(state)
      getgenv().BreakRope = state
      
      while getgenv().BreakRope do
        pcall(DisableRope)
      task.wait(0.05) end
    end
  })

  troll:Divider()
  
  local function ForceAbility()
    local timer = GetBeastEvent("BeastPowers", "PowerProgressPercent")
    if timer and (timer.Value ~= 1 or timer.Value ~= 0) then return end
    
    local event = GetBeastEvent("BeastPowers", "PowersEvent")
    if event then event:FireServer("Input") end 
  end
  troll:Button({
    Title = "Force Ability",
    Icon = "zap",
    Desc = "Forces the beast ability",
    Callback = ForceAbility
  })
  troll:Toggle({
    Title = "Auto Force",
    Desc = "Constantly forces ability",
    Value = false,
    Callback = function(state)
      getgenv().ForceAbility = state
      
      while getgenv().ForceAbility do
        pcall(ForceAbility)
      task.wait(1) end
    end
  })
end

-- Event
do
  local ShoCen = Tabs.Event:Section({ Title = "Shopping Center", Icon = "store", Opened = true })
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
    local specific = ShoCen:Section({ Title = "Specific Action", Icon = "crosshair", Opened = true })
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
local Forest = Tabs.Event:Section({ Title = "Event Place", Icon = "calendar", Opened = true })
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
            if not r then return end
            
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
    ReplicatedStorage.Remotes.MinigameEvent:FireServer(true)
  end
})