extends Node2D

class_name EmotionAnim

@onready var sprite  = $Sprite2D


const rest_high = preload("res://assets/UI/map_battery/battery_100-80.png")
const rest_low = preload("res://assets/UI/map_battery/battery_19-1.png")
const work_high = preload("res://assets/UI/map_battery/battery_100-80.png")
const work_low = preload("res://assets/UI/map_battery/battery_19-1.png")

func show_rest_high():
	sprite.set_texture(rest_high)
	
func show_rest_low():
	sprite.set_texture(rest_low)

func show_work_high():
	sprite.set_texture(work_high)

func show_work_low():
	sprite.set_texture(work_low)
