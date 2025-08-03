local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("DrRay", "Default")

task.defer(function()
    local mainFrame = window:FindFirstChild("MainFrame") or window:FindFirstChildWhichIsA("Frame")
    if mainFrame then
        mainFrame.Size = UDim2.new(0.29, 0, 0.29, 0) -- ปรับขนาด UI ประมาณ 29%
        mainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
    end
end)

local mainTab = DrRayLibrary.newTab("Main", "rbxassetid://6031763426")
local teleportsTab = DrRayLibrary.newTab("Teleports", "rbxassetid://6031071058")
local autoFarmTab = DrRayLibrary.newTab("Auto Farm", "rbxassetid://6031244740")
local miscTab = DrRayLibrary.newTab("Misc", "rbxassetid://6031071050")

local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId

-- Main Tab
mainTab.newLabel("Soon")

-- Teleports Tab
local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        print("Teleported to "..name)
    end
end

teleportsTab.newButton("End", "", function()
    teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61), "End")
end)
teleportsTab.newButton("Safezone", "", function()
    teleportToPosition(Vector3.new(-944.47, 1014.38, 55.65), "Safezone")
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

-- Auto Farm Tab

-- Auto Farm (วาปตำแหน่งทุก 120 วิ)
local autoFarmEnabled = getgenv().AutoFarmEnabled or false
autoFarmTab.newToggle("Auto Farm (Warp every 120s)", "วาปไปตำแหน่งทุก 120 วินาที", autoFarmEnabled, function(state)
    autoFarmEnabled = state
    getgenv().AutoFarmEnabled = state
    if state then
        task.spawn(function()
            while getgenv().AutoFarmEnabled do
                teleportToPosition(Vector3.new(-945.93, 1014.38, 170.06), "Auto Farm Location")
                task.wait(120)
            end
        end)
    end
end)

-- Auto Farm Win (OP)
getgenv().RemainingWins = getgenv().RemainingWins or 0
getgenv().AlreadyQueued = getgenv().AlreadyQueued or false

autoFarmTab.newInput("Set Win Count", "กรอกจำนวนรอบที่ต้องฟาร์ม", tostring(getgenv().RemainingWins), function(text)
    local num = tonumber(text)
    if num and num > 0 then
        getgenv().RemainingWins = num
        print("ตั้งจำนวน Win เป็น: " .. num)
    else
        warn("กรุณากรอกเลขมากกว่า 0")
    end
end)

local autoFarmWinEnabled = getgenv().AutoFarmWinEnabled or false
autoFarmTab.newToggle("Auto Farm Win (OP)", "วาปไป End แล้วรีเกมตามจำนวนที่ตั้ง", autoFarmWinEnabled, function(state)
    autoFarmWinEnabled = state
    getgenv().AutoFarmWinEnabled = state
    if state then
        if getgenv().RemainingWins <= 0 then
            warn("ยังไม่ได้ตั้งจำนวน Win หรือเหลือ 0")
            autoFarmTab.setToggle("Auto Farm Win (OP)", false)
            return
        end
        task.spawn(function()
            while getgenv().AutoFarmWinEnabled and getgenv().RemainingWins > 0 do
                teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61), "End")
                task.wait(7)

                if not getgenv().AlreadyQueued then
                    getgenv().AlreadyQueued = true
                    queue_on_teleport([[
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower.lua"))()
                    ]])
                end

                getgenv().RemainingWins -= 1
                print("Win เหลือ: " .. getgenv().RemainingWins)
                TeleportService:Teleport(PlaceId, player)
                break
            end
        end)
    else
        print("Auto Farm Win (OP) ปิดแล้ว")
    end
end)

-- หากรีเกมมาให้รันออโต้ต่อถ้ามีสถานะ
task.spawn(function()
    if getgenv().AutoFarmWinEnabled and getgenv().RemainingWins and getgenv().RemainingWins > 0 then
        print("Resuming Auto Farm Win (OP)... Win เหลือ: " .. getgenv().RemainingWins)
        autoFarmWinEnabled = true
        autoFarmTab.setToggle("Auto Farm Win (OP)", true)
    end
    if getgenv().AutoFarmEnabled then
        print("Resuming Auto Farm (Warp every 120s)...")
        autoFarmEnabled = true
        autoFarmTab.setToggle("Auto Farm (Warp every 120s)", true)
    end
end)

-- Misc Tab

-- Kill Yourself
miscTab.newButton("Kill Yourself", "", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then h.Health = 0 end
end)

-- WalkSpeed Input + Toggle
local walkSpeedValue = getgenv().SavedWalkSpeed or 16
local walkSpeedToggleState = false

miscTab.newInput("Set WalkSpeed", "กรอกเลขความเร็วเดิน", tostring(walkSpeedValue), function(text)
    local num = tonumber(text)
    if num and num >= 0 and num <= 500 then
        walkSpeedValue = num
        getgenv().SavedWalkSpeed = num
        if walkSpeedToggleState then
            local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if h then h.WalkSpeed = walkSpeedValue end
        end
    end
end)

miscTab.newToggle("Enable WalkSpeed", "เปิด/ปิดความเร็ว", false, function(state)
    walkSpeedToggleState = state
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = state and walkSpeedValue or 16
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
        if noclipConn then noclipConn:Disconnect() end
        for _, part in pairs(noclipParts) do
            if part and part.Parent then part.CanCollide = true end
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
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)
