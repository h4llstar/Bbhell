local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

local Window = Rayfield:CreateWindow({
	Name = "BGSIHub",
	LoadingTitle = "Loading...",
	LoadingSubtitle = "Bubble Gum Simulator INFINITY",
	ConfigurationSaving = {
		Enabled = false
	}
})

local MainTab = Window:CreateTab("Auto Farm")
local autoHatch = false
local autoGum = false
local autoSell = false
local selectedEgg = nil
local eggList = {}
local currentDropdown

local function refreshEggList()
	local newList = {}
	local overworld = workspace:FindFirstChild("Worlds"):FindFirstChild("The Overworld")
	if overworld then
		local islands = overworld:FindFirstChild("Islands")
		if islands then
			for _, island in ipairs(islands:GetChildren()) do
				local eggsFolder = island:FindFirstChild("Eggs")
				if eggsFolder then
					for _, egg in ipairs(eggsFolder:GetChildren()) do
						table.insert(newList, egg.Name)
					end
				end
			end
		end
	end

	if currentDropdown then
		currentDropdown:SetOptions(newList)
	end

	eggList = newList
	if not selectedEgg and #eggList > 0 then
		selectedEgg = eggList[1]
	end
end

currentDropdown = MainTab:CreateDropdown({
	Name = "Select Egg",
	Options = eggList,
	CurrentOption = selectedEgg or "None",
	Callback = function(egg)
		selectedEgg = egg
	end
})

refreshEggList()

task.spawn(function()
	while task.wait(5) do
		refreshEggList()
	end
end)

MainTab:CreateToggle({
	Name = "Auto Hatch",
	CurrentValue = false,
	Callback = function(val)
		autoHatch = val
	end
})

MainTab:CreateToggle({
	Name = "Auto Bubble",
	CurrentValue = false,
	Callback = function(val)
		autoGum = val
	end
})

MainTab:CreateToggle({
	Name = "Auto Sell",
	CurrentValue = false,
	Callback = function(val)
		autoSell = val
	end
})

task.spawn(function()
	while task.wait(1.5) do
		if autoHatch and selectedEgg then
			local hatchCount = 1
			pcall(function()
				local data = require(game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("GameUI"):WaitForChild("EggUI")).EggData
				hatchCount = data.MaxMulti or 1
			end)

			game:GetService("ReplicatedStorage")
				:WaitForChild("Shared")
				:WaitForChild("Framework")
				:WaitForChild("Network")
				:WaitForChild("Remote")
				:WaitForChild("Event")
				:FireServer("HatchEgg", selectedEgg, hatchCount)
		end
	end
end)

task.spawn(function()
	while task.wait(0.1) do
		if autoGum then
			pcall(function()
				game:GetService("ReplicatedStorage")
					:WaitForChild("Shared")
					:WaitForChild("Framework")
					:WaitForChild("Network")
					:WaitForChild("Remote")
					:WaitForChild("Event")
					:FireServer("BlowBubble")
			end)
		end
	end
end)

task.spawn(function()
	while task.wait(0.1) do
		if autoSell then
			pcall(function()
				game:GetService("ReplicatedStorage")
					:WaitForChild("Shared")
					:WaitForChild("Framework")
					:WaitForChild("Network")
					:WaitForChild("Remote")
					:WaitForChild("Event")
					:FireServer("SellBubble")
			end)
		end
	end
end)
