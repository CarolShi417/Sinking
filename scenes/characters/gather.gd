extends NodeState

@export var sprite: AnimatedSprite2D

func _ready():
	GameState.state_changed.connect(_on_state_changed)
	

#func _on_process(_delta : float) -> void:	
	
func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		if SanSystem.san >= 40 and SanSystem.san <= 59:
			sprite.play("40")

func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
