-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Selected = "",
  Typing = false,
  MaxWords = 9,
  Cache = {},
  Table = nil,
  Mode = ""
}

-- Functions
local function GetLetters()
  local mesa = Settings.Table
  if mesa and mesa:FindFirstChild(tostring(eu.UserId)) then
    return mesa.Billboard.Gui.Starting.Text
  end
  
  for _, table in pairs(workspace.Tables:GetChildren()) do
    for _, user in pairs(table:GetChildren()) do
      if user:IsA("Model") and user.Name == tostring(eu.UserId) then
        Settings.Table = table
        Settings.Mode = table:GetAttribute("Gamemode")
        return table.Billboard.Gui.Starting.Text
      end
    end
  end
end
local function PressKey(key)
  for _, group in pairs(eu.PlayerGui.Overbar.Frame.Keyboard:GetChildren()) do
    local children = group:GetChildren()
    if #children >= 3 then
      for _, k in pairs(children) do
        if k:IsA("TextButton") and k.Name:lower() == key:lower() then
          return firesignal(k.MouseButton1Click)
        end
      end
    end
  end
end
local function GetWords(letters)
  local url = "https://api.datamuse.com/words?sp=" .. letters .. "*"
  local response = game:HttpGet(url, true)
  local data = game:GetService("HttpService"):JSONDecode(response)
  
  local words = {}
  for i, entry in ipairs(data) do
    if #words >= Settings.MaxWords then return words end
    
    local word = entry.word or ""
    if word and not word:find(" ") and not word:find("-") and not table.find(words, word) and not table.find(Settings.Cache, word) then
      table.insert(words, word)
    end
  end
  
  return words
end

--[[
https://api.datamuse.com/words?sp=es*
workspace.Tables["2"].Billboard.Gui.Starting
workspace.Tables["8"] Gamemode == "One By One"" or "Last Letter"
workspace.Tables["2"]["9233473564"]
local img = game:GetService("Players").LocalPlayer.PlayerGui.Overbar.Frame.Keyboard["2"].A
game:GetService("Players").LocalPlayer.PlayerGui.Overbar.Frame.Keyboard.Delete
game:GetService("Players").LocalPlayer.PlayerGui.Overbar.Frame.Keyboard.Done
firesignal(img.MouseButton1Click)
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Type", Icon = "keyboard"}),
  Settings = Window:Tab({ Title = "Settings", Icon = "settings"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Words" })
local words = Tabs.Menu:Dropdown({
  Title = "Selected Word",
  Values = {},
  Value = Settings.Selected,
  Callback = function(option)
    Settings.Selected = option
  end
})
Tabs.Menu:Button({
  Title = "Refresh List",
  Desc = "Refreshs the list.",
  Callback = function()
    local letras = GetLetters()
    if not letras then return end
    
    words:Refresh(GetWords(letras))
  end
})
Tabs.Menu:Section({ Title = "Type" })
Tabs.Menu:Button({
  Title = "Type word",
  Desc = "Types the word you selected.",
  Callback = function()
    if Settings.Typing then return end
    
    local letras = GetLetters()
    if not letras then return end
    
    if Settings.Selected:lower():sub(1, #letras) ~= letras:lower() then return end
    
    
    Settings.Typing = true
    local faltando = Settings.Selected:sub(#letras + 1)
    if Settings.Mode == "One By One" then
      PressKey(faltando:sub(1, 1))
    elseif Settings.Mode == "Last Letter" then
      for letra in faltando:gmatch(".") do
        PressKey(letra)
        task.wait(0.1)
      end
      
      table.insert(Settings.Cache, Settings.Selected)
    end
    
    firesignal(eu.PlayerGui.Overbar.Frame.Keyboard.Done.MouseButton1Click)
    Settings.Typing = false
  end
})
Tabs.Menu:Button({
  Title = "Delete word",
  Desc = "Deletes the word you typed.",
  Callback = function()
    if Settings.Typing then return end
    
    local letras = GetLetters()
    if not letras then return end
    
    for letra in letras:gmatch(".") do
      firesignal(eu.PlayerGui.Overbar.Frame.Keyboard.Delete.MouseButton1Click)
      task.wait(1)
    end
  end
})

-- Settings
Tabs.Settings:Section({ Title = "Words" })
Tabs.Settings:Input({
  Title = "Max words",
  Value = tostring(Settings.MaxWords),
  Placeholder = "Numbers only, ex.: 10",
  Callback = function(input)
    Settings.MaxWords = tonumber(input) or 1
  end
})
Tabs.Settings:Section({ Title = "Cache" })
local cached = Tabs.Settings:Dropdown({
  Title = "Cached Words",
  Values = Settings.Cache,
  Value = "",
  Callback = function(option) end
})
Tabs.Settings:Button({
  Title = "Refresh List",
  Desc = "Refreshs the list.",
  Callback = function()
    cached:Refresh(Settings.Cache)
  end
})
Tabs.Settings:Button({
  Title = "Clean cache",
  Desc = "Cleans the used words cache.",
  Callback = function()
    Settings.Cache = {}
  end
})