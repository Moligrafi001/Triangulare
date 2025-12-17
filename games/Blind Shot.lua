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