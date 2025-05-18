class_name FieldCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 1

var player: Player
var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		if Input.is_action_just_pressed("remove_dirt") \
		and ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			remove_tilled_soil_cell()
		elif Input.is_action_just_pressed("hit") \
		and ToolManager.selected_tool == DataTypes.Tools.TillGround:
			get_cell_under_mouse()
			add_tilled_soil_cell()

func get_cell_under_mouse() -> void:
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

func is_tile_blocked(position: Vector2) -> bool:
	var world = get_viewport().get_world_2d()
	var space_state = world.direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = position
	query.collide_with_areas = true
	query.collision_mask = 0xFFFFFFFF
	for result in space_state.intersect_point(query):
		if result["collider"].is_in_group("till_blocker"):
			return true
	return false

func add_tilled_soil_cell() -> void:
	if distance < 20.0 and cell_source_id != -1 and not is_tile_blocked(local_cell_position):
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], terrain_set, terrain, true)

func remove_tilled_soil_cell() -> void:
	if distance < 20.0:
		tilled_soil_tilemap_layer.set_cells_terrain_connect([cell_position], 0, -1, true)
