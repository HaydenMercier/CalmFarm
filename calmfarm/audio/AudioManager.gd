extends Node

const BUS_NAME: String = "Master"
var index: int = AudioServer.get_bus_index(BUS_NAME)


func _ready() -> void:
	GameDialogueManager.mute.connect(on_mute)
	GameDialogueManager.normal.connect(on_normal)
	Settings.set_master_volume(0.0)


func on_mute() -> void:
	Settings.set_master_volume(-80.0)


func on_normal() -> void:
	Settings.set_master_volume(0.0)
