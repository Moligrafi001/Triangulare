
-- Locals
local selectedTp = false

-- Values
getgenv().AntiBarriers = false
getgenv().NoWater = false
getgenv().NoSand = false

-- workspace.ChangeTeam:FireServer(game:GetService("Teams").white)

local function TpTeam()
	local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	if character:FindFirstChild("Humanoid") then
		if character.Humanoid.Health <= 0 then
			Rayfield:Notify({
				Title = "You're dead!",
				Content = "You need to be alive to teleport.",
				Duration = 2.5,
				Image = 17091459839,
			})
		else
			if selectedTp == "White" then
				character.HumanoidRootPart.CFrame = CFrame.new(-49.8767357, -9.70000172, -553.887329, -0.999787033, 1.25884325e-08, -0.0206365604, 1.47957655e-08, 1, -1.06809573e-07, 0.0206365604, -1.07092156e-07, -0.999787033)
			elseif selectedTp == "Red" then
				character.HumanoidRootPart.CFrame = CFrame.new(425.057861, -9.70000172, -64.5107422, 0.0343699642, 1.23541966e-07, 0.999409199, 3.98828561e-08, 1, -1.24986585e-07, -0.999409199, 4.4155076e-08, 0.0343699642)
			elseif selectedTp == "Black" then
				character.HumanoidRootPart.CFrame = CFrame.new(-531.822144, -9.70000267, -69.1551514, -0.00589912944, 1.20717658e-07, -0.999982595, -9.69744374e-09, 1, 1.2077696e-07, 0.999982595, 1.04097539e-08, -0.00589912944)
			elseif selectedTp == "Blue" then
				character.HumanoidRootPart.CFrame = CFrame.new(425.261688, -9.70000172, 300.105286, 0.00153439876, 1.43000376e-08, 0.999998808, 2.10142148e-09, 1, -1.43032786e-08, -0.999998808, 2.12336593e-09, 0.00153439876)
			elseif selectedTp == "Green" then
				character.HumanoidRootPart.CFrame = CFrame.new(-533.034668, -9.70000267, 293.827362, 0.00386504922, -5.97546501e-09, -0.999992549, 2.27750636e-08, 1, -5.8874825e-09, 0.999992549, -2.2752138e-08, 0.00386504922)
			elseif selectedTp == "Magenta" then
				character.HumanoidRootPart.CFrame = CFrame.new(426.041626, -9.70000172, 646.9021, 0.0128429839, 2.46640219e-09, 0.999917507, 5.62189184e-09, 1, -2.53881338e-09, -0.999917507, 5.65403413e-09, 0.0128429839)
			elseif selectedTp == "Yellow" then
				character.HumanoidRootPart.CFrame = CFrame.new(-532.347107, -9.70000267, 640.261658, -0.0351400562, -9.47882128e-09, -0.999382377, -7.10814092e-08, 1, -6.98533098e-09, 0.999382377, 7.07920407e-08, -0.0351400562)
			else
				Rayfield:Notify({
						Title = "No team selected.",
						Content = "You have to select it before you teleport.",
						Duration = 2.5,
						Image = 17091459839,
					})
			end
		end
	end
end
local function AntiBarriers()
	while getgenv().AntiBarriers == true do
		for _, base in pairs(workspace:GetChildren()) do
			if base:IsA("Part") and base:FindFirstChild("Lock") and base.Lock:FindFirstChild("Part") then
				if base.Lock.Part.CanCollide == true or base.Lock.Part.CanTouch == true then
					base.Lock.Part.CanCollide = false
					base.Lock.Part.CanTouch = false
				end
			end
		end
		wait(0.01)
	end
	if getgenv().AntiBarriers == false then
		for _, base in pairs(workspace:GetChildren()) do
			if base:IsA("Part") and base:FindFirstChild("Lock") and base.Lock:FindFirstChild("Part") then
				if base.Lock.Part.CanCollide == false or base.Lock.Part.CanTouch == false then
					base.Lock.Part.CanCollide = true
					base.Lock.Part.CanTouch = true
				end
			end
		end
		wait(0.01)
	end
