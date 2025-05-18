extends PanelContainer

@onready var tool_axe: Button         = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_tilling: Button     = $MarginContainer/HBoxContainer/ToolTilling
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_corn: Button        = $MarginContainer/HBoxContainer/ToolCorn
@onready var tool_tomato: Button      = $MarginContainer/HBoxContainer/ToolTomato

func _ready() -> void:
	# Connect signal for unlocking new tools
	ToolManager.enable_tool.connect(Callable(self, "on_enable_tool_button"))

	# Disable locked tools initially
	for btn in [tool_tilling, tool_watering_can, tool_corn, tool_tomato]:
		btn.disabled = true
		btn.focus_mode = Control.FOCUS_NONE

	# THIS LINE alone stops any mouse clicks on this panel (and its children)
	mouse_filter = Control.MOUSE_FILTER_STOP

func _on_tool_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.AxeWood)

func _on_tool_tilling_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.TillGround)

func _on_tool_watering_can_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WaterCrops)

func _on_tool_corn_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantCorn)

func _on_tool_tomato_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantTomato)

func _input(event: InputEvent) -> void:
	# Keyboard/controller “release tool” still works
	if event.is_action_pressed("release_tool"):
		ToolManager.select_tool(DataTypes.Tools.None)
		for btn in [tool_axe, tool_tilling, tool_watering_can, tool_corn, tool_tomato]:
			btn.release_focus()

func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	match tool:
		DataTypes.Tools.TillGround:
			tool_tilling.disabled = false
			tool_tilling.focus_mode = Control.FOCUS_ALL
		DataTypes.Tools.WaterCrops:
			tool_watering_can.disabled = false
			tool_watering_can.focus_mode = Control.FOCUS_ALL
		DataTypes.Tools.PlantCorn:
			tool_corn.disabled = false
			tool_corn.focus_mode = Control.FOCUS_ALL
		DataTypes.Tools.PlantTomato:
			tool_tomato.disabled = false
			tool_tomato.focus_mode = Control.FOCUS_ALL
