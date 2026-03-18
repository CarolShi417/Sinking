extends PanelContainer

@export var button_mapA: Button
@export var button_assignWorkerToMapA: Button


signal button_assignWorkerToMapA_pressed

func _ready() -> void:
	# mapbutton初始化
	button_mapA.show()
	button_assignWorkerToMapA.hide()
	
	GameState.state_changed.connect(_on_state_changed)# 监听状态变化

func _on_map_button_a_pressed() -> void:
	button_mapA.hide()
	button_assignWorkerToMapA.show()


func _on_assign_button_a_pressed() -> void:
	button_mapA.show()
	button_assignWorkerToMapA.hide()
	button_assignWorkerToMapA_pressed.emit()

func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		button_assignWorkerToMapA.disabled = true
	elif state == DataTypes.GameState.Resting:
		button_assignWorkerToMapA.disabled = false
