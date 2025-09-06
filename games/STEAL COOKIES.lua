-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

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
  for _, cookie in pairs(GetCookies()) do
    if (eu.Character.HumanoidRootPart.Position - cookie.WorldPivot.Position).Magnitude <= 10 then
      fireproximityprompt(cookie.CookiePrompt)
    end
  end
end
local function AutoCollect()
  while getgenv().AutoCollect and task.wait(0.1) do
    pcall(function()
      CollectCookies()
    end)
  end
end
local function CookieESP(boolean)
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
    CookieESP(state)
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