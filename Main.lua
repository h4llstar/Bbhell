local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Info = TweenInfo.new(10)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer


local Window = Rayfield:CreateWindow({
    Name = "Weed",
    Icon = 0,
    LoadingTitle = "BubbleGum Simulator Infinity",
    LoadingSubtitle = "Loading...",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,

    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "BGSI HUB"
    },

    Discord = {
        Enabled = true,
        Invite = "discord.gg/bgsihub",
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
for _, folder in pairs(workspace.Rendered:GetChildren()) do
    if folder.Name == "Chunker" then
        for _, v in pairs(folder:GetChildren()) do
            if string.find(v.Name, "-") then
                ColFolder = folder
            end
        end
    end
end


local FarmTab = Window:CreateTab("Farm", "rewind")

local AutoBlowOn = false
FarmTab:CreateToggle({
    Name = "Auto Blow",
    Value = false,
    Callback = function(v) AutoBlowOn = v end,
})

local AutoSellOn = false
FarmTab:CreateToggle({
    Name = "Auto Sell",
    Value = false,
    Callback = function(v) AutoSellOn = v end,
})

local AutoFarmOn = false
FarmTab:CreateToggle({
    Name = "Auto Collect",
    Value = false,
    Callback = function(v) AutoFarmOn = v end,
})

local ItemsTab = Window:CreateTab("Items", "rewind")

local AutoDoggyOn = false
ItemsTab:CreateToggle({
    Name = "Auto Doggy Game",
    Value = false,
    Callback = function(v) AutoDoggyOn = v end,
})

local AutoPlaytimeOn = false
ItemsTab:CreateToggle({
    Name = "Auto Collect Playtime",
    Value = false,
    Callback = function(v) AutoPlaytimeOn = v end,
})

local AutoChestsOn = false
ItemsTab:CreateToggle({
    Name = "Auto Collect Chests",
    Value = false,
    Callback = function(v) AutoChestsOn = v end,
})

local AutoShopOn = false
ItemsTab:CreateToggle({
    Name = "Auto Alien Shop",
    Value = false,
    Callback = function(v) AutoShopOn = v end,
})

local AutoShop2On = false
local AutoShop2 = ItemsTab:CreateToggle({
	Name = "Auto Blackmarket",
	Value = false,
	Flag = "Toggle1000",
	Callback = function(Value)
		AutoShop2On = Value
	end,
})

local AutoTicketOn = false
ItemsTab:CreateToggle({
    Name = "Auto Claim Wheel Tickets",
    Value = false,
    Callback = function(v) AutoTicketOn = v end,
})

local AutoWheelOn = false
ItemsTab:CreateToggle({
    Name = "Auto Spin Wheel",
    Value = false,
    Callback = function(v) AutoWheelOn = v end,
})

local AutoMysteryOn = false
ItemsTab:CreateToggle({
    Name = "Auto Mystery box",
    Value = false,
    Callback = function(v) AutoMysteryOn = v end,
})

local EggsTab = Window:CreateTab("Eggs", "rewind")
EggsTab:CreateSection("This is necessary to open the eggs a little faster")

local SelectedEgg = ""
local Eggs = {}
for _, egg in pairs(game.ReplicatedStorage.Assets.Eggs:GetChildren()) do
    if not string.find(egg.Name, "Golden") and not string.find(egg.Name, "Season") and not string.find(egg.Name, "Shop") and egg.Name ~= "PackageLink" then
        table.insert(Eggs, egg.Name)
    end
end

EggsTab:CreateDropdown({
    Name = "Select Egg",
    Options = Eggs,
    Callback = function(opt) SelectedEgg = opt[1] end
})

local CurrentEggsAmount = 1
EggsTab:CreateSlider({
    Name = "How many eggs to open",
    Range = {1, 17},
    Increment = 1,
    Suffix = "Eggs",
    CurrentValue = 1,
    Callback = function(v) CurrentEggsAmount = v end,
})



local AutoEggOn = false
EggsTab:CreateToggle({
    Name = "Open Eggs",
    Value = false,
    Callback = function(v)
        AutoEggOn = v
        if v then
            Rayfield:Notify({
                Title = "Eggs Open",
                Content = "To open eggs, you need to stand next to them",
                Duration = 3,
                Image = "rewind"
            })
        end
    end
})

-- No Hatch Animation
local NoHatchAnimEnabled = false
local HatchModule = require(ReplicatedStorage.Client.Effects.HatchEgg)
local originalPlay = HatchModule.Play

EggsTab:CreateToggle({
    Name = "No Hatch Animation",
    Value = false,
    Callback = function(v)
        NoHatchAnimEnabled = v
        if v then
            HatchModule.Play = function(self, result)
                if result and result.Pets then
                    local gui = Player.PlayerGui.ScreenGui
                    gui.Hatching.Visible = false
                    gui.HUD.Visible = true
                    self._hatching = false
                end
            end
        else
            HatchModule.Play = originalPlay
        end
    end
})


local while1 = coroutine.create(function()
	while task.wait(10) do
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
					task.wait(0.1)
				end
			end
		end
		if AutoShop2On then
			for i = 1, 3 do
				for v = 1, 12 do
					game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("BuyShopItem", "shard-shop", i)
					task.wait(0.1)
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
                if AutoMysteryOn then
			game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Framework"):WaitForChild("Network"):WaitForChild("Remote"):WaitForChild("Event")
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
	while task.wait(0.1) do
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
