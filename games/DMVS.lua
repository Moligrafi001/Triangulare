-- Global Values
getgenv().AutoGun = false
getgenv().PullGun = false
getgenv().AutoKnife = false
getgenv().HitBox = false
getgenv().PlayerESP = false
getgenv().GunSound = false
getgenv().Triggerbot = false
getgenv().AutoSlash = false
getgenv().EquipKnife = false
getgenv().AutoTPe = false
getgenv().AutoBuy = false

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Settings = {
  Ignore = {"Moligrafi", "VladmirNine"},
  Triggerbot = {
    Cooldown = 3,
    Waiting = false
  },
  Teleport = {
    Mode = "Everytime",
    CFrame = CFrame.new(-337, 76, 19)
  },
  Slash = {
    Cooldown = 0.5
  },
  Boxes = {
    Selected = "Knife Box #1",
    Price = 500
  },
  SpamSoundCooldown = 0.2,
}
local HitSize = 5
local CorInocente = Color3.new(1, 0.5, 0)

-- Almost
local function GetClassOf(class)
  local Objects = { Allies = {}, Enemies = {} }
  for _, p in pairs(game:GetService("Players"):GetPlayers()) do
    if p ~= eu and p:GetAttribute("Game") == eu:GetAttribute("Game") then
      if (class == "Enemies" or class == "Everyone") and p:GetAttribute("Team") ~= eu:GetAttribute("Team") and not table.find(Settings.Ignore, p.Name) then
        table.insert(Objects.Enemies, p)
      elseif (class == "Allies" or class == "Everyone") and p:GetAttribute("Team") == eu:GetAttribute("Team") then
        table.insert(Objects.Allies, p)
      end
    end
  end
  if class == "Everyone" then
    return Objects
  elseif class == "Allies" then
    return Objects.Allies
  elseif class == "Enemies" then
    return Objects.Enemies
  end
end
local function ReturnItem(class, where)
  local function CheckedClass(item)
    if item:IsA("Tool") then
      if class == "Gun" and item:FindFirstChild("fire") and item:FindFirstChild("showBeam") and item:FindFirstChild("kill") then
        return item
      elseif class == "Knife" and item:FindFirstChild("Slash") then
        return item
      end
    end
    return false
  end
  if where then
    for _, item in pairs(eu[where]:GetChildren()) do
      local checked = CheckedClass(item)
      if checked then return checked end
    end
  else
    for _, item in pairs(eu.Backpack:GetChildren()) do
      local checked = CheckedClass(item)
      if checked then return checked end
    end
    for _, item in pairs(eu.Character:GetChildren()) do
      local checked = CheckedClass(item)
      if checked then return checked end
    end
  end
  return false
end

-- Functions
local function EquipKnife()
  while getgenv().EquipKnife and task.wait(0.25) do
    pcall(function()
      local Knife = ReturnItem("Knife", "Backpack")
      if Knife then Knife.Parent = eu.Character end
    end)
  end
end
local function KillGun()
  pcall(function()
    local Gun = ReturnItem("Gun", "Character")
    for _, enemy in pairs(GetClassOf("Enemies")) do
      pcall(function()
        if Gun and enemy.Character then
          repeat
            Gun.kill:FireServer(enemy, Vector3.new(enemy.Character.Head.Position))
            task.wait(0.1)
          until not Gun or Gun.Parent ~= eu.Character or not enemy.Character
        end
      end)
    end
  end)
end
local function KillKnife()
  for _, enemy in pairs(GetClassOf("Enemies")) do
    if eu.Character then
      game:GetService("ReplicatedStorage").KnifeKill:FireServer(enemy, enemy)
    end
  end
end
local function AutoGun()
  while getgenv().AutoGun and task.wait(1) do
    KillGun()
  end
end
local function AutoKnife()
  while getgenv().AutoKnife and task.wait(0.1) do
    KillKnife()
  end
end
local function PullGun()
  while getgenv().PullGun and task.wait(0.25) do
    pcall(function()
      local Gun = ReturnItem("Gun", "Backpack")
      if Gun then Gun.Parent = eu.Character end
    end)
  end
