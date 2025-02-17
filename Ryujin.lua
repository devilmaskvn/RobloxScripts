local Players = game:GetService("Players")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local prompt = workspace:WaitForChild("Ignore", 2):FindFirstChild("Interactables"):FindFirstChild("JobsRelated"):FindFirstChild("Boxes"):FindFirstChild("RecieveArea"):FindFirstChild("ProximityPrompt")
local isHoldingR = false
local maxVelocity = 120  -- Set the maximum velocity limit

-- Set prompt speed to be faster
prompt.HoldDuration = 0.01

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.R then
        -- Set holding flag to true
        isHoldingR = true

        -- Update velocity continuously to follow the player's orientation
        RunService.Heartbeat:Connect(function()
            if isHoldingR then
                local character = player.Character or player.CharacterAdded:Wait()
                local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                local currentVelocity = humanoidRootPart.AssemblyLinearVelocity
                local additionalVelocity = humanoidRootPart.CFrame.LookVector * 100  -- Adjust the forward push amount

                -- Calculate the new velocity and cap it
                local newVelocity = currentVelocity + additionalVelocity
                if newVelocity.Magnitude > maxVelocity then
                    newVelocity = newVelocity.Unit * maxVelocity
                end
                
                humanoidRootPart.AssemblyLinearVelocity = newVelocity
            end
        end)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.R then
        -- Set holding flag to false
        isHoldingR = false
    end
end)
