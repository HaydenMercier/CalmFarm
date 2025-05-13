class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_%s_game_data.res"
var game_data_resource: SaveGameDataResource

const ENCRYPTION_KEY := "#S0M3TH1N9P0L1T1caL!!"

func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name

func save_node_data() -> void:
	game_data_resource = SaveGameDataResource.new()
	for node: SaveDataComponent in get_tree().get_nodes_in_group("save_data_component"):
		if node is SaveDataComponent:
			var save_data_resource: NodeDataResource = node._save_data()
			game_data_resource.save_data_nodes.append(save_data_resource.duplicate())
	if InventoryManager:
		game_data_resource.inventory_data = InventoryManager.get_inventory_state()

	if ToolManager:
		game_data_resource.tool_data = ToolManager.get_enabled_tool_states()

	if Settings:
		game_data_resource.settings_data = Settings.get_settings_state()

	if GameManager:
		game_data_resource.player_data   = { "position": GameManager.get_player_position() }

	if DayAndNightCycleManager:
		game_data_resource.time_data = DayAndNightCycleManager.get_time_state()

func save_game() -> void:
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)

	var level_save_file_name: String = save_file_name % level_scene_name

	save_node_data()

	var temp_path = save_game_data_path + "temp_save.res"
	var result: int = ResourceSaver.save(game_data_resource, temp_path, ResourceSaver.FLAG_COMPRESS)
	print("raw save result:", result)

	var file = FileAccess.open(temp_path, FileAccess.READ)
	var raw_data = file.get_buffer(file.get_length())
	file.close()

	var encrypted_data = xor_data(raw_data, ENCRYPTION_KEY)

	var final_path = save_game_data_path + level_save_file_name
	var enc_file = FileAccess.open(final_path, FileAccess.WRITE)
	enc_file.store_buffer(encrypted_data)
	enc_file.close()

	DirAccess.remove_absolute(temp_path)

	print("Encrypted save written to:", final_path)


func xor_data(data: PackedByteArray, key: String) -> PackedByteArray:
	var key_bytes = key.to_utf8_buffer()
	var result = PackedByteArray()
	var key_len = key_bytes.size()

	for i in data.size():
		result.append(data[i] ^ key_bytes[i % key_len])

	return result


func load_game() -> void:
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_game_data_path + level_save_file_name

	if !FileAccess.file_exists(save_game_path):
		return

	var enc_file = FileAccess.open(save_game_path, FileAccess.READ)
	var encrypted_data = enc_file.get_buffer(enc_file.get_length())
	enc_file.close()

	var decrypted_data = xor_data(encrypted_data, ENCRYPTION_KEY)

	var temp_path = save_game_data_path + "temp_load.res"
	var temp_file = FileAccess.open(temp_path, FileAccess.WRITE)
	temp_file.store_buffer(decrypted_data)
	temp_file.close()

	game_data_resource = ResourceLoader.load(temp_path)
	DirAccess.remove_absolute(temp_path)

	if game_data_resource == null:
		return

	var root_node: Window = get_tree().root

	if InventoryManager:
		InventoryManager.set_inventory_state(game_data_resource.inventory_data)

	if ToolManager:
		ToolManager.set_enabled_tool_states(game_data_resource.tool_data)

	if Settings:
		Settings.set_settings_state(game_data_resource.settings_data)

	if GameManager:
		GameManager.set_player_position(game_data_resource.player_data.get("position", Vector2.ZERO))

	if DayAndNightCycleManager:
		DayAndNightCycleManager.set_time_state(game_data_resource.time_data)

	for resource in game_data_resource.save_data_nodes:
		if resource is NodeDataResource:
			resource._load_data(root_node)
