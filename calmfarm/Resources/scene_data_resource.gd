class_name SceneDataResource
extends NodeDataResource

@export var node_name: String
@export var scene_file_path: String
var spawned_node: Node2D = null


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	node_name = node.name
	scene_file_path = node.scene_file_path


func _load_data(window: Window) -> void:
	var parent_node: Node2D
	spawned_node = null
	
	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)
	
	if scene_file_path != "":
		var scene_file_resource: Resource = load(scene_file_path)
		if not scene_file_resource:
			push_error("Failed to load scene: " + scene_file_path)
			return
		spawned_node = scene_file_resource.instantiate() as Node2D
	
	if parent_node != null and spawned_node != null:
		spawned_node.global_position = global_position
		parent_node.add_child(spawned_node)
