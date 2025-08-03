-- โหลด UI Library
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("DrRay", "Default")

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
local PlaceId = game.PlaceId
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ใช้ shared เก็บสถานะข้ามรีเกม (สำหรับ Delta Executor)
shared.AutoFarmWinData = shared.AutoFarmWinData or {
    RemainingWins = 0,
    AutoFarmWinEnabled = false
}

local function saveState()
    shared.AutoFarmWinData.RemainingWins = getgenv().RemainingWins
    shared.AutoFarmWinData.AutoFarmWinEnabled = getgenv().AutoFarmWinEnabled
end

local function loadState()
    getgenv().RemainingWins = shared.AutoFarmWinData.RemainingWins or 0
    getgenv().AutoFarmWinEnabled = shared.AutoFarmWinData.AutoFarmWinEnabled or false
end

loadState()

local winsLabel = autoFarmTab.newLabel("Win เหลือ: " .. getgenv().RemainingWins)

local function teleportToPosition(pos, name)
    if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        print("Teleported to " .. name)
        return true
    else
        warn("ไม่พบ HumanoidRootPart")
        return false
    end
end

-- TELEPORTS TAB ปุ่มวาปต่าง ๆ
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

-- AUTO FARM WIN OP
local function startAutoFarmWin()
    task.spawn(function()
        while getgenv().AutoFarmWinEnabled and getgenv().RemainingWins > 0 do
            local success = teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61), "End")
            if not success then
                warn("ไม่สามารถวาปไป End ได้")
                break
            end

            print("รอ " .. (10) .. " วินาที ก่อนรีเกม")
            wait(10) -- รอระบบทำงาน

            -- รีเกมเอง
            TeleportService:Teleport(PlaceId, player)

            -- ลดจำนวน Win
            getgenv().RemainingWins = getgenv().RemainingWins - 1
            winsLabel:SetText("Win เหลือ: " .. getgenv().RemainingWins)
            print("Win เหลือ: " .. getgenv().RemainingWins)

            saveState()

            break -- ออกจากลูป เพราะรีเกมแล้วจะโหลดสคริปต์ใหม่
        end

        if getgenv().RemainingWins <= 0 then
            winsLabel:SetText("Auto Farm Win (OP) เสร็จสิ้น!")
            print("Auto Farm Win (OP) เสร็จสิ้น")
            getgenv().AutoFarmWinEnabled = false
            saveState()
            autoFarmTab.setToggle("Auto Farm Win (OP)", false)
        end
    end)
end

-- UI ตั้งจำนวน Win และ Toggle Auto Farm
autoFarmTab.newInput("ตั้งจำนวน Win", "กรอกจำนวนรอบที่จะฟาร์ม", tostring(getgenv().RemainingWins), function(text)
    local num = tonumber(text)
    if num and num > 0 then
        getgenv().RemainingWins = num
        winsLabel:SetText("Win เหลือ: " .. getgenv().RemainingWins)
        print("ตั้งจำนวน Win: " .. num)
        saveState()
    else
        warn("กรุณากรอกเลขมากกว่า 0")
    end
end)

autoFarmTab.newToggle("Auto Farm Win (OP)", "เปิด/ปิด Auto Farm Win", getgenv().AutoFarmWinEnabled, function(state)
    getgenv().AutoFarmWinEnabled = state
    saveState()
    if state then
        if getgenv().RemainingWins <= 0 then
            warn("กรุณาตั้งจำนวน Win ก่อนเปิดใช้งาน")
            autoFarmTab.setToggle("Auto Farm Win (OP)", false)
            return
        end
        print("เริ่ม Auto Farm Win (OP)")
        startAutoFarmWin()
    else
        print("ปิด Auto Farm Win (OP)")
    end
end)

-- รันออโต้ตอนเริ่มเกมถ้าตั้ง AutoFarm ไว้
if getgenv().AutoFarmWinEnabled and getgenv().RemainingWins > 0 then
    startAutoFarmWin()
end

-- MISC TAB ตัวอย่างอื่นๆ
miscTab.newButton("Kill Yourself", "", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then
        h.Health = 0
    end
end)

local walkSpeedValue = getgenv().SavedWalkSpeed or 16
local walkSpeedToggleState = false

local function updateWalkSpeed()
    local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if h then
        h.WalkSpeed = walkSpeedToggleState and walkSpeedValue or 16
    end
end

miscTab.newInput("Set WalkSpeed", "กรอกเลขความเร็วเดิน", tostring(walkSpeedValue), function(text)
    local num = tonumber(text)
    if num and num >= 0 and num <= 500 then
        walkSpeedValue = num
        getgenv().SavedWalkSpeed = num
        if walkSpeedToggleState then
            updateWalkSpeed()
        end
    else
        warn("กรุณากรอกเลขระหว่าง 0-500")
    end
end)

miscTab.newToggle("Enable WalkSpeed", "เปิด/ปิดความเร็ว", false, function(state)
    walkSpeedToggleState = state
    updateWalkSpeed()
end)

local noclipParts, noclipConn = {}, nil

local function enableNoclip()
    noclipConn = RunService.Stepped:Connect(function()
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.CanCollide then
                    part.CanCollide = false
                    table.insert(noclipParts, part)
                end
            end
        end
    end)
end

local function disableNoclip()
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

miscTab.newToggle("No-Clip", "ทะลุกำแพง", false, function(state)
    if state then
        enableNoclip()
    else
        disableNoclip()
    end
end)

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

-- รีเซ็ต WalkSpeed และ NoClip เวลาตัวละคร Respawn
player.CharacterAdded:Connect(function(char)
    wait(1) -- รอโหลดตัวละคร
    updateWalkSpeed()
    if noclipConn then
        disableNoclip()
        enableNoclip()
    end
end)
