extends NodeState

@export var worker: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	animated_sprite_2d.flip_h = true
	animated_sprite_2d.play("idle_left")


func _on_exit() -> void:
	animated_sprite_2d.flip_h = false
