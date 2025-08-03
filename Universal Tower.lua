local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("DrRay", "Default")

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
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId

-- MAIN TAB
mainTab.newLabel("Soon")

-- TELEPORTS TAB
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

-- AUTO FARM WIN (OP) SYSTEM

-- ตัวแปร global เก็บสถานะและค่าต่างๆ (เก็บข้ามรีเกม)
getgenv().RemainingWins = getgenv().RemainingWins or 0
getgenv().AutoFarmWinEnabled = getgenv().AutoFarmWinEnabled or false
getgenv().AlreadyQueued = getgenv().AlreadyQueued or false

local function teleportToEnd()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        hrp.CFrame = CFrame.new(-645.96, 1505.44, 21.61) -- ตำแหน่ง End
        print("Teleported to End")
        return true
    else
        warn("HumanoidRootPart not found, teleport failed")
        return false
    end
end

-- Label แสดง Win เหลือแบบเรียลไทม์
local winsLabel = autoFarmTab.newLabel("Win เหลือ: " .. getgenv().RemainingWins)

-- Input สำหรับตั้งจำนวน Win
autoFarmTab.newInput("ตั้งจำนวน Win", "กรอกจำนวนรอบที่จะฟาร์ม", tostring(getgenv().RemainingWins), function(text)
    local num = tonumber(text)
    if num and num > 0 then
        getgenv().RemainingWins = num
        winsLabel:SetText("Win เหลือ: " .. getgenv().RemainingWins)
        print("ตั้งจำนวน Win เป็น: " .. num)
    else
        warn("กรุณากรอกเลขมากกว่า 0")
    end
end)

-- ฟังก์ชันทำ Auto Farm Win จริงๆ
local function startAutoFarmWin()
    task.spawn(function()
        while getgenv().AutoFarmWinEnabled and getgenv().RemainingWins > 0 do
            local success = teleportToEnd()
            if not success then
                wait(3) -- รอแล้วลองใหม่
                continue
            end

            print("รอคูลดาวน์ 15 วินาที...")
            local waitTime = 15
            for i = waitTime, 1, -1 do
                winsLabel:SetText("Win เหลือ: " .. getgenv().RemainingWins .. " | รีเฟรชใน " .. i .. " วินาที")
                wait(1)
            end

            -- ตั้ง queue_on_teleport เพื่อโหลดสคริปต์ใหม่หลังรีเกม
            if not getgenv().AlreadyQueued then
                getgenv().AlreadyQueued = true
                queue_on_teleport([[
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower.lua"))()
                ]])
            end

            getgenv().RemainingWins -= 1
            print("Win เหลือ: " .. getgenv().RemainingWins)

            -- รีเกม (teleport)
            TeleportService:Teleport(PlaceId, player)

            -- รอรีเกมนานมาก ๆ เพื่อหยุด loop (เพราะเกมจะรีสตาร์ท)
            wait(99999)
        end

        -- ถ้าวินหมด ให้ปิด toggle และแจ้งเตือน
        if getgenv().RemainingWins <= 0 then
            winsLabel:SetText("Auto Farm Win (OP) เสร็จสิ้น!")
            print("Auto Farm Win (OP) ทำงานเสร็จแล้ว")
            getgenv().AutoFarmWinEnabled = false
            getgenv().AlreadyQueued = false
        end
    end)
end

-- Toggle เปิด/ปิด Auto Farm Win
autoFarmTab.newToggle("Auto Farm Win (OP)", "เปิด/ปิดระบบออโต้ฟาร์ม Win", getgenv().AutoFarmWinEnabled, function(state)
    getgenv().AutoFarmWinEnabled = state

    if state then
        if getgenv().RemainingWins <= 0 then
            warn("ยังไม่ได้ตั้งจำนวน Win หรือจำนวนไม่ถูกต้อง")
            -- ปิด toggle กลับถ้าเปิดโดยไม่ตั้งจำนวน
            autoFarmTab.setToggle("Auto Farm Win (OP)", false)
            return
        end
        print("เริ่ม Auto Farm Win (OP)")
        startAutoFarmWin()
    else
        print("หยุด Auto Farm Win (OP)")
    end
end)

-- ถ้าโหลดสคริปต์มาใหม่ และเปิด Auto Farm ค้างไว้ ให้เริ่มทำงานต่อทันที
task.spawn(function()
    if getgenv().AutoFarmWinEnabled and getgenv().RemainingWins > 0 then
        print("ทำงานต่อ Auto Farm Win (OP)... Win เหลือ: " .. getgenv().RemainingWins)
        autoFarmTab.setToggle("Auto Farm Win (OP)", true)
    end
end)

-- MISC FEATURES
-- Kill Yourself
miscTab.newButton("Kill Yourself", "", function()
    local h = player.Character and player.Character:FindFirstChild("Humanoid")
    if h then h.Health = 0 end
end)

-- WalkSpeed Input + Toggle
local walkSpeedValue = getgenv().SavedWalkSpeed or 16
local walkSpeedToggleState = false

miscTab.newInput("Set WalkSpeed", "กรอกเลขความเร็วเดิน", function(text)
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
