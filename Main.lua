local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Info = TweenInfo.new(10)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = game.Players.LocalPlayer

queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
Player.OnTeleport:Connect(function(State)
        queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/h4llstar/Bbhell/refs/heads/main/Main.lua'))()")
end)

for _,barrier in pairs(workspace.Worlds:FindFirstChild("The Overworld").Barrier:GetChildren()) do
	barrier.CanCollide = false
end

local function tp(pos)
	if Player.Character.HumanoidRootPart.Position.Y < 35 then
		Player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(Player.Character.HumanoidRootPart.Position.X, 35, Player.Character.HumanoidRootPart.Position.Z))
	end
	local mag = (Player.Character.HumanoidRootPart.Position - Vector3.new(pos.X, Player.Character.HumanoidRootPart.Position.Y, pos.Z)).Magnitude
       	TweenService:Create(Player.Character.HumanoidRootPart, TweenInfo.new(mag/38, Enum.EasingStyle.Linear), {CFrame = CFrame.new(Vector3.new(pos.X, Player.Character.HumanoidRootPart.Position.Y, pos.Z))}):Play()
	task.wait(mag/38)
	for i = 1, 50 do
		Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
		task.wait(0.01)
	end
end

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

local EggsFolder = workspace
for _,folder in pairs(workspace.Rendered:GetChildren()) do
	if folder.Name == "Chunker" then
		for _,v in pairs(folder:GetChildren()) do
			if string.find(v.Name, "Egg") then
				EggsFolder = folder
				break
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

local PriorEggOn = false
local PriorEgg = EggsTab:CreateToggle({
	Name = "Priority on eggs with multiplier",
	Value = false,
	Flag = "Toggle999",
	Callback = function(Value)
		PriorEggOn = Value
	end,
})

local AutoAuraOn = false
local AutoAura = EggsTab:CreateToggle({
	Name = "Auto Aura Egg",
	Value = false,
	Flag = "Toggle1111",
	Callback = function(Value)
		AutoAuraOn = Value
	end,
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

local RiftsTab = Window:CreateTab("Rifts", "rewind")
local RiftText = RiftsTab:CreateSection("Allows you to view all rifts and teleport to them")

local riftsPath = {}

local rift1 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[1].Display.Position)
   end,
})

local rift2 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[2].Display.Position)
   end,
})

local rift3 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[3].Display.Position)
   end,
})

local rift4 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[4].Display.Position)
   end,
})

local rift5 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[5].Display.Position)
   end,
})

local rift6 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[6].Display.Position)
   end,
})

local rift7 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[7].Display.Position)
   end,
})

local rift8 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[8].Display.Position)
   end,
})

local rift9 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[9].Display.Position)
   end,
})

local rift10 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[10].Display.Position)
   end,
})

local rift11 = RiftsTab:CreateButton({
   Name = "",
   Callback = function()
	local teleport = coroutine.create(tp)
	coroutine.resume(teleport, riftsPath[11].Display.Position)
   end,
})

local ExtraTab = Window:CreateTab("Extra", "rewind")

local Rejoin = ExtraTab:CreateButton({
   Name = "Rejoin",
   Callback = function()
	game:GetService("TeleportService"):Teleport(85896571713843)
   end,
})

local rifts = {rift1, rift2, rift3, rift4, rift5, rift6, rift7, rift8, rift9, rift10, rift11}

for _,rift in pairs(workspace.Rendered.Rifts:GetChildren()) do
	rift.Display.CanCollide = false
	for _,a in pairs(rift.Sign:GetChildren()) do
		if a:IsA("Part") then
			a.CanCollide = false
		else
			for _,b in pairs(a:GetChildren()) do
				b.CanCollide = false
			end
		end
	end
end

workspace.Rendered.Rifts.ChildAdded:Connect(function(rift)
	task.wait(1)
	rift.Display.CanCollide = false
	for _,a in pairs(rift.Sign:GetChildren()) do
		if a:IsA("BasePart") then
			a.CanCollide = false
		else
			for _,b in pairs(a:GetChildren()) do
				b.CanCollide = false
			end
		end
	end
end)

