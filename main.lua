-- Create GUI 
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FruitChestGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200) -- Increased size for Player ESP button
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Auto Fruit Button
local fruitBtn = Instance.new("TextButton")
fruitBtn.Size = UDim2.new(1, 0, 0.25, 0)
fruitBtn.Text = "Auto Devil Fruit (OFF)"
fruitBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
fruitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fruitBtn.Font = Enum.Font.SourceSansBold
fruitBtn.TextSize = 18
fruitBtn.Parent = frame

-- Player ESP Button
local espBtn = Instance.new("TextButton")
espBtn.Position = UDim2.new(0, 0, 0.25, 0)
espBtn.Size = UDim2.new(1, 0, 0.25, 0)
espBtn.Text = "Player ESP (OFF)"
espBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 18
espBtn.Parent = frame

-- Logic for Auto Fruit
local autoFruit = false
fruitBtn.MouseButton1Click:Connect(function()
	autoFruit = not autoFruit
	fruitBtn.Text = "Auto Devil Fruit (" .. (autoFruit and "ON" or "OFF") .. ")"
	fruitBtn.BackgroundColor3 = autoFruit and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)

	coroutine.wrap(function()
		while autoFruit do
			for _, obj in pairs(game.Workspace:GetDescendants()) do
				if obj:IsA("Tool") and obj:FindFirstChild("Handle") and obj.Name:lower():find("fruit") then
					game.Players.LocalPlayer.Character:MoveTo(obj.Handle.Position)
					break
				end
			end
			wait(1)
		end
	end)()
end)

-- Logic for Player ESP
local playerESP = false
espBtn.MouseButton1Click:Connect(function()
	playerESP = not playerESP
	espBtn.Text = "Player ESP (" .. (playerESP and "ON" or "OFF") .. ")"
	espBtn.BackgroundColor3 = playerESP and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)

	while playerESP do
		for _, player in pairs(game.Players:GetPlayers()) do
			if player ~= game.Players.LocalPlayer then
				local character = player.Character
				if character and character:FindFirstChild("HumanoidRootPart") then
					local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).magnitude
					local textLabel = Instance.new("TextLabel")
					textLabel.Size = UDim2.new(0, 100, 0, 30)
					textLabel.Position = UDim2.new(0.5, 0, 0, 0) -- Position above player
					textLabel.Text = player.Name .. " (" .. math.round(distance) .. "m)"
					textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					textLabel.BackgroundTransparency = 1
					textLabel.Font = Enum.Font.SourceSansBold
					textLabel.TextSize = 18
					textLabel.Parent = screenGui

					-- Follow the player position
					local playerPosition = character.HumanoidRootPart.Position
					game:GetService("RunService").RenderStepped:Connect(function()
						local screenPosition, onScreen = game:GetService("Workspace"):WorldToViewportPoint(playerPosition)
						if onScreen then
							textLabel.Position = UDim2.new(0, screenPosition.X, 0, screenPosition.Y)
						end
					end)
				end
			end
		end
		wait(1) -- Update the ESP every second
	end
end)

-- Draggable functionality for the GUI
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if dragging then
				updateDrag(input)
			end
		end)
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
