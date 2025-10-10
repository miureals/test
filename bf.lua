-- MiuHub its only for learning 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local JumpEnabled = false
local JumpValue = 50

local Window = Rayfield:CreateWindow({
    Name = "MiuHub",
    Icon = 0,
    LoadingTitle = "Wellcome To A Miuhub",
    LoadingSubtitle = "This Script only for a learn",
    LoadingSubtitle = "By Miu",
    ShowText = "GraceHub",
    Theme = "Amethyst",
    ToggleUIKeybind = "K",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "Big Hub" },
    Discord = { Enabled = false, Invite = "noinvitelink", RememberJoins = true },

    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Home Tab
local PlayerTab = Window:CreateTab("🏠Home🏠")
local SectionHome = PlayerTab:CreateSection("Main")

-- Variables
local SpeedEnabled = false
local SpeedValue = 16
local SmoothFactor = 0.1 -- semakin tinggi semakin cepat mengikuti arah, 0.1 = lembut, 0.3 = cepat

-- Slider untuk Speed
local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 300},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        SpeedValue = Value
    end
})

-- Toggle untuk Speed
local WalkSpeedToggle = PlayerTab:CreateToggle({
    Name = "Enable WalkSpeed",
    CurrentValue = false,
    Flag = "WalkSpeedToggle",
    Callback = function(Value)
        SpeedEnabled = Value
    end
})

-- Function helper
local function getCharParts()
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if root and humanoid then
        return char, root, humanoid
    end
end

-- SMOOTH MOVEMENT LOGIC
local velocity = Vector3.zero

RunService.RenderStepped:Connect(function(dt)
    if not SpeedEnabled then
        velocity = Vector3.zero
        return
    end

    local char, root, humanoid = getCharParts()
    if not (char and root and humanoid) then return end

    local moveDir = humanoid.MoveDirection
    if moveDir.Magnitude > 0 then
        local targetVelocity = moveDir.Unit * SpeedValue
        velocity = velocity:Lerp(targetVelocity, SmoothFactor)
    else
        velocity = velocity:Lerp(Vector3.zero, SmoothFactor * 1.5)
    end

    root.CFrame = root.CFrame + (velocity * dt)
end)

-- Handle respawn
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    char:WaitForChild("Humanoid")
    velocity = Vector3.zero
end)

-- Jump control
local JumpSlider = PlayerTab:CreateSlider({
    Name = "Jump",
    Range = {50, 500},
    Increment = 10,
    Suffix = "Jump",
    CurrentValue = 50,
    Flag = "Slider2",
    Callback = function(Value)
        JumpValue = Value
        local _, _, humanoid = getCharParts()
        if humanoid then
            pcall(function() humanoid.JumpPower = Value end)
        end
    end
})

local JumpToggle = PlayerTab:CreateToggle({
    Name = "Enable Jump",
    CurrentValue = false,
    Flag = "ToggleJump",
    Callback = function(Value)
        JumpEnabled = Value
        local _, _, humanoid = getCharParts()
        if humanoid then
            if Value then
                pcall(function() humanoid.JumpPower = JumpValue end)
            else
                pcall(function() humanoid.JumpPower = 50 end)
            end
        end
    end
})

RunService.Heartbeat:Connect(function()
    if JumpEnabled then
        local _, _, humanoid = getCharParts()
        if humanoid then
            pcall(function() humanoid.JumpPower = JumpValue end)
        end
    end
end)

-- ESP TAB
local EspTab = Window:CreateTab("🛠️Misc🛠️")
local SectionMisc = EspTab:CreateSection("Misc")

local localPlayer = Players.LocalPlayer
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

local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function()
        task.wait(1)
        createNameTag(player)
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

EspTab:CreateToggle({
    Name = "Esp Player",
    CurrentValue = false,
    Flag = "EspPlayer",
    Callback = function(Value)
        setNameTagsVisible(Value)
    end
})
