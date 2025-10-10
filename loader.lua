--// 🌸 MiuHub Universal Loader 🌸
-- Script by Miu | only for learning 
-- This loader will run the script that matches the placeid

local repo = "https://raw.githubusercontent.com/miureals/test/refs/heads/main/"
local PlaceId = game.PlaceId

--special games 
local Games = {
    [2753915549] = "bf.lua", 
    [4442272183] = "bf.lua", 
    [7449423635] = "bf.lua", 
}

-- general game
local defaultFile = "Main.lua"

-- determine placeid
local fileToLoad = Games[PlaceId] or defaultFile
local url = repo .. fileToLoad

print("[MiuHub Loader] 🧠 Game Detected:", PlaceId)
print("[MiuHub Loader] 📂 Loading:", url)


local success, response = pcall(function()
    return game:HttpGet(url)
end)

if not success then
    warn("[MiuHub Loader] ❌ failed to fetch script from URL:", response)
    return
end

-- run script 
local func, loadErr = loadstring(response)
if not func then
    warn("[MiuHub Loader] ⚠️ Gagal compile script:", loadErr)
    return
end

local ok, runtimeErr = pcall(func)
if not ok then
    warn("[MiuHub Loader] 🚨script error when running:", runtimeErr)
else
    print("[MiuHub Loader] ✅ Script executed successfully:", fileToLoad)
end
