-- Locals
local eu = game:GetService("Players").LocalPlayer
local Busy = false

-- Funtions
local function CollectChests()
  if Busy then
    WindUI:Notify({
      Title = "Wait! I'm busy!",
      Content = "Try again later, when i finish this.",
      Icon = "triangle",
      Duration = 5,
    })
  else
    Busy = true
    for _, chest in pairs(workspace.MapComponents.Chests:GetChildren()) do
      if not chest:GetAttribute("Receiver_" .. eu.Name) then
        eu.Character:SetAttribute("Triangulare", eu.Character.CFrame)
        task.wait(0.1)
        eu.Character.CFrame = chest.Giver.CFrame
        task.wait(0.3)
        fireproximityprompt(chest.Giver.Chest)
        eu.CFrame = eu:GetAttribute("Triangulare")
        task.wait(0.1)
      end
    end
    Busy = false
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