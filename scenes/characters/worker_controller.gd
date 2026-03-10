extends Node

@onready var worker_rest = get_tree().get_first_node_in_group("WorkerResting")
@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")

func _ready():
	GameState.state_changed.connect(_on_state_changed)
	worker_rest.show()
	worker_work.hide()
	worker_rest.z_index = 40
	worker_work.z_index = 11
	worker_rest.position = Vector2(450,180)
	worker_work.position = Vector2(1400,150)


func _on_state_changed(state):
	if state == DataTypes.GameState.Resting:

		worker_rest.show()
		worker_work.hide()

		worker_rest.position = Vector2(450,180)
		worker_rest.LEFT_LIMIT = 10
		worker_rest.RIGHT_LIMIT = 930

	elif state == DataTypes.GameState.Working:

		worker_rest.hide()
		worker_work.show()

		worker_work.position = Vector2(1400,230)
		worker_work.LEFT_LIMIT = 1000
		worker_work.RIGHT_LIMIT = 1900

	
