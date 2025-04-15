local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Info = TweenInfo.new(10)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Pets = require(ReplicatedStorage.Shared.Data.Pets)
local LocalDataService = require(ReplicatedStorage.Client.Framework.Services.LocalData)
local Player = game.Players.LocalPlayer

local Window = Rayfield:CreateWindow({
    Name = "BGSI Hub",
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
    Range = {1, 6},
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

local EnchTab = Window:CreateTab("Enchant", "rewind")
local EnchText = EnchTab:CreateSection("Tab for auto enchant pets.")

local SelectedPet = ""

local SelectedEnchants = {}
local SelectEnchants = EnchTab:CreateDropdown({
   Name = "Select Enchants",
   Options = {"Team Up I", "Team Up II", "Team Up III", "Team Up IV", "Team Up V", 
"Gleaming I", "Gleaming II", "Gleaming III", "Gleaming IV", "Gleaming V", 
"Bubbler I", "Bubbler II", "Bubbler III", "Bubbler IV", "Bubbler V",
"Looter I", "Looter II", "Looter III", "Looter IV", "Looter V"},
   CurrentOption = {},
   MultipleOptions = true,
   Flag = "Dropdown69",
   Callback = function(Options)
      SelectedEnchants = Options
   end,
})

local UseRerollOn = false
local UseReroll = EnchTab:CreateToggle({
	Name = "Use reroll orbs instead of gems",
	Value = false,
	Flag = "Toggle667",
	Callback = function(Value)
		UseRerollOn = Value
	end,
})

local AutoEnchOn = false
local AutoEnch = EnchTab:CreateToggle({
	Name = "Start Enchanting",
	Value = false,
	Flag = "Toggle666",
	Callback = function(Value)
		AutoEnchOn = Value
	end,
})  

local RiftsTab = Window:CreateTab("Rifts", "rewind")
local RiftText = RiftsTab:CreateSection("Allows you to view all rifts and teleport to them")

local riftsPath = {}

local function teleport(id)
	local closestIslandMag = 99999999
	local closestIslandName = ""
	for _,island in pairs(workspace.Worlds:WaitForChild("The Overworld").Islands:GetChildren()) do
		local mag = (riftsPath[id].Display.Position - island.Island.UnlockHitbox.Position).Magnitude
		if mag < closestIslandMag and island.Island.UnlockHitbox.Position.Y > riftsPath[id].Display.Position.Y then
			closestIslandMag = mag
			closestIslandName = island.Name
		end
	end
	game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("Teleport", `Workspace.Worlds.The Overworld.Islands.{closestIslandName}.Island.Portal.Spawn`)
	task.wait(0.5)
        Player.Character.Humanoid.Jump = true
        task.wait(0.5)
        TweenService:Create(Player.Character.HumanoidRootPart, TweenInfo.new(10), {CFrame = riftsPath[id].Display.CFrame}):Play()
end

local Rift2Text = RiftsTab:CreateSection("Still in development")

local rift1 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(1)
   end,
})

local rift2 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(2)
   end,
})

local rift3 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(3)
   end,
})

local rift4 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(4)
   end,
})

local rift5 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(5)
   end,
})

local rift6 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(6)
   end,
})

local rift7 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(7)
   end,
})

local rift8 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(8)
   end,
})

local rift9 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(9)
   end,
})

local rift10 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(10)
   end,
})

local rift11 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
      teleport(11)
   end,
})

local rifts = {rift1, rift2, rift3, rift4, rift5, rift6, rift7, rift8, rift9, rift10, rift11}

local while3 = coroutine.create(function()
	while task.wait(2) do
		for _,riftBtn in pairs(rifts) do
			riftBtn:Set("")
		end
		table.clear(riftsPath)
		for i,rift in pairs(workspace.Rendered.Rifts:GetChildren()) do
			table.insert(riftsPath, rift)
			local betterName = string.gsub(string.gsub(rift.Name, "-", " "), "(%a)([%w]*)", function(first, rest)
  				return string.upper(first) .. rest
			end)
			if string.find(rift.Name, "egg") then
				rifts[i]:Set(`{betterName} ({rift.Display.SurfaceGui.Timer.Text}) ({rift.Display.SurfaceGui.Icon.Luck.Text})`)
			else
				rifts[i]:Set(`{betterName} ({rift.Display.SurfaceGui.Timer.Text})`)
			end
		end
	end
end)
coroutine.resume(while3)


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
	while task.wait(0.1) do
			for _,pet in pairs(game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Frame.Inner.Pets.Main.ScrollingFrame.Team.Main.List:GetChildren()) do
			if string.find(pet.Name, "-") then
				SelectedPet = string.match(pet.Name, "^(.-)%-team%-0$")
				print(SelectedPet)
			end
		end
		local needEnch = true
                if AutoEnchOn then
			for _,ench in pairs(SelectedEnchants) do
				if string.find(game.Players.LocalPlayer.PlayerGui.ScreenGui.Inventory.Frame.Inner.Pets.Details.Enchants.Enchant1.Title.Text, ench) then
				needEnch = false
			end 
			if needEnch and not UseRerollOn then
				game.ReplicatedStorage.Shared.Framework.Network.Remote.Function:InvokeServer("RerollEnchants", SelectedPet)
			end
			if needEnch and UseRerollOn then
				game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("RerollEnchant", SelectedPet, 1)
			end
		end
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
