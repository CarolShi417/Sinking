extends Button

signal fast_button_pressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_pressed() -> void:
	fast_button_pressed.emit()
