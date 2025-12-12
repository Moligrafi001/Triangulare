-- Globals
getgenv().Autocomplete = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Typing = false,
  Table = nil,
  Mode = "",
  Words = {
    Selected = "",
    OnlyX = false,
    Max = 9,
    -- Ignore List
    ToBlacklist = "",
    ToUnblacklist = "",
    Blacklist = { "horcrux", "seeland", "seelie", "grawlix", "erx", "erbitux", "erymax", "boxx", "isocortex", "isx", "amoureux", "itx", "yux", "yandex", "urbex", "urox", "endocervix", "noncomplex", "xxx", "ianthe", "iand", "atex", "endoclimax", "entonox", "wessex", "skybox", "opex", "icex", "gedex", "kendrix", "axx", "etx", "yax", "anex", "edx", "edex", "edax", "editrix", "edronax", "ygx", "ymx", "xanax", "xx", "xxxx", "xenix", "xfx", "xox", "xfx", "xilinx", "xanadu", "yunx", "acex", "selex", "upx", "sonex", "nexx", "checkbox", "xxix", "xp", "xiphias", "allex", "albiorix", "tickbox", "texmex", "textbox", "emex", "edix", "edomex", "edsx", "ningen", "xorn", "xoanon", "xenocide", "xor", "tedax", "anancastic", "lamoureaux", "onx", "lamoureux", "lamoreaux", "onix", "deass", "selinux", "rolodex", "isindex", "ispbx", "olx", "netflix", "umx", "gygax", "omex", "omnimax", "omnifax", "omx", "tantrix", "tanx", "tanapox", "yaldabaoth", "idn", "idnx", "idx", "xxxxx", "xn", "owerri", "xbone", "asx", "asterix", "astyanax", "sedex", "etox", "etex", "fluxbox", "fluxx", "urex", "lexx", "berklix", "malraux", "nerveux", "diaphox", "diamox", "orse", "orsk", "ickx" },
    Cache = {},
  },
  Keys = {
    ["a"] = eu.PlayerGui.Overbar.Frame.Keyboard["2"].A,
    ["done"] = eu.PlayerGui.Overbar.Frame.Keyboard.Done,
    ["delete"] = eu.PlayerGui.Overbar.Frame.Keyboard.Delete
  }
}

-- Functions
local function GetLetters()
  local mesa = Settings.Table

  if mesa and mesa:FindFirstChild(tostring(eu.UserId)) then
    return mesa.Billboard.Gui.Starting.Text
  end

  local id = eu:GetAttribute("InTable")
  mesa = id and workspace.Tables:FindFirstChild(tostring(id))
  if not mesa then return end

  Settings.Table, Settings.Mode = mesa, mesa:GetAttribute("Gamemode")
  return mesa.Billboard.Gui.Starting.Text
end
local function PressKey(key)
  local button = Settings.Keys[key:lower()]
  if button then
    return firesignal(button.MouseButton1Click)
  end
  
  for _, group in pairs(eu.PlayerGui.Overbar.Frame.Keyboard:GetChildren()) do
    local children = group:GetChildren()
    for _, k in pairs(children) do
      if k:IsA("TextButton") and not Settings.Keys[k.Name:lower()] then
        Settings.Keys[k.Name:lower()] = k
        if k.Name:lower() == key:lower() then
          firesignal(k.MouseButton1Click)
        end
      end
    end
  end
end
local function GetWords(letters, max)
  local MaxWords = max or Settings.Words.Max
  
  local words = {}
  local function AddToWords(data)
    for _, entry in ipairs(data) do
      local word = entry.word
      if word and not (word:find(" ") or word:find("-") or word:find("'")) and not (table.find(Settings.Words.Cache, word) or table.find(Settings.Words.Blacklist, word) or table.find(words, word)) then
        table.insert(words, word)
      end
      
      if #words >= MaxWords then return end
    end
  end
  local url = "https://api.datamuse.com/sug?s=" .. letters:lower() .. "*"
  
  if Settings.Words.OnlyX then
    local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(url .. "x", true))
    
    if #data > 0 then AddToWords(data) end
  end
  
  if #words < MaxWords then
    local data = game:GetService("HttpService"):JSONDecode(game:HttpGet(url, true))
    
    if #data > 0 then AddToWords(data) end
  end
  
  return words
end

