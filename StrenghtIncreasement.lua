local player = game:GetService("Players").LocalPlayer
local char = player.Character
local humanoid = char.Humanoid

-- Clean Trees
for _, i in game.workspace:GetChildren() do
    if i.Name == "Tree1" or i.Name == "Tree2" or i.Name == "Tree3" or i.Name == "Tree4" then
        i:Destroy()
    end
end

-- Modify Block
local Block = game.workspace:WaitForChild("TestNpc")
local NpcGui = Block.NpcGui
local CashGui = Block.CashGui
local ClickDetector = Block:FindFirstChild("Hit")

Block.Position = Vector3.new(-210, 41, 295)
Block.CanCollide = false

ClickDetector.MaxActivationDistance = 500
NpcGui.Size = UDim2.new(8,0,5,0)
NpcGui.MaxDistance = 200
CashGui.Size = UDim2.new(10,0,10,0)
CashGui.MaxDistance = 200
CashGui.StudsOffset = Vector3.new(0, 5, 0)

-- Modify UpgradeBoard
local MoneyBoard = game.workspace:WaitForChild("Money")
local UpgradeBoard = game.workspace.Upgrades.Cash1
local Board = game.workspace:FindFirstChild("Board")

MoneyBoard.CanCollide = false
UpgradeBoard.CanCollide = false

MoneyBoard.Position = Vector3.new(-190, 51, 295)
UpgradeBoard.Position = Vector3.new(-190, 45, 295)
UpgradeBoard.Size = Vector3.new(30, 7.675, 0.888)
UpgradeBoard:FindFirstChild("SurfaceGui"):FindFirstChild("ScrollingFrame").CanvasSize = UDim2.new(1.1,0,0,0)

MoneyBoard.CFrame = CFrame.new(MoneyBoard.Position) * CFrame.Angles(math.rad(-30), math.rad(-210), math.rad(14))
UpgradeBoard.CFrame = CFrame.new(UpgradeBoard.Position) * CFrame.Angles(math.rad(-30), math.rad(-210), math.rad(14))
if Board then
    Board:Destroy()
end

-- Force WalkSpeed AND AutoClick
task.spawn(function()
    while task.wait(0.1) do
    humanoid.WalkSpeed = 40
    end
end)
task.spawn(function()
    while task.wait(0.5) do
        fireclickdetector(ClickDetector)
    end
end)
