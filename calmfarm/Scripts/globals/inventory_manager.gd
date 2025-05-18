extends Node

var inventory: Dictionary = {}

signal inventory_changed

const MAX_ITEM_COUNT := 999

func add_collectable(collectable_name: String) -> void:
	inventory.get_or_add(collectable_name, 0)

	if inventory[collectable_name] < MAX_ITEM_COUNT:
		inventory[collectable_name] += 1

	inventory_changed.emit()


func remove_collectable(collectable_name: String) -> void:
	if inventory.get(collectable_name, 0) > 0:
		inventory[collectable_name] -= 1

	inventory_changed.emit()

func get_inventory_state() -> Dictionary:
	return inventory

func set_inventory_state(state: Dictionary) -> void:
	inventory = state
	inventory_changed.emit()
