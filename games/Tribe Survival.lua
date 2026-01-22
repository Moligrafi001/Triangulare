local Gokka = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Gokka.lua"))()

-- Globals
getgenv().PlayerESP = false
getgenv().StrucESP = false
getgenv().AutoEat = false
Gokka:Disconnect("AutoEat")

--[[
local args = {
    [1] = CFrame.new(641.2633056640625, 2.094999074935913, 315.3388366699219) * CFrame.Angles(6.771798410909469e-08, -0.1746547818183899, 1.2827732653875046e-08),
    [2] = {
        [1] = workspace.Resources.TundraFruitBush
    },
    [4] = {}
}
game:GetService("Players").LocalPlayer.Character.Greataxe.ToolScripts.Swing:FireServer(unpack(args))
local args = {
    [1] = CFrame.new(632.7011108398438, 2.094999074935913, 298.54547119140625) * CFrame.Angles(1.093031265497757e-08, -4.670395146163587e-16, -5.8864280561010673e-08),
    [2] = {
        [1] = game:GetService("Players").grayboy7438.Character
    },
    [4] = {}
}
game:GetService("Players").LocalPlayer.Character.Greataxe.ToolScripts.Swing:FireServer(unpack(args))
game:GetService("Players").LocalPlayer.OwnedHats["Archer Hat"]
local args = {
    [1] = "Speed Cap"
}
game:GetService("ReplicatedStorage").Remotes.Hats.EquipHat:FireServer(unpack(args))
local args = {
    [1] = "Dark Hood"
}
game:GetService("ReplicatedStorage").Remotes.Hats.EquipHat:FireServer(unpack(args))
]]--

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Speed = 25,
  Food = "Comida",
  Eating = false,
  Pretend = {
    Enabled = false,
    Hold = 0.25
  },
  Quantity = 1
}

-- Load
local LexSP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/lasp.lua"))()
local function SetEat(char)
  Gokka:Connect({
    Name = "AutoEat",
    Signal = game:GetService("Players").LocalPlayer.Character.Humanoid.HealthChanged,
    Callback = function(vidaAtual)
      if not getgenv().AutoEat or vidaAtual == 1 or Settings.Eating then return end
      
      char = char or eu.Character
      local humanoid = char and char:FindFirstChild("Humanoid")
      if not humanoid then return end
      
      if vidaAtual >= humanoid.MaxHealth then return end
      
      -- Food Stuff
      local function ScanFoodIn(where)
        for _, f in ipairs(eu[where]:GetChildren()) do
          if f:FindFirstChild("FoodScripts") and f:FindFirstChild("Stats") then
            return f
          end
        end
      end
      
      local food = eu.Backpack:FindFirstChild(Settings.Food) or char:FindFirstChild(Settings.Food)
      if not food then
        local f = ScanFoodIn("Backpack") or ScanFoodIn("Character")
        if not f then return end
        
        Settings.Food, food = f.Name, f
      end
      
      Settings.Eating = true
      
      local Pretend = Settings.Pretend.Enabled
      if Pretend and food.Parent ~= char then food.Parent = char end
      
      do
        local FoodCost, Heal = food.Stats:GetAttribute("FoodCost"), food.Stats:GetAttribute("Heal")
        local Health, MaxHealth, Resources = humanoid.Health, humanoid.MaxHealth, char.Resources:GetAttribute("Food")
        
        eu._Events.AddInput:FireServer({
          ["ButtonX"] = 1,
          ["ButtonR2"] = 1
        })
        while Health < MaxHealth and Resources >= FoodCost do
          food.FoodScripts.Eat:InvokeServer()
          
          Resources, Health = Resources - FoodCost, Health + Heal
        task.wait() end
      end
      
      if Pretend then
        task.spawn(function()
          task.wait(Settings.Pretend.Hold)
          if food and food.Parent ~= eu.Backpack then food.Parent = eu.Backpack end
        end)
      end
      
      Settings.Eating = false
    end
  })
end
Gokka:Connect({
  Name = "SetEatOnLoad",
  Signal = game:GetService("Players").LocalPlayer.CharacterAdded,
  Callback = function(char)
    char:WaitForChild("Humanoid")
    char:WaitForChild("Resources")
    task.wait(1)
    SetEat(char)
  end
})

LexSP:RegisterListener({
  From = workspace.Structures,
  Name = "NPCs",
  
  Validate = function(obj)
    local name = obj.Name:lower()
    if string.find(name, "trap") or name == "landmine" then
      local MyTribe, Owner = eu:GetAttribute("ActiveTribe"), obj.Owner.Value
      
      if Owner == eu or MyTribe and Owner:GetAttribute("ActiveTribe") == MyTribe then return end
      
      for _, child in next, obj:GetChildren() do
        pcall(function()
          if child.Name == "Visual" then
            child.Transparency = 0
          end
        end)
      end
      
      return true, {
        TextLabel = {
          Text = Owner.Name,
          Adornee = obj,
          
          TextSize = 10
        },
      }
    end
  end
})

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Eat", Icon = "heart-plus"}),
  Visuals = Window:Tab({ Title = "Visuals", Icon = "eye"}),
  Crates = Window:Tab({ Title = "Crates", Icon = "box"}),
  Tween = Window:Tab({ Title = "Tween", Icon = "shell"}),
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Auto Eat" })
Tabs.Menu:Toggle({
  Title = "Auto Eat",
  Desc = "Eats food when necessarry.",
  Value = false,
  Callback = function(state)
    getgenv().AutoEat = state
    if not state then
      Settings.Food = "Comida"
      Gokka:Disconnect("AutoEat")
      return
    end
    SetEat()
  end
})
do
  local Configs = Tabs.Menu:Section({ Title = "Settings" })
  Configs:Toggle({
    Title = "Equip Food",
    Desc = "Equips food before eating and unequips it.",
    Value = false,
    Locked = true,
    Callback = function(state)
      Settings.Pretend = state
    end
  })
  Configs:Input({
    Title = "Equip Time",
    Value = tostring(Settings.Pretend.Hold),
    Placeholder = "In seconds, e.g.: 0.25",
    Locked = true,
    Callback = function(input)
      Settings.Pretend.Hold = tonumber(input) or 0.09
    end
  })
  Configs:Open()