-- Management
local function TypeWord(word, letras)
  if word:lower():sub(1, #letras) ~= letras:lower() then return end
  
  Settings.Typing = true
  local faltando = word:sub(#letras + 1)
  if Settings.Mode == "One By One" then
    PressKey(faltando:sub(1, 1))
  elseif Settings.Mode == "Last Letter" then
    for letra in faltando:gmatch(".") do
      PressKey(letra)
      task.wait(0.1)
    end
    
    table.insert(Settings.Words.Cache, word)
  end
  
  PressKey("done")
  Settings.Typing = false
end
local function AutoType(letters)
  if Settings.Typing then return end
  
  local letras = letters or GetLetters()
  if not letras then return end
  
  local WordsArray = GetWords(letras, 1)
  if not WordsArray then return end
  
  TypeWord(WordsArray[1], letras)
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
  Blacklist = Window:Tab({ Title = "Blacklist", Icon = "gavel"}),
  Cache = Window:Tab({ Title = "Cache", Icon = "database"}),
  Settings = Window:Tab({ Title = "Settings", Icon = "settings"}),
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Words" })
local words = Tabs.Menu:Dropdown({
  Title = "Selected Word",
  Values = {},
  Value = Settings.Words.Selected,
  Callback = function(option)
    Settings.Words.Selected = option
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
    
    TypeWord(Settings.Words.Selected, letras)
  end
})
Tabs.Menu:Button({
  Title = "Delete word",
  Desc = "Deletes the word you typed.",
  Callback = function()
    if Settings.Typing then return end
    
    local letras = GetLetters()
    if not letras then return end
    
    local button = Settings.Keys["delete"]
    for letra in letras:gmatch(".") do
      firesignal(button.MouseButton1Down)
      firesignal(button.MouseButton1Up)
    end
  end
})
Tabs.Menu:Section({ Title = "Beta" })
Tabs.Menu:Button({
  Title = "Complete Word",
  Desc = "Completes the word.",
  Callback = function()
    AutoType()
  end
})
--[[Tabs.Menu:Toggle({
  Title = "Autocomplete",
  Desc = "Automatically completes the word.",
  Value = false,
  Callback = function(state)
    getgenv().Autocomplete = state
    if not getgenv().Autocompleting then
      getgenv().Autocompleting = true
      local old
      old = hookfunction(print, function(...)
        if not getgenv().Autocomplete then return old(...) end
        
        local args = {...}
        local printed = args[1]
        
        if printed and printed == "Word:" then
          local word = args[2]
          if word then
            task.spawn(function()
              task.wait(1)
              AutoType(word)
            end)
          end
        end
      
        return old(...)
      end)
    end
  end
})--]]
Tabs.Menu:Button({
  Title = "Suggest word",
  Desc = "Suggests a word in the chat.",
  Callback = function()
    local letras = GetLetters()
    if not letras then return end
    
    local WordsArray = GetWords(letras, 1)
    if not WordsArray then return end
    
    game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync(WordsArray[1])
  end
})

-- Settings
Tabs.Settings:Section({ Title = "Words" })
Tabs.Settings:Input({
  Title = "Max words",
  Value = tostring(Settings.Words.Max),
  Placeholder = "Numbers only, ex.: 10",
  Callback = function(input)
    Settings.Words.Max = tonumber(input) or 1
  end
})
Tabs.Settings:Toggle({
  Title = "X only words",
  Desc = "Sugests most words that ends with X.",
  Value = false,
  Callback = function(state)
    Settings.Words.OnlyX = state
  end
})

-- Cache
Tabs.Cache:Section({ Title = "List" })
local cached = Tabs.Cache:Dropdown({
  Title = "Cached Words",
  Values = Settings.Words.Cache,
  Value = "",
  Callback = function(option)
    Settings.Words.ToBlacklist = option
  end
})
Tabs.Cache:Button({
  Title = "Refresh List",
  Desc = "Refreshs the list.",
  Callback = function()
    cached:Refresh(Settings.Words.Cache)
  end
})
Tabs.Cache:Section({ Title = "Action" })
Tabs.Cache:Button({
  Title = "Blacklist Word",
  Desc = "Blacklists the selected word.",
  Callback = function()
    if not table.find(Settings.Words.Blacklist, Settings.Words.ToBlacklist) then
      table.insert(Settings.Words.Blacklist, Settings.Words.ToBlacklist)
    end
  end
})
Tabs.Cache:Button({
  Title = "Clean cache",
  Desc = "Cleans the used words cache.",
  Callback = function()
    Settings.Words.Cache = {}
  end
})

-- Blacklist
Tabs.Blacklist:Section({ Title = "List" })
local blacklisted = Tabs.Blacklist:Dropdown({
  Title = "Blacklisted Words",
  Values = Settings.Words.Blacklist,
  Value = "",
  Callback = function(option)
    Settings.Words.ToUnblacklist = option
  end
})
Tabs.Blacklist:Button({
  Title = "Refresh List",
  Desc = "Refreshs the list.",
  Callback = function()
    blacklisted:Refresh(Settings.Words.Blacklist)
  end
})
Tabs.Blacklist:Section({ Title = "Action" })
Tabs.Blacklist:Button({
  Title = "Remove from List",
  Desc = "Removes the selected word from the list.",
  Callback = function()
    local i = table.find(Settings.Words.Blacklist, Settings.Words.ToUnblacklist)
    if i then
      table.remove(Settings.Words.Blacklist, i)
    end
  end
})