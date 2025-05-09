extends Node

var selected_tool: DataTypes.Tools = DataTypes.Tools.None
var tool_states := {
	"tilling": false,
	"watering_can": false,
	"corn": false,
	"tomato": false
}

signal tool_selected(tool: DataTypes.Tools) 
signal enable_tool(tool : DataTypes.Tools)


func select_tool(tool: DataTypes.Tools) -> void:
	tool_selected.emit(tool)
	selected_tool = tool

func enable_tool_button(tool : DataTypes.Tools) -> void:
	enable_tool.emit(tool)

func get_enabled_tool_states() -> Dictionary:
	return tool_states

func set_enabled_tool_states(states: Dictionary) -> void:
	tool_states = states
