-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlankScreen"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a blank Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)  -- Full screen
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)  -- Black background
frame.BorderSizePixel = 0
frame.Parent = screenGui
