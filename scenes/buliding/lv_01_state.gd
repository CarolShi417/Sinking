extends NodeState

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	sprite.play("LV2")


func _on_exit() -> void:
	pass
	pass
