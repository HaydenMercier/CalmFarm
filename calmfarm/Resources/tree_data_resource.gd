class_name TreeDataResource
extends NodeDataResource

@export var is_chopped: bool = false

func _save_data(node: Node2D) -> void:
	super._save_data(node)
	is_chopped = node.is_chopped

func _load_data(window: Window) -> void:
	var node = window.get_node_or_null(node_path)
	if node and "is_chopped" in node:
		node.is_chopped = is_chopped
		if is_chopped:
			node.queue_free()
