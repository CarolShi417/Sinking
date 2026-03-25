extends Node

@onready var state_controller = get_parent()

@onready var panel_container = get_tree().get_first_node_in_group("MapSelect")

signal on_assign_worker

func _ready():

	panel_container.assign_pressed.connect(_on_button_assignWorker_pressed)

func _on_button_assignWorker_pressed():
	on_assign_worker.emit()
