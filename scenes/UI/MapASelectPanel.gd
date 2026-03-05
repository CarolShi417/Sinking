extends PanelContainer

@export var button_mapA: Button


@export var button_assignWorkerToMapA: Button


signal button_assignWorkerToMapA_pressed

func _ready() -> void:
	# mapbutton初始化
	button_mapA.show()
	button_assignWorkerToMapA.hide()
	
	# fragment timeline 初始

func _on_map_button_a_pressed() -> void:
	button_mapA.hide()
	button_assignWorkerToMapA.show()


func _on_assign_button_a_pressed() -> void:
	button_mapA.show()
	button_assignWorkerToMapA.hide()
	button_assignWorkerToMapA_pressed.emit()
