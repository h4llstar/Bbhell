local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local TweenService = game:GetService("TweenService")
local Info = TweenInfo.new(10)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local Pets = require(ReplicatedStorage.Shared.Data.Pets)
local LocalDataService = require(ReplicatedStorage.Client.Framework.Services.LocalData)
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

-- Webhook Notifications
local WebhookTab = Window:CreateTab("Webhook", "rewind")
_G.WebhookURL = ""

local LegendaryPets = {}
for name, pet in pairs(Pets) do
    if pet.Rarity == "Legendary" then
        table.insert(LegendaryPets, name)
    end
end

local function convertToShorter(number, kind)
    if kind == "seconds" then
        return math.floor(number / 3600) .. "h " .. math.floor((number % 3600) / 60) .. "m " .. (number % 60) .. "s"
    elseif kind == "hatches" then
        return string.format("%.2fk", number / 1000)
    elseif kind == "bubbles" then
        return number < 1e6 and number or (number < 1e9 and string.format("%.2fm", number / 1e6) or string.format("%.2fb", number / 1e9))
    end
end

local function getStats()
    local data = LocalDataService:Get()
    local total = 0
    for _, v in pairs(data.Pets) do total += v.Amount or 0 end
    return {
        playTime = convertToShorter(data.Stats.Playtime or 0, "seconds"),
        hatches = convertToShorter(data.Stats.Hatches or 0, "hatches"),
        bubbles = convertToShorter(data.Stats.Bubbles or 0, "bubbles"),
        totalPets = total,
        gems = data.Gems
    }
end

local function getImageThumbnail(assetId)
    local id = assetId:match("rbxassetid://(%d+)")
    if not id then return nil end
    local result = syn.request({
        Url = "https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&size=420x420&format=png&isCircular=false",
        Method = "GET",
        Headers = { ["Content-Type"] = "application/json" }
    })
    local data = HttpService:JSONDecode(result.Body)
    return data.data[1] and data.data[1].imageUrl or nil
end

local WebhookHandler = {}
WebhookHandler.__index = WebhookHandler

function WebhookHandler.new()
    local self = setmetatable({}, WebhookHandler)
    self.remoteEvent = ReplicatedStorage.Shared.Framework.Network.Remote.Event
    self.webhookUrl = _G.WebhookURL
    self:initialize()
    return self
end

function WebhookHandler:initialize()
    self.remoteEvent.OnClientEvent:Connect(function(...)
        self:handleEvent(...)
    end)
end

function WebhookHandler:handleEvent(...)
    local args = { ... }
    if args[1] == "HatchEgg" and typeof(args[2]) == "table" then
        for _, pet in ipairs(args[2].Pets or {}) do
            if pet.Pet and table.find(LegendaryPets, pet.Pet.Name) then
                self:sendWebhook(pet.Pet)
            end
        end
    end
end

function WebhookHandler:sendWebhook(petData)
    local info = Pets[petData.Name]
    local image = info.Images and info.Images.Normal and getImageThumbnail(info.Images.Normal) or nil
    local stats = getStats()

    local embed = {
        title = "Legendary Pet Hatched!",
        description = Player.Name .. " just hatched a **" .. petData.Name .. "**!",
        color = 0xFF9900,
        fields = {
            { name = "Pet Name", value = petData.Name, inline = true },
            { name = "Rarity", value = info.Rarity or "Unknown", inline = true },
            { name = "Shiny", value = petData.Shiny and "Yes" or "No", inline = true },
            { name = "Gems", value = convertToShorter(stats.gems, "bubbles"), inline = true },
            { name = "Total Pets", value = convertToShorter(stats.totalPets, "hatches"), inline = true },
            { name = "Playtime", value = stats.playTime, inline = true },
            { name = "Hatches", value = stats.hatches, inline = true },
            { name = "Bubbles", value = stats.bubbles, inline = true }
        },
        footer = {
            text = "Made By West | " .. os.date("%Y-%m-%d %H:%M:%S")
        },
        thumbnail = image and { url = image } or nil
    }

    local payload = HttpService:JSONEncode({
        username = "Legendary Pet Notifier",
        avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. Player.UserId .. "&width=420&height=420&format=png",
        embeds = { embed }
    })

    pcall(function()
        syn.request({
            Url = self.webhookUrl,
            Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = payload
        })
    end)
end

WebhookTab:CreateInput({
    Name = "Webhook URL",
    PlaceholderText = "Paste your Discord webhook here",
    RemoveTextAfterFocusLost = false,
    Callback = function(state)
        if state and state:match("^https://") then
            _G.WebhookURL = state
            WebhookHandler.new()
        end
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
