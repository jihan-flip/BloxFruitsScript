-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlankScreen"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a draggable, centered Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200) -- Medium size
frame.Position = UDim2.new(0.5, -150, 0.5, -100) -- Centered
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
