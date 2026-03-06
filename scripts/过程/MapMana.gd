extends Node2D

@onready var worker_working = $"../../../Worker" #申明worker
#@onready var worker_resting = $Worker
@onready var control = $"../Control" #申明UI
@onready var hover_area = worker_working.get_node("HoverArea")


# ===== Working State 计时=====
const work_duration := 600.0
const rest_duration := 300.0
const step_duration := 5.0
const segment := work_duration / step_duration

var work_timer : Timer
var rest_timer : Timer
var step_timer : Timer

# ===== Working State 悬停加速 =====
const work_speed_normal := 0.20 #正常获取碎片效率为0.2个/秒
const work_speed_monitor_multiplier := 1.20 #monitor状态增益
var current_speed := work_speed_normal
var hover_active := false


# 正常状态获取碎片数量
var fragment_A_per_time_mapA := 30
var fragment_B_per_time_mapA := 10
var fragment_C_per_time_mapA := 10

# 最新的一次探索实时获取碎片数量
var total_fragment_A_in_mapA := 0.0
signal step_tick(level: String) #每5秒发送一次信号 用于更新UI

# ===== Resting State =====
@onready var bg_dark: Sprite2D = $"../bg dark"

# 测试用 最好挪到UIControl里面
@onready var test_skip_button = $"../Control/Test_SkipButton"
var debug_timer := 0.0

# 游戏开始运行
func _ready() -> void:
	_create_timers()# 创建所有 Timer
	
	worker_working.hide()
	worker_working.position = Vector2(480,240)  # 设置初始坐标
	
	#bg_dark.hide()
	
	control.assign_worker_to_mapA.connect(_on_assign_worker_to_mapA) #接收信号：mapA按钮按下
	
	GameState.worker_state_changed.connect(_on_worker_state_changed) #接收信号：GameState改变
	_on_worker_state_changed(GameState.worker_state) # 游戏开始时执行一次
	
	hover_area.hover_changed.connect(_on_worker_hover) #接收信号：鼠标悬停
	
	control.skip_this_work.connect(_on_skip_this_work)
	
func _process(_delta) -> void:
	pass
	
func _create_timers():
	# 工作计时器（一次性）
	work_timer = Timer.new()
	work_timer.one_shot = true # 只触发一次 timeout，然后停止
	work_timer.timeout.connect(_on_work_finished)# 当工作时间结束时，进入回调 _on_work_finished
	add_child(work_timer)

	# 休息计时器（一次性）
	rest_timer = Timer.new()
	rest_timer.one_shot = true
	rest_timer.timeout.connect(start_work)
	add_child(rest_timer)

	# Step Timer（循环，每 5 秒触发）
	step_timer = Timer.new()
	step_timer.one_shot = false
	step_timer.wait_time = step_duration
	step_timer.timeout.connect(_on_step_tick)
	add_child(step_timer)

# 接收信号 如果worker状态改变，print当前状态
func _on_worker_state_changed(state):
	print("worker state changed:",
		GameState.get_worker_state_name(state))	
	match state:

		GameState.WorkerState.Working:
			hover_area.set_enabled(true)
			bg_dark.hide()

		GameState.WorkerState.Resting:
			hover_area.set_enabled(false)
			bg_dark.show()

	hover_active = false
		
# Debug：监听 worker 状态变化
func _on_assign_worker_to_mapA():
	start_work()	

#结束工作
func _on_work_finished():
	stop_work()
	
func stop_work():
	print("stop work")	
	# 停止所有 Working 相关 timer
	step_timer.stop()
	work_timer.stop()
	
	# 结算碎片	
	GameState.gain_fragment(total_fragment_A_in_mapA, fragment_B_per_time_mapA)	
	
	# 停止 worker 行为
	worker_working.hide()
	worker_working.stop_move()
	worker_working.position = Vector2(480,300)  # 设置初始坐标
	
	# 切换状态为 Resting
	GameState.set_worker_state(GameState.WorkerState.Resting)
	
	# 启动休息倒计时
	rest_timer.start(rest_duration)	
		
	# 重置碎片获取以及UI
	total_fragment_A_in_mapA = 0.0
	current_speed = work_speed_normal
	

func start_work():
	print("start work")
	GameState.set_worker_state(GameState.WorkerState.Working)
	
	#重置碎片值
	#total_fragment_A_in_mapA = 0.0
	
	# 开始 worker 行为
	worker_working.show()
	worker_working.start_move()	
	
	# 开始计时
	work_timer.start(work_duration)# 启动工作总时长计时
	step_timer.start()# 启动 5 秒 tick 循环
	
	
# ========================================
# ====== hover对于fragment speed的影响 =====
# ========================================
# 每 5 秒触发一次
func _on_step_tick():
	#更新速度
	update_work_speed() # 更新当前获取碎片速度
	
	#计算碎片获取量
	var gained_per_5_seconds := current_speed * step_duration # 计算这 5 秒产出的碎片
	total_fragment_A_in_mapA += gained_per_5_seconds
	
	#更新speed level，用于Control UI显示
	var speed_level := get_speed_level()	
	emit_signal("step_tick", speed_level)#发送信号给Control
	
	#测试
	print("speed:", current_speed)
	print(" gained this step:", gained_per_5_seconds,
		  " total:", total_fragment_A_in_mapA)
	print("当前hover状态为", hover_active)

# 判断当前获取fragment speed是否高
func get_speed_level() -> String:
	if current_speed > 0.2:
		return "high"
	else:
		return "low"	
		
#接受hover_area的信号，仅在workstate的时候启动
func _on_worker_hover(active):
	hover_active = active
		
# 根据 hover 状态更新速度
func update_work_speed():
	if hover_active:
		current_speed = work_speed_normal * work_speed_monitor_multiplier
	else:
		current_speed = work_speed_normal
	
# ========================================
#用于加速时间的按钮
# ========================================
func _on_skip_this_work() -> void:
	if GameState.worker_state == GameState.WorkerState.Working:
		stop_work()