for _,mountain in pairs(workspace.Worlds:FindFirstChild("The Overworld").Decoration.Mountains:GetChildren()) do
    for _,part in pairs(mountain:GetChildren()) do
        part.CanCollide = false
    end
end

local while3 = coroutine.create(function()
	while task.wait(1) do
		table.clear(riftsPath)
		for _,riftBtn in pairs(rifts) do
			riftBtn:Set("")
		end
		for i,rift in pairs(workspace.Rendered.Rifts:GetChildren()) do
			if not rift:FindFirstChild("Display") then continue end
			if not rift.Display:FindFirstChild("SurfaceGui") then continue end
			if not rift.Display.SurfaceGui:FindFirstChild("Timer") then continue end
			if string.find(rift.Name, "egg") and not rift.Display.SurfaceGui:FindFirstChild("Icon") then continue end
			local betterName = string.gsub(string.gsub(rift.Name, "-", " "), "(%a)([%w]*)", function(first, rest)
  				return string.upper(first) .. rest
			end)
			table.insert(riftsPath, rift)
			if string.find(rift.Name, "egg") or string.find(rift.Name, "event") then
				if betterName == "Man Egg" then
					betterName = "Aura Egg"
				elseif betterName == "Event 1" then
					betterName = "Bunny Egg"
				elseif betterName == "Event 2" then
					betterName = "Pastel Egg"
				end
				rifts[i]:Set(`{betterName} ({rift.Display.SurfaceGui.Timer.Text}) ({rift.Display.SurfaceGui.Icon.Luck.Text})`)
			else
				rifts[i]:Set(`{betterName} ({rift.Display.SurfaceGui.Timer.Text})`)
			end
			if not rift:FindFirstChild("Died") then
				local died = Instance.new("StringValue", rift)
				died.Name = "Died"
				if string.find(rift.Name, "event") and tonumber(string.sub(rift.Display.SurfaceGui.Icon.Luck.Text, 2)) == 25 then
					SendMessage(`> # :partying_face:﻿ x25 {betterName} Was Found At ~{math.round(rift.Display.Position.Y - 8)}m. <@&1361772075270017054> \n > ## Time Remaining {rift.Display.SurfaceGui.Timer.Text} \n > ### the link won't work if it's a private server \n > [Click to join](https://h4llstar.github.io/roblox-redirect/?placeId={game.PlaceId}&gameInstanceId={game.JobId})`, 1)
				end
				if string.find(rift.Name, "man-egg") then
					SendMessage(`> # :partying_face:﻿ {tonumber(string.sub(rift.Display.SurfaceGui.Icon.Luck.Text, 2))} {betterName} Was Found At ~{math.round(rift.Display.Position.Y - 8)}m. @everyone \n > ## Time Remaining {rift.Display.SurfaceGui.Timer.Text} \n > ### the link won't work if it's a private server \n > [Click to join](https://h4llstar.github.io/roblox-redirect/?placeId={game.PlaceId}&gameInstanceId={game.JobId})`, 1)
				end
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
		if AutoTicketOn then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("ClaimFreeWheelSpin")
		end
		if AutoWheelOn then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Function:InvokeServer("WheelSpin")
		end
	end
end)
coroutine.resume(while1)

local function Sell()
	Selling = true
	Player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(-70.75, 6859.23, 120.47))
	task.wait(0.5)
	Selling = false
end
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
		print(CurrentSellAmount)
		print(tonumber(string.gsub(string.match(Player.PlayerGui.ScreenGui.HUD.Left.Currency.Bubble.Frame.Label.Text, '>([%d,]+)<font'), ',', '')))
		if AutoSellOn and not teleporting and tonumber(string.gsub(string.match(Player.PlayerGui.ScreenGui.HUD.Left.Currency.Bubble.Frame.Label.Text, '>([%d,]+)<font'), ',', '')) >= CurrentSellAmount then
			local csell = coroutine.create(Sell)
			coroutine.resume(csell)
		end
		if AutoEggOn then
			if auraEgg then
				game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("HatchEgg", "Man Egg", CurrentEggsAmount)
			else
				game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("HatchEgg", SelectedEgg, CurrentEggsAmount)
			end
		else
			AutoEgg:Set(false)
		end
	end
