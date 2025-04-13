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

for _, obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("Model") and obj:FindFirstChild("Egg") then
		table.insert(eggList, obj.Name)
	end
end

selectedEgg = eggList[1] or nil

MainTab:CreateDropdown({
	Name = "Select Egg",
	Options = eggList,
	CurrentOption = selectedEgg or "None",
	Callback = function(egg)
		selectedEgg = egg
	end
})

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
