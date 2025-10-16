-- Magnet_Legend AutoFish, AutoClaim Clamss, Auto Smelt,....
--{{ SERVICES }}--
local RepStorage = game:GetService("ReplicatedStorage")

--{{ VARIABLES }}--
local plr = game:GetService('Players').LocalPlayer
local PlrGui = plr:WaitForChild("PlayerGui")

-- Fishing Gui
local FishingGui = PlrGui:WaitForChild("Fishing")
local CastBox = nil -- Blue box to cast
local SpeedUpIconFrame = nil -- Frame hold SpeedUp icons
local temp = FishingGui.Frame.FishingCaster:GetChildren()
for _, item in ipairs(temp) do
	if item:IsA("Frame") and item.Size.X.Scale == 2 then CastBox = item; break end
end
temp = FishingGui.Frame:GetChildren()
for _, item in temp do
	if item.Name == "Frame" and item.Size == UDim2.new(-0.25, 0, -4.464, 0) then SpeedUpIconFrame = item; break end
end

--== Remotes ==--
-- Fishing
local StartFishingRemote = RepStorage.FrameworkEvents.StartFishing
local FishingPowClickRemote = RepStorage.FrameworkEvents.FishingPowerClick

-- Clam
local ClaimClamRemote = RepStorage.FrameworkEvents.ClaimClam

-- Smelt gold
local FinishedSmeltRemote = RepStorage.FrameworkEvents.FinishedSmelt

--== Event Args ==--
-- Fishing
local StartFishingResult = "Excellent" -- arg2
-- Clam - none, name use 'Clam_<index>'
-- Fishing - none, name use 'Gold<index>'


local SmeltCommand 

--{{ MAIN }}--
--{{ MAIN }}--
warn('SCRIPT RUN')
local toggle = false
local startFishingThread = nil -- Coroutine cho việc bắt đầu câu
local powerClickThread = nil   -- Coroutine cho việc click liên tục
local smeltingThread = nil 		 -- Coroutine cho việc tự động nấu vàng thỏi

-- CONFIGS --
local START_INTERVAL = 0.1       -- Cứ 3 giây sẽ bắt đầu một lượt câu mới
local CLICK_INTERVAL = 0.02     -- Tốc độ click, 0.1 = 10 lần/giây. Tăng số này để click chậm lại.

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
	if gameProcessedEvent then return end

	if input.KeyCode == Enum.KeyCode.Q then
		toggle = not toggle -- Bật/tắt chế độ tự động

		if toggle then
			-- Bật cả hai vòng lặp trong hai coroutine riêng biệt
			warn("Đã bật AutoFish")

			-- Vòng lặp 1: Bắt đầu câu cá mỗi 3 giây
			startFishingThread = task.spawn(function()
				while toggle do
					StartFishingRemote:FireServer(StartFishingResult)
					task.wait(START_INTERVAL)
				end
			end)

			-- Vòng lặp 2: Click liên tục với tốc độ vừa phải
			powerClickThread = task.spawn(function()
				while toggle do
					FishingPowClickRemote:FireServer()
					for i = 1, 6 do
						ClaimClamRemote:FireServer("Clam_"..i)
					end
					task.wait(CLICK_INTERVAL)
				end
			end)
			
			smeltingThread = task.spawn(function()
				while toggle do
					for i = 1, 18 do
						FinishedSmeltRemote:FireServer("Gold"..i)
					end
					task.wait(0.5)
				end
			end)
			
		else
			-- Tắt cả hai vòng lặp
			if startFishingThread then
				task.cancel(startFishingThread)
				startFishingThread = nil
			end
			if powerClickThread then
				task.cancel(powerClickThread)
				powerClickThread = nil
			end
			if smeltingThread then
				task.cancel(smeltingThread)
				smeltingThread = nil
			end
			
			warn("Đã tắt AutoFish")
		end
	end
	
end)
