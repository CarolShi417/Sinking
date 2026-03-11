extends Node

@export var sprite: AnimatedSprite2D

func _process(_delta : float) -> void:
	if SanSystem.san >= 20 and SanSystem.san <= 39:
		sprite.play("20")

func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
