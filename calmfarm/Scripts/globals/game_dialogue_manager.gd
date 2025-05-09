extends Node

signal give_crop_seeds
signal feed_the_animals
signal mute
signal normal
signal quiet
signal off
signal on

func action_give_crop_seeds() -> void:
	give_crop_seeds.emit()

func action_feed_animals() -> void:
	feed_the_animals.emit()

func action_mute() -> void:
	mute.emit()
	
func action_normal() -> void:
	normal.emit()

func action_off() -> void:
	off.emit()

func action_on() -> void:
	on.emit()
