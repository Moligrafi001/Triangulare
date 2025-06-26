-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Management Functions
local function SetESP(instance, color, boolean)
  if instance:FindFirstChild("Luz") then
    if instance.Luz.Enabled ~= boolean then
      instance.Luz.Enabled = boolean
    end
  else
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.Adornee, highlight.Parent = instance, instance
    highlight.Name = "Luz"
    highlight.FillColor, highlight.OutlineColor = color, color
  end
end

-- Control Functions
local function MobsESP()
  while getgenv().MobsESP and task.wait(1) do
    pcall(function()
      for _, mob in pairs(workspace.Mobs:GetChildren()) do
        SetESP(mob, Color3.FromRGB(255, 125, 0), true)
      end
      if not workspace.Mobs:GetAttribute("Connected") then
        workspace.Mobs:SetAttribute("Connected", true)
        workspace.Mobs.ChildAdded:Connect(function(obj)
          if getgenv().MobsESP then
            SetESP(obj, Color3.FromRGB(255, 125, 0), true)
          end
        end)
      end
    end)
  end
  if not getgenv().MobsESP then
    for _, mob in pairs(workspace.Mobs:GetChildren()) do
      SetESP(mob, 0, false)
    end
  end
end

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "ESP Mobs",
  Desc = "Highlight mobs.",
  Value = false,
  Callback = function(state)
    getgenv().MobsESP = state
    MobsESP()
  end
})