extends Node

signal dead_sequence_finished

const REST_POSITION := Vector2(450, 180)
const WORK_POSITION := Vector2(1400, 230)
const DEAD_REST_POSITION := Vector2(140, 180)
const REVIVE_DURATION := 1.0

func _ready():
	GameState.state_changed.connect(_on_state_changed)
	_apply_visible_worker(GameState.current_state)


func _on_state_changed(state):
	_apply_visible_worker(state)


func start_dead_sequence() -> void:
	_play_dead_sequence.call_deferred()


func start_alive_recovery() -> void:
	_play_alive_recovery.call_deferred()


func _play_dead_sequence() -> void:
	_show_work_worker()
	_get_work_state_machine().transition_to("Dead")
	await _get_work_sprite().animation_finished
	_show_dead_rest_worker()
	_get_rest_state_machine().transition_to("DeadPose")


func _play_alive_recovery() -> void:
	_show_dead_rest_worker()
	_get_rest_state_machine().transition_to("Revive")
	await get_tree().create_timer(REVIVE_DURATION).timeout
	dead_sequence_finished.emit()


func _apply_visible_worker(state) -> void:
	if state == DataTypes.GameState.Working:
		_show_work_worker()
	elif state == DataTypes.GameState.Resting:
		_show_rest_worker()


func _show_rest_worker() -> void:
	var worker_rest = _get_rest_worker()
	var worker_work = _get_work_worker()
	worker_rest.show()
	worker_work.hide()
	worker_rest.z_index = 40
	worker_work.z_index = 11
	worker_rest.position = REST_POSITION
	worker_rest.LEFT_LIMIT = 10
	worker_rest.RIGHT_LIMIT = 930
	worker_rest.velocity = Vector2.ZERO


func _show_work_worker() -> void:
	var worker_rest = _get_rest_worker()
	var worker_work = _get_work_worker()
	worker_rest.hide()
	worker_work.show()
	worker_rest.z_index = 40
	worker_work.z_index = 11
	worker_work.position = WORK_POSITION
	worker_work.LEFT_LIMIT = 1000
	worker_work.RIGHT_LIMIT = 1900
	worker_work.velocity = Vector2.ZERO


func _show_dead_rest_worker() -> void:
	var worker_rest = _get_rest_worker()
	var worker_work = _get_work_worker()
	worker_work.hide()
	worker_rest.show()
	worker_rest.z_index = 40
	worker_rest.position = DEAD_REST_POSITION
	worker_rest.LEFT_LIMIT = DEAD_REST_POSITION.x
	worker_rest.RIGHT_LIMIT = DEAD_REST_POSITION.x
	worker_rest.velocity = Vector2.ZERO


func _get_rest_worker() -> CharacterBody2D:
	return get_tree().get_first_node_in_group("WorkerResting")


func _get_work_worker() -> CharacterBody2D:
	return get_tree().get_first_node_in_group("WorkerWorking")


func _get_rest_state_machine() -> Node:
	return _get_rest_worker().get_node("StateMachine")


func _get_work_state_machine() -> Node:
	return _get_work_worker().get_node("StateMachine")


func _get_work_sprite() -> AnimatedSprite2D:
	return _get_work_worker().get_node("AnimatedSprite2D")
