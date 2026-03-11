extends Node

#@onready var hover_area = get_tree().root.get_node("MapTexture/MapTexture/ScreenArea/maps/WorkerWorking/HoverArea")
@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")

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
const work_speed_monitor_multiplier := 1.20 #monitor状态增益
var current_speed := work_speed_normal
var hover_active := false
# ===============================
# 发送信号
# ===============================
signal fragment_gain_per_step

#signal step_tick(level: String) #每5秒发送一次信号 用于更新UI



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	
	await get_tree().process_frame
	# ===============================
	#获取upgradebutton的signal
	# ===============================
	var upgrade_building_button = get_tree().get_first_node_in_group("UpgradeBuildingButtonGroup")
	#for upgrade_building_button in upgrade_building_buttons:
	upgrade_building_button.UpgradeButton_0to1_Pressed.connect(fragment_analyzer_upgrade_lv0_to_lv1)
	
	# ===============================
	#接收鼠标悬停在小人上的signal
	# ===============================	
	var hover_area = worker_work.get_node("HoverArea")	
	if hover_area:
		hover_area.hover_changed.connect(_speedup_gain_fragments)
		
		
func _on_step_tick(duration):
	update_work_speed() # 更新当前获取碎片速度
	
	var gained_per_5_seconds : float = current_speed * duration

	total_fragment_a_work_in_mapA += gained_per_5_seconds
	
	print("本次探索获取到碎片数量为",  total_fragment_a_work_in_mapA)
	
	var speed_level := get_speed_level()	
	fragment_gain_per_step.emit(speed_level)
	
	
# rest state下重置碎片设定
func _on_state_changed(state):
	if state == DataTypes.GameState.Resting:
		total_fragment_a += total_fragment_a_work_in_mapA
		#发送信号给UI，让UI更新Label
		#print("total_fragment_a数量为", total_fragment_a)
		total_fragment_a_work_in_mapA = 0.00
		
		current_speed = work_speed_normal
		

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
# 升级建筑消耗fragment
# ===============================
func fragment_analyzer_upgrade_lv0_to_lv1(amount):
	if total_fragment_a >= amount:
		total_fragment_a -= amount
		print("total_fragment_a", total_fragment_a)
	else:
		print("碎片不足")
	
