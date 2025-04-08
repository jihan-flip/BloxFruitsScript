-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BlankScreen"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a blank Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 428, 0, 321) -- 7% bigger than approx. 400x300
frame.Position = UDim2.new(0.5, -214, 0.5, -160) -- Centered on screen
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui
