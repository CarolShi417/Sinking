extends Sprite2D


@onready var map_select_panel : PanelContainer = get_node("../../../GameScreenUI/MapSelectPanel")
var current_map_id: String = ""
@export var mapA: Sprite2D
@export var mapB: Sprite2D
@export var mapC: Sprite2D
@export var Dark: Sprite2D



func _ready():
	GameState.state_changed.connect(_on_state_changed)# 监听状态变化
	
	#await get_tree().process_frame
	map_select_panel.map_selected.connect(_show_map)
	
	_hide_all_maps()
#
func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		_show_map(current_map_id)
	elif state == DataTypes.GameState.Resting:
		_hide_all_maps()

func _show_map(map_id: String):
	#print("显示地图")
	current_map_id = map_id
	#print("current_map_id = " + current_map_id)
	Dark.hide()

	# 先全部隐藏
	mapA.hide()
	mapB.hide()
	mapC.hide()

	# 再根据 id 显示
	match map_id:
		"A":
			mapA.show()
			#print("显示 mapA")
		"B":
			mapB.show()
			#print("显示 mapB")
		"C":
			mapC.show()
	
func _hide_all_maps():
	Dark.show()
	mapA.hide()
	mapB.hide()
	mapC.hide()
	#print("隐藏所有地图")
