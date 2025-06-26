local function SetESP(instance, color, boolean)
  local luz = instance:FindFirstChild("Luz")
  if luz then
    luz.Enabled = boolean
  elseif boolean then
    local highlight = Instance.new("Highlight")
    highlight.Name = "Luz"
    highlight.FillTransparency = 1
    highlight.FillColor = color
    highlight.OutlineColor = color
    highlight.Adornee = instance
    highlight.Parent = instance
  end
end

local function MobsESP()
  if not workspace:FindFirstChild("Mobs") then
    warn("Mobs não encontrado!")
    return
  end

  while getgenv().MobsESP and task.wait(1) do
    pcall(function()
      for _, mob in pairs(workspace.Mobs:GetChildren()) do
        SetESP(mob, Color3.fromRGB(255, 125, 0), true)
      end
      if not workspace.Mobs:GetAttribute("Connected") then
        workspace.Mobs:SetAttribute("Connected", true)
        workspace.Mobs.ChildAdded:Connect(function(obj)
          if getgenv().MobsESP then
            SetESP(obj, Color3.fromRGB(255, 125, 0), true)
          end
        end)
      end
    end)
  end

  -- desligar ESP
  for _, mob in pairs(workspace.Mobs:GetChildren()) do
    SetESP(mob, Color3.new(), false)
  end
end

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Auto Farm", Icon = "house"})
}

Tabs.Menu:Toggle({
  Title = "ESP Mobs",
  Desc = "Highlight mobs.",
  Value = false,
  Callback = function(state)
    getgenv().MobsESP = state
    coroutine.wrap(MobsESP)()
  end
})