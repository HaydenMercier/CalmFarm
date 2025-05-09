class_name RockDataResource
extends NodeDataResource

@export var is_mined: bool = false


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	is_mined = node._get_serialized_data().get("is_mined", false)

func _load_data(window: Window) -> void:
	super._load_data(window)
	var node = window.get_node_or_null(node_path)
	if node:
		node.call_deferred("_apply_serialized_state", {"is_mined": is_mined})
