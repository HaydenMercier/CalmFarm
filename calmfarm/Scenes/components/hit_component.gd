class_name HitComponent
extends Area2D

@export var current_tool : DataTypes.Tools = DataTypes.Tools.None
@export var hit_damage : int = 1


signal on_hit


func _on_area_entered(area: Area2D) -> void:
	pass
