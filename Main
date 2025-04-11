-- Load Linoria and check for success
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
if not Library or typeof(Library.CreateWindow) ~= "function" then
    warn("Failed to load Linoria Library.")
    return
end

local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

-- Create main window
local Window = Library:CreateWindow({
    Title = 'BGS Infinity | Wave',
    Center = true,
    AutoShow = true
})

if not Window or typeof(Window.AddTab) ~= "function" then
    warn("Failed to create Linoria Window.")
    return
end

-- Setup tabs
local MainTab = Window:AddTab('Main')
local UITab = Window:AddTab('UI Settings')

-- Internal state
local Toggles = {}
local selectedEgg = nil

-- Get dynamic egg list
local eggList = {}
for _, island in ipairs(workspace.Worlds["The Overworld"].Islands:GetChildren()) do
	for _, obj in ipairs(island:GetChildren()) do
		if obj:FindFirstChild("Egg") then
			table.insert(eggList, obj.Name)
		end
	end
end

-- Add Toggles and Dropdown
MainTab:AddToggle('AutoBlow', {
	Text = 'Auto Blow',
	Default = false
}):OnChanged(function(state)
	Toggles.AutoBlow = state
end)

MainTab:AddToggle('AutoSell', {
	Text = 'Auto Sell',
	Default = false
}):OnChanged(function(state)
	Toggles.AutoSell = state
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
}):OnChanged(function(state)
	Toggles.AutoHatch = state
end)

-- Background loops
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

-- Setup UI settings
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
SaveManager:SetFolder('Wave/BGSInfinity')
SaveManager:BuildConfigSection(UITab)
ThemeManager:ApplyToTab(UITab)
