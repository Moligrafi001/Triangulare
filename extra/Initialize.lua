local Luache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Luache/main/Source/Library.lua"))()
Luache:Settings({
  Service = "triangulare",
  DebugMode = true
})

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI.Services.Luache = {
  Name = "Luache",
  Icon = "shield",
  Args = {"API"},
  New = function(API)
    function validateKey(key)
      if not key then return false, "Key is missing!" end
      
      local result = Luache:Check(key)
      if not result then return false, "Invalid key!" end
      
      return true, "Amazing key!"
    end
    
    function copyLink()
      return setclipboard(Luache:GetKey())
    end
    
    return {
      Verify = validateKey,
      Copy = copyLink,
    }
  end
}

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

  KeySystem = {
    Note = "Insert your key, or get one.",
    SaveKey = true,
    API = {
      {
        Type = "Luache",
        API = "dunno"
      }
    }
  }
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
    Duration = 7
  })
end