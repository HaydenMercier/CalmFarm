extends Node
var master_volume_db  : float = 0.0
var day_night_enabled : bool  = true

@export var audio_bus_name : String = "Master"

@export var day_night_overlay : NodePath = NodePath():
	set(value):
		day_night_overlay = value
		_overlay = _resolve_overlay(value)
		_apply_overlay_visibility()

var _audio_bus_idx : int = -1
@onready var _overlay : CanvasItem = null

func _ready() -> void:
	_audio_bus_idx = AudioServer.get_bus_index(audio_bus_name)
	_overlay       = _resolve_overlay(day_night_overlay)

	set_master_volume(master_volume_db)
	_apply_overlay_visibility()

func set_master_volume(db: float) -> void:
	master_volume_db = clamp(db, -80.0, 0.0)
	if _audio_bus_idx != -1:
		AudioServer.set_bus_volume_db(_audio_bus_idx, master_volume_db)
	else:
		push_warning("Audio bus '%s' not found; volume unchanged." % audio_bus_name)

func set_day_night_enabled(enabled: bool) -> void:
	day_night_enabled = enabled
	_apply_overlay_visibility()

func _apply_overlay_visibility() -> void:
	if _overlay:
		_overlay.visible = day_night_enabled
	else:
		push_warning("No CanvasItem set for day_night_overlay; toggle ignored.")

func _resolve_overlay(path: NodePath) -> CanvasItem:
	var node := get_node_or_null(path)
	return node if node is CanvasItem else null

func get_settings_state() -> Dictionary:
	var vol_db : float
	if _audio_bus_idx == -1:
		vol_db = master_volume_db
	else:
		vol_db = AudioServer.get_bus_volume_db(_audio_bus_idx)

	var overlay_visible : bool = day_night_enabled
	if _overlay and _overlay is CanvasItem:
		overlay_visible = _overlay.visible

	return {
		"master_volume_db"  : vol_db,
		"day_night_enabled" : overlay_visible,
	}

func set_settings_state(state: Dictionary) -> void:
	set_master_volume(   state.get("master_volume_db",  0.0))
	set_day_night_enabled(state.get("day_night_enabled", true))
