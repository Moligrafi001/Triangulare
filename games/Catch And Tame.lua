-- Global Values
getgenv().AutoCollect = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function collectAll()
    local r = game:GetService("ReplicatedStorage").Remotes.collectPetCash
    for _, p in pairs(workspace.PlayerPens["1"].Pets:GetChildren()) do
        if p:IsA("Model") then r:FireServer(p:GetAttribute("PetId") or p.Name) end
        task.wait(0.03)
    end
end

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
local section = Tabs.Menu:Section({ Title = "Cash", Icon = "banknote", Opened = true })
section:Button({
  Title = "Auto Cash",
  Desc = "Auto collect money from your pets",
  Callback = collectAll
})
section:Toggle({
  Title = "Auto Collect",
  Desc = "Auto Collect cash for you ",
  Value = false,
  Callback = function(state)
    getgenv().AutoCollect = state

    while getgenv().AutoCollect do
      pcall(collectAll)
    task.wait(30) end
  end
})
