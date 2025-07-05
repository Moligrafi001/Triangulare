-- Locals
local eu = game:GetService("Players").LocalPlayer
local Busy = false

-- Funtions
local function CollectChests()
  local function ReturnChests()
    local Chests = {}
    
    for _, chest in pairs(workspace.MapComponents.Chests:GetChildren()) do
      if not chest:GetAttribute("Receiver_" .. eu.Name) then
        table.insert(Chests, chest)
      end
    end
    
    return Chests
  end
  if Busy then
    WindUI:Notify({
      Title = "Wait! I'm busy!",
      Content = "Try again later, when i finish this.",
      Icon = "triangle",
      Duration = 5,
    })
  elseif #ReturnChests() == 0 then
    WindUI:Notify({
      Title = "Need more chests!",
      Content = "No chests available to collect.",
      Icon = "triangle",
      Duration = 5,
    })
  else
    WindUI:Notify({
      Title = "Collecting...",
      Content = "Wait, don't move.",
      Icon = "triangle",
      Duration = 5,
    })
    Busy = true
    for _, chest in pairs(ReturnChests()) do
      eu.Character.HumanoidRootPart:SetAttribute("Triangulare", eu.Character.HumanoidRootPart.CFrame)
      task.wait(0.1)
      eu.Character.HumanoidRootPart.CFrame = chest.Giver.CFrame
      task.wait(0.3)
      fireproximityprompt(chest.Giver.Chest)
      eu.Character.HumanoidRootPart.CFrame = eu.Character.HumanoidRootPart:GetAttribute("Triangulare")
      task.wait(0.1)
    end
    Busy = false
    WindUI:Notify({
      Title = "Done!",
      Content = "Collected all chests!",
      Icon = "triangle",
      Duration = 5,
    })
  end
end

--[[
Game: 7037847546 | Place: 124519565742104
workspace.MapComponents.Chests.CopperSword.Giver.Chest
Receiver_Moligrafi
]]--

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
Tabs.Menu:Section({ Title = "Helpful" })
Tabs.Menu:Button({
  Title = "Collect Chests",
  Desc = "Collects all chests.",
  Callback = function()
    CollectChests()
  end
})