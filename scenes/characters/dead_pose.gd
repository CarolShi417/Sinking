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
	animated_sprite_2d.play("dead_right")
	animated_sprite_2d.stop()
	animated_sprite_2d.frame = animated_sprite_2d.sprite_frames.get_frame_count("dead_right") - 1


func _on_exit() -> void:
	pass
