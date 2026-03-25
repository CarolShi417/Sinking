extends Sprite2D


@onready var map_A_select = get_tree().get_first_node_in_group("mapAselect")
@onready var map_B_select = get_tree().get_first_node_in_group("mapBselect")
@onready var map_C_select = get_tree().get_first_node_in_group("mapCselect")
@export var mapA: Sprite2D
@export var mapB: Sprite2D
@export var mapC: Sprite2D
@export var Dark: Sprite2D


func _ready():
	GameState.state_changed.connect(_on_state_changed)# 监听状态变化
	
	await get_tree().process_frame
	map_A_select.map_select_pressed.connect(_show_map_A)
	map_B_select.map_select_pressed.connect(_show_map_B)
	map_C_select.map_select_pressed.connect(_show_map_C)
	_hide_all_maps()
#
func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		_show_map_A()
		_show_map_B()
		_show_map_C()
	elif state == DataTypes.GameState.Resting:
		_hide_all_maps()

func _show_map_A():
	Dark.hide()
	mapA.show()
	mapB.hide()
	mapC.hide()
	print("显示mapA")

func _show_map_B():
	Dark.hide()
	mapA.hide()
	mapB.show()
	mapC.hide()
	
func _show_map_C():
	Dark.hide()
	mapA.hide()
	mapB.hide()
	mapC.show()
	
func _hide_all_maps():
	Dark.show()
	mapA.hide()
	mapB.hide()
	mapC.hide()
	print("隐藏所有地图")
