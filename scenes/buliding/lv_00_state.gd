extends NodeState

@onready var sprite : AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var upgrade_building_button = get_tree().current_scene.get_node(
	"GameScreenUI/UpgradeBuildingPanel/MarginContainer/Button"
	)
func _ready():
	upgrade_building_button.UpgradeButtonPressed.connect(_upgrade_building)
	
func _upgrade_building():
	sprite.play("LV1")
	
	
func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	pass


#func _on_enter() -> void:
	#sprite.play("LV1")


func _on_exit() -> void:
	pass
