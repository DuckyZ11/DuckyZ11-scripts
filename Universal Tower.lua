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
local antistunTab = DrRayLibrary.newTab("Antistun", "rbxassetid://6031244740")
local miscTab = DrRayLibrary.newTab("Misc", "rbxassetid://6031071050")

local player = game.Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PlaceId = game.PlaceId

-- Magnet Battery (All Range)
local magnetBattery = false
local magnetConnection = nil
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Linear)

local function magnetizeBatteryFromFolder()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local folder = workspace:FindFirstChild("FX") and workspace.FX:FindFirstChild("BatteryModel")
    if folder then
        for _, model in ipairs(folder:GetChildren()) do
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

mainTab.newToggle("Magnet Battery (All Range)", "ดูดแบตจาก FX/BatteryModel เข้าใกล้ตัว", false, function(state)
    magnetBattery = state
    if state then
        magnetizeBatteryFromFolder()
        local batteryFolder = workspace:FindFirstChild("FX") and workspace.FX:FindFirstChild("BatteryModel")
        if batteryFolder then
            magnetConnection = batteryFolder.DescendantAdded:Connect(descendantAddedToBatteryModel)
        end
    else
        if magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
    end
end)

-- ปุ่ม Tower Event
local function teleportToUnlocked()
    local TowerEvent = workspace:FindFirstChild("TowerEvent")
    if not TowerEvent then return end
    for _, obj in pairs(TowerEvent:GetDescendants()) do
        if obj:IsA("BillboardGui") then
            local textLabel = obj:FindFirstChild("TextLabel")
            if textLabel and textLabel.Text == "Unlocked!!" then
                local adornee = obj.Adornee
                local pos = adornee and adornee.Position or (obj.Parent:IsA("BasePart") and obj.Parent.Position)
                if pos then
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
                    end
                    return
                end
            end
        end
    end
end

mainTab.newButton("Teleport to Unlocked Tower", "วาปไปตำแหน่ง Unlocked!!", teleportToUnlocked)

-- TELEPORTS TAB
local function teleportToPosition(pos)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
    end
end

teleportsTab.newButton("End", "", function()
    teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61))
end)

teleportsTab.newButton("Safezone", "", function()
    teleportToPosition(Vector3.new(-944.47, 1014.38, 55.65))
end)

teleportsTab.newButton("Nearby end", "", function()
    teleportToPosition(Vector3.new(-657.45, 1505.44, 21.10))
end)

teleportsTab.newButton("Get Unit 1", "", function()
    teleportToPosition(Vector3.new(-1090.60, 1395.38, 298.34))
end)

teleportsTab.newButton("Get Unit 2", "", function()
    teleportToPosition(Vector3.new(-1318.05, 1240.66, -37.35))
end)

teleportsTab.newButton("Get Unit 3", "", function()
    teleportToPosition(Vector3.new(-941.67, 1263.38, -167.66))
end)

teleportsTab.newButton("Get Unit 4", "", function()
    teleportToPosition(Vector3.new(-1203.99, 1365.39, -90.20))
end)

teleportsTab.newButton("Get Unit 5", "", function()
    teleportToPosition(Vector3.new(-945.93, 1014.38, 170.06))
end)

teleportsTab.newButton("Get Unit 6", "", function()
    teleportToPosition(Vector3.new(-1186.58, 1240.68, 191.17))
end)

teleportsTab.newButton("Get Unit 7", "", function()
    teleportToPosition(Vector3.new(-995.53, 1365.56, -286.45))
end)

-- Antistun
antistunTab.newButton("Click 1 time", "กันสตั้น", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
end)

-- MISC TAB
miscTab.newButton("Kill Yourself", "", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then
        h.Health = 0
    end
end)

-- NoClip
local noclipParts, noclipConn = {}, nil
miscTab.newToggle("No-Clip", "ทะลุกำแพง", false, function(state)
    if state then
        noclipConn = RunService.Stepped:Connect(function()
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
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
