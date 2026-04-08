extends Node

@onready var map_select_panel : PanelContainer = get_node("/root/Game/GameScreenUI/MapSelectPanel")

signal on_assign_worker

func _ready():

	map_select_panel.has_assigned.connect(_on_assigned_pressed)

func _on_assigned_pressed():
	on_assign_worker.emit()
	#print("on_assign_worker signal emit")
