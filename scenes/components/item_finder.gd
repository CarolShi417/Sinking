extends Sprite2D


func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	#Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
	hide()
	set_process(false)

func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		show()
		set_process(true)
	else:
		hide()
		set_process(false)


func _process(_delta) -> void:
	global_position = get_global_mouse_position()
