local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("premium version", "Default")

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
local UserInputService = game:GetService("UserInputService")

-- Auto Tower
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

-- Teleports
local function teleportToPosition(pos, name)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
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

teleportsTab.newButton("Ayanokoji", "", function()
    teleportToPosition(Vector3.new(-1090.62, 1395.38, 304.09), "Ayanokoji")
end)

teleportsTab.newButton("Batolomeo", "", function()
    teleportToPosition(Vector3.new(-1322.48, 1240.66, -38.68), "Batolomeo")
end)

teleportsTab.newButton("Fujitora", "", function()
    teleportToPosition(Vector3.new(-1217.44, 1404.38, 78.68), "Fujitora")
end)

teleportsTab.newButton("Kashimo", "", function()
    teleportToPosition(Vector3.new(-1203.41, 1365.39, -85.41), "Kashimo")
end)

teleportsTab.newButton("Noob", "", function()
    teleportToPosition(Vector3.new(-945.30, 1014.38, 177.37), "Noob")
end)

teleportsTab.newButton("Saitama", "", function()
    teleportToPosition(Vector3.new(-1186.26, 1240.68, 197.13), "Saitama")
end)

teleportsTab.newButton("Yamato", "", function()
    teleportToPosition(Vector3.new(-1456.68, 1365.56, -26.13), "Yamato")
end)

-- Anti Stun
antistunTab.newButton("Anti Stun", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
end)

-- Misc
miscTab.newButton("Kill Yourself", "", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then h.Health = 0 end
end)

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

-- WalkSpeed
local walkSpeedValue = 50
local walkSpeedEnabled = false

miscTab.newTextBox("WalkSpeed Value", "", true, function(value)
    local num = tonumber(value)
    if num then
        walkSpeedValue = num
        if walkSpeedEnabled and player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = walkSpeedValue end
        end
    end
end)

miscTab.newToggle("Enable WalkSpeed", "", false, function(state)
    walkSpeedEnabled = state
    if player.Character then
        local h = player.Character:FindFirstChildOfClass("Humanoid")
        if h then
            if walkSpeedEnabled then
                h.WalkSpeed = walkSpeedValue
            else
                h.WalkSpeed = 16
            end
        end
    end
end)

-- Floating Part
miscTab.newButton("Floating Part", "", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
end)

-- Tp Save Position
miscTab.newButton("Tp Save Position", "", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/Tp%20Place%20GUI'))()
end)

-- Character Added connection to apply walk speed & inf jump dynamically
player.CharacterAdded:Connect(function(char)
    task.wait(1)
    local h = char:WaitForChild("Humanoid")
    if h then
        if walkSpeedEnabled then h.WalkSpeed = walkSpeedValue end
    end
end)
