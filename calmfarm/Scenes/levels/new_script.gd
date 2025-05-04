@tool
extends Node

@onready var tilemap_layer: TileMapLayer = $GameTilemap/Trees
@onready var tree_parent: Node2D = $TreesInstances

@export var generate_instances: bool = false  # Checkbox in the Inspector

var tile_to_scene_map := {
	2: preload("res://Scenes/objects/tree/small_tree.tscn"),
	3: preload("res://Scenes/objects/tree/large_tree.tscn")
}

func _process(_delta):
	if Engine.is_editor_hint() and generate_instances:
		generate_instances = false  # reset checkbox
		replace_tiles_with_scenes()

func replace_tiles_with_scenes():
	tree_parent.clear()  # Clear existing tree instances

	for cell in tilemap_layer.get_used_cells():
		var tile_id = tilemap_layer.get_cell_source_id(cell)
		if tile_to_scene_map.has(tile_id):
			var scene = tile_to_scene_map[tile_id]
			var instance = scene.instantiate()
			instance.global_position = tilemap_layer.map_to_local(cell)
			tree_parent.add_child(instance)

	print("🌲 Trees instantiated successfully.")
