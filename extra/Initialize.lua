local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI.Services.Luache = {
  Name = "Luache",
  Icon = "shield",
  Args = { "Service", "DebugMode" },
  New = function(Service, DebugMode)
    local Luache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Luache/main/Source/Library.lua"))()
    Luache:Settings({
      Service = Service,
      DebugMode = DebugMode or false
      
      KeySystem = {
        HWIDs = { "9e3065db04157b8dd181680ac86b4694e024093b4828b6e9059b280d06becdec" }
      }
    })
  
    return {
      Verify = function(key)
        local boolean, message = Luache:Check(key)
        return boolean, message
      end,
      Copy = function()
        return setclipboard(Luache:GetKey())
      end,
    }
  end
}

local Window = WindUI:CreateWindow({
  Title = "Triangulare | " .. (InitializeName or "Undefined"),
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
        Service = "triangulare",
        DebugMode = false,
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