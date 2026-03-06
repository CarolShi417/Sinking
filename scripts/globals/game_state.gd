extends Node

signal state_changed

var current_state : DataTypes.GameState = DataTypes.GameState.Resting


func set_state(new_state: DataTypes.GameState):

	if current_state == new_state:
		return

	current_state = new_state

	print("GameState → ", new_state)

	state_changed.emit(new_state)
