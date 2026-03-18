extends NodeState

@export var sprite: AnimatedSprite2D
#@onready var upgrade_building_button = get_node("../../Control/UpgradeBuildingPanel/MarginContainer/Button")

#func _ready():
	#upgrade_building_button.UpgradeButton_0to1_Pressed.connect(_upgrade_building)
	
func _upgrade_building(_amount):	
	sprite.play("LV1")
	#print("建筑已升级为LV1")
	
	
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
