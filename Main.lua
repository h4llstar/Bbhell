local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
	Name = "BGSI Hub",
	Icon = 0,
	LoadingTitle = "BubbleGum Simulator Infinity Cheat",
	LoadingSubtitle = "Loading...",
	Theme = "Default",

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,

	ConfigurationSaving = {
		Enabled = false,
		FolderName = nil,
		FileName = "BGSI Hub"
	},

	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true
	},

	KeySystem = false,
	KeySettings = {
		Title = "Untitled",
		Subtitle = "Key System",
		Note = "No method of obtaining the key is provided",
		FileName = "Key",
		SaveKey = true,
		GrabKeyFromSite = false,
		Key = {"Hello"}
	}
})

local ColFolder = workspace
for _,folder in pairs(workspace.Rendered:GetChildren()) do
	if folder.Name == "Chunker" then
		for _,v in pairs(folder:GetChildren()) do
			if string.find(v.Name, "-") then
				ColFolder = folder
			end
		end
	end
end

local FarmTab = Window:CreateTab("Farm", "rewind")

local AutoBlowOn = false
local AutoBlow = FarmTab:CreateToggle({
	Name = "Auto Blow",
	Value = false,
	Flag = "Toggle1",
	Callback = function(Value)
		AutoBlowOn = Value
	end,
})

local AutoSellOn = false
local AutoSell = FarmTab:CreateToggle({
	Name = "Auto Sell",
	Value = false,
	Flag = "Toggle2",
	Callback = function(Value)
		AutoSellOn = Value
	end,
})

local AutoFarmOn = false
local AutoFarm = FarmTab:CreateToggle({
	Name = "Auto Сollect",
	Value = false,
	Flag = "Toggle100",
	Callback = function(Value)
		AutoFarmOn = Value
	end,
})

local ItemsTab = Window:CreateTab("Items", "rewind")

local AutoDoggyOn = false
local AutoDoggy = ItemsTab:CreateToggle({
	Name = "Auto Doggy Game",
	Value = false,
	Flag = "Toggle3",
	Callback = function(Value)
		AutoDoggyOn = Value
	end,
})

local AutoPlaytimeOn = false
local AutoPlaytime = ItemsTab:CreateToggle({
	Name = "Auto Collect Playtime",
	Value = false,
	Flag = "Toggle5",
	Callback = function(Value)
		AutoPlaytimeOn = Value
	end,
})

local AutoChestsOn = false
local AutoChests = ItemsTab:CreateToggle({
	Name = "Auto Collect Chests",
	Value = false,
	Flag = "Toggle69",
	Callback = function(Value)
		AutoChestsOn = Value
	end,
})

local AutoShopOn = false
local AutoShop = ItemsTab:CreateToggle({
	Name = "Auto Alien Shop",
	Value = false,
	Flag = "Toggle89",
	Callback = function(Value)
		AutoShopOn = Value
	end,
})

local AutoTicketOn = false
local AutoTicket = ItemsTab:CreateToggle({
	Name = "Auto Claim Wheel Tickets",
	Value = false,
	Flag = "Toggle101",
	Callback = function(Value)
		AutoTicketOn = Value
	end,
})

local AutoWheelOn = false
local AutoWheel = ItemsTab:CreateToggle({
	Name = "Auto Spin Wheel",
	Value = false,
	Flag = "Toggle102",
	Callback = function(Value)
		AutoWheelOn = Value
	end,
})

local EggsTab = Window:CreateTab("Eggs", "rewind")
local EggsText = EggsTab:CreateSection("This is necessary to open the eggs a little faster.")

local SelectedEgg = ""
local Eggs = {}
for _,egg in pairs(game.ReplicatedStorage.Assets.Eggs:GetChildren()) do
	if not string.find(egg.Name, "Golden") and not string.find(egg.Name, "Season") and not string.find(egg.Name, "Shop") and egg.Name ~= "PackageLink" then
		table.insert(Eggs, egg.Name)
	end
end
local SelectEgg = EggsTab:CreateDropdown({
	Name = "Select Egg",
	Options = Eggs, 
	CurrentOption = {},
	MultipleOptions = false,
	Flag = "Dropdown1",
	Callback = function(CurrentOption)
		for _,i in pairs(CurrentOption) do 
			SelectedEgg = i
		end
	end,
})

local CurrentEggsAmount = 1
local EggsAmount = EggsTab:CreateSlider({
	Name = "How many eggs to open",
	Range = {1, 6},
	Increment = 1,
	Suffix = "Eggs",
	CurrentValue = 1,
	Flag = "Slider1",
	Callback = function(CurrentValue)
		CurrentEggsAmount = CurrentValue
	end,
})

local AutoEggOn = false
local AutoEgg = EggsTab:CreateToggle({
	Name = "Open Eggs",
	Value = false,
	Flag = "Toggle4",
	Callback = function(Value)
		AutoEggOn = Value
		if Value then
			Rayfield:Notify({
				Title = "Eggs Open",
				Content = "To open eggs, you need to stand next to them",
				Duration = 3,
				Image = "rewind",
			})
		end
	end,
})

local while1 = coroutine.create(function()
	while wait(10) do
		if AutoChestsOn then
			for _,chest in pairs(workspace.Rendered.Chests:GetChildren()) do
				if not workspace.Rendered.Generic:FindFirstChild(chest.Name):FindFirstChild("ChestRespawn") then
					game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("ClaimChest", chest.Name, true)
				end
			end
		end
		if AutoShopOn then
			for i = 1, 3 do
				for v = 1, 12 do
					game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("BuyShopItem", "alien-shop", i)
					wait(0.1)
				end
			end
		end
		if AutoPlaytimeOn then
			for i = 1,9 do
				game.ReplicatedStorage.Shared.Framework.Network.Remote.Function:InvokeServer("ClaimPlaytime", i)
			end
		end
		if AutoDoggyOn then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("DoggyJumpWin", 3)
		end
		if AutoTicketOn then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("ClaimFreeWheelSpin")
		end
		if AutoWheelOn then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Function:InvokeServer("WheelSpin")
		end
	end
end)
coroutine.resume(while1)

local while2 = coroutine.create(function()
	while wait(0.1) do
		if AutoFarmOn then
			for _,v in pairs(ColFolder:GetChildren()) do
				game.ReplicatedStorage.Remotes.Pickups.CollectPickup:FireServer(v.Name)
				v:Destroy()
			end
		end
		if AutoBlowOn then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("BlowBubble")
		end
		if AutoSellOn then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("SellBubble")
		end
		if AutoEggOn then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("HatchEgg", SelectedEgg, CurrentEggsAmount)
		end
	end
end)
coroutine.resume(while2)
