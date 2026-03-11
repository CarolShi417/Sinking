extends Button

signal UpgradeButton_0to1_Pressed(amount)

@export var amount : int = 10

func _ready():
	if FragmentSystem.total_fragment_a < amount:
		disabled = true
	else:
		disabled = false
		
func _on_pressed() -> void:
	if FragmentSystem.total_fragment_a >= amount:
		UpgradeButton_0to1_Pressed.emit(amount)
		disabled = true
