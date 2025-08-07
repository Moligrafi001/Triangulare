-- Global Values
getgenv().SoulAura= false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Funções
local function EquipAll()
eu.Character.HumanoidRootPart:SetAttribute("Hallow_Hub", eu.Character.HumanoidRootPart.CFrame)
	for _, class in pairs(workspace.Spawn.Classes:GetChildren()) do
		if class.Button:FindFirstChild("ClickDetector") then
			fireclickdetector(class.Button.ClickDetector)
		end
	end
	wait(0.9)
	eu.Character.HumanoidRootPart.CFrame = eu.Character.HumanoidRootPart:GetAttribute("Hallow_Hub")
end
local function SoulAura()
	while getgenv().SoulAura and task.wait(0.01) do
	  pcall(function()
  		if eu.Backpack:FindFirstChild("Soul Stone") and not eu.Character:FindFirstChild("Soul Stone") then
  			eu.Backpack["Soul Stone"].Parent = eu.Character
  			for _, item in pairs(eu.Character:GetChildren()) do
  			  pcall(function()
    				if item:IsA("Tool") and item.Name ~= "Soul Stone" then
    					item.Parent = eu.Backpack
    					item.Parent = eu.Character
    				end
  				end)
  			end
  		end
		end)
	end
end

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Infinity Stones" })
Tabs.Menu:Button({
  Title = "Get Reality Stone",
  Desc = "Gives you the reality stone if it's avaiable.",
 Callback = function()
   if workspace:FindFirstChild("Reality Stone ") then
    workspace["Reality Stone "].Handle.Position = eu.Character.Head.Position
    WindUI:Notify({
      Title = "Got it! Yay!",
      Content = "Sucessfully got the Reality Stone!",
      Icon = "crosshair",
      Duration = 3,
    })
   else
    WindUI:Notify({
      Title = "It's not ready!",
      Content = "The Reality Stone didn't spawned yet.",
      Icon = "crosshair",
      Duration = 3,
    })
    end
  end
})
Tabs.Menu:Button({
  Title = "Get Time Stone",
  Desc = "Gives you the time stone if it's avaiable.",
  Callback = function()
    if workspace:FindFirstChild("TimeStone") then
      workspace.TimeStone.Handle.Position = eu.Character.Head.Position
      WindUI:Notify({
        Title = "Got it! Yay!",
        Content = "Sucessfully got the Time Stone!",
        Icon = "crosshair",
        Duration = 3,
      })
    else
      WindUI:Notify({
        Title = "It's not ready!",
        Content = "The Time Stone didn't spawned yet.",
        Icon = "crosshair",
        Duration = 3,
      })
    end
  end
})
Tabs.Menu:Button({
  Title = "Get Space Stone",
  Desc = "Gives you the space stone if it's avaiable.",
  Callback = function()
    if workspace:FindFirstChild("Space stone") then
      workspace["Space stone"].Handle.Position = eu.Character.Head.Position
      WindUI:Notify({
        Title = "Got it! Yay!",
        Content = "Sucessfully got the Space Stone!",
        Icon = "crosshair",
        Duration = 3,
      })
    else
      WindUI:Notify({
        Title = "It's not ready!",
        Content = "The Space Stone didn't spawned yet.",
        Icon = "crosshair",
        Duration = 3,
      })
    end
  end
})
Tabs.Menu:Section({ Title = "More" })
Tabs.Menu:Toggle({
  Title = "Damage Aura",
  Desc = "Needs soul stone.",
  Value = false,
  Callback = function(state)
    getgenv().SoulAura = state
    SoulAura()
  end
})
Tabs.Menu:Button({
  Title = "Equip All Items",
  Desc = "Equips all the items you unlocked.",
  Callback = function()
    EquipAll()
  end
})