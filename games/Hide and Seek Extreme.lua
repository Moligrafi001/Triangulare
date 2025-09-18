-- Global Values
getgenv().AutoCollect = false
getgenv().AutoTouch = false
getgenv().CoinsESP = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Almost
local function GetCoins()
  local Coins = {}
  
  for _, coin in pairs(workspace.GameObjects:GetChildren()) do
    if coin:FindFirstChild("TouchInterest") and coin.Name == "Credit" then
      table.insert(Coins, coin)
    end
  end
  
  return Coins
end

-- Functions
local function CollectCoins()
  pcall(function()
    if eu.PlayerData.InGame.Value then
      for _, coin in pairs(GetCoins()) do
        pcall(function()
          firetouchinterest(eu.Character.HumanoidRootPart, coin, 0)
          firetouchinterest(eu.Character.HumanoidRootPart, coin, 1)
        end)
      end
    end
  end)
end
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(1) do
    CollectCoins()
  end
end
local function CoinsESP()
  local function SetESP(state)
    pcall(function()
      for _, coin in pairs(GetCoins()) do
        pcall(function()
          if coin:FindFirstChild("Highlight") then
            if coin.Highlight.Enabled ~= state then
              coin.Highlight.Enabled = state
            end
          elseif state then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.new(1, 0.5, 0)
            highlight.OutlineColor = Color3.new(1, 0.5, 0)
            highlight.FillTransparency = 0.7
            highlight.Adornee = coin
            highlight.Parent = coin
          end
        end)
      end
    end)
  end
  while getgenv().CoinsESP and task.wait(1) do
    SetESP(true)
  end
  if not getgenv().CoinsESP then SetESP(false) end
end
local function TouchAll()
  for _, p in pairs(game:GetService("Players"):GetPlayers()) do
    pcall(function()
      if eu.Character:GetAttribute("IsSeekerCharacter") and p.PlayerData.InGame.Value then
        firetouchinterest(eu.Character.HumanoidRootPart, p.Character.HumanoidRootPart, 0)
        firetouchinterest(eu.Character.HumanoidRootPart, p.Character.HumanoidRootPart, 1)
      end
    end)
  end
end
local function AutoTouch()
  while getgenv().AutoTouch and task.wait(1) do
    TouchAll()
  end
end

--[[
Game: 93740418 | Place: 205224386
IsSeekerCharacter
workspace.GameObjects:GetChildren()[6]:GetChildren()[5]
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Coins" })
Tabs.Menu:Toggle({
  Title = "Coins ESP",
  Desc = "Shows you all the coins.",
  Value = false,
  Callback = function(state)
    getgenv().CoinsESP = state
    CoinsESP()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Collect",
  Desc = "Collects all the coins.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Button({
  Title = "Collect All",
  Desc = "Collects all coins.",
  Callback = function()
    CollectCoins()
  end
})
Tabs.Menu:Section({ Title = "Seeker" })
Tabs.Menu:Toggle({
  Title = "Auto Touch",
  Desc = "Auto touchs everyone.",
  Value = false,
  Callback = function(state)
    getgenv().AutoTouch = state
    AutoTouch()
  end
})
Tabs.Menu:Button({
  Title = "Touch Everyone",
  Desc = "Touchs everyone in-game.",
  Callback = function()
    TouchAll()
  end
})