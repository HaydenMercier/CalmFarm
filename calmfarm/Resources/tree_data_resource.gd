class_name TreeDataResource
extends NodeDataResource

@export var is_chopped: bool = false


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	is_chopped = node._get_serialized_data().get("is_chopped", false)

func _load_data(window: Window) -> void:
	super._load_data(window)
	var node = window.get_node_or_null(node_path)
	if node:
		node.call_deferred("apply_serialized_state", {"is_chopped": is_chopped})
