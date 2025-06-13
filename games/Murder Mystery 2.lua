local Tabs = {
  Visual = Window:Tab({ Title = "Visual", Icon = "eye" }),
  Sheriff = Window:Tab({ Title = "Sheriff", Icon = "shield-plus" }),
  Murderer = Window:Tab({ Title = "Murderer", Icon = "sword" }),
  Auto = Window:Tab({ Title = "Auto", Icon = "bot" }),
  Player = Window:Tab({ Title = "Player", Icon = "user-round" }),
  Teleport = Window:Tab({ Title = "Teleport", Icon = "shell" }),
  Round = Window:Tab({ Title = "Round", Icon = "waves" }),
}
Window:SelectTab(1)

--//--// VISUAL TAB \\--\\--

getgenv().PlayerESPEnabled = false
getgenv().SheriffESPEnabled = false
getgenv().MurdererESPEnabled = false
getgenv().GunESPEnabled = false
getgenv().CoinESPEnabled = false

local RoleColors = {
    Innocent = Color3.fromRGB(0, 255, 0),
    Murderer = Color3.fromRGB(255, 0, 0),
    Sheriff = Color3.fromRGB(0, 0, 255),
    Hero = Color3.fromRGB(255, 255, 0),
    Unknown = Color3.fromRGB(255, 255, 255)
}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local ts = game:GetService("TweenService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

Tabs.Visual:Section({ Title = "ESP" })

--// PLAYER ESP \\--

Tabs.Visual:Toggle({
    Title = "Player ESP",
    Desc = "Shows ESP for all players regardless of role",
    Default = false,
    Callback = function(state)
        getgenv().PlayerESPEnabled = state
    end
})

Tabs.Visual:Toggle({
    Title = "Sheriff ESP",
    Desc = "Only shows ESP for the sheriff",
    Default = false,
    Callback = function(state)
        getgenv().SheriffESPEnabled = state
    end
})

Tabs.Visual:Toggle({
    Title = "Murderer ESP",
    Desc = "Only shows ESP for the murderer",
    Default = false,
    Callback = function(state)
        getgenv().MurdererESPEnabled = state
    end
})

local function createBillboard(nameText, color)
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "RoleBillboard"
    billboard.Size = UDim2.new(0, 90, 0, 21)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 3, 0)

    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "TextLabel"
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = nameText
    textLabel.TextColor3 = color
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.Gotham
    textLabel.Parent = billboard

    return billboard
end

local function ShouldShowESPFor(role)
    if getgenv().PlayerESPEnabled then return true end
    if getgenv().SheriffESPEnabled and role == "Sheriff" then return true end
    if getgenv().MurdererESPEnabled and role == "Murderer" then return true end
    return false
end

