-- Global Values
getgenv().StealAura = false
getgenv().AutoSell = false

-- Locals
local eu = game:GetService("Players").LocalPlayer

-- Functions
local function StealAura()
  while getgenv().StealAura and task.wait(0.1) do
    pcall(function()
      if eu:GetAttribute("team") == "rats" then
        for _, prompt in pairs(workspace.__important.server.baits:GetDescendants()) do
          pcall(function()
            if prompt:IsA("ProximityPrompt") and prompt.ActionText == "Steal" then
              fireproximityprompt(prompt)
            end
          end)
        end
      end
    end)
  end
end
local function AutoSell()
  while getgenv().AutoSell and task.wait(1) do
    pcall(function()
      if eu:GetAttribute("team") == "rats" then
        game:GetService("ReplicatedStorage").remotes.client.ui.dialogues.request_sell_all:InvokeServer()
      end
    end)
  end
end

--[[
Game: 8169094622 | Place: 117957332897543
game:GetService("ReplicatedStorage").remotes.client.ui.dialogues.request_sell_all:InvokeServer()
]]--

-- Tabs
local Tabs = {
  Rats = Window:Tab({ Title = "Rats", Icon = "rat"})
}
Window:SelectTab(1)

-- Rats
Tabs.Rats:Section({ Title = "Steal" })
Tabs.Rats:Toggle({
  Title = "Steal Aura",
  Desc = "Steals all the cheese nearby..",
  Value = false,
  Callback = function(state)
    getgenv().StealAura = state
    StealAura()
  end
})
Tabs.Rats:Section({ Title = "Sell" })
Tabs.Rats:Button({
  Title = "Sell Everything",
  Desc = "Sells your inventory.",
  Callback = function()
    game:GetService("ReplicatedStorage").remotes.client.ui.dialogues.request_sell_all:InvokeServer()
  end
})
Tabs.Rats:Toggle({
  Title = "Auto Sell Cheese",
  Desc = "Auto sells your cheese.",
  Value = false,
  Callback = function(state)
    getgenv().AutoSell = state
    AutoSell()
  end
})