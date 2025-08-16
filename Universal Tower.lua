local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("premium version", "Default")

-- Adjust UI size
task.defer(function()
    local mainFrame = window:FindFirstChild("MainFrame") or window:FindFirstChildWhichIsA("Frame")
    if mainFrame then
        mainFrame.Size = UDim2.new(0.29, 0, 0.29, 0)
        mainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
    end
end)

-- Tabs
local mainTab = DrRayLibrary.newTab("Main", "rbxassetid://6031763426")
local teleportsTab = DrRayLibrary.newTab("Teleports", "rbxassetid://6031071058")
local antistunTab = DrRayLibrary.newTab("Antistun", "rbxassetid://6031244740")
local miscTab = DrRayLibrary.newTab("Misc", "rbxassetid://6031071050")
local animationsTab = DrRayLibrary.newTab("Animations", "rbxassetid://6031763432")
local morphsTab = DrRayLibrary.newTab("Morphs", "rbxassetid://6031763433")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ==================== Main Tab ====================

-- Auto Tower
local function autoTowerFunction()
    local TowerEvent = workspace:FindFirstChild("TowerEvent")
    if not TowerEvent then return end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in pairs(TowerEvent:GetDescendants()) do
        if obj:IsA("BillboardGui") then
            local textLabel = obj:FindFirstChild("TextLabel")
            if textLabel and textLabel.Text == "Unlocked!!" then
                local adornee = obj.Adornee
                local pos
                if adornee and adornee:IsA("BasePart") then
                    pos = adornee.Position
                elseif obj.Parent and obj.Parent:IsA("BasePart") then
                    pos = obj.Parent.Position
                end
                if pos then
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0,5,0))
                    break
                end
            end
        end
    end
end

mainTab.newButton("Auto Tower", "", function()
    autoTowerFunction()
end)

-- Bring Battery
local bringBatteryEnabled = false
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)

local function magnetizeBattery()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local batteryFolder = game:GetService("ReplicatedStorage"):FindFirstChild("AssetBossFight") and game:GetService("ReplicatedStorage").AssetBossFight:FindFirstChild("Battery")
    if batteryFolder then
        for _, battery in ipairs(batteryFolder:GetChildren()) do
            if battery:IsA("Model") then
                local primary = battery.PrimaryPart or battery:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local tween = TweenService:Create(primary, tweenInfo, {CFrame = hrp.CFrame + Vector3.new(0,3,0)})
                    tween:Play()
                end
            end
        end
    end
end

mainTab.newToggle("Bring Battery", "", false, function(state)
    bringBatteryEnabled = state
end)

-- Anti Thanos Boss
local antiThanosEnabled = false
local function clearThanosEffects()
    local assets = {"Lava", "Explosion", "Bullet", "SpinDamage"}
    for _, name in ipairs(assets) do
        local folder = game:GetService("ReplicatedStorage"):FindFirstChild("AssetBossFight") and game:GetService("ReplicatedStorage").AssetBossFight:FindFirstChild(name)
        if folder then
            for _, obj in ipairs(folder:GetChildren()) do
                if obj.Parent then obj:Destroy() end
            end
        end
    end
end

mainTab.newToggle("Anti Thanos Boss", "", false, function(state)
    antiThanosEnabled = state
end)

-- Heartbeat Loop for Main Tab
RunService.Heartbeat:Connect(function()
    if bringBatteryEnabled then magnetizeBattery() end
    if antiThanosEnabled then clearThanosEffects() end
end)

-- ==================== Teleports ====================
local function teleportToPosition(pos)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

teleportsTab.newButton("End", "", function() teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61)) end)
teleportsTab.newButton("Safezone", "", function() teleportToPosition(Vector3.new(-944.47, 1014.38, 55.65)) end)
teleportsTab.newButton("Nearby End", "", function() teleportToPosition(Vector3.new(-657.45, 1505.44, 21.10)) end)
teleportsTab.newButton("Boss Thanos", "", function() teleportToPosition(Vector3.new(-953.44, 1106.38, -185.17)) end)
teleportsTab.newButton("Ayanokoji", "", function() teleportToPosition(Vector3.new(-1090.62, 1395.38, 304.09)) end)
teleportsTab.newButton("Batolomeo", "", function() teleportToPosition(Vector3.new(-1322.48, 1240.66, -38.68)) end)
teleportsTab.newButton("Fujitora", "", function() teleportToPosition(Vector3.new(-1217.44, 1404.38, 78.68)) end)
teleportsTab.newButton("Kashimo", "", function() teleportToPosition(Vector3.new(-1203.41, 1365.39, -85.41)) end)
teleportsTab.newButton("Noob", "", function() teleportToPosition(Vector3.new(-945.30, 1014.38, 177.37)) end)
teleportsTab.newButton("Saitama", "", function() teleportToPosition(Vector3.new(-1186.26, 1240.68, 197.13)) end)
teleportsTab.newButton("Yamato", "", function() teleportToPosition(Vector3.new(-1456.68, 1365.56, -26.13)) end)

-- ==================== Anti Stun ====================
antistunTab.newButton("Anti Stun", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
end)

-- ==================== Misc ====================

-- Speed Tool
local boostspeed = 160
local ospeed = 16
local plr = player
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local bool = Instance.new("BoolValue")
bool.Value = false
local tool = Instance.new("Tool")
tool.Name = "speedboost"
tool.RequiresHandle = false
tool.Parent = plr.Backpack

tool.Equipped:Connect(function() bool.Value = true end)
tool.Unequipped:Connect(function() bool.Value = false end)
bool:GetPropertyChangedSignal("Value"):Connect(function()
    if bool.Value then
        hum.WalkSpeed = boostspeed
    else
        hum.WalkSpeed = ospeed
    end
end)

miscTab.newButton("Speed Tool", "", function()
    tool.Parent = plr.Backpack
end)

-- Infinite Jump
local infJump = false
miscTab.newToggle("Infinite Jump", "", false, function(state)
    infJump = state
end)
UserInputService.JumpRequest:Connect(function()
    if infJump and player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Floating Part
miscTab.newButton("Floating Part", "", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
end)

-- Tp Save Position
miscTab.newButton("Tp Save Position", "", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/Tp%20Place%20GUI',true))()
end)

-- ==================== Animations ====================
local animTrack
local playingAnim = false
animationsTab.newToggle("Axel Walks", "", false, function(state)
    if not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if state and not playingAnim then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://98044982170207"
        animTrack = hum:LoadAnimation(anim)
        animTrack.Looped = true
        animTrack:Play()
        playingAnim = true
    elseif not state and playingAnim then
        if animTrack then animTrack:Stop() end
        playingAnim = false
    end
end)

-- ==================== Morphs ====================
morphsTab.newButton("Morph Cid Transform", "", function()
    local transform = game:GetService("ReplicatedStorage").Asset.Transform:FindFirstChild("Cid")
    if transform then
        transform:Clone().Parent = player.Character
    end
end)
morphsTab.newButton("Morph Cid Character", "", function()
    local character = game:GetService("ReplicatedStorage").Asset.Character:FindFirstChild("Cid")
    if character then
        character:Clone().Parent = player.Character
    end
end)
morphsTab.newButton("Morph Transform Folder", "", function()
    local folder = game:GetService("ReplicatedStorage").Asset.Transform
    if folder then
        folder:Clone().Parent = player.Character
    end
end)
