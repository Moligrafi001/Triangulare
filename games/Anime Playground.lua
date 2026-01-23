-- Global Values
getgenv().HitAura = false
getgenv().DestAura = false

-- Locals
local ReplicatedStorage, Players = game:GetService("ReplicatedStorage"), game:GetService("Players")
local eu = Players.LocalPlayer

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house" })
}
Window:SelectTab(1)

-- Hit Aura
local hitaura = Tabs.Menu:Section({ Title = "Hit Aura", Icon = "hand-fist", Opened = true })

local hitrange, whitelisteds = 30, {}

hitaura:Toggle({
  Title = "Hit Aura",
  Desc = "Hits everyone in the selected range",
  Callback = function(state)
    getgenv().HitAura = state
    
    local function GetNearby()
      local Detected = {}
      
      for _, enemy in pairs(workspace:GetPartBoundsInBox(eu.Character.HumanoidRootPart.CFrame, Vector3.new(hitrange, hitrange, hitrange), nil)) do
        local model = enemy:FindFirstAncestorWhichIsA("Model")
        if model and model:FindFirstChild("Humanoid") and model ~= eu.Character and not table.find(whitelisteds, model.Name) then
          table.insert(Detected, model)
        end
      end
      
      return Detected
    end
    while getgenv().HitAura do
      pcall(function()
        for _, enemy in pairs(GetNearby()) do
          pcall(function()
            ReplicatedStorage.Library.Network.SendData:FireServer("PunchHitEnemy_RE", enemy)
          end)
        end
      end)
    task.wait(0.05) end
  end
})
hitaura:Slider({
  Title = "Aura Range",
  Desc = "Max range to hit",
  Step = 1,
  Value = {
    Min = 5,
    Max = 30,
    Default = hitrange
  },
  Callback = function(value)
    hitrange = value
  end
})

hitaura:Divider()

hitaura:Toggle({
  Title = "Destructive Aura",
  Desc = "Breaks things around you",
  Callback = function(state)
    getgenv().DestAura = state
    
    while getgenv().DestAura do
      pcall(function()
        ReplicatedStorage.Library.Network.SendData:FireServer("PunchCasted_RE")
      end)
    task.wait(0.1) end
  end
})

Tabs.Menu:Divider()

-- Whitelist
local whitelist = Tabs.Menu:Section({ Title = "Whitelist", Icon = "contact", Opened = true })

local selectedplayer = "Select a Player"

local cuzinho = whitelist:Dropdown({
  Title = "Whitelisteds",
  Desc = "List of whitelist players",
  Values = whitelisteds,
  Value = "Select a Player",
  Callback = function(option)
    if option == "Select a Player" then return end
    selectedplayer = option:match("%[%s*(.-)%s*%]")
  end
})
whitelist:Button({
  Title = "Blacklist Player",
  Desc = "Removes the selected player from the whitelist",
  Icon = "gavel",
  Callback = function()
    table.remove(whitelisteds, table.find(whitelisteds, selectedplayer))
    cuzinho:Refresh(whitelisteds)
  end
})

whitelist:Divider()

local plist, towhite

local ptable = {}
local function GetPlayers()
  local players = {}
  for _, p in pairs(Players:GetPlayers()) do
    if p ~= eu then
      table.insert(players, string.format("%s [ %s ]", p.DisplayName, p.Name))
    end
  end
  return players
end

plist = whitelist:Dropdown({
  Title = "Active Players",
  Desc = "List of players",
  Values = GetPlayers(),
  Value = "Select a Player",
  Callback = function(option)
    if option == "Select a Player" then return end
    towhite = option:match("%[%s*(.-)%s*%]")
  end
})
whitelist:Button({
  Title = "Whitelist Player",
  Icon = "smile-plus",
  Callback = function()
    if table.find(whitelisteds, towhite) then return end
    table.insert(whitelisteds, towhite)
    cuzinho:Refresh(whitelisteds)
  end
})

task.spawn(function()
  while task.wait(10) do
    local newlist = GetPlayers()
    if ptable ~= newlist then
      ptable = newlist
      plist:Refresh(GetPlayers())
    end
  end
end)