-- Global Values
getgenv().AutoCollect = false
getgenv().CookieESP = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Busy = false
}

-- Almost
local function GetCookies()
  local Cookies = {}
  
  for _, cookie in pairs(workspace.Map.Functional.SpawnedItems:GetChildren()) do
    if cookie:IsA("Model") and cookie:FindFirstChild("CookiePrompt") then
      table.insert(Cookies, cookie)
    end
  end
  
  return Cookies
end

-- Functions
local function CollectCookies()
  local CookiesList = GetCookies()
  if Settings.Busy then
    return WindUI:Notify({
      Title = "Wait! I'm Busy",
      Content = "I'm colleting, wait...",
      Icon = "x",
      Duration = 5
    })
  elseif #GetCookiest == 0 then
    return WindUI:Notify({
      Title = "No more cookies.",
      Content = "Already collected everything.",
      Icon = "x",
      Duration = 5
    })
  else
    WindUI:Notify({
      Title = "Collecting cookies.",
      Content = "Wait... Almost done.",
      Icon = "hourglass",
      Duration = 5
    })
  end
  Settings.Busy = true
  eu:SetAttribute("Triangulare", eu.Character.HumanoidRootPart.CFrame)
  for _, cookie in pairs(CookiesList) do
    eu.Character.HumanoidRootPart.CFrame = CFrame.new(cookie.WorldPivot.Position)
    task.wait(0.1)
    fireproximityprompt(cookie.CookiePrompt)
  end
  eu.Character.HumanoidRootPart.CFrame = eu:GetAttribute("Triangulare")
  WindUI:Notify({
    Title = "Perfect! Done!",
    Content = "Collected all cookies!",
    Icon = "check",
    Duration = 5
  })
  Settings.Busy = false
end
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(0.1) do
    pcall(function()
      for _, cookie in pairs(GetCookies()) do
        if (eu.Character.HumanoidRootPart.Position - cookie.WorldPivot.Position).Magnitude <= 10 then
          fireproximityprompt(cookie.CookiePrompt)
        end
      end
    end)
  end
end
local function CookieESP()
  local function SetESP(state)
    for _, cookie in pairs(GetCookies()) do
      if cookie:FindFirstChild("Highlight") then
        if cookie.Highlight.Enabled ~= boolean then
          cookie.Highlight.Enabled = boolean
        end
      elseif boolean then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.new(1, 0.5, 0)
        highlight.OutlineColor = Color3.new(1, 0.5, 0)
        highlight.FillTransparency = 0.7
        highlight.Adornee = cookie
        highlight.Parent = cookie
      end
    end
  end
  while getgenv().CookieESP and task.wait(1) do
    SetESP(true)
  end
  if not getgenv().CookieESP then SetESP(false) end
end

--[[
workspace.Map.Functional.SpawnedItems:GetChildren()[23].ObjectClickDetector
workspace.Map.Functional.SpawnedItems:GetChildren()[3].CookiePrompt
Game: 8374113155 | Place: 133719960214587
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Cookies ESP",
  Desc = "Shows you all the cookies.",
  Value = false,
  Callback = function(state)
    getgenv().CookieESP = state
    CookieESP()
  end
})
Tabs.Menu:Toggle({
  Title = "Auto Collect",
  Desc = "Collects all the nearby cookies.",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state
    AutoCollect()
  end
})
Tabs.Menu:Section({ Title = "Blatant" })
Tabs.Menu:Button({
  Title = "Collect All",
  Desc = "Collects all cookies.",
  Callback = function()
    CollectCookies()
  end
})