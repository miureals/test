local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Rayfield Example Window",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local PlayerTab = Window:CreateTab("Tab Example") -- Title, Image
local EspSection = PlayerTab:CreateSection("Main")

-- Config toggle & slider
local autoAttackEnabled = false
local attackSpeed = 0.5 -- default detik per serangan

-- Toggle
local Toggle = PlayerTab:CreateToggle({
    Name = "Auto Attack",
    CurrentValue = false,
    Flag = "ToggleAutoAttack",
    Callback = function(Value)
        autoAttackEnabled = Value
    end,
})

-- Slider
local Slider = PlayerTab:CreateSlider({
    Name = "Attack Speed",
    Range = {0.1, 5}, -- interval detik per serangan
    Increment = 0.1,
    Suffix = "Seconds",
    CurrentValue = 0.5,
    Flag = "SliderAttackSpeed",
    Callback = function(Value)
        attackSpeed = Value
    end,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local ATTACK_RADIUS = 30
local lastAttack = 0

-- Cek apakah sedang memegang weapon
local function isHoldingWeapon()
    local tool = character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") and tool.Name == "UnequippedWeapon" then
        return tool
    end
    return nil
end

-- Fungsi attack NPC
local function attackNPC(npc, damage)
    if npc:FindFirstChild("Humanoid") then
        npc.Humanoid:TakeDamage(damage)
    end
end

-- Loop auto attack
RunService.Heartbeat:Connect(function(deltaTime)
    if not autoAttackEnabled then return end

    local tool = isHoldingWeapon()
    if tool then
        lastAttack = lastAttack + deltaTime
        if lastAttack >= attackSpeed then
            lastAttack = 0
            -- Ambil nilai damage dari weapon
            local damageValue = tool:FindFirstChild("Damage") and tool.Damage.Value or 10

            for _, npc in pairs(Workspace:GetChildren()) do
                if npc:FindFirstChild("Humanoid") and npc:FindFirstChild("HumanoidRootPart") then
                    local distance = (npc.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                    if distance <= ATTACK_RADIUS then
                        attackNPC(npc, damageValue)
                    end
                end
            end
        end
    end
end)
