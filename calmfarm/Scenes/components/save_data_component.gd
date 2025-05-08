class_name SaveDataComponent
extends Node

@onready var parent_node: Node2D = get_parent() as Node2D

@export var save_data_resource: Resource

func _ready() -> void:
	add_to_group("save_data_component")

func get_serialized_data() -> Dictionary:
	if owner.has_method("_get_serialized_data"):
		return owner._get_serialized_data()
	return {}

func load_serialized_data(data: Dictionary) -> void:
	if owner.has_method("_load_serialized_data"):
		owner._load_serialized_data(data)

func _save_data() -> Resource:
	if parent_node == null:
		return null
	
	if save_data_resource == null:
		push_error("SaveDataComponent: Missing save_data_resource for", parent_node.name)
		return null
	
	save_data_resource._save_data(parent_node)
	return save_data_resource

func apply_loaded_data(resource: Resource) -> void:
	if resource == null or not resource is NodeDataResource:
		push_error("SaveDataComponent: Tried to load invalid resource into " + str(parent_node.name))
		return
	
	save_data_resource = resource
	if parent_node != null and save_data_resource.has_method("_load_data"):
		(save_data_resource as NodeDataResource)._load_data(get_tree().root)
