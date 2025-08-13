local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("premium version", "Default")

-- ปรับขนาด UI ประมาณ 29%
task.defer(function()
    local mainFrame = window:FindFirstChild("MainFrame") or window:FindFirstChildWhichIsA("Frame")
    if mainFrame then
        mainFrame.Size = UDim2.new(0.29, 0, 0.29, 0)
        mainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
    end
end)

local mainTab = DrRayLibrary.newTab("Main", "rbxassetid://6031763426")
local teleportsTab = DrRayLibrary.newTab("Teleports", "rbxassetid://6031071058")
local antistunTab = DrRayLibrary.newTab("Antistun", "rbxassetid://6031244740") -- แท็บเดียวสำหรับกันสตั้น + Anti Thanos
local miscTab = DrRayLibrary.newTab("Misc", "rbxassetid://6031071050")

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local FX = workspace:FindFirstChild("FX")
local PlaceId = game.PlaceId

-- Magnet Battery (All Range) from workspace.FX.BatteryModel and ReplicatedStorage.AssetBossFight.Battery
local magnetBattery = false
local magnetConnection = nil
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)

local function magnetizeBatteryFromFolder()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- ดูดจาก workspace.FX.BatteryModel
    local folder1 = workspace:FindFirstChild("FX") and workspace.FX:FindFirstChild("BatteryModel")
    if folder1 then
        for _, model in ipairs(folder1:GetChildren()) do
            if model:IsA("Model") then
                local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local tween = TweenService:Create(primary, tweenInfo, {
                        CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                    })
                    tween:Play()
                end
            end
        end
    end

    -- ดูดจาก ReplicatedStorage.AssetBossFight.Battery
    local folder2 = ReplicatedStorage:FindFirstChild("AssetBossFight") and ReplicatedStorage.AssetBossFight:FindFirstChild("Battery")
    if folder2 then
        for _, model in ipairs(folder2:GetChildren()) do
            if model:IsA("Model") then
                local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                if primary then
                    local tween = TweenService:Create(primary, tweenInfo, {
                        CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                    })
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

mainTab.newToggle("Magnet Battery (All Range)", "ดูดแบตจาก FX/BatteryModel และ ReplicatedStorage เข้าใกล้ตัว", false, function(state)
    magnetBattery = state
    if state then
        magnetizeBatteryFromFolder()
        local batteryFolder1 = workspace:FindFirstChild("FX") and workspace.FX:FindFirstChild("BatteryModel")
        if batteryFolder1 then
            magnetConnection = batteryFolder1.DescendantAdded:Connect(descendantAddedToBatteryModel)
        end
        local batteryFolder2 = ReplicatedStorage:FindFirstChild("AssetBossFight") and ReplicatedStorage.AssetBossFight:FindFirstChild("Battery")
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

-- เพิ่มปุ่ม Tower Event ในแท็บ Main
local function teleportToUnlocked()
    local TowerEvent = workspace:FindFirstChild("TowerEvent")
    if not TowerEvent then
        warn("ไม่พบ TowerEvent ใน workspace")
        return
    end

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
                    local character = player.Character or player.CharacterAdded:Wait()
                    local hrp = character:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
                    -- print("วาปไปที่ Unlocked!!")
                    return
                end
            end
        end
    end
    warn("ไม่พบตำแหน่ง 'Unlocked!!' ตอนนี้")
end

mainTab.newButton("Teleport to Unlocked Tower", "วาปไปตำแหน่ง Unlocked!! ตัวแรกที่เจอ", function()
    teleportToUnlocked()
end)

-- TELEPORTS TAB
local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        -- print("Teleported to " .. name)
    end
end

teleportsTab.newButton("End", "", function()
    teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61), "End")
end)

teleportsTab.newButton("Safezone", "", function()
    teleportToPosition(Vector3.new(-944.47, 1014.38, 55.65), "Safezone")
end)

