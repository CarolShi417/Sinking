extends Node
# 计算石子落下概率，什么时候出现和消失
# 后面可加石子落下的数量

signal go_to_stone_position

@onready var stone = get_tree().get_first_node_in_group("StoneComponent")
@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")
@onready var behavior_controller = get_tree().get_first_node_in_group("BehaviorController")

const trigger_chance := 0.1 # 每30s触发概率为10%
var is_stone_active := false # 保证每次只有一颗石子被触发
var worker_is_walking_to_stone := false

func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	stone.hide()
	# 监听 component 落地等待结束的信号
	#stone.stone_finished.connect(_on_stone_finished)	
	stone.get_node("StoneHoverArea").hover_changed.connect(_on_stone_hover_changed)
	worker_work.stone_walk_finished.connect(_on_stone_walk_finished)
		
func _on_stone_hover_changed(active: bool) -> void:
	if GameState.current_state != DataTypes.GameState.Working: return
	if active:
		var stone_position = stone.position
		#print("stone_position")
		go_to_stone_position.emit(stone_position.x)			
		worker_is_walking_to_stone = true

	#让worker移动到stone_position
	#发信号给fragment.system 增加及时的fragment数量
	#播放碎片动画

#func _on_stone_walk_finished() -> void:
	#worker_is_walking_to_stone = false
	#is_stone_active = false
	#stone.hide()	
	
# 每30秒收到信号，10% 概率触发石子落下
func _on_random_stone_triggered() -> void:
	if is_stone_active: return# 保证每次只有一颗石子		
	if GameState.current_state != DataTypes.GameState.Working: return  # 非Working直接忽略
	
	is_stone_active = true
	stone.position = Vector2(randf_range(980, 1880), 70)
	stone.show()
	#print("石头已显示: ", stone.visible, " 位置: ", stone.position)
	stone.launch() # 通知 component 开始运动
	
func _on_stone_walk_finished() -> void:
	worker_is_walking_to_stone = false
	is_stone_active = false
	stone.hide()
	
# resting时石子状态重置
func _on_state_changed(state) -> void:
	print("stone controller state changed: ", state)  # 👈
	if state == DataTypes.GameState.Resting:
		is_stone_active = false
		worker_is_walking_to_stone = false
		stone.hide()
		stone.reset()
		print("stone controller state changed: ", state)  # 👈
