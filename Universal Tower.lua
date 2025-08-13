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
local antistunTab = DrRayLibrary.newTab("Antistun", "rbxassetid://6031244740")
local miscTab = DrRayLibrary.newTab("Misc", "rbxassetid://6031071050")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Magnet Battery (All Range)
local magnetBattery = false
local magnetConnection = nil
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)

local function magnetizeBatteryFromFolder()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local folder1 = workspace:FindFirstChild("FX") and workspace.FX:FindFirstChild("BatteryModel")
    if folder1 then
        for _, model in ipairs(folder1:GetChildren()) do
            if model:IsA("Model") then
                local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local tween = TweenService:Create(primary, tweenInfo, {CFrame = hrp.CFrame + Vector3.new(0, 3, 0)})
                    tween:Play()
                end
            end
        end
    end

    local folder2 = game:GetService("ReplicatedStorage"):FindFirstChild("AssetBossFight") and game:GetService("ReplicatedStorage").AssetBossFight:FindFirstChild("Battery")
    if folder2 then
        for _, model in ipairs(folder2:GetChildren()) do
            if model:IsA("Model") then
                local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local tween = TweenService:Create(primary, tweenInfo, {CFrame = hrp.CFrame + Vector3.new(0, 3, 0)})
                    tween:Play()
                end
            end
        end
    end
end

local function descendantAddedToBatteryModel(desc)
    if desc:IsA("Model") then
        task.wait(0.1)
        magnetizeBatteryFromFolder()
    end
end

mainTab.newToggle("Magnet Battery (All Range)", "", false, function(state)
    magnetBattery = state
    if state then
        magnetizeBatteryFromFolder()
        local batteryFolder1 = workspace:FindFirstChild("FX") and workspace.FX:FindFirstChild("BatteryModel")
        if batteryFolder1 then
            magnetConnection = batteryFolder1.DescendantAdded:Connect(descendantAddedToBatteryModel)
        end
        local batteryFolder2 = game:GetService("ReplicatedStorage"):FindFirstChild("AssetBossFight") and game:GetService("ReplicatedStorage").AssetBossFight:FindFirstChild("Battery")
        if batteryFolder2 and not magnetConnection then
            magnetConnection = batteryFolder2.DescendantAdded:Connect(descendantAddedToBatteryModel)
        end
    else
        if magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
    end
end)

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
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
                    break
                end
            end
        end
    end
end

mainTab.newButton("Auto Tower", "", function()
    autoTowerFunction()
end)

-- Teleports Tab
local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

teleportsTab.newButton("End", "", function() teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61), "End") end)
teleportsTab.newButton("Safezone", "", function() teleportToPosition(Vector3.new(-944.47, 1014.38, 55.65), "Safezone") end)
teleportsTab.newButton("Nearby end", "", function() teleportToPosition(Vector3.new(-657.45, 1505.44, 21.10), "Nearby end") end)
teleportsTab.newButton("Get Unit 1", "", function() teleportToPosition(Vector3.new(-1090.60, 1395.38, 298.34), "Get Unit 1") end)
teleportsTab.newButton("Get Unit 2", "", function() teleportToPosition(Vector3.new(-1318.05, 1240.66, -37.35), "Get Unit 2") end)
teleportsTab.newButton("Get Unit 3", "", function() teleportToPosition(Vector3.new(-941.67, 1263.38, -167.66), "Get Unit 3") end)
teleportsTab.newButton("Get Unit 4", "", function() teleportToPosition(Vector3.new(-1203.99, 1365.39, -90.20), "Get Unit 4") end)
teleportsTab.newButton("Get Unit 5", "", function() teleportToPosition(Vector3.new(-945.93, 1014.38, 170.06), "Get Unit 5") end)
teleportsTab.newButton("Get Unit 6", "", function() teleportToPosition(Vector3.new(-1186.58, 1240.68, 191.17), "Get Unit 6") end)
teleportsTab.newButton("Get Unit 7", "", function() teleportToPosition(Vector3.new(-995.53, 1365.56, -286.45), "Get Unit 7") end)

-- Anti Stun Button
antistunTab.newButton("Anti Stun", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
end)

-- New AntiStun Features: Invincible / Infinite Dodge / Full Safezone
local invincibleEnabled, infDodgeEnabled, fullSafezoneEnabled = false, false, false

antistunTab.newToggle("Invincible", "", false, function(state) invincibleEnabled = state end)
antistunTab.newToggle("Infinite Dodge", "", false, function(state) infDodgeEnabled = state end)
antistunTab.newToggle("Full Safezone", "", false, function(state) fullSafezoneEnabled = state end)

RunService.Heartbeat:Connect(function()
    local character = player.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    if invincibleEnabled then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end

    if infDodgeEnabled then
        local anim = game:GetService("ReplicatedStorage").Asset.Animation:FindFirstChild("Dodge")
        local fx = game:GetService("ReplicatedStorage").Asset.FX:FindFirstChild("Toji"):FindFirstChild("Dodge")
        if fx then
            local clone = fx:Clone()
            clone.Parent = workspace
            clone.CFrame = hrp.CFrame
            clone:Destroy()
        end
    end

    if fullSafezoneEnabled then
        local part = workspace:FindFirstChild("SafeZone") and workspace.SafeZone:FindFirstChild("Part")
        if part then
            hrp.CFrame = part.CFrame + Vector3.new(0,3,0)
        end
    end
end)

-- MISC TAB
miscTab.newButton("Kill Yourself", "", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then h.Health = 0 end
end)

-- Infinite Jump Toggle
local infJump = false
miscTab.newToggle("Infinite Jump", "", false, function(state) infJump = state end)

UserInputService.JumpRequest:Connect(function()
    if infJump and player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)
