class_name PlayerDataResource
extends NodeDataResource


func _save_data(node: Node2D) -> void:
	position = node.global_position
	node_path = node.get_path()

func _load_data(window: Window) -> void:
	if node_path == null:
		return
	
	var node = window.get_node_or_null(node_path)
	if node:
		node.global_position = position
