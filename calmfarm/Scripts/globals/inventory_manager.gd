extends Node

var inventory: Dictionary = Dictionary()

signal inventory_changed

func add_collectable(collectable_name: String) -> void:
	inventory.get_or_add(collectable_name)
	
	if inventory[collectable_name] == null:
		inventory[collectable_name] = 1
		print(inventory[collectable_name])

	else:
		inventory[collectable_name] += 1
		print(inventory[collectable_name])
		
	inventory_changed.emit()
