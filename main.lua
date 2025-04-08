-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FruitChestGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.Active = true
frame.Draggable = false -- We'll handle dragging ourselves
frame.Parent = screenGui

-- Draggable Handle (black bar below)
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 20)
dragBar.Position = UDim2.new(0, 0, 1, 0)
dragBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dragBar.Parent = frame

-- Auto Fruit Button
local fruitBtn = Instance.new("TextButton")
fruitBtn.Size = UDim2.new(1, 0, 0.5, 0)
fruitBtn.Text = "Auto Devil Fruit (OFF)"
fruitBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
fruitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fruitBtn.Font = Enum.Font.SourceSansBold
fruitBtn.TextSize = 18
fruitBtn.Parent = frame

-- Player ESP Button
local espBtn = Instance.new("TextButton")
espBtn.Position = UDim2.new(0, 0, 0.5, 0)
espBtn.Size = UDim2.new(1, 0, 0.5, 0)
espBtn.Text = "Player ESP (OFF)"
espBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 18
espBtn.Parent = frame

-- Auto Fruit Logic
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

-- Player ESP Logic
local espEnabled = false
local espObjects = {}

local function createESPForPlayer(player)
	if player == game.Players.LocalPlayer then return end
	if espObjects[player] then return end

	local character = player.Character or player.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "PlayerESP"
	billboard.Adornee = hrp
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = hrp

	local nameTag = Instance.new("TextLabel")
	nameTag.Size = UDim2.new(1, 0, 1, 0)
	nameTag.BackgroundTransparency = 1
	nameTag.TextColor3 = Color3.new(1, 1, 1)
	nameTag.Font = Enum.Font.SourceSansBold
	nameTag.TextScaled = true
	nameTag.Text = player.Name
	nameTag.Parent = billboard

	espObjects[player] = {
		gui = billboard,
		label = nameTag,
	}

	game:GetService("RunService").RenderStepped:Connect(function()
		if not espEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
		local myHRP = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if myHRP then
			local dist = (myHRP.Position - player.Character.HumanoidRootPart.Position).Magnitude
			nameTag.Text = player.Name .. " (" .. math.floor(dist) .. "m)"
		end
	end)
end

local function clearESP()
	for _, data in pairs(espObjects) do
		if data.gui then data.gui:Destroy() end
	end
	espObjects = {}
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = "Player ESP (" .. (espEnabled and "ON" or "OFF") .. ")"
	espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)

	if espEnabled then
		for _, player in pairs(game.Players:GetPlayers()) do
			createESPForPlayer(player)
		end

		game.Players.PlayerAdded:Connect(function(player)
			player.CharacterAdded:Connect(function()
				wait(1)
				if espEnabled then
					createESPForPlayer(player)
				end
			end)
		end)
	else
		clearESP()
	end
end)

-- Dragging Logic (handle dragBar)
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

dragBar.InputBegan:Connect(function(input)
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

dragBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
