extends Node

@export var tilemap_layer: TileMapLayer
@export var tree_parent: Node2D

var tile_to_scene_map := {
	2: preload("res://Scenes/objects/tree/small_tree.tscn"),
	3: preload("res://Scenes/objects/tree/large_tree.tscn"),
}

func _ready():
	replace_tiles_with_scenes()

func replace_tiles_with_scenes():
	for cell in tilemap_layer.get_used_cells():
		var tile_id := tilemap_layer.get_cell_source_id(cell)
		if tile_to_scene_map.has(tile_id):
			var scene = tile_to_scene_map[tile_id]
			var instance = scene.instantiate()
			instance.global_position = tilemap_layer.map_to_local(cell)
			tree_parent.add_child(instance)

	print("🌳 Trees instantiated successfully.")