end

-- Visuals
Tabs.Visuals:Section({ Title = "Players" })
Tabs.Visuals:Toggle({
  Title = "Player Tracer",
  Value = getgenv().PlayerESP,
  Callback = function(state)
    getgenv().PlayerESP = state
    local function Set(state)
      local MyTribe = eu:GetAttribute("ActiveTribe")
      for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        pcall(function()
          LexSP:BasicESP({
            Parent = p.Character,
            Name = "Tracado",
            
            Tracer = {
              From = p.Character.HumanoidRootPart,
              To = eu.Character.HumanoidRootPart,
              
              Enabled = state,
              Color = ColorSequence.new(MyTribe and p:GetAttribute("ActiveTribe") == MyTribe and Color3.fromRGB(255, 0, 255) or Color3.fromRGB(255, 0, 0)),
            }
          })
        end)
      end
    end
    
    if not state then return Set(false) end
    while getgenv().PlayerESP do
      pcall(Set, true)
    task.wait(1) end
  end
})
Tabs.Visuals:Section({ Title = "Structures" })
Tabs.Visuals:Button({
  Title = "Join Dungeon",
  Callback = function()
    local root = eu.Character.HumanoidRootPart
    local door = workspace.Map.DungeonEnter.DungeonEntrance.Door
    
    firetouchinterest(door, root, 0)
    firetouchinterest(door, root, 1)
  end
})
Tabs.Visuals:Toggle({
    Title = "Highlight Trap",
    Value = getgenv().StrucESP,
    Callback = function(state)
      getgenv().StrucESP = state

      local function SetTraps(isVisible)
        local targetTransparency = isVisible and 0 or 1
        
        for _, p in pairs(workspace.Structures:GetChildren()) do
          if p.Name:find("Trap") then
            for _, child in pairs(p:GetDescendants()) do
              if child.Name == "Visual" and (child:IsA("BasePart") or child:IsA("MeshPart")) then
                child.Transparency = targetTransparency
              end
            end
          end
        end
      end
      
      if not state then 
        SetTraps(false)
        return 
      end
      
      while getgenv().StrucESP do
        SetTraps(true)
      task.wait(1) end
  end
})
Tabs.Visuals:Section({ Title = "FOV" })
Tabs.Visuals:Slider({
  Title = "Field Of View",
  Desc = "Changes your visible area.",
  
  Step = 1,
  Value = {
    Min = 1,
    Max = 120,
    Default = 70,
  },
  Callback = function(value)
    workspace.CurrentCamera.FieldOfView = value
  end
})

-- Crates
Tabs.Crates:Section({ Title = "Open Crate" })
Tabs.Crates:Input({
  Title = "Quantity",
  Value = tostring(Settings.Quantity),
  Placeholder = "Numbers only, e.g.: 10",
  Callback = function(input)
    Settings.Quantity = tonumber(input) or 0.09
  end
})
Tabs.Crates:Button({
  Title = "Open Crates",
  Desc = "Opens the selected amount of crates.",
  Callback = function()
    for i = 1, Settings.Quantity do
      game:GetService("ReplicatedStorage").Remotes.Hats.BuyHatCrate:InvokeServer(false, false)
    end
  end
})

-- Tween
local function GetTweener()
  local TweenService = game:GetService("TweenService")
  local mouse = eu:GetMouse()
  
  local tool = Instance.new("Tool")
  tool.Name = "Tweener"
  tool.RequiresHandle = false
  tool.Parent = eu.Backpack
  
  tool.Activated:Connect(function()
    local root = eu.Character.HumanoidRootPart
    
    local targetPos = mouse.Hit.p
    local finalPos = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
    
    local duration = (root.Position - finalPos).Magnitude / Settings.Speed
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(root, tweenInfo, {
      CFrame = CFrame.new(finalPos)
    })
  
    tween:Play()
  end)
end
local function DelTweener()
  local tweener = eu.Backpack:FindFirstChild("Tweener") or eu.Character:FindFirstChild("Tweener")
  if tweener then tweener:Destroy() end
end

Tabs.Tween:Section({ Title = "Tween Tool" })
Tabs.Tween:Button({
  Title = "Get Tool",
  Desc = "Gives you the tween tool.",
  Callback = function()
    GetTweener()
  end
})
Tabs.Tween:Button({
  Title = "Remove Tool",
  Desc = "Removes the tween tool.",
  Callback = function()
    DelTweener()
  end
})
Tabs.Tween:Input({
  Title = "Tween Speed",
  Value = tostring(Settings.Speed),
  Placeholder = "Numbers only, e.g.: 25",
  Callback = function(input)
    Settings.Speed = tonumber(input) or 0.09
  end
})