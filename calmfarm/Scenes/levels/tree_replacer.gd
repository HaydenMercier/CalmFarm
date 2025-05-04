@tool
extends EditorScript

func _run():
	# Get the currently opened scene's root
	var editor_interface = get_editor_interface()
	var scene = editor_interface.get_edited_scene_root()
	if scene == null:
		push_error("❌ No scene is currently open.")
		return

	# Adjust this path to your actual TileMapLayer node
	var tilemap_layer: TileMapLayer = scene.get_node("GameTilemap/Trees")
	if tilemap_layer == null:
		push_error("❌ TileMapLayer 'GameTilemap/Trees' not found.")
		return

	# Map tile IDs to scene files
	var tile_to_scene_map: Dictionary = {
		3: preload("res://Scenes/objects/tree/large_tree.tscn"),
		2: preload("res://Scenes/objects/tree/small_tree.tscn")
	}

	# Create a container for the instances
	var container := Node2D.new()
	container.name = "InstancedTiles"
	scene.add_child(container)

	# Loop through all tiles in the TileMapLayer
	for cell in tilemap_layer.get_used_cells():
		var tile_id := tilemap_layer.get_cell_source_id(0, cell)
		if tile_to_scene_map.has(tile_id):
			var tree_scene: PackedScene = tile_to_scene_map[tile_id]
			var instance := tree_scene.instantiate()
			instance.global_position = tilemap_layer.map_to_local(cell)
			container.add_child(instance)

	print("✅ Done replacing tiles with scene instances.")
