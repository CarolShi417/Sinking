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
	var animation_name := "dead_right"
	animated_sprite_2d.flip_h = worker.direction == -1
	if animated_sprite_2d.sprite_frames:
		animated_sprite_2d.sprite_frames.set_animation_loop(animation_name, false)
	animated_sprite_2d.play(animation_name)


func _on_exit() -> void:
	if animated_sprite_2d.sprite_frames:
		animated_sprite_2d.sprite_frames.set_animation_loop("dead_right", true)
