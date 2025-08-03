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
        queue_on_teleport([[
            local Players = game:GetService("Players")
            local TeleportService = game:GetService("TeleportService")
            local RunService = game:GetService("RunService")

            local player = Players.LocalPlayer
            local placeId = game.PlaceId

            local function waitForCharacter()
                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
                    player.CharacterAdded:Wait()
                    repeat task.wait() until player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                end
            end

            local function teleportToEnd()
                waitForCharacter()
                local hrp = player.Character:WaitForChild("HumanoidRootPart")
                hrp.CFrame = CFrame.new(-645.96, 1505.44, 21.61)
                print("[AutoFarm] วาร์ปไป End แล้ว")
            end

            local function walkRightFor(seconds)
                local connection = RunService.RenderStepped:Connect(function()
                    player:Move(Vector3.new(1, 0, 0), true)
                end)
                task.wait(seconds)
                connection:Disconnect()
                player:Move(Vector3.zero, false)
            end

            local function autoFarmLoop()
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
                    TeleportService:Teleport(placeId)
                    break
                end
            end

            autoFarmLoop()
        ]])
        TeleportService:Teleport(placeId)
        break
    end
end

autoFarmLoop()
