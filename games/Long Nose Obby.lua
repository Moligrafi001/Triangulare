-- Global Values
getgenv().AutoSkip = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function TeleportToLevel(level)
  local checkpoint = workspace.Checkpoints:FindFirstChild(tostring(level))
  if not checkpoint then return end

  eu.Character.HumanoidRootPart.CFrame = checkpoint.CFrame
end
local function SkipStage()
  TeleportToLevel(eu.leaderstats.Stage.Value + 1)
end

-- Tabs
local Tabs = {
  Menu = Window:Tab({ Title = "Main", Icon = "house"})
}
Window:SelectTab(1)

-- Menu
local section = Tabs.Menu:Section({ Title = "Checkpoint", Icon = "square-code", Opened = true })
section:Button({
  Title = "Skip Stage",
  Desc = "Skips the current stage",
  Callback = SkipStage
})
section:Toggle({
  Title = "Auto Skip",
  Desc = "Automatically skips stages",
  Value = false,
  Callback = function(state)
    getgenv().AutoSkip = state
    
    while getgenv().AutoSkip do
      pcall(SkipStage)
    task.wait(0.1) end
  end
})