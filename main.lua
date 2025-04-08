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
frame.Draggable = true
frame.Parent = screenGui

-- Auto Fruit Button
local fruitBtn = Instance.new("TextButton")
fruitBtn.Size = UDim2.new(1, 0, 0.5, 0)
fruitBtn.Text = "Auto Get Fruit (OFF)"
fruitBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
fruitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fruitBtn.Font = Enum.Font.SourceSansBold
fruitBtn.TextSize = 18
fruitBtn.Parent = frame

-- Auto Chest Button
local chestBtn = Instance.new("TextButton")
chestBtn.Position = UDim2.new(0, 0, 0.5, 0)  -- Adjust position so it's below the fruit button
chestBtn.Size = UDim2.new(1, 0, 0.5, 0)
chestBtn.Text = "Auto Chest (OFF)"
chestBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
chestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
chestBtn.Font = Enum.Font.SourceSansBold
chestBtn.TextSize = 18
chestBtn.Parent = frame

-- Logic
local autoFruit = false
local autoChest = false

fruitBtn.MouseButton1Click:Connect(function()
    autoFruit = not autoFruit
    fruitBtn.Text = "Auto Get Fruit (" .. (autoFruit and "ON" or "OFF") .. ")"
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

chestBtn.MouseButton1Click:Connect(function()
    autoChest = not autoChest
    chestBtn.Text = "Auto Chest (" .. (autoChest and "ON" or "OFF") .. ")"
    chestBtn.BackgroundColor3 = autoChest and Color3.fromRGB(85, 255, 85) or Color3.fromRGB(255, 85, 85)

    coroutine.wrap(function()
        while autoChest do
            for _, chest in pairs(game.Workspace:GetDescendants()) do
                if chest:IsA("Model") and chest:FindFirstChild("TouchInterest") then
                    -- Move to chest
                    local chestPosition = chest:FindFirstChild("PrimaryPart") and chest.PrimaryPart.Position or chest:GetModelCFrame().p
                    game.Players.LocalPlayer.Character:MoveTo(chestPosition)
                    wait(0.5)

                    -- Simulate chest collection (for example, trigger the chest's touch event)
                    local touch = chest:FindFirstChild("TouchInterest")
                    if touch then
                        -- This simulates the interaction. In case there is an actual touch event needed, we'd trigger it.
                        -- For example, we can use the Touch event here if the chest requires it.
                        -- chest:Touch(game.Players.LocalPlayer.Character)
                    end
                    break  -- Stop after interacting with one chest
                end
            end
            wait(2)  -- Check every 2 seconds
        end
    end)()
end)
