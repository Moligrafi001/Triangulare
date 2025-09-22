local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Window = WindUI:CreateWindow({
  Title = "Triangulare | " .. InitializeName,
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
  Title = "Triangulare",
  Draggable = true
})

-- Toggle Key
Window:SetToggleKey(Enum.KeyCode.H)
if game:GetService("UserInputService").KeyboardEnabled then
  WindUI:Notify({
    Title = "We detected your keyboard!",
    Content = "Use the 'H' key to toggle the window visibility.",
    Icon = "keyboard",
    Duration = 5
  })
end