extends Node

var master_volume_db: float = 0.0  # 0 = normal, -80 = mute
var day_night_enabled: bool = true

var day_night_component: DayNightCycleComponent = null
var audio_node: Node = null

func _ready() -> void:
	if day_night_component:
		day_night_component.visible = day_night_enabled
	if audio_node:
		AudioServer.set_bus_volume_db(audio_node.index, master_volume_db)

func set_day_night_enabled(enabled: bool) -> void:
	day_night_enabled = enabled
	if day_night_component:
		day_night_component.visible = enabled

func set_master_volume(db: float) -> void:
	master_volume_db = db
	if audio_node:
		AudioServer.set_bus_volume_db(audio_node.index, db)

func get_settings_state() -> Dictionary:
	return {
		"master_volume_db": master_volume_db,
		"day_night_enabled": day_night_enabled
	}

func set_settings_state(state: Dictionary) -> void:
	set_master_volume(state.get("master_volume_db", 0.0))
	set_day_night_enabled(state.get("day_night_enabled", true))
