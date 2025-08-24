local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2zu/OPEN-SOURCE-UI-ROBLOX/refs/heads/main/X2ZU%20UI%20ROBLOX%20OPEN%20SOURCE/DummyUi-leak-by-x2zu/fetching-main/Tools/Framework.luau"))()

-- Main Window
local Window = Library:Window({
    Title = "Universal Tower [DuckyHub]",
    Desc = "Premium Version",
    Icon = 111020520855538,
    Theme = "Dark",
    Config = {
        Keybind = Enum.KeyCode.LeftControl,
        Size = UDim2.new(0, 500, 0, 400)
    },
    CloseUIButton = {
        Enabled = true,
        Text = "close"
    }
})

-- Services
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

----------------------------------------------------------------------
-- MAIN TAB
----------------------------------------------------------------------
local MainTab = Window:Tab({Title = "Main", Icon = "star"})

-- Auto Tower
MainTab:Button({
    Title = "Auto Tower",
    Desc = "Teleport to unlocked tower",
    Callback = function()
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
})

-- Anti Stun
MainTab:Button({
    Title = "Anti Stun",
    Desc = "Prevent stuns",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower%20Anti%20Stuns"))()
    end
})

----------------------------------------------------------------------
-- TELEPORTS TAB
----------------------------------------------------------------------
local Teleports = Window:Tab({Title = "Teleports", Icon = "map"})

local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        Window:Notify({Title = "Teleport", Desc = "Teleported to "..name, Time = 2})
    end
end

Teleports:Button({Title = "End", Callback = function() teleportToPosition(Vector3.new(-645.96,1505.44,21.61),"End") end})
Teleports:Button({Title = "Safezone", Callback = function() teleportToPosition(Vector3.new(-944.47,1014.38,55.65),"Safezone") end})
Teleports:Button({Title = "Nearby End", Callback = function() teleportToPosition(Vector3.new(-657.45,1505.44,21.10),"Nearby End") end})
Teleports:Button({Title = "Boss Thanos", Callback = function() teleportToPosition(Vector3.new(-953.44,1106.38,-185.17),"Boss Thanos") end})
Teleports:Button({Title = "Ayanokoji", Callback = function() teleportToPosition(Vector3.new(-1090.62,1395.38,304.09),"Ayanokoji") end})
Teleports:Button({Title = "Batolomeo", Callback = function() teleportToPosition(Vector3.new(-1322.48,1240.66,-38.68),"Batolomeo") end})
Teleports:Button({Title = "Fujitora", Callback = function() teleportToPosition(Vector3.new(-1217.44,1404.38,78.68),"Fujitora") end})
Teleports:Button({Title = "Kashimo", Callback = function() teleportToPosition(Vector3.new(-1203.41,1365.39,-85.41),"Kashimo") end})
Teleports:Button({Title = "Noob", Callback = function() teleportToPosition(Vector3.new(-945.30,1014.38,177.37),"Noob") end})
Teleports:Button({Title = "Saitama", Callback = function() teleportToPosition(Vector3.new(-1186.26,1240.68,197.13),"Saitama") end})
Teleports:Button({Title = "Yamato", Callback = function() teleportToPosition(Vector3.new(-1456.68,1365.56,-26.13),"Yamato") end})

----------------------------------------------------------------------
-- ANIMATIONS TAB
----------------------------------------------------------------------
local Animations = Window:Tab({Title = "Animations", Icon = "film"})

local axelAnim = nil
Animations:Toggle({
    Title = "Axel Walks",
    Value = false,
    Callback = function(state)
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
    end
})

-- Dodge Animations
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
Animations:Toggle({
    Title = "Dodge Animations",
    Value = false,
    Callback = function(state)
        dodgeLoop = state
        if dodgeLoop then
            task.spawn(function()
                while dodgeLoop do
                    local id = DodgeAnimations[math.random(1, #DodgeAnimations)]
                    local track = playAnimOnce(id)
                    task.wait((track and track.Length or 1) + 1.2)
                end
            end)
        end
    end
})

local gokuLoop = false
Animations:Toggle({
    Title = "Goku UI Animation",
    Value = false,
    Callback = function(state)
        gokuLoop = state
        if gokuLoop then
            task.spawn(function()
                while gokuLoop do
                    local track = playAnimOnce(GokuAnimation)
                    task.wait((track and track.Length or 1) + 1.2)
                end
            end)
        end
    end
})

Animations:Button({
    Title = "Animations UI",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/UT%20animations"))()
    end
})

----------------------------------------------------------------------
-- MISC TAB
----------------------------------------------------------------------
local Misc = Window:Tab({Title = "Misc", Icon = "wrench"})

Misc:Button({
    Title = "Speed Tool",
    Callback = function()
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

        tool.Equipped:Connect(function() bool.Value = true end)
        tool.Unequipped:Connect(function() bool.Value = false end)
        bool:GetPropertyChangedSignal("Value"):Connect(function()
            if bool.Value then hum.WalkSpeed = boostspeed else hum.WalkSpeed = ospeed end
        end)
    end
})

Misc:Toggle({
    Title = "Infinite Jump",
    Value = false,
    Callback = function(state)
        local infJump = state
        UserInputService.JumpRequest:Connect(function()
            if infJump and player.Character then
                local h = player.Character:FindFirstChildOfClass("Humanoid")
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end
        end)
    end
})

Misc:Button({Title = "Floating Part", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/GhostPlayer352/Test4/main/Float'))() end})
Misc:Button({Title = "Tp Save Position", Callback = function() loadstring(game:HttpGet('https://raw.githubusercontent.com/0Ben1/fe/main/Tp%20Place%20GUI',true))() end})
Misc:Button({Title = "Tp To Players", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Tp%20to%20players"))() end})
Misc:Button({Title = "Anti touchable parts", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Mautiku/ehh/main/remove%20touchable%20parts.txt",true))() end})

----------------------------------------------------------------------
-- Final Notify
----------------------------------------------------------------------
Window:Notify({
    Title = "Universal Tower",
    Desc = "Loaded successfully",
    Time = 4
})
