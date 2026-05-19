extends Node
# ===============================
# 发送信号
# ===============================
signal fragment_gain_per_step
signal total_fragment_changed # 碎片总数发生了变化
signal fragment_gained_this_exploration_updated(amount: float)

@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")

# ===============================
# 碎片总数量,碎片用a b c表示，map用A B C表示
# ===============================
var total_fragment_a := 0.00
var total_fragment_b := 0.00
var total_fragment_c := 0.00

# ===============================
# 每次work状态下的碎片总数量
# ===============================
var fragment_gained_this_exploration := 0.00

# ===============================
# 获取碎片速率
# ===============================
const work_speed_normal := 0.20 #正常获取碎片效率为0.2个/秒
const work_speed_monitor_multiplier := 1.20 #monitor状态增益
var current_speed := work_speed_normal
var hover_active := false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	
	# ===============================
	#接收鼠标悬停在小人上的signal
	# ===============================	
	HoverController.hover_changed.connect(_speedup_gain_fragments)
	#await get_tree().process_frame
	#var hover_area = worker_work.get_node("HoverArea")	
	#if hover_area:
		#hover_area.hover_changed.connect(_speedup_gain_fragments)
	
		
func _on_step_tick(duration):
	#只有working状态才计算碎片
	if GameState.current_state != DataTypes.GameState.Working:
		return
	update_work_speed() # 更新当前获取碎片速度
	
	var gained_per_5_seconds : float = current_speed * duration

	fragment_gained_this_exploration += gained_per_5_seconds
	#发送信号给RealTimeFragment面板更新
	fragment_gained_this_exploration_updated.emit(fragment_gained_this_exploration)
	# print("本次探索获取到碎片数量为",  fragment_gained_this_exploration)
	
	var speed_level := get_speed_level()	
	fragment_gain_per_step.emit(speed_level)
	
	
# rest/dead state下重置碎片
func _on_state_changed(state):
	if state == DataTypes.GameState.Resting:
		total_fragment_a += fragment_gained_this_exploration
		#发送信号给UI，让UI更新Label，更新判定地图是否可以被解锁
		total_fragment_changed.emit()		
		#print("total_fragment_a数量为", total_fragment_a)
		fragment_gained_this_exploration = 0.00
	elif state == DataTypes.GameState.Dead:
		fragment_gained_this_exploration = 0.00
		total_fragment_a *= 0.5
	#重置状态	
	current_speed = work_speed_normal
	hover_active = false	

# 判断当前获取fragment speed是否高
func get_speed_level() -> String:
	if current_speed > 0.2:
		return "high"
	else:
		return "low"			
		
func _speedup_gain_fragments(active):
	hover_active = active
	#print("hover_active:", active)

#根据 hover 状态更新速度
func update_work_speed():
	if hover_active:
		current_speed = work_speed_normal * work_speed_monitor_multiplier
	else:
		current_speed = work_speed_normal

# ===============================
# 判断是否有足够碎片
# ===============================
func can_spend_fragment_a(amount: float) -> bool:
	return total_fragment_a >= amount
func can_spend_fragment_b(amount: float) -> bool:
	return total_fragment_b >= amount
func can_spend_fragment_c(amount: float) -> bool:
	return total_fragment_c >= amount
	
# ===============================
# 判断是否能同时扣除多种碎片
# ===============================
func can_spend_fragments(costs: Dictionary) -> bool:
	return can_spend_fragment_a(costs.get("A", 0.0)) \
		and can_spend_fragment_b(costs.get("B", 0.0)) \
		and can_spend_fragment_c(costs.get("C", 0.0))
		
# ===============================
# 扣除对应碎片
# ===============================
func spend_fragment_a(amount: float) -> bool:
	if !can_spend_fragment_a(amount):
		return false

	total_fragment_a -= amount
	#print("total_fragment_a", total_fragment_a)
	return true
	
func spend_fragment_b(amount: float) -> bool:
	if !can_spend_fragment_b(amount):
		return false

	total_fragment_b -= amount
	return true

func spend_fragment_c(amount: float) -> bool:
	if !can_spend_fragment_c(amount):
		return false

	total_fragment_c -= amount
	return true

# =========================
# 扣除多种对应碎片
# =========================
func spend_fragments(costs: Dictionary) -> bool:
	if !can_spend_fragments(costs):
		return false

	if !spend_fragment_a(costs.get("A", 0.0)):
		return false
	if !spend_fragment_b(costs.get("B", 0.0)):
		return false
	if !spend_fragment_c(costs.get("C", 0.0)):
		return false
	return true
