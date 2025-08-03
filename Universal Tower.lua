-- โหลด UI Library local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))() local window = DrRayLibrary:Load("DrRay", "Default")

-- ปรับขนาด UI ประมาณ 29% task.defer(function() local mainFrame = window:FindFirstChild("MainFrame") or window:FindFirstChildWhichIsA("Frame") if mainFrame then mainFrame.Size = UDim2.new(0.29, 0, 0.29, 0) mainFrame.Position = UDim2.new(0.35, 0, 0.35, 0) end end)

local mainTab = DrRayLibrary.newTab("Main", "rbxassetid://6031763426") local teleportsTab = DrRayLibrary.newTab("Teleports", "rbxassetid://6031071058") local autoFarmTab = DrRayLibrary.newTab("Auto Farm", "rbxassetid://6031244740") local miscTab = DrRayLibrary.newTab("Misc", "rbxassetid://6031071050")

local player = game.Players.LocalPlayer local TeleportService = game:GetService("TeleportService") local PlaceId = game.PlaceId local RunService = game:GetService("RunService") local UserInputService = game:GetService("UserInputService")

-- MAIN TAB mainTab.newLabel("Soon")

-- TELEPORTS TAB local function teleportToPosition(pos, name) if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(pos) print("Teleported to "..name) end end

teleportsTab.newButton("End", "", function() teleportToPosition(Vector3.new(-645.96, 1505.44, 21.61), "End") end) teleportsTab.newButton("Safezone", "", function() teleportToPosition(Vector3.new(-944.47, 1014.38, 55.65), "Safezone") end) teleportsTab.newButton("Get Unit 1", "", function() teleportToPosition(Vector3.new(-1090.60, 1395.38, 298.34), "Get Unit 1") end) teleportsTab.newButton("Get Unit 2", "", function() teleportToPosition(Vector3.new(-1318.05, 1240.66, -37.35), "Get Unit 2") end) teleportsTab.newButton("Get Unit 3", "", function() teleportToPosition(Vector3.new(-941.67, 1263.38, -167.66), "Get Unit 3") end) teleportsTab.newButton("Get Unit 4", "", function() teleportToPosition(Vector3.new(-1203.99, 1365.39, -90.20), "Get Unit 4") end) teleportsTab.newButton("Get Unit 5", "", function() teleportToPosition(Vector3.new(-945.93, 1014.38, 170.06), "Get Unit 5") end) teleportsTab.newButton("Get Unit 6", "", function() teleportToPosition(Vector3.new(-1186.58, 1240.68, 191.17), "Get Unit 6") end) teleportsTab.newButton("Get Unit 7", "", function() teleportToPosition(Vector3.new(-995.53, 1365.56, -286.45), "Get Unit 7") end)

-- AUTO FARM WIN OP getgenv().RemainingWins = getgenv().RemainingWins or 0 getgenv().AutoFarmWinEnabled = getgenv().AutoFarmWinEnabled or false getgenv().AlreadyQueued = getgenv().AlreadyQueued or false

local winsLabel = autoFarmTab.newLabel("Win เหลือ: " .. getgenv().RemainingWins)

local function teleportToEnd() if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then player.Character.HumanoidRootPart.CFrame = CFrame.new(-645.96, 1505.44, 21.61) print("Teleported to End") return true else warn("ไม่พบ HumanoidRootPart") return false end end

autoFarmTab.newInput("ตั้งจำนวน Win", "กรอกจำนวนรอบที่จะฟาร์ม", tostring(getgenv().RemainingWins), function(text) local num = tonumber(text) if num and num > 0 then getgenv().RemainingWins = num winsLabel:SetText("Win เหลือ: " .. getgenv().RemainingWins) print("ตั้งจำนวน Win: " .. num) else warn("กรุณากรอกเลขมากกว่า 0") end end)

local function startAutoFarmWin() task.spawn(function() while getgenv().AutoFarmWinEnabled and getgenv().RemainingWins > 0 do teleportToEnd() task.wait(12)

if not getgenv().AlreadyQueued then
            getgenv().AlreadyQueued = true
            queue_on_teleport([[loadstring(game:HttpGet("https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower.lua"))()]])
        end

        getgenv().RemainingWins -= 1
        winsLabel:SetText("Win เหลือ: " .. getgenv().RemainingWins)

        TeleportService:Teleport(PlaceId, player)
        break
    end

    if getgenv().RemainingWins <= 0 then
        winsLabel:SetText("Auto Farm Win (OP) เสร็จสิ้น!")
        print("Auto Farm Win (OP) เสร็จสิ้น")
        getgenv().AutoFarmWinEnabled = false
        getgenv().AlreadyQueued = false
    end
end)

end

autoFarmTab.newToggle("Auto Farm Win (OP)", "เปิด/ปิด Auto Farm Win", getgenv().AutoFarmWinEnabled, function(state) getgenv().AutoFarmWinEnabled = state

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

-- MISC TAB miscTab.newButton("Kill Yourself", "", function() local h = player.Character and player.Character:FindFirstChild("Humanoid") if h then h.Health = 0 end end)

local walkSpeedValue = getgenv().SavedWalkSpeed or 16 local walkSpeedToggleState = false

miscTab.newInput("Set WalkSpeed", "กรอกเลขความเร็วเดิน", tostring(walkSpeedValue), function(text) local num = tonumber(text) if num and num >= 0 and num <= 500 then walkSpeedValue = num getgenv().SavedWalkSpeed = num if walkSpeedToggleState then local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = walkSpeedValue end end end end)

miscTab.newToggle("Enable WalkSpeed", "เปิด/ปิดความเร็ว", false, function(state) walkSpeedToggleState = state local h = player.Character and player.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed = state and walkSpeedValue or 16 end end)

local noclipParts, noclipConn = {}, nil miscTab.newToggle("No-Clip", "ทะลุกำแพง", false, function(state) if state then noclipConn = RunService.Stepped:Connect(function() for _, part in pairs(player.Character:GetChildren()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" and part.CanCollide then part.CanCollide = false table.insert(noclipParts, part) end end end) else if noclipConn then noclipConn:Disconnect() end for _, part in pairs(noclipParts) do if part and part.Parent then part.CanCollide = true end end noclipParts = {} end end)

local infJump = false miscTab.newToggle("Infinite Jump", "กระโดดไม่จำกัด", false, function(state) infJump = state end)

UserInputService.JumpRequest:Connect(function() if infJump and player.Character then local h = player.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

