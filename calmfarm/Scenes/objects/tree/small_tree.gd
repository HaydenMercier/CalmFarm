extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var save_data_component: SaveDataComponent = $SaveDataComponent

var log_scene = preload("res://Scenes/objects/tree/log.tscn")
var is_chopped: bool = false

func _ready() -> void:
	save_data_component.save_data_resource = save_data_component.save_data_resource.duplicate()

	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damage_reached.connect(on_max_damage_reached)

	var data = save_data_component.save_data_resource as TreeDataResource
	if data.is_chopped:
		queue_free()

func _get_serialized_data() -> Dictionary:
	return {
		"is_chopped": is_chopped
	}

func _apply_serialized_state(data: Dictionary) -> void:
	is_chopped = data.get("is_chopped", false)
	if is_chopped:
		hide()
		$StaticBody2D/CollisionShape2D.disabled = true

func on_hurt(hit_damage: int) -> void:
	if is_chopped: return

	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 0.25)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

func on_max_damage_reached() -> void:
	if is_chopped: return

	is_chopped = true
	var data = save_data_component.save_data_resource as TreeDataResource
	data.is_chopped = true

	await get_tree().create_timer(0.5).timeout
	call_deferred("add_log_scene")
	hide()
	$StaticBody2D/CollisionShape2D.disabled = true

func add_log_scene() -> void:
	var log_instance = log_scene.instantiate()
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
