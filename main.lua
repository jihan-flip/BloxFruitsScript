-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FruitCollectorGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create Draggable Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0.5, -150, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Create Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.Text = "Auto Get Fruit (OFF)"
toggleBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.Parent = frame

-- Logic
local autoGetEnabled = false

toggleBtn.MouseButton1Click:Connect(function()
	autoGetEnabled = not autoGetEnabled
	toggleBtn.Text = "Auto Get Fruit (" .. (autoGetEnabled and "ON" or "OFF") .. ")"
	toggleBtn.BackgroundColor3 = autoGetEnabled and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)

	while autoGetEnabled do
		for _, obj in pairs(game.Workspace:GetDescendants()) do
			if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Name:lower():find("fruit") then
				game.Players.LocalPlayer.Character:MoveTo(obj.Handle.Position)
				break
			end
		end
		wait(1)
	end
end)
