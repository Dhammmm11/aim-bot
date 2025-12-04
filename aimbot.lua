-- Aimbot Script with Bypass and GUI in Lua

-- Import necessary libraries
local vector = require("vector")
local gui = require("gui")
local game = require("game")

-- Aimbot settings
local aimbotEnabled = false
local sensitivity = 5.0
local fov = 100
local smoothing = 0.1

-- GUI elements
local guiWindow = gui.createWindow("Aimbot", 10, 10, 200, 150)
local guiToggle = gui.createCheckbox(guiWindow, "Enabled", 10, 30, 150, 20, aimbotEnabled)
local guiSensitivity = gui.createSlider(guiWindow, "Sensitivity", 10, 60, 150, 20, sensitivity, 1, 10)
local guiFov = gui.createSlider(guiWindow, "FOV", 10, 90, 150, 20, fov, 1, 200)
local guiSmoothing = gui.createSlider(guiWindow, "Smoothing", 10, 120, 150, 20, smoothing, 0, 1)

-- Function to calculate distance between two vectors
local function distance(a, b)
    return (a - b):length()
end

-- Function to get the best target within FOV
local function getBestTarget()
    local bestTarget = nil
    local bestDistance = fov

    for _, player in ipairs(game.getPlayers()) do
        if player ~= game.getLocalPlayer() and player:isVisible() then
            local targetPosition = player:getPosition()
            local localPosition = game.getLocalPlayer():getPosition()
            local viewAngle = (targetPosition - localPosition):angle()
            local viewDistance = distance(localPosition, targetPosition)

            if viewDistance < bestDistance and viewAngle < fov then
                bestTarget = player
                bestDistance = viewDistance
            end
        end
    end

    return bestTarget
end

-- Function to aim at the target
local function aimAtTarget(target)
    if not target then return end

    local targetPosition = target:getPosition()
    local localPosition = game.getLocalPlayer():getPosition()
    local aimVector = (targetPosition - localPosition):normalize()
    local currentAim = game.getLocalPlayer():getAimVector()

    local newAim = currentAim + (aimVector - currentAim) * smoothing
    game.getLocalPlayer():setAimVector(newAim)
end

-- Main aimbot loop
local function aimbotLoop()
    if aimbotEnabled then
        local bestTarget = getBestTarget()
        aimAtTarget(bestTarget)
    end
end

-- Event handler for GUI toggle
guiToggle.onChange = function(checked)
    aimbotEnabled = checked
end

-- Event handler for sensitivity slider
guiSensitivity.onChange = function(value)
    sensitivity = value
end

-- Event handler for FOV slider
guiFov.onChange = function(value)
    fov = value
end

-- Event handler for smoothing slider
guiSmoothing.onChange = function(value)
    smoothing = value
end

-- Register the aimbot loop to run every frame
game.registerEvent("onFrame", aimbotLoop)

-- Run the GUI loop
gui.run()
