--[[
Game: 8169094622 | Place: 117957332897543
game:GetService("ReplicatedStorage").remotes.client.ui.dialogues.request_sell_all:InvokeServer()
]]--

-- Global Values
getgenv().StealAura = false
getgenv().AutoSell = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function StealAura()
  while getgenv().StealAura and task.wait(0.1) do
  end
end