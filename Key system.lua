local premiumKey = "premium_ducky"
local scriptUrl = "https://raw.githubusercontent.com/DuckyZ11/DuckyZ11-scripts/refs/heads/main/Universal%20Tower.lua"

local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
local TextBox = Instance.new("TextBox", Frame)
local Button = Instance.new("TextButton", Frame)

Frame.Size = UDim2.new(0, 300, 0, 120)
Frame.Position = UDim2.new(0.4, 0, 0.35, 0)
Frame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Frame.Active = true
Frame.Draggable = true

TextBox.Size = UDim2.new(0.8, 0, 0, 30)
TextBox.Position = UDim2.new(0.1, 0, 0.2, 0)
TextBox.PlaceholderText = "Enter Premium Key"
TextBox.ClearTextOnFocus = false
TextBox.TextSize = 18

Button.Size = UDim2.new(0.8, 0, 0, 40)
Button.Position = UDim2.new(0.1, 0, 0.6, 0)
Button.Text = "Activate"
Button.TextSize = 20

Button.MouseButton1Click:Connect(function()
	if TextBox.Text == premiumKey then
		Button.Text = "Loading..."
		loadstring(game:HttpGet(scriptUrl))()
		ScreenGui:Destroy()
	else
		Button.Text = "Invalid Key!"
		task.wait(2)
		Button.Text = "Activate"
	end
end)