local function updateRoles()
    local success, playerData = pcall(function()
        return ReplicatedStorage.Remotes.Gameplay.GetCurrentPlayerData:InvokeServer()
    end)
    if not success or typeof(playerData) ~= "table" then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local data = playerData[player.Name]
            if data and not data.Dead then
                local role = data.Role or "Unknown"
                local color = RoleColors[role] or RoleColors.Unknown

                local highlight = player.Character:FindFirstChild("RoleESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "RoleESP"
                    highlight.FillTransparency = 0.7
                    highlight.OutlineTransparency = 0.2
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                end
                highlight.FillColor = color

                local head = player.Character.Head
                local billboard = head:FindFirstChild("RoleBillboard")
                if not billboard then
                    billboard = createBillboard(player.DisplayName, color)
                    billboard.Adornee = head
                    billboard.Parent = head
                else
                    local label = billboard:FindFirstChild("TextLabel")
                    if label then
                        label.TextColor3 = color
                        label.Text = player.DisplayName
                    end
                end
            end
        end
    end
end

local function isAlive(player)
    if not player or not player:IsA("Player") then return false end
    local success, playerData = pcall(function()
        return ReplicatedStorage.Remotes.Gameplay.GetCurrentPlayerData:InvokeServer()
    end)
    if not success or typeof(playerData) ~= "table" then return false end

    local data = playerData[player.Name]
    return data and not data.Dead
end

RunService.RenderStepped:Connect(function()
    local success, playerData = pcall(function()
        return ReplicatedStorage.Remotes.Gameplay.GetCurrentPlayerData:InvokeServer()
    end)
    if not success or typeof(playerData) ~= "table" then return end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local data = playerData[player.Name]
            local role = data and data.Role or "Unknown"
            local alive = data and not data.Dead
            local show = alive and ShouldShowESPFor(role)

            local highlight = player.Character:FindFirstChild("RoleESP")
            if highlight then
                highlight.Enabled = show
            end

            local head = player.Character.Head
            local billboard = head:FindFirstChild("RoleBillboard")
            if billboard then
                billboard.Enabled = show

                if show then
                    local dist = (camera.CFrame.Position - head.Position).Magnitude
                    local maxDistance = 300
                    if dist > maxDistance then
                        billboard.Enabled = false
                    else
                        local alpha = 1
                        if dist > 150 then
                            alpha = 1 - ((dist - 150) / (maxDistance - 150))
                        end

                        local label = billboard:FindFirstChild("TextLabel")
                        if label then
                            label.TextTransparency = 1 - alpha
                            label.TextStrokeTransparency = 0.5 + (1 - alpha) * 0.5
                        end
                    end
                end
            end
        end
    end
end)

local updateInterval = 0.5
local lastUpdate = 0

RunService.RenderStepped:Connect(function()
    if tick() - lastUpdate >= updateInterval then
        pcall(updateRoles)
        lastUpdate = tick()
    end
end)

--// GUN ESP \\--

local GunName = "GunDrop"
local hlName = "GunHighlight"
local bbName = "GunBillboard"
local hlColor = Color3.fromRGB(255, 255, 0)

local function createGunESP(part)
	local coinHL = Workspace:FindFirstChild("CoinHighlight_" .. part:GetDebugId())
	if coinHL then
		coinHL:Destroy()
	end

	if not part:FindFirstChild(hlName) then
		local highlight = Instance.new("Highlight")
		highlight.Name = hlName
		highlight.FillColor = hlColor
		highlight.OutlineColor = hlColor
		highlight.FillTransparency = 0.3
		highlight.OutlineTransparency = 0.1
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		highlight.Adornee = part
		highlight.Parent = part
	end

	if not part:FindFirstChild(bbName) then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = bbName
		billboard.Size = UDim2.new(0, 90, 0, 21)
		billboard.StudsOffset = Vector3.new(0, 2, 0)
		billboard.AlwaysOnTop = true
		billboard.Adornee = part
		billboard.Parent = part

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "GUN DROP"
		label.TextColor3 = hlColor
		label.TextStrokeTransparency = 0.5
		label.TextScaled = true
		label.Font = Enum.Font.SourceSansBold
		label.Parent = billboard
	end
end

local function scanGunDrops()
	for _, model in ipairs(Workspace:GetChildren()) do
		if model:IsA("Model") then
			for _, part in ipairs(model:GetChildren()) do
				if part:IsA("Part") and part.Name == GunName then
					createGunESP(part)
					local hl = part:FindFirstChild(hlName)
					if hl then hl.Enabled = getgenv().GunESPEnabled end

					local bb = part:FindFirstChild(bbName)
					if bb then bb.Enabled = getgenv().GunESPEnabled end
				end
			end
		end
	end
end

Workspace.ChildAdded:Connect(function(model)
	if model:IsA("Model") then
		model.ChildAdded:Connect(function(part)
			if part:IsA("Part") and part.Name == GunName then
				createGunESP(part)
				local hl = part:FindFirstChild(hlName)
				if hl then hl.Enabled = getgenv().GunESPEnabled end

				local bb = part:FindFirstChild(bbName)
				if bb then bb.Enabled = getgenv().GunESPEnabled end
			end
		end)
	end
end)

RunService.RenderStepped:Connect(function()
	if not getgenv().GunESPEnabled then return end

	for _, model in ipairs(Workspace:GetChildren()) do
		if model:IsA("Model") then
			for _, part in ipairs(model:GetChildren()) do
				if part:IsA("Part") and part.Name == GunName then
					local billboard = part:FindFirstChild(bbName)
					if billboard then
						local dist = (camera.CFrame.Position - part.Position).Magnitude
						local maxDistance = 300
						billboard.Enabled = dist <= maxDistance

						if dist <= maxDistance then
							local alpha = dist > 150 and (1 - (dist - 150) / 150) or 1
							local label = billboard:FindFirstChildOfClass("TextLabel")
							if label then
								label.TextTransparency = 1 - alpha
								label.TextStrokeTransparency = 0.5 + (1 - alpha) * 0.5
							end
						end
					end

					local hl = part:FindFirstChild(hlName)
					if hl then hl.Enabled = true end
				end
			end
		end
	end
end)

Tabs.Visual:Toggle({
	Title = "Gun ESP",
	Desc = "Shows ESP for the Gun Drop",
	Default = false,
	Callback = function(state)
		getgenv().GunESPEnabled = state
		scanGunDrops()
	end
})

--// COIN ESP \\--

local hlColor = Color3.fromRGB(245, 205, 48)
local coinContainer = Workspace:FindFirstChild("CoinContainer") or Workspace

local function createHLS(part)
	if not getgenv().CoinESPEnabled then return end
	if part.Name == "GunDrop" then return end

	local id = "CoinHighlight_" .. part:GetDebugId()
	if Workspace:FindFirstChild(id) then return end

	local adorneeTarget = part.Parent:IsA("Model") and part.Parent or part

	local highlight = Instance.new("Highlight")
	highlight.Name = id
	highlight.FillColor = hlColor
	highlight.OutlineColor = hlColor
	highlight.FillTransparency = 0.8
	highlight.OutlineTransparency = 0.1
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee = adorneeTarget
	highlight.Parent = Workspace
end

local function scanForCoins()
	for _, child in ipairs(coinContainer:GetChildren()) do
		if child:IsA("Part") and child.Name == "Coin_Server" then
			createHLS(child)
		elseif child:IsA("Model") then
			for _, inner in ipairs(child:GetChildren()) do
				if inner:IsA("Part") and inner.Name == "Coin_Server" then
					createHLS(inner)
				end
			end
		end
	end
end

local function updateCoinESPState()
	for _, obj in ipairs(Workspace:GetChildren()) do
		if obj:IsA("Highlight") and obj.Name:match("^CoinHighlight_") then
			if getgenv().CoinESPEnabled then
				obj.Enabled = true
			else
				obj:Destroy()
			end
		end
	end
end
scanForCoins()

Workspace.DescendantAdded:Connect(function(obj)
	if obj:IsA("Part") and obj.Name == "Coin_Server" then
		createHLS(obj)
	end
end)

local lastUpdate = 0
RunService.RenderStepped:Connect(function()
	local now = tick()
	if now - lastUpdate >= 0.5 then
		lastUpdate = now
		if getgenv().CoinESPEnabled then
			scanForCoins()
		end
	end
end)

Tabs.Visual:Toggle({
    Title = "Coin ESP",
    Desc = "Shows ESP for the Coins",
    Default = false,
    Callback = function(state)
        getgenv().CoinESPEnabled = state
        updateCoinESPState()
    end
})

--//--// SHERIFF TAB \\--\\--

Tabs.Sheriff:Section({ Title = "Gun" })

--// SHOOT MURDERER \\--

local PREDICTION_MULTIPLIER = 1.2
local MAX_PREDICTION_DISTANCE = 50
local debounce = false
local teleportDebounce = false

local function findGun()
    local function searchContainer(container)
        return container:FindFirstChild("Gun") or nil
    end
    return searchContainer(localPlayer.Backpack) or searchContainer(localPlayer.Character)
end

local function hasKnife(player)
    local function checkContainer(container)
        local knife = container:FindFirstChild("Knife")
        return knife and knife:IsA("Tool")
    end
    return checkContainer(player.Backpack) or checkContainer(player.Character)
end

local function getPredictedPosition(targetRoot, gunPosition)
    local targetVelocity = targetRoot.Velocity
    local distance = (targetRoot.Position - gunPosition).Magnitude
    
    if distance > MAX_PREDICTION_DISTANCE then
        return targetRoot.Position
    end
    
    return targetRoot.Position + (targetVelocity * PREDICTION_MULTIPLIER)
end

local function findMurderer()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart and hasKnife(player) then
                return player.Character
            end
        end
    end
end

local function teleportToMurderer()
    local targetChar = findMurderer()
    if not targetChar then return false end
    
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHRP then return false end
    
    local myChar = localPlayer.Character
    if not myChar then return false end
    
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end
    
    myHRP.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
    return true
end

local function executeShot()
    local gun = findGun()
    if not gun then return end
    
    local target = findMurderer()
    if not target then return end
    
    local remote = gun.KnifeLocal.CreateBeam:FindFirstChildWhichIsA("RemoteFunction")
    if not remote then return end
    
    remote:InvokeServer(1, getPredictedPosition(target.HumanoidRootPart, gun.Handle.Position), "AH2")
end

Tabs.Sheriff:Keybind({
    Title = "Shoot Murderer",
    Desc = "Shoots the murderer",
    Value = "K",
    Callback = function()
        if debounce then return end
        debounce = true
        
        executeShot()
        
        task.delay(0.5, function()
            debounce = false
        end)
    end
})

Tabs.Sheriff:Keybind({
    Title = "Shoot Murderer (Teleport)",
    Desc = "Teleports you to murderer and shoots",
    Value = "J",
    Callback = function()
        if teleportDebounce then return end
        teleportDebounce = true
        
        if teleportToMurderer() then
            task.wait(0.2)
            executeShot()
        end
        
        task.delay(1, function()
            teleportDebounce = false
        end)
    end
})

--// AIMBOT \\--

Tabs.Sheriff:Section({ Title = "Aim" })

local MAX_DISTANCE = 200

getgenv().aimbotEnabled = false
local selectedHotkey = Enum.UserInputType.MouseButton2

local function isFirstPerson()
	local camera = workspace.CurrentCamera
	local head = localPlayer.Character and localPlayer.Character:FindFirstChild("Head")
	if not head then return false end
	return (camera.Focus.Position - camera.CFrame.Position).Magnitude < 1
end

local function checkHotkey()
	if selectedHotkey == Enum.UserInputType.MouseButton1 or selectedHotkey == Enum.UserInputType.MouseButton2 then
		return UIS:IsMouseButtonPressed(selectedHotkey)
	else
		return UIS:IsKeyDown(selectedHotkey)
	end
end

local function aimAtTarget()
	if not getgenv().aimbotEnabled then return end
	if not isFirstPerson() then return end
	if not findGun() then return end
	if not checkHotkey() then return end

	local targetChar = findMurderer()
	if not targetChar then return end

	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	local myHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not targetHRP or not myHRP then return end

	local distance = (targetHRP.Position - myHRP.Position).Magnitude
	if distance > MAX_DISTANCE then return end

	local cam = workspace.CurrentCamera
	local camPos = cam.CFrame.Position

	cam.CFrame = CFrame.lookAt(camPos, targetHRP.Position)
end

Tabs.Sheriff:Toggle({
	Title = "Aimbot (High)",
	Desc = "Only works in first person mode",
	Default = false,
	Callback = function(state)
		getgenv().aimbotEnabled = state
	end
})

Tabs.Sheriff:Dropdown({
	Title = "Hotkey",
	Values = { "Left Mouse", "Right Mouse", "Left Control", "Left Alt" },
	Value = "Right Mouse",
	Callback = function(option)
		selectedHotkey = ({
			["Left Mouse"] = Enum.UserInputType.MouseButton1,
			["Right Mouse"] = Enum.UserInputType.MouseButton2,
			["Left Control"] = Enum.KeyCode.LeftControl,
			["Left Alt"] = Enum.KeyCode.LeftAlt
		})[option]
	end
})

RunService.RenderStepped:Connect(aimAtTarget)

--//--// MURDERER TAB \\--\\--

Tabs.Murderer:Section({ Title = "Knife" })

--// KILL SHERIFF \\--

local function findKnife()
	local function search(container)
		return container:FindFirstChild("Knife")
	end
	return search(localPlayer.Character) or search(localPlayer.Backpack)
end

local function hasGun(player)
	local function check(container)
		local tool = container:FindFirstChild("Gun")
		return tool and tool:IsA("Tool")
	end
	return check(player.Character) or check(player.Backpack)
end

local function findSheriff()
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and isAlive(player) and player.Character then
			local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
			if rootPart and hasGun(player) then
				return player.Character
			end
		end
	end
end

local function killSheriff()
	local knife = findKnife()
	if not knife then return end
	
	local target = findSheriff()
	if not target then return end

	local hrp = target:FindFirstChild("HumanoidRootPart")
    local hmd = target:FindFirstChild("Humanoid")
	local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not myHrp then return end

    hrp.Anchored = true
    hmd.WalkSpeed = 0
    hmd.JumpPower = 0
	hrp.CFrame = myHrp.CFrame + myHrp.CFrame.LookVector * 1

	local remote = knife:FindFirstChild("Stab") or knife:FindFirstChildWhichIsA("RemoteEvent", true)
	if not remote then return end

	task.wait(0.05)

	if remote:IsA("RemoteFunction") then
		remote:InvokeServer("Slash")
	elseif remote:IsA("RemoteEvent") then
		remote:FireServer("Slash")
	end
end

Tabs.Murderer:Keybind({
	Title = "Kill Sheriff",
	Desc = "Kills the sheriff instantly",
	Value = "B",
	Callback = function()
		killSheriff()
	end
})

--// KILL ALL \\--

local function killAll()
	local knife = findKnife()
	if not knife then return end

	local remote = knife:FindFirstChild("Stab") or knife:FindFirstChildWhichIsA("RemoteEvent", true)
	if not remote then return end

	local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myHrp then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and isAlive(player) and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			local hmd = player.Character:FindFirstChild("Humanoid")

			if hrp and hmd then
				hrp.Anchored = true
				hmd.WalkSpeed = 0
				hmd.JumpPower = 0
				hrp.CFrame = myHrp.CFrame + myHrp.CFrame.LookVector * 1
			end
		end
	end

	task.spawn(function()
		while true do
			local stillAlive = false
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer and isAlive(player) then
					stillAlive = true
					break
				end
			end

			if not stillAlive then
				break
			end

			if remote:IsA("RemoteFunction") then
				remote:InvokeServer("Slash")
			elseif remote:IsA("RemoteEvent") then
				remote:FireServer("Slash")
			end

			task.wait(0.3)
		end
	end)
end

Tabs.Murderer:Keybind({
	Title = "Kill All",
	Desc = "Kills all players instantly",
	Value = "N",
	Callback = function()
        killAll()
	end
})

--// KILL PLAYER \\--

local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local SelectedPlayer = getPlayerNames()[1]

local function killPlayer()
	local knife = findKnife()
	if not knife then return end

	local targetPlayer = Players:FindFirstChild(SelectedPlayer)
	if not targetPlayer or not isAlive(targetPlayer) then return end

	local target = targetPlayer.Character
	if not target then return end

	local hrp = target:FindFirstChild("HumanoidRootPart")
	local hmd = target:FindFirstChild("Humanoid")
	local myHrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp or not myHrp then return end

	hrp.Anchored = true
	hmd.WalkSpeed = 0
	hmd.JumpPower = 0
	hrp.CFrame = myHrp.CFrame + myHrp.CFrame.LookVector * 1

	local remote = knife:FindFirstChild("Stab") or knife:FindFirstChildWhichIsA("RemoteEvent", true)
	if not remote then return end

	task.wait(0.05)

	if remote:IsA("RemoteFunction") then
		remote:InvokeServer("Slash")
	elseif remote:IsA("RemoteEvent") then
		remote:FireServer("Slash")
	end
end

Tabs.Murderer:Button({
    Title = "Kill Player",
    Desc = "Kills the selected player instantly",
    Locked = false,
    Callback = function()
        killPlayer()
    end
})

local PlayersDropdown = Tabs.Murderer:Dropdown({
    Title = "Choose a Player",
    Desc = "Player to kill",
    Values = getPlayerNames(),
    Value = SelectedPlayer,
    Callback = function(option) 
        SelectedPlayer = option
    end
})
Players.PlayerAdded:Connect(function() PlayersDropdown:Refresh(getPlayerNames()) end)
Players.PlayerRemoving:Connect(function() PlayersDropdown:Refresh(getPlayerNames()) end)
PlayersDropdown:Refresh(getPlayerNames())

Tabs.Murderer:Section({ Title = "Aura" })

--// KILL AURA \\--

local auraDistance = 25
getgenv().auraEnabled = false

local function throwKnife(targetHRP)
	local knife = localPlayer.Backpack:FindFirstChild("Knife") or localPlayer.Character:FindFirstChild("Knife")
	if not knife then return end

	local throwRemote = knife:FindFirstChild("Throw")
	if not throwRemote then return end

	local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local origin = hrp.Position + Vector3.new(0, 1.5, 0)
	local lookAt = targetHRP.Position
	local directionCFrame = CFrame.new(origin, lookAt)

	throwRemote:FireServer(directionCFrame, lookAt)
end

local function getClosestPlayer(maxDistance)
	local closest, minDist = nil, maxDistance

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp and isAlive(player) then
				local dist = (hrp.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
				if dist <= minDist then
					closest, minDist = player, dist
				end
			end
		end
	end

	return closest
end

local lastThrow = 0
RunService.RenderStepped:Connect(function()
	if not getgenv().auraEnabled then return end
	if tick() - lastThrow < 0.3 then return end

	local targetPlayer = getClosestPlayer(tonumber(auraDistance) or 25)
	if targetPlayer and targetPlayer.Character then
		local hrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
		local hmd = targetPlayer.Character:FindFirstChild("Humanoid")
		if hrp and hmd then
			hrp.Anchored = true
			hmd.WalkSpeed = 0
			hmd.JumpPower = 0

			lastThrow = tick()
			throwKnife(hrp)
		end
	end
end)

Tabs.Murderer:Toggle({
    Title = "Kill Aura",
    Desc = "Automatically kills nearby players instantly",
    Default = false,
    Callback = function(state)
        getgenv().auraEnabled = state
    end
})

Tabs.Murderer:Slider({
    Title = "Aura Distance",
    Desc = "Distance to detect players",
    Step = 1,
    Value = {
        Min = 5,
        Max = 50,
        Default = 25,
    },
    Callback = function(value)
        auraDistance = tonumber(value) or 25
    end
})

--//--// AUTO TAB \\--\\--

Tabs.Auto:Section({ Title = "Auto Farm" })

--// AUTO FARM \\--

Tabs.Auto:Toggle({
	Title = "Auto Farm (SOON)",
	Desc = "Automatically farming coins around the map",
	Default = false,
	Callback = function(state)

	end
})

Tabs.Auto:Slider({
	Title = "Tween Speed",
	Desc = "Speed of tweening",
	Step = 0.1,
	Value = {
		Min = 0.1,
		Max = 1,
		Default = 0.5,
	},
	Callback = function(value)

	end
})
