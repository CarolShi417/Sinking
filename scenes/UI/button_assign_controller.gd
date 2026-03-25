extends Node

@onready var state_controller = get_parent()

@onready var panel_container_A = get_tree().get_first_node_in_group("PanelContainerA")

signal on_assign_worker

func _ready():

	panel_container_A.assign_pressed.connect(_on_button_assignWorkerToMapA_pressed)

func _on_button_assignWorkerToMapA_pressed():
	on_assign_worker.emit()
