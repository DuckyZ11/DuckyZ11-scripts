local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("free version", "Default")  -- เปลี่ยนชื่อหน้าต่างตรงนี้

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
local PlaceId = game.PlaceId

-- MAIN TAB
mainTab.newLabel("Soon")

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
-- ลบปุ่มและฟังก์ชันในแท็บนี้ออกทั้งหมด
-- แทนที่ด้วยข้อความแจ้งว่า "Auto Farm Disabled"
autoFarmTab.newLabel("Auto Farm Disabled")

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
