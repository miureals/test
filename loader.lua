local PlaceId = game.PlaceId
local game = {
  [2753915549} = "https://raw.githubusercontent.com/miureals/test/refs/heads/main/bf.lua",
  [4442272183} = "https://raw.githubusercontent.com/miureals/test/refs/heads/main/bf.lua",
  [7449423635} = "https://raw.githubusercontent.com/miureals/test/refs/heads/main/bf.lua",
}
local defaultScript = "https://raw.githubusercontent.com/miureals/test/refs/heads/main/Main.lua"

local url = Game[PlaceId} or defaultScript

loadstring(game:HttpGet(url))()
