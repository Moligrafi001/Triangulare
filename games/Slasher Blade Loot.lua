-- workspace.Live.MobModel["ad1af47c-c97a-4c88-a26e-aa3921651301"]
while task.wait(0.1) do
local Mobs = {}
for _, mob in pairs(workspace.Live.MobModel:GetChildren()) do
if mob:GetAttribute("Id") then
table.insert(Mobs, mob.Name)
end
end
game:GetService("ReplicatedStorage").Remote.Event.Combat.M1:FireServer(Mobs)
end
Game: 8796373417 | Place: 99827026339186