end
local function HitBox()
	while getgenv().HitBox and wait() do
	  pcall(function()
		for _, player in pairs(game.Players:GetPlayers()) do
			if player ~= eu and player:GetAttribute("Game") == eu:GetAttribute("Game") and player:GetAttribute("Team") ~= eu:GetAttribute("Team") then
				if player.Character then
					if player.Character:FindFirstChild("HumanoidRootPart") then
						if player.Character.HumanoidRootPart.Size ~= Vector3.new(HitSize, HitSize, HitSize) or player.Character.HumanoidRootPart.Transparency ~= 0.6 then
							player.Character.HumanoidRootPart.Size = Vector3.new(HitSize, HitSize, HitSize)
							player.Character.HumanoidRootPart.Transparency = 0.6
							player.Character.HumanoidRootPart.CanCollide = false
						end
					end
				end
			end
		end
	  end)
	end
	if not getgenv().HitBox then
		for _, player in pairs(game.Players:GetPlayers()) do
			if player ~= game.Players.LocalPlayer then
				if player.Character and game.Players.LocalPlayer.Character then
					if player.Character:FindFirstChild("HumanoidRootPart") then
						if player.Character.HumanoidRootPart.Size ~= Vector3.new(2, 2, 1) or player.Character.HumanoidRootPart.Transparency ~= 0 then
							player.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
							player.Character.HumanoidRootPart.Transparency = 0
						end
					end
				end
			end
		end
	end
end
local function PlayerESP()
	while getgenv().PlayerESP and wait(0.33) do
	  pcall(function()
    	for _, players in pairs(GetClassOf("Enemies")) do
    		local player = players.Character
    		if player and player.Parent then
    			if player:FindFirstChild("Highlight") then
    				if not player.Highlight.Enabled then
    					player.Highlight.Enabled = true
    				end
    				if player.Highlight.FillColor ~= CorInocente or player.Highlight.OutlineColor ~= CorInocente then
    				  player.Highlight.FillColor = CorInocente
    				  player.Highlight.OutlineColor = CorInocente
    				end
    			else
    				local highlight = Instance.new("Highlight")
    				highlight.FillColor = CorInocente
    				highlight.OutlineColor = CorInocente
    				highlight.FillTransparency = 0.6
    				highlight.Adornee = player
    				highlight.Parent = player
    			end
    		end
    	end
		end)
	end
	if not getgenv().PlayerESP then
		for _, players in pairs(GetClassOf("Enemies")) do
			local player = players.Character
			if player and player:FindFirstChild("Highlight") then
				if player.Highlight.Enabled then
					player.Highlight.Enabled = false
				end
			end
		end
	end
end
local function GunSound()
  while getgenv().GunSound and task.wait(Settings.SpamSoundCooldown) do
    pcall(function()
      local Gun = ReturnItem("Gun", "Character")
      if Gun then Gun.fire:FireServer() end
    end)
  end
end
local function Triggerbot()
  local function GetAlliesChar(allies)
    local Allies = {}
    for _, ally in pairs(allies) do
      if ally.Character then
        table.insert(Allies, ally.Character)
      end
    end
    return Allies
  end
  local Triggerbot = Settings.Triggerbot
  while getgenv().Triggerbot and task.wait(0.01) do
    pcall(function()
      local Gun = ReturnItem("Gun", "Character")
      if Gun and workspace.CurrentCamera then
        local Teams = GetClassOf("Everyone")
        for _, enemy in pairs(Teams.Enemies) do
          local char = enemy.Character
          local root = char and char:FindFirstChild("HumanoidRootPart")
          if root then
            local GunPos = Gun.Handle.Position
            local CamPos = workspace.CurrentCamera.CFrame.Position
            local rayParams = RaycastParams.new()
            rayParams.FilterDescendantsInstances = {eu.Character, unpack(GetAlliesChar(Teams.Allies))}
            rayParams.FilterType = Enum.RaycastFilterType.Blacklist
            local camResult = workspace:Raycast(CamPos, root.Position - CamPos, rayParams)
            local hitResult = workspace:Raycast(GunPos, root.Position - GunPos, rayParams)
            if not Triggerbot.Waiting and camResult and camResult.Instance:IsDescendantOf(char) and hitResult and hitResult.Instance:IsDescendantOf(char) then
              Gun.fire:FireServer()
              Gun.showBeam:FireServer(hitResult.Position, GunPos, Gun.Handle)
              Gun.kill:FireServer(enemy, Vector3.new(hitResult.Position))
              Triggerbot.Waiting = true
              task.delay(Triggerbot.Cooldown, function()
                Triggerbot.Waiting = false
              end)
            end
          end
        end
      end
    end)
  end
end
local function AutoSlash()
  while getgenv().AutoSlash and task.wait(Settings.Slash.Cooldown) do
    pcall(function()
      local Knife = ReturnItem("Knife", "Character")
      if Knife then Knife.Slash:FireServer() end
    end)
  end
end
local function GetTP()
  pcall(function()
    local mouse = eu:GetMouse()
    local tool = Instance.new("Tool")
    tool.RequiresHandle = false
    tool.Name = "Teleport Tool"
    tool.ToolTip = "Equip and click somewhere to teleport - Triangulare"
    -- tool.TextureId = "rbxassetid://17091459839"
    
    tool.Activated:Connect(function()
      local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
      eu.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end)
    
    tool.Parent = eu.Backpack
  end)
