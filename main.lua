--- Create GUI
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
frame.Draggable = false
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

	local function setupESP()
		local character = player.Character
		if not character then return end
		local hrp = character:FindFirstChild("HumanoidRootPart")
		if not hrp then return end

		local billboard = Instance.new("BillboardGui")
		billboard.Name = "PlayerESP"
		billboard.Adornee = hrp
		billboard.Size = UDim2.new(0, 200, 0, 30)
		billboard.StudsOffset = Vector3.new(0, 3, 0)
		billboard.AlwaysOnTop = true
