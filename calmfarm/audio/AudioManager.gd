extends Node

const bus_name = "Master"
var index = AudioServer.get_bus_index(bus_name)

func _ready() -> void:
	GameDialogueManager.mute.connect(on_mute)
	GameDialogueManager.normal.connect(on_normal)
	Settings.audio_node = self
	Settings.set_master_volume(0.0)

func get_bus_index(bus_name: String) -> int:
	return AudioServer.get_bus_index(bus_name)


func on_mute() -> void:
	AudioServer.set_bus_volume_db(index, -80)

func on_normal() -> void:
	AudioServer.set_bus_volume_db(index, 0)
