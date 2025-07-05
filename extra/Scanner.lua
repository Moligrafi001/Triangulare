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
  Explorer = Window:Tab({ Title = "Explorer", Icon = "house"})
}
Window:SelectTab(1)

--[[
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Spy-Mobile-Script-Restored-22732"))()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Keyless-mobile-dex-17888"))()
setclipboard("Game: " .. game.GameId .. " | Place: " .. game.PlaceId)
]]--

-- Remote
Tabs.Menu:Section({ Title = "Remote Events" })
Tabs.Menu:Button({
  Title = "Load SimpleSpy",
  Desc = "Executes simple spy.",
  Callback = function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Simple-Spy-Mobile-Script-Restored-22732"))()
  end
})