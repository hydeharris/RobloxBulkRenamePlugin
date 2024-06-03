local toolbar = plugin:CreateToolbar("Bulk Rename")

local ToggleButton = toolbar:CreateButton("Rename Instances", "Activate GUI Tool","rbxassetid://16811360870")

local Selection = game:GetService("Selection")

local HistoryService = game:GetService("ChangeHistoryService")

local newName = nil

local gui = script:WaitForChild("BulkRenameGui", 10)
if gui == nil then 
	warn("Bulk Rename Gui not found!")
end


local main = gui:WaitForChild("Main")
local ActivationButtons = main.EnableButtonFrame 
local closeButton = main.PluginTitleFrame.CloseButton


local function renameInstances(intances)
	for i, v in pairs(intances) do
		v.Name = newName
	end
	HistoryService:SetWaypoint("Changed Instance Names.")
end




local function onSelectionConnection()
	if gui.Parent == game:WaitForChild("CoreGui") then
		gui.Main.IntancesSelected.Text = #Selection:Get().. " Instances Selected"
	end	
end

local SelectionConnection = Selection.SelectionChanged:Connect(onSelectionConnection)

task.wait()
SelectionConnection:Disconnect() // Initial Disconnect

ActivationButtons.ActivateButton.Activated:Connect(function()
	if Selection:Get()[1]==nil then return end 
	
	local newName = gui.Main.NameFrame.InputFrame.NameInput.Text
	if tostring(newName) == nil then 
		warn("NAME NOT INPUTTED")
		return 
	end
	
	renameInstances(Selection:Get(), newName)
end)

gui.Main.NameFrame.InputFrame.NameInput.FocusLost:Connect(function()
	HistoryService:SetWaypoint("Changed Instance Names.")
	newName =  gui.Main.NameFrame.InputFrame.NameInput.Text
	gui.Main.IntancesSelected.Text = #Selection:Get()
end)

ToggleButton.Click:Connect(function()
	if gui.Parent == script then
		gui.Parent = game:WaitForChild("CoreGui")
		if not SelectionConnection.Connected then 
			SelectionConnection = Selection.SelectionChanged:Connect(onSelectionConnection)
		end
	elseif gui.Parent == game:WaitForChild("CoreGui") then
		gui.Parent = script
		if SelectionConnection.Connected then 
			SelectionConnection:Disconnect() // Stop listening to save resources
		end
	end
end)

closeButton.Activated:Connect(function()
	gui.Parent = script
	if SelectionConnection.Connected then 
		SelectionConnection:Disconnect() // Stop listening to save resources
	end
end)
