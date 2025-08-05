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
local autoFarmTab = DrRayLibrary.newTab("Auto Farm", "rbxassetid://6031244740")
local miscTab = DrRayLibrary.newTab("Misc", "rbxassetid://6031071050")

local player = game.Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PlaceId = game.PlaceId

-- ฟังก์ชันช่วยดูดแบต
local function tryMagnetizeBattery(batteryModel)
    if not batteryModel or not batteryModel.Parent then return end
    if batteryModel:IsA("Model") and batteryModel.Name == "Battery" then
        local primary = batteryModel.PrimaryPart or batteryModel:FindFirstChildWhichIsA("BasePart")
        if primary then
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                pcall(function()
                    primary.CFrame = CFrame.new(hrp.Position + Vector3.new(0, 2, 0))
                end)
            end
        end
    end
end

local magnetBattery = false
local magnetConnection = nil

mainTab.newToggle("Magnet Battery (All Range)", "ดูดแบตทั้งหมดในเกมเข้าหาตัวทันที", false, function(state)
    magnetBattery = state
    if state then
        -- ดึงแบตเก่าทั้งหมดตอนเปิด
        for _, v in ipairs(workspace:GetDescendants()) do
            tryMagnetizeBattery(v)
        end

        -- เชื่อม event ฟังตอนมีแบตใหม่โผล่
        magnetConnection = workspace.DescendantAdded:Connect(function(descendant)
            tryMagnetizeBattery(descendant)
        end)
    else
        -- ปิด event
        if magnetConnection then
            magnetConnection:Disconnect()
            magnetConnection = nil
        end
    end
end)

-- เพิ่มปุ่ม Tower Event ในแท็บ Main
mainTab.newButton("Tower Event", "วาร์ปไปจุด Tower Event พิเศษ", function()
    local towerEvent = workspace:FindFirstChild("TowerEvent")
    if towerEvent then
        local specialWeek = towerEvent:FindFirstChild("Special Week")
        if specialWeek and specialWeek:FindFirstChild("Special Week") then
            local block = specialWeek["Special Week"]:FindFirstChild("Block")
            if block and block:IsA("BasePart") then
                local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = block.CFrame + Vector3.new(0, 5, 0)
                    print("[TowerEvent] Teleported to Tower Event Block")
                end
            else
                warn("[TowerEvent] ไม่พบ Block ภายใน Special Week")
            end
        else
            warn("[TowerEvent] ไม่พบ Special Week -> Special Week")
        end
    else
        warn("[TowerEvent] ไม่พบ TowerEvent ใน workspace")
    end
end)

-- TELEPORTS TAB
local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        print("Teleported to " .. name)
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

-- AUTO FARM TAB
autoFarmTab.newLabel("🌀 Loop: Leave the game to stop")
autoFarmTab.newLabel("📘 Tutorial: ฟีเจอร์นี้จะทำงานซ้ำไปเรื่อย ๆ จนกว่าคุณจะออกจากเกม")

autoFarmTab.newButton("Auto Farm Win (Loop)", "ฟาร์ม Win วนลูปอัตโนมัติ", function()
    local success, err = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Auto%20farm%20win%20ut.lua"))()
    end)
    if not success then
        warn("โหลด Auto Farm Win (Loop) ไม่สำเร็จ: " .. tostring(err))
    end
end)

local autoFarmCode = [[
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

-- รอตัวละครโหลด
local function waitForCharacter()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        player.CharacterAdded:Wait()
        repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    end
end

-- วาร์ปไปตำแหน่ง End
local function teleportToEnd()
    waitForCharacter()
    local hrp = player.Character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(-645.96, 1505.44, 21.61)
    print("[AutoFarm] วาร์ปไป End แล้ว")
end

-- เดินไปทางขวา
local function walkRightFor(seconds)
    local connection = RunService.RenderStepped:Connect(function()
        player:Move(Vector3.new(1, 0, 0), true)
    end)
    task.wait(seconds)
    connection:Disconnect()
    player:Move(Vector3.zero, false)
end

-- วนลูปฟาร์ม
local function autoFarmLoop()
    print("[AutoFarm] เริ่มทำงานวนลูป...")
    while true do
        print("[AutoFarm] รอโหลดแมพ 6 วิ")
        task.wait(6)

        teleportToEnd()
        task.wait(2)

        walkRightFor(0.4)

        print("[AutoFarm] รอรับ Win 2 วิ")
        task.wait(2)

        print("[AutoFarm] รีจอย...")
        queue_on_teleport(script.Source)
        TeleportService:Teleport(PlaceId)
        break
    end
end

autoFarmLoop()
]]

autoFarmTab.newButton("Copy Script for Auto Execute (Delta)", "กดเพื่อคัดลอกโค้ดไปวางใน Auto Execute (Delta)", function()
    if setclipboard then
        setclipboard(autoFarmCode)
        print("[AutoFarm] คัดลอกโค้ดฟาร์มเข้าสู่คลิปบอร์ดแล้ว")
    else
        warn("ไม่รองรับฟังก์ชัน setclipboard บนเครื่องนี้")
    end
end)
autoFarmTab.newLabel("Copy this and put it on auto execute (Delta)")

-- MISC TAB
-- Kill Yourself
miscTab.newButton("Kill Yourself", "", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then
        h.Health = 0
    end
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
            if h then
                h.WalkSpeed = walkSpeedValue
            end
        end
    end
end)

miscTab.newToggle("Enable WalkSpeed", "เปิด/ปิดความเร็ว", walkSpeedToggleState, function(state)
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
