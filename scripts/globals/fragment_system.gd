extends Node
# ===============================
# 碎片总数量,碎片用a b c表示，map用A B C表示
# ===============================
var total_fragment_a := 0.00

# ===============================
# 每次work状态下的碎片总数量
# ===============================
var total_fragment_a_work_in_mapA := 0.00



# ===============================
# 获取碎片速率
# ===============================
const work_speed_normal := 0.20 #正常获取碎片效率为0.2个/秒
var current_speed := work_speed_normal

# ===============================
# 发送信号
# ===============================
signal fragment_gain_per_step

# 最新的一次探索实时获取碎片数量
var total_fragment_A_in_mapA := 0.0
#signal step_tick(level: String) #每5秒发送一次信号 用于更新UI

#监听gamestate


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)


func _on_step_tick(duration):

	var gained_per_5_seconds : float = current_speed * duration

	total_fragment_a_work_in_mapA += gained_per_5_seconds
	
	print("本次探索获取到碎片数量为",  total_fragment_a_work_in_mapA)
	
	fragment_gain_per_step.emit()

# rest state下重置碎片设定
func _on_state_changed(state):
	if state == DataTypes.GameState.Resting:
		total_fragment_a_work_in_mapA = 0.00
		current_speed = work_speed_normal
