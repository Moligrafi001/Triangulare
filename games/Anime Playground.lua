-- Global Values
getgenv().HitAura = false

-- Locals
local Players = game:GetService("Players")
local eu = Players.LocalPlayer

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house" })
}
Window:SelectTab(1)

-- Hit Aura
local hitaura = Tabs.Menu:Section({ Title = "Hit Aura", Icon = "hand-fist", Opened = true })

local hitrange, whitelisteds = 40, {}

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
            game:GetService("ReplicatedStorage").Library.Network.SendData:FireServer("PunchHitEnemy_RE", enemy)
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
    Min = 1,
    Max = 20,
    Default = hitrange / 2
  },
  Callback = function(value)
    hitrange = value * 2
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
  Title = "Refresh List",
  Icon = "refresh-ccw",
  Callback = function()
    cuzinho:Refresh(whitelisteds)
  end
})

whitelist:Button({
  Title = "Blacklist Player",
  Desc = "Removes the selected player from the whitelist",
  Icon = "gavel",
  Callback = function()
    table.remove(whitelisteds, table.find(whitelisteds, selectedplayer))
  end
})

whitelist:Divider()

local plist, towhite

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
  Title = "Refresh List",
  Icon = "refresh-ccw",
  Callback = function()
    plist:Refresh(GetPlayers())
  end
})
whitelist:Button({
  Title = "Whitelist Player",
  Icon = "smile-plus",
  Callback = function()
    table.insert(whitelisteds, towhite)
  end
})