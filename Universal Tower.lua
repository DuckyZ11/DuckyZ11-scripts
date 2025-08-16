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

-- ===========================
-- Main Tab
-- ===========================

-- Auto Tower Function
local function autoTowerFunction()
    local TowerEvent = workspace:FindFirstChild("TowerEvent")
    if not TowerEvent then return end
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
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

-- Anti Stun (loop)
local antiStunConnection
mainTab.newButton("Anti Stun", "", function()
    if antiStunConnection then antiStunConnection:Disconnect() end
    antiStunConnection = RunService.Heartbeat:Connect(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
        end)
    end)
end)

-- Anti Thanos Boss (loop + remove damage)
local antiThanosConnection
mainTab.newButton("Anti Thanos Boss", "", function()
    if antiThanosConnection then antiThanosConnection:Disconnect() end
    antiThanosConnection = RunService.Heartbeat:Connect(function()
        local assets = workspace:FindFirstChild("FX")
        local bossAssets = game:GetService("ReplicatedStorage").AssetBossFight
        if assets then
            for _, child in pairs(assets:GetChildren()) do
                if child.Name:match("Power") or child.Name=="Meteor" or child.Name=="Lighting" or child.Name=="Warning" or child.Name=="Lava" then
                    child:Destroy()
                end
            end
        end
        -- Remove damage parts
        local toRemove = {"Lava","Explosion","Bullet","SpinDamage"}
        for _, name in pairs(toRemove) do
            if bossAssets:FindFirstChild(name) then
                for _, obj in pairs(bossAssets[name]:GetChildren()) do
                    if obj:IsA("BasePart") then obj:Destroy() end
                end
            end
        end
    end)
end)

-- Bring Battery (magnet)
local batteryConnection
mainTab.newButton("Bring Battery", "", function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local batteryFolder = game:GetService("ReplicatedStorage").AssetBossFight:FindFirstChild("Battery")
    if batteryFolder then
        for _, model in pairs(batteryFolder:GetChildren()) do
            if model:IsA("Model") then
                local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    primary.CFrame = hrp.CFrame + Vector3.new(0,3,0)
                end
            end
        end
    end
end)

-- ===========================
-- Teleports Tab
-- ===========================
local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        print("Teleported to "..name)
    end
end

teleportsTab.newButton("End", "", function() teleportToPosition(Vector3.new(-645.96,1505.44,21.61),"End") end)
teleportsTab.newButton("Safezone", "", function() teleportToPosition(Vector3.new(-944.47,1014.38,55.65),"Safezone") end)
teleportsTab.newButton("Nearby End","",function() teleportToPosition(Vector3.new(-657.45,1505.44,21.10),"Nearby End") end)
teleportsTab.newButton("Boss Thanos","",function() teleportToPosition(Vector3.new(-953.44,1106.38,-185.17),"Boss Thanos") end)
teleportsTab.newButton("Ayanokoji","",function() teleportToPosition(Vector3.new(-1090.62,1395.38,304.09),"Ayanokoji") end)
teleportsTab.newButton("Batolomeo","",function() teleportToPosition(Vector3.new(-1322.48,1240.66,-38.68),"Batolomeo") end)
teleportsTab.newButton("Fujitora","",function() teleportToPosition(Vector3.new(-1217.44,1404.38,78.68),"Fujitora") end)
teleportsTab.newButton("Kashimo","",function() teleportToPosition(Vector3.new(-1203.41,1365.39,-85.41),"Kashimo") end)
teleportsTab.newButton("Noob","",function() teleportToPosition(Vector3.new(-945.30,1014.38,177.37),"Noob") end)
teleportsTab.newButton("Saitama","",function() teleportToPosition(Vector3.new(-1186.26,1240.68,197.13),"Saitama") end)
teleportsTab.newButton("Yamato","",function() teleportToPosition(Vector3.new(-1456.68,1365.56,-26.13),"Yamato") end)

-- ===========================
-- Misc Tab
-- ===========================
-- Speed Tool
local boostspeed = 160
local ospeed = 16
local plr = player
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local bool = Instance.new("BoolValue")
bool.Value = false
local tool = Instance.new("Tool")
tool.Name = "Speed Boost"
tool.RequiresHandle = false
tool.Parent = plr.Backpack

tool.Equipped:Connect(function()
    bool.Value = true
end)
tool.Unequipped:Connect(function()
    bool.Value = false
end)
bool:GetPropertyChangedSignal("Value"):Connect(function()
    if bool.Value then
        hum.WalkSpeed = boostspeed
    else
        hum.WalkSpeed = ospeed
    end
end)

-- Infinite Jump
local infJump = false
miscTab.newToggle("Infinite Jump","",false,function(state)
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

-- Floating Part Button
miscTab.newButton("Floating Part","",function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
end)

-- Tp Save Position Button
miscTab.newButton("Tp Save Position","",function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/Tp%20Place%20GUI',true))()
end)

-- ===========================
-- Animations Tab
-- ===========================
-- Anti Cut Scene Broly & Cid
animationsTab.newButton("Anti Cut Scene Broly","",function()
    local camBroly = game:GetService("ReplicatedStorage").Asset.Animation.Cam:FindFirstChild("Broly")
    if camBroly and workspace:FindFirstChild(camBroly.Name) then
        workspace[camBroly.Name]:Destroy()
    end
end)

animationsTab.newButton("Anti Cut Scene Cid","",function()
    local camCid = game:GetService("ReplicatedStorage").Asset.Animation.Cam:FindFirstChild("Cid")
    if camCid and workspace:FindFirstChild(camCid.Name) then
        workspace[camCid.Name]:Destroy()
    end
end)

-- Axel Walks loop
local loopAnim = nil
animationsTab.newToggle("Axel Walks Loop","",false,function(state)
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    if state then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://98044982170207"
        loopAnim = humanoid:LoadAnimation(anim)
        loopAnim.Looped = true
        loopAnim:Play()
    else
        if loopAnim then loopAnim:Stop() loopAnim = nil end
    end
end)
