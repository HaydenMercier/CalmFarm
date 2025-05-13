class_name SceneDataResource
extends NodeDataResource

@export var node_name: String
@export var scene_file_path: String
var spawned_node: Node2D = null

func _save_data(node: Node2D) -> void:
	super._save_data(node)
	node_name = node.name
	scene_file_path = node.scene_file_path
	parent_node_path = node.get_parent().get_path()
	position = node.global_position

func _load_data(window: Window) -> void:
	super._load_data(window)

	spawned_node = null
	var parent_node: Node2D = null

	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)

	if scene_file_path != "":
		var scene_file_resource: Resource = load(scene_file_path)
		if not scene_file_resource:
			push_error("Failed to load scene: " + scene_file_path)
			return
		spawned_node = scene_file_resource.instantiate() as Node2D

	if parent_node != null and spawned_node != null:
		spawned_node.global_position = position
		parent_node.add_child(spawned_node)
