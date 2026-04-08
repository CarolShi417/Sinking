extends Node

#@onready var worker_rest = get_tree().get_first_node_in_group("WorkerResting")
#@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")

# 如何接收信号
#@onready var test_button_speedup = get_tree().get_first_node_in_group("TestButton")
# onready
#test_button_speedup.fast_button_pressed.connect(_speedup_timers)

#如何直接获取根目录节点： var panel = get_node("/root/Game/GameScreenUI/MapSelectPanel")


#func _ready() -> void:
	#GameState.state_changed.connect(_on_state_changed)
#
#
#func _on_state_changed(state):
	#if state == DataTypes.GameState.Resting:
		#
	#if state == DataTypes.GameState.Working:
