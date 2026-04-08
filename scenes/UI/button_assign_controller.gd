extends Node

@onready var state_controller = get_parent()

@onready var map_select_panel = get_node("/root/Game/GameScreenUI/MapSelectPanel")

signal on_assign_worker

func _ready():

	map_select_panel.has_assigned.connect(_on_button_assignWorker_pressed)

func _on_button_assignWorker_pressed(_map_id: String = ""):
	on_assign_worker.emit()
	print("on_assign_worker signal emit")