end)
coroutine.resume(while2)

local auraEgg = false
local while4 = coroutine.create(function()
	while task.wait(2) do
		auraEgg = false
		local EggOnRift = nil
		for _,rift in pairs(workspace.Rendered.Rifts:GetChildren()) do
			if not rift:FindFirstChild("Display") then continue end
			if not rift.Display:FindFirstChild("SurfaceGui") then continue end
			if not rift.Display.SurfaceGui:FindFirstChild("Timer") then continue end
			if string.find(rift.Name, "egg") and not rift.Display.SurfaceGui:FindFirstChild("Icon") then continue end
			local betterName = string.gsub(string.gsub(rift.Name, "-", " "), "(%a)([%w]*)", function(first, rest)
  				return string.upper(first) .. rest
			end)
			if betterName == "Man Egg" then
				auraEgg = true
				EggOnRift = rift
			end
			if betterName == "Event 1" then
				betterName = "Bunny Egg"
			elseif betterName == "Event 2" then
				betterName = "Pastel Egg"
			end
			if betterName == SelectedEgg and not auraEgg then
				if EggOnRift then
					if tonumber(string.sub(rift.Display.SurfaceGui.Icon.Luck.Text, 2)) > tonumber(string.sub(EggOnRift.Display.SurfaceGui.Icon.Luck.Text, 2)) then
						if string.find(rift.Display.SurfaceGui.Timer.Text, "seconds") and tonumber(string.match(rift.Display.SurfaceGui.Timer.Text, "%d+")) > 15 then
						else
							EggOnRift = rift
						end
					end
				else
					if string.find(rift.Display.SurfaceGui.Timer.Text, "seconds") and tonumber(string.match(rift.Display.SurfaceGui.Timer.Text, "%d+")) > 15 then
					else
						EggOnRift = rift
					end
				end
			end
		end
		if not Selling and not teleporting then
			if AutoEggOn and SelectedEgg then
				if PriorEggOn and EggOnRift then
					local mag = (Player.Character.HumanoidRootPart.Position - EggOnRift.Display.Position).Magnitude
					if mag > 50 then
						game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn")
						task.wait(1)
						local teleport = coroutine.create(tp)
						coroutine.resume(teleport, EggOnRift.Display.Position)
						task.wait(((Player.Character.HumanoidRootPart.Position - Vector3.new(EggOnRift.Display.Position.X, Player.Character.HumanoidRootPart.Position.Y, EggOnRift.Display.Position.Z)).Magnitude/38)+0.4)
					end
				else
					local event = false
					if not EggsFolder:FindFirstChild(SelectedEgg) then
						if SelectedEgg == "Pastel Egg" or SelectedEgg == "Bunny Egg" then
							event = true
							game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("Teleport", "Workspace.Event.Portal.Spawn")
							task.wait(1)
							local teleport = coroutine.create(tp)
							coroutine.resume(teleport, Vector3.new(-396.6, 12013, -56.8))
							task.wait(((Player.Character.HumanoidRootPart.Position - Vector3.new(-396.6, 12013, -56.8)).Magnitude/38)+0.4)
						else
							game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("Teleport", "Workspace.Worlds.The Overworld.FastTravel.Spawn")
							task.wait(1)
						end
					end
					local mag = (Player.Character.HumanoidRootPart.Position - EggsFolder:FindFirstChild(SelectedEgg).Prompt.Position).Magnitude
					if mag > 15 then
						local teleport = coroutine.create(tp)
						coroutine.resume(teleport, EggsFolder:FindFirstChild(SelectedEgg).Prompt.Position)
						task.wait(((Player.Character.HumanoidRootPart.Position - Vector3.new(EggsFolder:FindFirstChild(SelectedEgg).Prompt.Position.X, Player.Character.HumanoidRootPart.Position.Y, EggsFolder:FindFirstChild(SelectedEgg).Prompt.Position.Z)).Magnitude/38)+0.4)
					end
				end
			end
		end
	end
end)
coroutine.resume(while4)
