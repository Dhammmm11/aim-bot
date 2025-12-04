local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

-- Aimbot settings
local aimbotEnabled = false
local sensitivity = 0.5
local fov = 100
local smoothing = 0. 1

-- Function to get distance
local function distance(a, b)
    return (a - b). Magnitude
end

-- Function to get best target
local function getBestTarget()
    local bestTarget = nil
    local bestDistance = fov
    local localCharacter = LocalPlayer.Character
    
    if not localCharacter or not localCharacter:FindFirstChild("Head") then
        return nil
    end
    
    local localPosition = localCharacter.Head.Position

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local targetPosition = player.Character.Head. Position
            local viewDistance = distance(localPosition, targetPosition)

            if viewDistance < bestDistance then
                bestTarget = player
                bestDistance = viewDistance
            end
        end
    end

    return bestTarget
end

-- Function to aim at target
local function aimAtTarget(target)
    if not target or not target. Character or not target.Character:FindFirstChild("Head") then 
        return 
    end

    local targetPosition = target.Character.Head. Position
    local newCFrame = CFrame.new(Camera.CFrame.Position, targetPosition)
    Camera.CFrame = Camera.CFrame:Lerp(newCFrame, smoothing)
end

-- Main loop
local connection
connection = game:GetService("RunService").RenderStepped:Connect(function()
    if aimbotEnabled then
        local bestTarget = getBestTarget()
        aimAtTarget(bestTarget)
    end
end)

-- Toggle with keypress (Right Alt)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightAlt then
        aimbotEnabled = not aimbotEnabled
        print("Aimbot: " .. (aimbotEnabled and "ON" or "OFF"))
    end
end)

print("✓ Aimbot Script Loaded!")
print("P

lo
