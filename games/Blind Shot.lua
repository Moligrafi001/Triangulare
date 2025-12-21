-- Global Values
getgenv().PlayerESP = false
getgenv().RayESP = false

-- Locals
local Players = game:GetService("Players")
local eu = Players.LocalPlayer

-- Functions
local function RayESP()
  while getgenv().RayESP and task.wait(0.1) do
    pcall(function()
      for _, p in pairs(Players:GetPlayers()) do
        if p ~= eu then
          local char = p.Character
          if char and char:FindFirstChild("Skin1") then
            local clone = char.Skin1:Clone()
            clone.Name = "Cloned"
            clone.Enabled = true
          end
        end
      end
    end)
  end
end
local function PlayerESP()
    local function SetESP(state)
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= eu then
                local char = p.Character
                if char then
                    local luz = char:FindFirstChild("Luz")
                    if state then
                        if luz then
                            if not luz.Enabled then
                                luz.Enabled = true
                            end
                        else
                            -- Cria a luz se não existir
                            luz = Instance.new("PointLight")
                            luz.Name = "Luz"
                            luz.Brightness = 2
                            luz.Range = 15
                            luz.Color = Color3.fromRGB(255, 0, 0) -- vermelho, por exemplo
                            luz.Parent = char:FindFirstChild("Head") or char.PrimaryPart
                        end
                    else
                        -- Desativa a luz se o ESP estiver desligado
                        if luz then
                            luz.Enabled = false
                        end
                    end
                end
            end
        end
    end

    while getgenv().PlayerESP do
        task.wait(1)
        pcall(function()
            SetESP(getgenv().PlayerESP)
        end)
    end

    -- Garante que todas as luzes sejam desligadas quando o ESP for desativado
    if not getgenv().PlayerESP then
        SetESP(false)
    end
end

--[[
9277195104/118614517739521
-- workspace.derekzero0.Skin1.ponto.Beam
while task.wait(0.1) do
for , p in pairs(game.Players:GetPlayers()) do
local char = p.Character
if char and char:FindFirstChild("Skin_1") and not char.Skin_1.ponto:FindFirstChild("Clone") then
local clone = char.Skin_1.ponto.Beam:Clone()
clone.Name = "Clone"
clone.Enabled = true
-- char.Skin_1.ponto.Beam.Enabled = true
end
end
end
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Toggle({
  Title = "Ray ESP",
  Value = false,
  Callback = function(state)
    getgenv().RayESP = state
    RayESP()
  end
})
Tabs.Menu:Toggle({
  Title = "Player ESP",
  Value = false,
  Callback = function(state)
    getgenv().PlayerESP = state
    PlayerESP()
  end
})