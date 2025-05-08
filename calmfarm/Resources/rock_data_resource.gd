class_name RockDataResource
extends NodeDataResource

@export var is_mined: bool = false

func _save_data(node: Node2D) -> void:
	super._save_data(node)
	is_mined = node.is_mined

func _load_data(window: Window) -> void:
	var node = window.get_node_or_null(node_path)
	if node and "is_mined" in node:
		node.is_mined = is_mined
		if is_mined:
			node.queue_free()
