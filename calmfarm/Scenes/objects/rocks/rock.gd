extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var save_data_component: SaveDataComponent = $SaveDataComponent

var stone_scene = preload("res://Scenes/objects/rocks/stone.tscn")
var is_mined: bool = false

func _ready() -> void:
	if save_data_component.save_data_resource == null:
		save_data_component.save_data_resource = preload("res://Resources/rock_data_resource.tres").duplicate()
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)

func _get_serialized_data() -> Dictionary:
	return {
		"is_mined": is_mined
	}

func _apply_serialized_state(data: Dictionary) -> void:
	is_mined = data.get("is_mined", false)
	if is_mined:
		hide()
		$StaticBody2D/CollisionShape2D.disabled = true
		$AreaBlocker.disabled = true

func on_hurt(hit_damage: int) -> void:
	if is_mined:
		return
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 0.15)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damage_reached() -> void:
	if is_mined:
		return
	is_mined = true
	var data = save_data_component.save_data_resource as RockDataResource
	data.is_mined = true
	await get_tree().create_timer(0.5).timeout
	call_deferred("add_stone_scene")
	hide()
	$StaticBody2D/CollisionShape2D.disabled = true
	$AreaBlocker.disabled = true


func add_stone_scene() -> void:
	var stone_instance = stone_scene.instantiate()
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)
