local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
  Title = "Triangulare Game Scanner",
  Icon = "triangle",
  Author = "by Moligrafi",
  Folder = "Triangulare",
  Size = UDim2.fromOffset(580, 400),
  Transparent = true,
  Theme = "Dark",
  User = {
    Enabled = true
  },
  SideBarWidth = 200,
  HasOutline = true,

  -- KeySystem = {
  --   Key = { "iloveyouMoligrafi" },
  --   Note = "Join our Discord to get the key and unlock the script:",
  --   URL = "https://discord.gg/9Nmhn8JKjA",
  --   SaveKey = true,
  -- },
})
Window:EditOpenButton({
  Title = "Triangulare Scanner",
  Icon = "triangle",
  CornerRadius = UDim.new(0,16),
  StrokeThickness = 2,
  Color = ColorSequence.new(Color3.fromRGB(0, 255, 120), Color3.fromRGB(0, 120, 255)),
  Draggable = true
})
Window:SetToggleKey(Enum.KeyCode.H)

-- Tabs
local Tabs = {
  Remote = Window:Tab({ Title = "Remotes", Icon = "house"}),
  Explorer = Window:Tab({ Title = "Explorer", Icon = "house"}),
  Game = Window:Tab({ Title = "Game", Icon = "house"}),
  Script = Window:Tab({ Title = "Script", Icon = "house"}),
}
Window:SelectTab(1)

--[[
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Spy-Mobile-Script-Restored-22732"))()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Keyless-mobile-dex-17888"))()
loadstring(game:HttpGet("https://gist.githubusercontent.com/dannythehacker/1781582ab545302f2b34afc4ec53e811/raw/ee5324771f017073fc30e640323ac2a9b3bfc550/dark%2520dex%2520v4"))()
setclipboard("Game: " .. game.GameId .. " | Place: " .. game.PlaceId)
]]--

-- Remote
Tabs.Remote:Section({ Title = "Remote Events" })
Tabs.Remote:Button({
  Title = "Load Simple Spy",
  Desc = "Executes simple spy.",
  Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Spy-Mobile-Script-Restored-22732"))()
  end
})

-- Explorer
Tabs.Explorer:Section({ Title = "Mobile" })
Tabs.Explorer:Button({
  Title = "Load DEX [ Mobile ]",
  Desc = "Executes dex explorer.",
  Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Keyless-mobile-dex-17888"))()
  end
})
Tabs.Explorer:Section({ Title = "Desktop" })
Tabs.Explorer:Button({
  Title = "Load DEX [ Desktop ]",
  Desc = "Executes dex explorer.",
  Callback = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/dannythehacker/1781582ab545302f2b34afc4ec53e811/raw/ee5324771f017073fc30e640323ac2a9b3bfc550/dark%2520dex%2520v4"))()
  end
})

-- Game
Tabs.Game:Section({ Title = "IDs" })
Tabs.Game:Button({
  Title = "Copy Game & Place ID",
  Desc = "Set game & place id to ur clipboard.",
  Callback = function()
    setclipboard("Game: " .. game.GameId .. " | Place: " .. game.PlaceId)
  end
})