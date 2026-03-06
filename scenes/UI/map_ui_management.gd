extends Node

@export var real_time_fragment_gain_display : Node2D


func _ready():

	GameState.state_changed.connect(_on_state_changed)

	# 初始化一次
	_on_state_changed(GameState.current_state)


func _on_state_changed(state):

	if state == DataTypes.GameState.Working:
		real_time_fragment_gain_display.show()

	elif state == DataTypes.GameState.Resting:
		real_time_fragment_gain_display.hide()
