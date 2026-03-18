extends Node

signal state_changed
signal behavior_changed
signal first_rest_completed

var current_state : DataTypes.GameState = DataTypes.GameState.Resting
var current_behavior_state : DataTypes.BehaviorState = DataTypes.BehaviorState.idle
var is_in_first_rest : bool = true

# ====管理resting和working====
func set_state(new_state: DataTypes.GameState):

	if current_state == new_state:
		return

	current_state = new_state

	state_changed.emit(new_state)
	
# ====管理idle和gather和walk和dead====
func set_behavior(new_behavior: DataTypes.BehaviorState):

	if current_behavior_state == new_behavior:
		return

	current_behavior_state = new_behavior

	behavior_changed.emit(new_behavior)


func mark_first_rest_completed() -> void:
	if !is_in_first_rest:
		return

	is_in_first_rest = false
	first_rest_completed.emit()