end
local function DelTP()
  pcall(function()
    for _, tool in pairs(eu.Character:GetChildren()) do
      if tool:IsA("Tool") and tool.Name == "Teleport Tool" then
        tool:Destroy()
      end
    end
    for _, tool in pairs(eu.Backpack:GetChildren()) do
      if tool:IsA("Tool") and tool.Name == "Teleport Tool" then
        tool:Destroy()
      end
    end
  end)
end
local function AutoTPe()
  while getgenv().AutoTPe and task.wait() do
    pcall(function()
      local function ToolsLoaded()
        local Gun = ReturnItem("Gun")
        local Knife = ReturnItem("Knife")
        
        if Gun and Knife then
          return true
        end
        return false
      end
      if Settings.Teleport.Mode == "Tools Load" and (eu.Backpack:FindFirstChild("Teleport Tool") or eu.Character:FindFirstChild("Teleport Tool")) and not ToolsLoaded() then
        DelTP()
      elseif not eu.Backpack:FindFirstChild("Teleport Tool") and not eu.Character:FindFirstChild("Teleport Tool") then
        if Settings.Teleport.Mode == "Tools Load" and ToolsLoaded() then
          GetTP()
        elseif Settings.Teleport.Mode == "Everytime" then
          GetTP()
        end
      end
    end)
  end
end
local function BuyBox()
  if eu.Cash.Value >= Settings.Boxes.Price then
    game:GetService("ReplicatedStorage").BuyCase:InvokeServer(Settings.Boxes.Selected)
  end
end
local function AutoBuy()
  while getgenv().AutoBuy and task.wait(1) do
    pcall(function()
      BuyBox()
    end)
  end
