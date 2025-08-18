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

-- Anti Stun
mainTab.newButton("Anti Stun", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
end)

-- Teleports
local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        print("Teleported to " .. name)
    end
end

teleportsTab.newButton("End", "", function() teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61), "End") end)
teleportsTab.newButton("Safezone", "", function() teleportToPosition(Vector3.new(-944.47, 1014.38, 55.65), "Safezone") end)
teleportsTab.newButton("Nearby End", "", function() teleportToPosition(Vector3.new(-657.45, 1505.44, 21.10), "Nearby End") end)
teleportsTab.newButton("Boss Thanos", "", function() teleportToPosition(Vector3.new(-953.44, 1106.38, -185.17), "Boss Thanos") end)
teleportsTab.newButton("Ayanokoji", "", function() teleportToPosition(Vector3.new(-1090.62, 1395.38, 304.09), "Ayanokoji") end)
teleportsTab.newButton("Batolomeo", "", function() teleportToPosition(Vector3.new(-1322.48, 1240.66, -38.68), "Batolomeo") end)
teleportsTab.newButton("Fujitora", "", function() teleportToPosition(Vector3.new(-1217.44, 1404.38, 78.68), "Fujitora") end)
teleportsTab.newButton("Kashimo", "", function() teleportToPosition(Vector3.new(-1203.41, 1365.39, -85.41), "Kashimo") end)
teleportsTab.newButton("Noob", "", function() teleportToPosition(Vector3.new(-945.30, 1014.38, 177.37), "Noob") end)
teleportsTab.newButton("Saitama", "", function() teleportToPosition(Vector3.new(-1186.26, 1240.68, 197.13), "Saitama") end)
teleportsTab.newButton("Yamato", "", function() teleportToPosition(Vector3.new(-1456.68, 1365.56, -26.13), "Yamato") end)

-- Animations
local axelAnim = nil

animationsTab.newToggle("Axel Walks", "", false, function(state)
    if not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildWhichIsA("Animator") or Instance.new("Animator", hum)

    if state then
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://98044982170207"
        local track = animator:LoadAnimation(anim)
        track.Looped = true
        track:Play()
        axelAnim = track
    else
        if axelAnim then
            axelAnim:Stop()
            axelAnim:Destroy()
            axelAnim = nil
        end
    end
end)

-- Dodge Animations IDs
local DodgeAnimations = {
    "rbxassetid://103080434658054",
    "rbxassetid://127692577072948",
    "rbxassetid://85895939846988",
    "rbxassetid://102979127301031",
    "rbxassetid://96639785369459"
}
local GokuAnimation = "rbxassetid://83245771145043"

local function playAnimOnce(id)
    if not player.Character then return end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = id
    local track = hum:LoadAnimation(anim)
    track.Looped = false
    track:Play()
    return track
end

local dodgeLoop = false
animationsTab.newToggle("Dodge Animations", "", false, function(state)
    dodgeLoop = state
    if dodgeLoop then
        spawn(function()
            while dodgeLoop do
                local id = DodgeAnimations[math.random(1, #DodgeAnimations)]
                local track = playAnimOnce(id)
                task.wait((track and track.Length or 1) + 1.2)
            end
        end)
    end
end)

local gokuLoop = false
animationsTab.newToggle("Goku UI Animation", "", false, function(state)
    gokuLoop = state
    if gokuLoop then
        spawn(function()
            while gokuLoop do
                local track = playAnimOnce(GokuAnimation)
                task.wait((track and track.Length or 1) + 1.2)
            end
        end)
    end
end)

-- Animations UI
animationsTab.newButton("Animations UI", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/UT%20animations"))()
end)

-- Misc
miscTab.newButton("Speed Tool", "", function()
    local boostspeed = 160
    local ospeed = 16
    local plr = game:GetService("Players").LocalPlayer
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
end)

miscTab.newToggle("Infinite Jump", "", false, function(state)
    local infJump = state
    UserInputService.JumpRequest:Connect(function()
        if infJump and player.Character then
            local h = player.Character:FindFirstChildOfClass("Humanoid")
            if h then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end)

miscTab.newButton("Floating Part", "", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))()
end)

miscTab.newButton("Tp Save Position", "", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/Tp%20Place%20GUI',true))()
end)

miscTab.newButton("Tp To Players", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Tp%20to%20players"))()
end)

miscTab.newButton("Anti touchable parts", "", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Mautiku/ehh/main/remove%20touchable%20parts.txt",true))()
end)
