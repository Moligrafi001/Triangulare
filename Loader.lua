-- code moved to a dynamic server sided loader for better performance
loadstring(game:HttpGet("http://triangulare.xyz/loader?g="..game.GameId.."&p="..game.PlaceId))()
