-- Setup
local CredSettings = {
  Teleport = "Noobs Must Die"
}
local CredTabs = {}
CredTabs.ExtraDivider = Window:Divider()

-- Supported
local function SupportedList(type)
  local gamePlaceIds = {
    ["Noobs Must Die"] = 93557410403539,
    ["Rope Battles"] = 136195938137126,
    ["Dangerous Night"] = 109686116036889,
    ["[DUELS] Murderers VS Sherrifs"] = 135856908115931,
    ["Make a Sprunki Tycoon!"] = 71508074112900,
    ["Fast Food Simulator"] = 119055906651998,
    ["Basketball Legends"] = 14259168147,
    ["Saber Showdown"] = 12625784503,
    ["Kingdom of Magic Tycoon"] = 18608175830,
    ["Wizard Tycoon - 2 Player"] = 281489669,
    ["raise bob"] = 84593840279371,
    ["Steal a Pet"] = 106848621211283,
    ["Steal a Ore"] = 123763291847901,
    ["Steal a Character"] = 101354156600579,
    ["Steal a Gubby"] = 79983021053282,
    ["Steal a Labubu"] = 119823419558973,
    ["Bunker Life Tycoon"] = 118975157774793,
    ["2 Player Labubu Tycoon"] = 133335273076187,
    ["Stick Battles"] = 136372246050123,
    ["Critical Fantasy"] = 124519565742104,
    ["Steal a magic"] = 84467557068970,
    ["Thanos Simulator"] = 3261957210,
    ["Trap and Bait"] = 117957332897543,
    ["Steal To Be Rich!"] = 133945484297240,
    ["Zombie Tower"] = 115338810233057,
    ["therapy"] = 8286149869,
    ["Don't Wake the Brainrots!"] = 118915549367482,
    ["Steal a Country"] = 112076897193131,
    ["STEAL COOKIES"] = 133719960214587,
    ["Steal a Number"] = 74178616685491,
    ["Build A Boat For Treasure"] = 537413528,
    ["Hide and Seek Extreme"] = 205224386,
    ["Be a Beggar!"] = 119574637420814,
    ["Bunker Battles"] = 84767406892643,
    ["Bridge Battles!"] = 87531672335231,
    ["Rob a Bank!"] = 107431063731700,
    ["Steal a Power-up"] = 75235622760301,
    ["Blast Zone"] = 9058310544,
    ["Slasher Blade Loot"] = 99827026339186,
    ["Wizard Arena"] = 136178978872141,
    ["Last Letter"] = 129866685202296,
    ["Blind Shot"] = 118614517739521,
  }
  if type == "Names" then
    local Names = {}
    for name, _ in pairs(gamePlaceIds) do
      table.insert(Names, name)
    end
    return Names
  end
  return gamePlaceIds
end
CredTabs.SupportedTab = Window:Tab({ Title = "Games", Icon = "gamepad-2"})
CredTabs.SupportedTab:Section({ Title = "Supported Games" })
CredTabs.SupportedTab:Dropdown({
  Title = "Selected Game",
  Values = SupportedList("Names"),
  Value = CredSettings.Teleport,
  Callback = function(option)
    CredSettings.Teleport = option
  end
})
CredTabs.SupportedTab:Section({ Title = "Teleport to Game" })
CredTabs.SupportedTab:Button({
  Title = "Teleport",
  Desc = "Teleports you to the selected game.",
  Callback = function()
    local id = SupportedList("IDs")[CredSettings.Teleport]
    game:GetService("TeleportService"):Teleport(id, game:GetService("Players").LocalPlayer)
  end
})

-- Credits
CredTabs.CreditsTab = Window:Tab({ Title = "Credits", Icon = "info"})
CredTabs.CreditsTab:Section({ Title = "Developers" })
CredTabs.CreditsTab:Paragraph({
  Title = "Founder Developer",
  Desc = "Discord: @moligrafi",
})
CredTabs.CreditsTab:Paragraph({
  Title = "Co-Developers",
  Desc = "Discord: @_prismx\nDiscord: @zylxex",
})
CredTabs.CreditsTab:Section({ Title = "Discord Server" })
CredTabs.CreditsTab:Paragraph({
  Title = "Discord Server",
  Desc = "https://discord.gg/q7xBfkwdjc",
  Buttons = {
    {
      Title = "Copy Server Link",
      Variant = "Primary",
      Callback = function()
        setclipboard("https://discord.gg/q7xBfkwdjc")
      end,
      Icon = "link"
    }
  }
})