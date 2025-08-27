-- Locals
local eu = game:game:GetService("Players").LocalPlayer

-- Almost
local function GetClassOf(class)
  local Objects = {}
  for _, p in pairs(game:GetService("Players"):GetPlayers()) do
    pcall(function()
      if p ~= eu and p:GetAttribute("Game") == eu:GetAttribute("Game") then
        if class == "Enemies" and p:GetAttribute("Team") ~= eu:GetAttribute("Team") then
          table.insert(Objects, p)
        elseif class == "Allies" and p:GetAttribute("Team") == eu:GetAttribute("Team") then
          table.insert(Objects, p)
        end
      end
    end)
  end
  return Objects
end
local function ReturnItem(class)
  for _, item in pairs(eu.Backpack:GetChildren()) do
    if item:IsA("Tool") then
      if class == "Gun" and item:FindFirstChild("fire") and item:FindFirstChild("showBeam") and item:FindFirstChild("kill") then
        return item
      elseif class == "Knife" and item:FindFirstChild("Slash") then
        return item
      end
    end
  end
  for _, item in pairs(eu.Character:GetChildren()) do
    if item:IsA("Tool") then
      if class == "Gun" and item:FindFirstChild("fire") and item:FindFirstChild("showBeam") and item:FindFirstChild("kill") then
        return item
      elseif class == "Knife" and item:FindFirstChild("Slash") then
        return item
      end
    end
  end
  return false
end

local function KillKnife()
  for _, enemy in pairs(GetClassOf("Enemies")) do
    local Knife = ReturnItem("Knife")
    if Knife and Knife.Parent == eu.Character and enemy.Character then
      repeat
        enemy.Character.HumanoidRootPart.CFrame == eu.Character.HumanoidRootPart.CFrame
        Knife.Slash:FireServer()
        task.wait(0.09)
      until not Knife or Knife.Parent ~= eu.Character or not enemy.Character
    end
  end
end

--

local Settings = {}
local eu = game:GetService("Players").LocalPlayer

-- Load
task.spawn(function()
	task.wait()	
end)

--

local Gokka = {}
local Settings = {
}

-- Load
task.spawn(function()
    if getgenv().Gokka then
    end
end)

-- Management
local function AdmMsg(type, msg)
  if type == 1 then
    print("[ Gokka ] - " .. tostring(msg))
  elseif type == 2 then
    warn("[ Gokka ] - " .. tostring(msg))
  elseif type == 3 then
    error("[ Gokka ] - " .. tostring(msg))
  elseif type == 9 then
    if msg == 1 then
      print(".*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.")
    elseif msg == 2 then
      warn(".*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.")
    elseif msg == 3 then
      error(".*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.*.")
    end
  end
end

-- Functions
function Gokka:Start(table)
    if table then
        AdmMsg(1, "System started successfully, wait...")
    else
        AdmMsg(3, "Missing the start table.")
    end
end

function 

return Gokka
