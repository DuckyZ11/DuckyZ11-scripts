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

local mainTab = DrRayLibrary.newTab("Main", "rbxassetid://6031763426")
local teleportsTab = DrRayLibrary.newTab("Teleports", "rbxassetid://6031071058")
local animationsTab = DrRayLibrary.newTab("Animations", "rbxassetid://6031244740")
local miscTab = DrRayLibrary.newTab("Misc", "rbxassetid://6031071050")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ================= Main Tab =================
-- Auto Tower Function
local function autoTowerFunction()
    local TowerEvent = workspace:FindFirstChild("TowerEvent")
    if not TowerEvent then return end
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
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

-- Anti Thanos Boss (remove effects & spin damage loop)
local antiThanosEnabled = false
mainTab.newToggle("Anti Thanos Boss", "", false, function(state)
    antiThanosEnabled = state
end)

RunService.Heartbeat:Connect(function()
    if antiThanosEnabled then
        local effects = {"Lava","Explosion","Bullet","SpinDamage"}
        for _, vname in pairs(effects) do
            local folder = game:GetService("ReplicatedStorage").AssetBossFight:FindFirstChild(vname)
            if folder then
                for _, obj in pairs(folder:GetChildren()) do
                    if obj:IsA("BasePart") or obj:IsA("Model") then
                        obj:Destroy()
                    end
                end
            end
        end
        -- clear damage from SpinDamage
        local char = player.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid.Health = char.Humanoid.MaxHealth
        end
    end
end)

-- Bring Battery (magnet to player)
local bringBatteryEnabled = false
mainTab.newToggle("Bring Battery", "", false, function(state)
    bringBatteryEnabled = state
end)

local function magnetBattery()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local folder = game:GetService("ReplicatedStorage").AssetBossFight:FindFirstChild("Battery")
    if folder then
        for _, v in pairs(folder:GetChildren()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                local primary = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                if primary then
                    TweenService:Create(primary, TweenInfo.new(0.3, Enum.EasingStyle.Linear), {CFrame = hrp.CFrame + Vector3.new(0,3,0)}):Play()
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if bringBatteryEnabled then
        magnetBattery()
    end
end)

-- ================= Teleports Tab =================
local function teleportToPosition(pos)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

teleportsTab.newButton("End", "", function() teleportToPosition(Vector3.new(-645.96,1505.44,21.61)) end)
teleportsTab.newButton("Safezone", "", function() teleportToPosition(Vector3.new(-944.47,1014.38,55.65)) end)
teleportsTab.newButton("Nearby End", "", function() teleportToPosition(Vector3.new(-657.45,1505.44,21.10)) end)
teleportsTab.newButton("Boss Thanos", "", function() teleportToPosition(Vector3.new(-953.44,1106.38,-185.17)) end)
teleportsTab.newButton("Ayanokoji", "", function() teleportToPosition(Vector3.new(-1090.62,1395.38,304.09)) end)
teleportsTab.newButton("Batolomeo", "", function() teleportToPosition(Vector3.new(-1322.48,1240.66,-38.68)) end)
teleportsTab.newButton("Fujitora", "", function() teleportToPosition(Vector3.new(-1217.44,1404.38,78.68)) end)
teleportsTab.newButton("Kashimo", "", function() teleportToPosition(Vector3.new(-1203.41,1365.39,-85.41)) end)
teleportsTab.newButton("Noob", "", function() teleportToPosition(Vector3.new(-945.30,1014.38,177.37)) end)
teleportsTab.newButton("Saitama", "", function() teleportToPosition(Vector3.new(-1186.26,1240.68,197.13)) end)
teleportsTab.newButton("Yamato", "", function() teleportToPosition(Vector3.new(-1456.68,1365.56,-26.13)) end)

-- ================= Animations Tab =================
-- Axel Walk Loop
local axelAnim = Instance.new("Animation")
axelAnim.AnimationId = "rbxassetid://98044982170207"
local axelTrack = nil
animationsTab.newToggle("Axel Walk Loop", "", false, function(state)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if state then
        axelTrack = hum:LoadAnimation(axelAnim)
        axelTrack:Play()
        axelTrack.Looped = true
    else
        if axelTrack then
            axelTrack:Stop()
            axelTrack = nil
        end
    end
end)

-- Morph Cid
animationsTab.newButton("Morph Cid", "", function()
    local char = player.Character
    if not char then return end
    for _, v in pairs({
        game:GetService("ReplicatedStorage").Asset.Transform.Cid,
        game:GetService("ReplicatedStorage").Asset.Character.Cid,
        game:GetService("ReplicatedStorage").Asset.Transform
    }) do
        if v then
            v:Clone().Parent = char
        end
    end
end)

-- Anti Broly/Cid Cut Scene (Button ลบครั้งเดียว)
animationsTab.newButton("Remove Broly/Cid Cut Scene", "", function()
    local broly = workspace:FindFirstChild("Broly")
    if broly then broly:Destroy() end
    local cid = workspace:FindFirstChild("Cid")
    if cid then cid:Destroy() end
end)

-- ================= Misc Tab =================
-- Speed Tool
local boostspeed = 160
local ospeed = 16
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local bool = Instance.new("BoolValue")
bool.Value = false
local tool = Instance.new("Tool")
tool.Name = "speedboost"
tool.RequiresHandle = false
tool.Parent = player.Backpack

tool.Equipped:Connect(function() bool.Value = true end)
tool.Unequipped:Connect(function() bool.Value = false end)

bool:GetPropertyChangedSignal("Value"):Connect(function()
    if bool.Value then
        hum.WalkSpeed = boostspeed
    else
        hum.WalkSpeed = ospeed
    end
end)

-- Infinite Jump
local infJump = false
miscTab.newToggle("Infinite Jump", "", false, function(state)
    infJump = state
end)
UserInputService.JumpRequest:Connect(function()
    if infJump and player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
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
