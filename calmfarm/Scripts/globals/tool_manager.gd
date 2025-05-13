extends Node

var selected_tool : DataTypes.Tools = DataTypes.Tools.None
var tool_states := {
	DataTypes.Tools.TillGround   : false,
	DataTypes.Tools.WaterCrops   : false,
	DataTypes.Tools.PlantCorn    : false,
	DataTypes.Tools.PlantTomato  : false,
}

signal tool_selected(tool : DataTypes.Tools)
signal enable_tool(tool  : DataTypes.Tools)


func select_tool(tool: DataTypes.Tools) -> void:
	selected_tool = tool
	tool_selected.emit(tool)


func enable_tool_button(tool: DataTypes.Tools) -> void:
	tool_states[tool] = true
	enable_tool.emit(tool)


func get_enabled_tool_states() -> Dictionary:
	return tool_states


func set_enabled_tool_states(states: Dictionary) -> void:
	tool_states = states.duplicate(true)
	for tool in tool_states.keys():
		if tool_states[tool]:
			enable_tool.emit(tool)
