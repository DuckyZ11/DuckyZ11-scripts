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
local mainTab = window:NewTab("Main", "rbxassetid://6031763426")
local teleportsTab = window:NewTab("Teleports", "rbxassetid://6031071058")
local antistunTab = window:NewTab("Antistun", "rbxassetid://6031244740")
local miscTab = window:NewTab("Misc", "rbxassetid://6031071050")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ========== Main Tab ==========
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

mainTab:NewButton("Auto Tower", "", function()
    autoTowerFunction()
end)

-- ========== Teleports Tab ==========
local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        print("Teleported to " .. name)
    end
end

teleportsTab:NewButton("End", "", function() teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61), "End") end)
teleportsTab:NewButton("Safezone", "", function() teleportToPosition(Vector3.new(-944.47, 1014.38, 55.65), "Safezone") end)
teleportsTab:NewButton("Nearby End", "", function() teleportToPosition(Vector3.new(-657.45, 1505.44, 21.10), "Nearby End") end)
teleportsTab:NewButton("Boss Thanos", "", function() teleportToPosition(Vector3.new(-953.44, 1106.38, -185.17), "Boss Thanos") end)
teleportsTab:NewButton("Ayanokoji", "", function() teleportToPosition(Vector3.new(-1090.62, 1395.38, 304.09), "Ayanokoji") end)
teleportsTab:NewButton("Batolomeo", "", function() teleportToPosition(Vector3.new(-1322.48, 1240.66, -38.68), "Batolomeo") end)
teleportsTab:NewButton("Fujitora", "", function() teleportToPosition(Vector3.new(-1217.44, 1404.38, 78.68), "Fujitora") end)
teleportsTab:NewButton("Kashimo", "", function() teleportToPosition(Vector3.new(-1203.41, 1365.39, -85.41), "Kashimo") end)
teleportsTab:NewButton("Noob", "", function() teleportToPosition(Vector3.new(-945.30, 1014.38, 177.37), "Noob") end)
teleportsTab:NewButton("Saitama", "", function() teleportToPosition(Vector3.new(-1186.26, 1240.68, 197.13), "Saitama") end)
teleportsTab:NewButton("Yamato", "", function() teleportToPosition(Vector3.new(-1456.68, 1365.56, -26.13), "Yamato") end)

-- ========== Antistun Tab ==========
antistunTab:NewButton("Anti Stun", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
end)

-- ========== Misc Tab ==========
-- WalkSpeed Loop
getgenv().WalkSpeedValue = 16
local walkSpeedEnabled = false

miscTab:NewTextBox("Walk Speed", "Enter speed", function(val)
    getgenv().WalkSpeedValue = tonumber(val) or 16
end)

miscTab:NewToggle("Enable WalkSpeed Loop", "Loop until disabled", false, function(state)
    walkSpeedEnabled = state
end)

task.spawn(function()
    while true do
        task.wait(0.1)
        if walkSpeedEnabled and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = getgenv().WalkSpeedValue
            end
        end
    end
end)

-- Floating Part
miscTab:NewButton("Floating Part", "", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
end)

-- Tp Save Position
miscTab:NewButton("Tp Save Position", "", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/Tp%20Place%20GUI',true))()
end)

-- Infinite Jump
local infJump = false
miscTab:NewToggle("Infinite Jump", "", false, function(state)
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
