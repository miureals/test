local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local desiredJumpPower = 50 -- Nilai default

local Window = Rayfield:CreateWindow({
   Name = "GraceHub",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Wellcome",
   LoadingSubtitle = "By Miu",
   ShowText = "GraceHub", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Amethyst", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = false,
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

local PlayerTab = Window:CreateTab("🏠Home🏠") -- Title, Image
local Section = PlayerTab:CreateSection("Main")

--speed
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local SpeedValue = 16
local SpeedEnabled = false
local SpeedConnection = nil

local SliderSpeed = PlayerTab:CreateSlider({
   Name = "Speed",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "Speedslider", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
	SpeedValue = Value
 end,
})

local SpeedToggle = PlayerTab:CreateToggle({
    Name = "Enable Speed",
    CurrentValue = false,
    Flag = "ToggleSpeed",
    Callback = function(Value)
        SpeedEnabled = Value
        
        if SpeedConnection then
            SpeedConnection:Disconnect()
            SpeedConnection = nil
        end

        if SpeedEnabled then
            SpeedConnection = RunService.RenderStepped:Connect(function()
			local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local moveDir = Vector3.new(0, 0, 0)
    if userInputService:IsKeyDown(Enum.KeyCode.W) then
        moveDir += Workspace.CurrentCamera.CFrame.LookVector
    end
    if userInputService:IsKeyDown(Enum.KeyCode.S) then
        moveDir -= Workspace.CurrentCamera.CFrame.LookVector
    end
    if userInputService:IsKeyDown(Enum.KeyCode.A) then
        moveDir -= Workspace.CurrentCamera.CFrame.RightVector
    end
    if userInputService:IsKeyDown(Enum.KeyCode.D) then
        moveDir += Workspace.CurrentCamera.CFrame.RightVector
    end

    if moveDir.Magnitude > 0 then
        moveDir = moveDir.Unit
        hrp.CFrame = hrp.CFrame + moveDir * (SpeedValue * deltaTime)
    end
end)

--Jump boost
local Slider = PlayerTab:CreateSlider({
   Name = "Jump",
   Range = {50, 500},
   Increment = 10,
   Suffix = "Jump",
   CurrentValue = 10,
   Flag = "Slider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
end,
})

local JumpToggle = PlayerTab:CreateToggle({
    Name = "Enable Jump",
    CurrentValue = false,
    Flag = "ToggleJump",
    Callback = function(Value)
        JumpEnabled = Value
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        if humanoid then
            if Value then
                humanoid.JumpPower = JumpValue
            else
                humanoid.JumpPower = 50 -- balik ke normal
            end
        end
    end,
})

--window Misc
local EspTab = Window:CreateTab("🛠️Misc🛠️",nil)
local Section = EspTab:CreateSection("Misc")
--esp player
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local nameTags = {}
local showNameTags = false 


local function setNameTagsVisible(state)
	showNameTags = state
	for _, gui in pairs(nameTags) do
		if gui and gui:IsA("BillboardGui") then
			gui.Enabled = state
		end
	end
end

local function createNameTag(player)
	if player == localPlayer then return end
	if not player.Character then return end
	local head = player.Character:FindFirstChild("Head")
	if not head then return end

	if nameTags[player] then
		nameTags[player]:Destroy()
		nameTags[player] = nil
	end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "NameTag"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 200, 0, 70)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Enabled = showNameTags
	billboard.Parent = head

	local layout = Instance.new("UIListLayout")
	layout.Parent = billboard
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.VerticalAlignment = Enum.VerticalAlignment.Top
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 2)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 15)
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
	nameLabel.TextStrokeTransparency = 0.5
	nameLabel.Font = Enum.Font.SourceSansBold
	nameLabel.TextScaled = false
	nameLabel.TextSize = 16
	nameLabel.Text = "[" .. player.Name .. "]"
	nameLabel.Parent = billboard

	local healthLabel = Instance.new("TextLabel")
	healthLabel.Size = UDim2.new(1, 0, 0, 20)
	healthLabel.BackgroundTransparency = 1
	healthLabel.TextColor3 = Color3.fromRGB(0, 200, 0)
	healthLabel.TextStrokeTransparency = 0.5
	healthLabel.Font = Enum.Font.SourceSansBold
	healthLabel.TextScaled = false
	healthLabel.TextSize = 16
	healthLabel.Text = "[Hp: 0]"
	healthLabel.Parent = billboard

	local distanceLabel = Instance.new("TextLabel")
	distanceLabel.Size = UDim2.new(1, 0, 0, 20)
	distanceLabel.BackgroundTransparency = 1
	distanceLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
	distanceLabel.TextStrokeTransparency = 0.5
	distanceLabel.Font = Enum.Font.SourceSansBold
	distanceLabel.TextScaled = false
	distanceLabel.TextSize = 16
	distanceLabel.Text = "[Jarak: 0 m]"
	distanceLabel.Parent = billboard

	nameTags[player] = billboard

	RunService.Heartbeat:Connect(function()
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			local humanoid = player.Character.Humanoid
			healthLabel.Text = string.format("[Hp: %d]", math.floor(humanoid.Health))
		end

		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local dist = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
			local meter = math.floor(dist * 0.28)
			distanceLabel.Text = "[Jarak: ".. meter.."m]"
		end
	end)
end

local function removeNameTag(player)
	if nameTags[player] then
		nameTags[player]:Destroy()
		nameTags[player] = nil
	end
end

local function onCharacterAdded(player)
	task.wait(1)
	createNameTag(player)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function()
		onCharacterAdded(player)
	end)
	if player.Character then
		createNameTag(player)
	end
end

for _, p in pairs(Players:GetPlayers()) do
	if p ~= localPlayer then
		onPlayerAdded(p)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(removeNameTag)


local Toggle = EspTab:CreateToggle({
	Name = "Esp Player",
	CurrentValue = false,
	Flag = "EspPlayer",
	Callback = function(Value)
		setNameTagsVisible(Value)
	end,
})
