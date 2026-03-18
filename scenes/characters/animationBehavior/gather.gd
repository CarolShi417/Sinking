extends NodeState

@export var worker: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D


func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if GameState.current_behavior_state == DataTypes.BehaviorState.gather:
		if worker.direction == 1:
			animated_sprite_2d.play("gather_right")
		elif worker.direction == -1:
			animated_sprite_2d.play("gather_left")

func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