end

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "leaf"}),
  Gun = Window:Tab({ Title = "Gun", Icon = "skull"}),
  Knife = Window:Tab({ Title = "Knife", Icon = "sword"}),
  Boxes = Window:Tab({ Title = "Boxes", Icon = "box"}),
  Teleport = Window:Tab({ Title = "Teleport", Icon = "shell"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Player ESP" })
Tabs.Menu:Toggle({
  Title = "Player ESP",
  Desc = "Extra Sensorial Experience.",
  Value = false,
  Callback = function(state)
    getgenv().PlayerESP = state
    PlayerESP()
  end
})
Tabs.Menu:Colorpicker({
  Title = "ESP Color",
  Default = CorInocente,
  Locked = true,
  Callback = function(color)
    CorInocente = Color3.new(color)
  end
})
Tabs.Menu:Section({ Title = "Hitbox Expander" })
Tabs.Menu:Toggle({
  Title = "Expand Hitboxes",
  Desc = "Bigger hitboxes.",
  Value = false,
  Callback = function(state)
    getgenv().HitBox = state
    HitBox()
  end
})
Tabs.Menu:Input({
  Title = "Hitbox Size",
  Value = "5",
  Placeholder = "Default HitBox Size = 5",
  Callback = function(input)
    HitSize = tonumber(input) or 1
  end
})

-- Gun
Tabs.Gun:Section({ Title = "Undetectable" })
Tabs.Gun:Toggle({
  Title = "Triggerbot",
  Desc = "Auto kill enemies in sight.",
  Value = false,
  Callback = function(state)
    getgenv().Triggerbot = state
    Triggerbot()
  end
})
Tabs.Gun:Input({
  Title = "Shoot Cooldown",
  Value = "3",
  Placeholder = "In seconds, ex.: 3",
  Callback = function(input)
    Settings.Triggerbot.Cooldown = tonumber(input) or 0
  end
})
Tabs.Gun:Section({ Title = "Blatant" })
Tabs.Gun:Button({
  Title = "Kill All",
  Desc = "Kills everyone using your gun.",
  Callback = function()
    KillGun()
  end
})
Tabs.Gun:Toggle({
  Title = "Auto Kill",
  Desc = "Auto kills everyone.",
  Value = false,
  Callback = function(state)
    getgenv().AutoGun = state
    AutoGun()
  end
})
Tabs.Gun:Toggle({
  Title = "Auto Equip Gun",
  Desc = "Automatically equips your gun.",
  Value = false,
  Callback = function(state)
    getgenv().PullGun = state
    PullGun()
  end
})
Tabs.Gun:Section({ Title = "Misc" })
Tabs.Gun:Toggle({
  Title = "Spam Sound (FE)",
  Desc = "Automatically spams the shoot sound.",
  Value = false,
  Callback = function(state)
    getgenv().GunSound = state
    GunSound()
  end
})
Tabs.Gun:Input({
  Title = "Sound Cooldown",
  Value = "0.2",
  Placeholder = "In seconds, ex.: 0.2",
  Callback = function(input)
    Settings.SpamSoundCooldown= tonumber(input) or 1
  end
})

-- Knife
Tabs.Knife:Section({ Title = "Legit" })
Tabs.Knife:Toggle({
  Title = "Auto Slash",
  Desc = "Auto use your knife.",
  Value = false,
  Callback = function(state)
    getgenv().AutoSlash = state
    AutoSlash()
  end
})
Tabs.Knife:Input({
  Title = "Slash Cooldown",
  Value = "0.5",
  Placeholder = "In seconds, ex.: 0.5",
  Callback = function(input)
    Settings.Slash.Cooldown = tonumber(input) or 1
  end
})
Tabs.Knife:Section({ Title = "Blatant" })
Tabs.Knife:Button({
  Title = "Kill All",
  Desc = "Kills everyone using your knife.",
  Callback = function()
    KillKnife()
  end
})
Tabs.Knife:Toggle({
  Title = "Auto Kill",
  Desc = "Auto kills everyone.",
  Value = false,
  Callback = function(state)
    getgenv().AutoKnife = state
    AutoKnife()
  end
})
Tabs.Knife:Toggle({
  Title = "Auto Equip Knife",
  Desc = "Automatically equips your knife.",
  Value = false,
  Callback = function(state)
    getgenv().EquipKnife = state
    EquipKnife()
  end
})

-- Boxes
Tabs.Boxes:Section({ Title = "Selected Box" })
Tabs.Boxes:Dropdown({
  Title = "Selected Box",
  Values = { "Knife Box #1", "Knife Box #2", "Gun Box #1", "Gun Box #2", "Mythic Box #1", "Mythic Box #2", "Mythic Box #3", "Mythic Box #4" },
  Value = Settings.Boxes.Selected,
  Callback = function(option)
    Settings.Boxes.Selected = option
    if string.find(option, "Mythic") then
      Settings.Boxes.Price = 1500
    else
      Settings.Boxes.Price = 500
    end
  end
})
Tabs.Boxes:Section({ Title = "Buy Box" })
Tabs.Boxes:Button({
  Title = "Buy Box",
  Desc = "Buys the selected box if you have money.",
  Callback = function()
    BuyBox()
  end
})
Tabs.Boxes:Toggle({
  Title = "Auto Buy",
  Desc = "Auto buys the selected box.",
  Value = false,
  Callback = function(state)
    getgenv().AutoBuy = state
    AutoBuy()
  end
})

-- Teleport
Tabs.Teleport:Section({ Title = "Teleport to Map" })
Tabs.Teleport:Dropdown({
  Title = "Selected Map",
  Values = {"Lobby", "Hotel", "Factory", "House", "Mansion", "MilBase", "Waiting Room"},
  Value = "Lobby",
  Callback = function(option)
    if option == "Lobby" then
      Settings.Teleport.CFrame = CFrame.new(-337, 76, 19)
    elseif option == "Factory" then
      Settings.Teleport.CFrame = CFrame.new(-1074, 113, 5437)
    elseif option == "House" then
      Settings.Teleport.CFrame = CFrame.new(408, 111, 6859)
    elseif option == "Mansion" then
      Settings.Teleport.CFrame = CFrame.new(-1175, 47, 6475)
    elseif option == "MilBase" then
      Settings.Teleport.CFrame = CFrame.new(-1186, 27, 3737)
    elseif option == "Hotel" then
      Settings.Teleport.CFrame = CFrame.new(677.19104, 95.9535522, 4991.19287)
    elseif option == "Waiting Room" then
      Settings.Teleport.CFrame = CFrame.new(1888.1405, -63.8421059, 78.9331055)
    end
  end
})
Tabs.Teleport:Button({
  Title = "Teleport",
  Desc = "Teleports you to the selected map.",
  Callback = function()
    pcall(function()
      eu.Character.HumanoidRootPart.CFrame = Settings.Teleport.CFrame
    end)
  end
})
Tabs.Teleport:Section({ Title = "Teleport Tool" })
Tabs.Teleport:Button({
  Title = "Get Teleport Tool",
  Desc = "Gives you the teleport tool.",
  Callback = function()
    GetTP()
  end
})
Tabs.Teleport:Button({
  Title = "Remove Tool",
  Desc = "Removes the teleport tool.",
  Callback = function()
    DelTP()
  end
})
Tabs.Teleport:Toggle({
  Title = "Permanent Tool",
  Desc = "Auto get teleport tool.",
  Value = false,
  Callback = function(state)
    getgenv().AutoTPe = state
    AutoTPe()
  end
})
Tabs.Teleport:Dropdown({
  Title = "Get Tool When",
  Values = { "Tools Load", "Everytime" },
  Value = Settings.Teleport.Mode,
  Callback = function(option)
    Settings.Teleport.Mode = option
  end
})