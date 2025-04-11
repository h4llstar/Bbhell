local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

-- Load Linoria UI
local success, Library = pcall(loadstring, game:HttpGet(repo .. 'Library.lua'))
if not success or not Library then
    warn("Failed to load Linoria.")
    return
end

Library = Library()

-- Addons
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- Wait for PlayerGui
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create Window
local Window = Library:CreateWindow({
    Title = 'BGS Infinity | Wave',
    Center = true,
    AutoShow = true
})

-- Confirm Tabs work
local MainTab = Window:AddTab('Main')
local UITab = Window:AddTab('UI Settings')

-- Internal state
local Toggles = {}
local selectedEgg = nil

-- Gather egg list
local eggList = {}
for _, island in ipairs(workspace.Worlds["The Overworld"].Islands:GetChildren()) do
	for _, obj in ipairs(island:GetChildren()) do
		if obj:FindFirstChild("Egg") then
			table.insert(eggList, obj.Name)
		end
	end
end

-- Setup UI elements after everything is confirmed
MainTab:AddToggle('AutoBlow', {
	Text = 'Auto Blow',
	Default = false
}):OnChanged(function(val)
	Toggles.AutoBlow = val
end)

MainTab:AddToggle('AutoSell', {
	Text = 'Auto Sell',
	Default = false
}):OnChanged(function(val)
	Toggles.AutoSell = val
end)

MainTab:AddDropdown('EggDropdown', {
	Values = eggList,
	Default = 1,
	Multi = false,
	Text = 'Select Egg'
}):OnChanged(function(val)
	selectedEgg = val
end)

MainTab:AddToggle('AutoHatch', {
	Text = 'Auto Hatch',
	Default = false
}):OnChanged(function(val)
	Toggles.AutoHatch = val
end)

-- Loops
task.spawn(function()
	while task.wait() do
		if Toggles.AutoBlow then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("BlowBubble")
		end
	end
end)

task.spawn(function()
	while task.wait(1) do
		if Toggles.AutoSell then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("SellBubble")
		end
	end
end)

task.spawn(function()
	while task.wait() do
		if Toggles.AutoHatch and selectedEgg then
			game.ReplicatedStorage.Shared.Framework.Network.Remote.Event:FireServer("HatchEgg", selectedEgg, 1)
		end
	end
end)

-- UI Persistence
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder('Wave/BGSInfinity')
SaveManager:BuildConfigSection(UITab)
ThemeManager:ApplyToTab(UITab)