end
local function NoWater()
	while getgenv().NoWater == true do
		if workspace.Water.CanTouch == true then
			workspace.Water.CanTouch = false
		end
		for _, stage in pairs(workspace.BoatStages.NormalStages:GetChildren()) do
			if stage:FindFirstChild("Water") then
				if stage.Water.CanTouch == true then
					stage.Water.CanTouch = false
				end
			end
		end
		for _, stage in pairs(workspace.BoatStages.OtherStages:GetChildren()) do
			if stage:FindFirstChild("Water") and stage.Water:IsA("Part") then
				if stage.Water.CanTouch == true then
					stage.Water.CanTouch = false
				end
			end
			if stage.Name == "WashingMachineStage" then
				if stage:FindFirstChild("Water") then
					for _, water in pairs(stage.Water:GetChildren()) do
						if water.CanTouch == true then
							water.CanTouch = false
						end
					end
				end
			end
		end
		wait(0.01)
	end
	if getgenv().NoWater == false then
		if workspace.Water.CanTouch == false then
			workspace.Water.CanTouch = true
		end
		for _, stage in pairs(workspace.BoatStages.NormalStages:GetChildren()) do
			if stage:FindFirstChild("Water") then
				if stage.Water.CanTouch == false then
					stage.Water.CanTouch = true
				end
			end
		end
		for _, stage in pairs(workspace.BoatStages.OtherStages:GetChildren()) do
			if stage:FindFirstChild("Water") and stage.Water:IsA("Part") then
				if stage.Water.CanTouch == false then
					stage.Water.CanTouch = true
				end
			end
			if stage.Name == "WashingMachineStage" then
				if stage:FindFirstChild("Water") then
					for _, water in pairs(stage.Water:GetChildren()) do
						if water.CanTouch == false then
							water.CanTouch = true
						end
					end
				end
			end
		end
	end
end
local function NoSand()
	while getgenv().NoSand == true do
		if workspace.Sand.CanTouch == true then
			workspace.Sand.CanTouch = false
		end
		for _, stage in pairs(workspace.BoatStages.NormalStages:GetChildren()) do
			if stage:FindFirstChild("Sand") then
				if stage.Sand.CanTouch == true then
					stage.Sand.CanTouch = false
				end
			end
		end
		for _, stage in pairs(workspace.BoatStages.OtherStages:GetChildren()) do
			if stage:FindFirstChild("Sand") then
				if stage.Sand.CanTouch == true then
					stage.Sand.CanTouch = false
				end
			end
		end
		wait(0.01)
	end
	if getgenv().NoSand == false then
		if workspace.Sand.CanTouch == false then
			workspace.Sand.CanTouch = true
		end
		for _, stage in pairs(workspace.BoatStages.NormalStages:GetChildren()) do
			if stage:FindFirstChild("Sand") then
				if stage.Sand.CanTouch == false then
					stage.Sand.CanTouch = true
				end
			end
		end
		for _, stage in pairs(workspace.BoatStages.OtherStages:GetChildren()) do
			if stage:FindFirstChild("Sand") then
				if stage.Sand.CanTouch == false then
					stage.Sand.CanTouch = true
				end
			end
		end
	end
end
-- Tabs
local Tabs = {
    Main = Window:Tab({Title = "Main", Icon = "home"}),
    Teleport = Window:Tab({Title = "Teleport", Icon = "Shell"}),
}

-- Main Tab
Tabs.Main:Section({Title = "Helpful"})
Tabs.Main:Toggle({
    Title = "No Water Damage",
    Desc = "Prevents water damage",
    Value = false,
    Callback = function(state)
        getgenv().NoWater = state
        NoWater()
    end
})
Tabs.Main:Toggle({
    Title = "No Sand Damage",
    Desc = "Prevents sand damage",
    Value = false,
    Callback = function(state)
        getgenv().NoSand = state
        NoSand()
    end
})

Tabs.Main:Section({Title = "Misc"})
Tabs.Main:Toggle({
    Title = "Anti Barriers",
    Desc = "Removes barriers",
    Value = false,
    Callback = function(state)
        getgenv().AntiBarriers = state
        AntiBarriers()
    end
})

-- Teleport Tab
Tabs.Teleport:Section({Title = "Teleport to Team"})
Tabs.Teleport:Dropdown({
    Title = "Selected Team",
    Desc = "Choose team to teleport to",
    Values = {"White", "Red", "Black", "Blue", "Green", "Magenta", "Yellow"},
    Value = "No Map Selected",
    Callback = function(selected)
        selectedTp = selected
    end
})
Tabs.Teleport:Button({
    Title = "Teleport to Team",
    Desc = "Teleports to selected team",
    Callback = function()
        TpTeam()
    end
})

-- Select first tab by default
Window:SelectTab(1)
