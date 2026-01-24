-- Global Values
getgenv().AutoCollect = false

-- Locals
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Plot = nil
}

-- Load
task.spawn(function()
  while not Settings.Plot do
    for _, plot in pairs(workspace.Bases:GetChildren()) do
      if plot:GetAttribute("Holder") == eu.UserId then
        Settings.Plot = plot
        return
      end
    end
  task.wait(1) end
end)

-- Functions
local function ExistsIn(brainrot, area)
  if ReplicatedStorage.Assets.Brainrots[area]:FindFirstChild(brainrot) then
    return true
  end
end

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house" }),
  Brainrots = Window:Tab({ Title = "Brainrots", Icon = "skull" })
}
Window:SelectTab(1)

-- Menu
do
  local base = Tabs.Menu:Section({ Title = "Base", Icon = "house-plus", Opened = true })
  
  local cooldown = 1.5
  base:Toggle({
    Title = "Auto Collect",
    Desc = "Automatically collects cash",
    Value = false,
    Callback = function(state)
      getgenv().AutoCollect = state
      
      while getgenv().AutoCollect do
        pcall(function()
          local r = eu.Character.HumanoidRootPart
          
          for _, slot in pairs(Settings.Plot.Slots:GetChildren()) do
            pcall(function()
              if slot.Upgrade.UpgradeGui.Enabled then
                local p = slot.Collect
                firetouchinterest(r, p, 0)
                firetouchinterest(r, p, 1)
              end
            end)
          end
        end)
      task.wait(cooldown) end
    end
  })
  base:Input({
    Title = "Collect Cooldown",
    Desc = "Cooldown to collect the cash",
    Value = tostring(cooldown),
    Placeholder = "In seconds, e.g.: 1.5",
    Callback = function(input)
      cooldown = tonumber(input) or 1
    end
  })
end

-- Brainrots
do
  local bsec = Tabs.Brainrots:Section({ Title = "Sniper", Icon = "crosshair", Opened = true })
  
  local selectedarea, blist = workspace.ActiveBrainrots.Common
  
  local function GetBrainrots()
    local names = {}
    for _, obj in pairs(selectedarea:GetChildren()) do
      local mutation = obj:GetAttribute("Mutation")
      local result = string.format("%s [ %s ]", obj:GetAttribute("BrainrotName"), mutation == "None" and "Common" or mutation)
      if not table.find(names, result) then
        table.insert(names, result)
      end
    end
    return names
  end
  
  local list = GetBrainrots()
  local selectedbrainrot = list[1]
  
  local function UpdateList()
    list = GetBrainrots()
    blist:Refresh(list)
    
    if not table.find(list, selectedbrainrot) then
      selectedbrainrot = list[1]
      blist:Select(list[1])
    end
  end
  
  bsec:Dropdown({
    Title = "Selected Area",
    Desc = "Selected area to scan brainrots",
    Values = (function()
      local zones = {}
      for _, zone in pairs(workspace.ActiveBrainrots:GetChildren()) do
        table.insert(zones, zone.Name)
      end
      return zones
    end)(),
    Value = selectedarea.Name,
    Callback = function(option)
      local area = workspace.ActiveBrainrots:FindFirstChild(option)
      if selectedarea == area then return end
      
      selectedarea = area
      UpdateList()
    end
  })

  bsec:Divider()
  
  blist = bsec:Dropdown({
    Title = "Available Brainrots",
    Desc = "Brainrots in the selected area",
    Values = list,
    Value = selectedbrainrot,
    Callback = function(option)
      selectedbrainrot = option
    end
  })
  bsec:Button({
    Title = "Update List",
    Desc = "Re-scans the brainrots",
    Icon = "scan-search",
    Callback = function()
      UpdateList()
    end
  })

  bsec:Divider()
  
  bsec:Button({
    Title = "Collect Brainrot",
    Desc = "Collects the selected brainrot",
    Icon = "truck",
    Callback = function()
      local brainrot = (function()
        local selectedname, selectedmutation = selectedbrainrot:match("^(.-)%s%["), selectedbrainrot:match("%[%s*(.-)%s*%]")
        selectedmutation = selectedmutation == "Common" and "None" or selectedmutation
        
        for _, brainrot in pairs(selectedarea:GetChildren()) do
          if brainrot:GetAttribute("Mutation") == selectedmutation and brainrot:GetAttribute("BrainrotName") == selectedname then
            return brainrot
          end
        end
      end)()
      if not brainrot then return end
      
      local r, p = eu.Character.HumanoidRootPart, brainrot.Root
      local backup = r.CFrame
      
      --[[
      r.CFrame = p.CFrame
      task.wait(0.3)
      fireproximityprompt(p.TakePrompt)
      r.CFrame = backup
      ]]--
      
      local TweenService = game:GetService("TweenService")
      
      local info = TweenInfo.new(1, Enum.EasingStyle.Linear)
      local newY = CFrame.new(backup.Position.X, -6, backup.Position.Z)
      
      local atolar = TweenService:Create(r, info, { CFrame = newY })
      atolar:Play()
      atolar.Completed:Wait()
      
      local targetPos = Vector3.new(p.Position.X, newY.Position.Y, p.Position.Z)
      local targetCFrame = (r.CFrame - r.CFrame.Position) + targetPos
      
      local distance = (r.Position - targetPos).Magnitude
      local duration = distance / 100
      
      local info2 = TweenInfo.new(duration, Enum.EasingStyle.Linear)
      local walkUnder = TweenService:Create(r, info2, { CFrame = targetCFrame })
      walkUnder:Play()
      walkUnder.Completed:Wait()
      
      r.CFrame = p.CFrame
      task.wait(0.3)
      fireproximityprompt(p.TakePrompt)
    end
  })
end