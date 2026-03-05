extends Node

@onready var state_controller = get_parent()


@onready var panel_container_A = get_tree().get_first_node_in_group("PanelContainerA")

func _ready():

	panel_container_A.button_assignWorkerToMapA_pressed.connect(_on_assign_worker)



func _on_assign_worker():
	state_controller.request_work()
