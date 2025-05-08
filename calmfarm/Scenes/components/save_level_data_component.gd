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
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	
	game_data_resource = SaveGameDataResource.new()
	
	if nodes != null:
		for node: SaveDataComponent in nodes:
			if node is SaveDataComponent:
				var save_data_resource: NodeDataResource = node._save_data()
				var save_final_resource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)


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
	for resource in game_data_resource.save_data_nodes:
		if resource is NodeDataResource:
			resource._load_data(root_node)
