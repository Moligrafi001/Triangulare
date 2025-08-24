-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function GetItem(item)
  if item == "Cheese" then
    return fireclickdetector(workspace["Picnic Basket"].CheeseUntextured.ClickDetector)
  end
  for _, obj in pairs(workspace:GetChildren()) do
    if item == "Yellow Key" and obj:FindFirstChild("ClickDetector") and obj:FindFirstChild("Script") and obj:FindFirstChild("Mesh") and obj.CFrame == CFrame.new(-510.158936, -18.978363, -58.810009, 0.00186401606, -0.998980701, -0.0451014228, -0.985486925, 0.00582045317, -0.169652, 0.169741586, 0.044763092, -0.98447156) then
      return fireclickdetector(obj.ClickDetector)
    elseif item == "Stressball" then
      if obj:FindFirstChild("ClickDetector") and obj.CFrame and obj.CFrame == CFrame.new(-509.531311, 3.90429688, 9.21760178, -0.506094933, 0.341999441, 0.791773021, 0.224785, 0.938597262, -0.261738181, -0.832670271, 0.0455143377, -0.551895618) then
        return fireclickdetector(obj.ClickDetector)
      end
    end
  end
end

--[[
Game: 3177453609 | Place: 8286149869
for _, key in pairs(workspace:GetChildren()) do
if key:FindFirstChild("ClickDetector") and key:FindFirstChild("Script") and key:FindFirstChild("Mesh") and key.CFrame == CFrame.new(-510.158936, -18.978363, -58.810009, 0.00186401606, -0.998980701, -0.0451014228, -0.985486925, 0.00582045317, -0.169652, 0.169741586, 0.044763092, -0.98447156) then
print(key.Name)
end
end
workspace:GetChildren()[151].Handle.ClickDetector
workspace["Picnic Basket"].CheeseUntextured.ClickDetector
workspace.Opey.ClickDetector
workspace:GetChildren()[282].ClickDetector  -509.531311, 3.90429688, 9.21760178, -0.506094933, 0.341999441, 0.791773021, 0.224785, 0.938597262, -0.261738181, -0.832670271, 0.0455143377, -0.551895618
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Get Item" })
Tabs.Menu:Button({
  Title = "Get Cheese",
  Callback = function()
    GetItem("Cheese")
  end
})
Tabs.Menu:Button({
  Title = "Get Yellow Key",
  Callback = function()
    GetItem("Yellow Key")
  end
})
Tabs.Menu:Button({
  Title = "Get Stressball",
  Callback = function()
    GetItem("Stressball")
  end
})