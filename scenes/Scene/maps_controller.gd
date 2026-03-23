extends Sprite2D


@onready var panel_container_A = get_tree().get_first_node_in_group("PanelContainerA")
@export var mapA: Sprite2D
@export var mapB: Sprite2D
@export var mapC: Sprite2D
@export var Dark: Sprite2D


#func _ready():
	#GameState.state_changed.connect(_on_state_changed)# 监听状态变化
	#panel_container_A.button_assignWorkerToMapA_pressed.connect(_show_map_A)
	#_hide_all_maps()
#
#func _on_state_changed(state):
	#if state == DataTypes.GameState.Working:
		#_show_map_A()
	#elif state == DataTypes.GameState.Resting:
		#_hide_all_maps()
		#
#
#func _show_map_A():
	#Dark.hide()
	#mapA.show()
	#mapB.hide()
	#mapC.hide()
	#print("显示mapA")
	#
#func _hide_all_maps():
	#Dark.show()
	#mapA.hide()
	#mapB.hide()
	#mapC.hide()
	#print("隐藏所有地图")
