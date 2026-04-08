extends Node

@onready var worker_rest = get_tree().get_first_node_in_group("WorkerResting")
@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")

const REST_POSITION := Vector2(450, 180)
const WORK_POSITION := Vector2(1400, 230)

func _ready():
	GameState.state_changed.connect(_on_state_changed)
	
	worker_rest.z_index = 40
	worker_work.z_index = 11
	
	worker_rest.position = REST_POSITION
	worker_work.position = WORK_POSITION
	
	if GameState.current_state == DataTypes.GameState.Resting:
		_show_rest_worker()
		

func _on_state_changed(state):
	if state == DataTypes.GameState.Resting:
		await get_tree().create_timer(2.0).timeout
		_show_rest_worker()
	elif state == DataTypes.GameState.Working:
		await get_tree().create_timer(2.0).timeout
		_show_work_worker()
	elif state == DataTypes.GameState.Dead:
		_worker_dead()
		
func _show_rest_worker() -> void:
	worker_rest.show()
	worker_work.hide()
	worker_rest.position = REST_POSITION
	worker_rest.reset_movement(1)
	worker_rest.LEFT_LIMIT = 10
	worker_rest.RIGHT_LIMIT = 900


func _show_work_worker() -> void:
	worker_rest.hide()
	worker_work.show()
	worker_work.position = WORK_POSITION
	worker_work.reset_movement(-1)
	worker_work.LEFT_LIMIT = 1000
	worker_work.RIGHT_LIMIT = 1900

func _worker_dead() -> void:
	await get_tree().create_timer(2.0).timeout
	worker_rest.show()
	worker_work.hide()
	worker_rest.position = REST_POSITION	
	worker_rest.reset_movement(1)
