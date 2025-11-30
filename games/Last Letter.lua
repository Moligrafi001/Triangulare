-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Selected = ""
}

-- Functions
local function GetTable()
  for _, table in pairs(workspace.Tables:GetChildren()) do
    for _, user in pairs(table:GetChildren()) do
      if user:IsA("Model") and user.Name == tostring(eu.UserId) then
        return table
      end
    end
  end
end
local function GetLetters()
  local table = GetTable()
  if not table then return end
  local text = table.Billboard.Gui.Starting.Text
  
  return text
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
    local word = entry.word or ""
    if word and not table.find(words, word) then
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
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"})
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
  Title = "Type selected word",
  Desc = "Types the word you selected.",
  Callback = function()
    local letras = GetLetters()
    if not letras then return end
    
    local faltando = Settings.Selected:sub(#letras + 1)
    
    for letra in faltando:gmatch(".") do
      PressKey(letra)
      task.wait(0.1)
    end
    
    firesignal(eu.PlayerGui.Overbar.Frame.Keyboard.Done, MouseButton1Click)
  end
})