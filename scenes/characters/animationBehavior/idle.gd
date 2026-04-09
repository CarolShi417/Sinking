extends NodeState

@onready var worker: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if GameState.current_behavior_state == DataTypes.BehaviorState.idle:
		if worker.direction == 1:
			animated_sprite_2d.play("idle_right")
		elif worker.direction == -1:
			animated_sprite_2d.play("idle_left")

func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
