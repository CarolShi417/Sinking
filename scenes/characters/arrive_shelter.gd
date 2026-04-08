extends NodeState

@onready var worker: CharacterBody2D = $"../.."
@onready var animated_sprite_2d: AnimatedSprite2D =$"../../AnimatedSprite2D"

func _ready():
	pass
	#GameState.state_changed.connect(_on_state_changed)
	
func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	pass


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	pass
