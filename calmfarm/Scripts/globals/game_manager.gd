extends Node

var game_menu_screen = preload("res://Scenes/ui/game_menu_screen.tscn")
@onready var player: Player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

func start_game() -> void:
	SceneManager.load_main_scene_container()
	SceneManager.load_level("Level1") 
	await get_tree().process_frame
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	var save_path = "user://game_data/save_Level1_game_data.res"
	if FileAccess.file_exists(save_path):
		SaveGameManager.load_game()
	else:
		var spawn = get_spawn_position()
		set_player_position(spawn)

	SaveGameManager.allow_save_game = true

func exit_game() -> void:
	get_tree().quit()

func show_game_menu_screen() -> void:
	var game_menu_screen_instance = game_menu_screen.instantiate()
	get_tree().root.add_child(game_menu_screen_instance)

func get_player_position() -> Vector2:
	if player and is_instance_valid(player):
		return player.global_position
	return get_spawn_position()

func set_player_position(pos: Vector2) -> void:
	if not is_instance_valid(player):
		await get_tree().process_frame
		player = get_tree().get_first_node_in_group("player")

	if player:
		player.global_position = pos

func get_spawn_position() -> Vector2:
	var scene = get_tree().get_current_scene()
	if scene:
		var fallback = scene.get_node_or_null("MainScene/GameRoot/PlayerSpawn") or scene.get_node_or_null("PlayerSpawn")
		if fallback:
			return fallback.global_position
	return Vector2(500, 250)