teleportsTab.newButton("Nearby end", "", function()
    teleportToPosition(Vector3.new(-657.45, 1505.44, 21.10), "Nearby end")
end)

teleportsTab.newButton("Get Unit 1", "", function()
    teleportToPosition(Vector3.new(-1090.60, 1395.38, 298.34), "Get Unit 1")
end)

teleportsTab.newButton("Get Unit 2", "", function()
    teleportToPosition(Vector3.new(-1318.05, 1240.66, -37.35), "Get Unit 2")
end)

teleportsTab.newButton("Get Unit 3", "", function()
    teleportToPosition(Vector3.new(-941.67, 1263.38, -167.66), "Get Unit 3")
end)

teleportsTab.newButton("Get Unit 4", "", function()
    teleportToPosition(Vector3.new(-1203.99, 1365.39, -90.20), "Get Unit 4")
end)

teleportsTab.newButton("Get Unit 5", "", function()
    teleportToPosition(Vector3.new(-945.93, 1014.38, 170.06), "Get Unit 5")
end)

teleportsTab.newButton("Get Unit 6", "", function()
    teleportToPosition(Vector3.new(-1186.58, 1240.68, 191.17), "Get Unit 6")
end)

teleportsTab.newButton("Get Unit 7", "", function()
    teleportToPosition(Vector3.new(-995.53, 1365.56, -286.45), "Get Unit 7")
end)

-- === Antistun Tab ===

-- ตัวแปรเก็บสถานะ toggle
local antiThanosBossEnabled = false
local antiThanosPlayerEnabled = false

-- Toggle Anti Thanos Boss
antistunTab.newToggle("Anti Thanos Boss", "ลบสกิลและเอฟเฟคบอสธานอสทั้งหมด", false, function(state)
    antiThanosBossEnabled = state
    if state then
        -- ลบเอฟเฟคบอสธานอสทิ้งทั้งหมด
        if FX then
            for _, child in pairs(FX:GetChildren()) do
                if child.Name:match("Power") or child.Name == "Meteor" or child.Name == "Lighting" or child.Name == "Warning" or child.Name == "Lava" then
                    child:Destroy()
                end
            end
        end
    end
end)

-- Toggle Anti Thanos Player
antistunTab.newToggle("Anti Thanos Player", "กันคนอื่นใช้สกิล Thanos กดเราให้ตาย", false, function(state)
    antiThanosPlayerEnabled = state
end)

-- ปุ่ม Antistuns (โหลดจากลิงก์เดิม)
antistunTab.newButton("Antistuns", "กันสตั้น", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
end)

-- ฟังชั่นดัก RemoteEvent ของ Thanos Player สกิล เพื่อกันไม่ให้กดเราแล้วตาย
local remoteAction = ReplicatedStorage:WaitForChild("Remote"):WaitForChild("Action")

remoteAction.OnClientEvent:Connect(function(actionType, actionName, targetCharacter)
    if antiThanosPlayerEnabled and actionType == "Thanos" and actionName == "click" and targetCharacter == player.Character then
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.Health > 0 then
            -- รีเซ็ตเลือดเพื่อไม่ให้ตาย
            humanoid.Health = humanoid.MaxHealth
        end
    end
end)

-- MISC TAB
miscTab.newButton("Kill Yourself", "", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then
        h.Health = 0
    end
end)

-- NoClip Toggle
local noclipParts, noclipConn = {}, nil

miscTab.newToggle("No-Clip", "ทะลุกำแพง", false, function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.CanCollide then
                    part.CanCollide = false
                    table.insert(noclipParts, part)
                end
            end
        end)
    else
        if noclipConn then
            noclipConn:Disconnect()
            noclipConn = nil
        end
        for _, part in pairs(noclipParts) do
            if part and part.Parent then
                part.CanCollide = true
            end
        end
        noclipParts = {}
    end
end)

-- Infinite Jump
local infJump = false

miscTab.newToggle("Infinite Jump", "กระโดดไม่จำกัด", false, function(state)
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
