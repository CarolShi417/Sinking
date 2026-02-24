extends Node2D

@onready var worker_working = $"../../../Worker" #申明worker
#@onready var worker_resting = $Worker
@onready var control = $"../Control" #申明UI
@onready var hover_area = worker_working.get_node("HoverArea")


# ===== Working State 计时=====
const work_duration := 600.0
const rest_duration := 300.0
const step_duration :=5.0

var work_timer : Timer
var rest_timer : Timer
var step_timer : Timer

#var work_time := 0.0
#const work_duration := 600.0 #单次探索工作时间为10分钟
# ===== Working State 悬停加速 =====
const work_speed_normal := 0.20 #正常获取碎片效率为0.2个/秒
const work_speed_monitor_multiplier := 1.20 #monitor状态增益
var current_speed := work_speed_normal
#const STEP_TIME := 5.0 #每5s更新一次状态
#var step_timer := 0.0 #用于计算5秒循环
var hover_active := false

# ===== Resting State =====
#var rest_time := 0.0
#const rest_duration := 300.0 #worker最长待机时间为5分钟

# 正常状态获取碎片数量
var fragment_A_per_time_mapA := 30
var fragment_B_per_time_mapA := 10
var fragment_C_per_time_mapA := 10

#测试用 最好挪到UIControl里面
@onready var test_skip_button = $"../Control/Test_SkipButton"
var debug_timer := 0.0

# 游戏开始运行
func _ready() -> void:
	_create_timers()# 创建所有 Timer
	worker_working.hide()
	worker_working.position = Vector2(480,300)  # 设置初始坐标
	control.assign_worker_to_mapA.connect(_on_assign_worker_to_mapA) #接收信号：mapA按钮按下
	GameState.worker_state_changed.connect(_on_worker_state_changed)
	hover_area.hover_changed.connect(_on_worker_hover)
	
func _create_timers():

	# 工作计时器（一次性）
	work_timer = Timer.new()
	work_timer.one_shot = true
	work_timer.timeout.connect(_on_work_finished)
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

func _on_worker_state_changed(state):
	print("worker state changed:", state)
	
# 每帧调用=update
#func _process(delta) -> void:
	#if GameState.worker_state == GameState.WorkerState.Working:
		#
		#work_time += delta	
		#step_timer += delta	
		#if step_timer >= STEP_TIME:
			#step_timer = 0.0
			#update_work_speed()
		#if work_time >= work_duration:
			#stop_work()	
			#
		## ===== 每秒debug =====	
		#debug_timer += delta
		#if debug_timer >= 1.0:
			#debug_timer = 0.0
			#print("speed:", current_speed, " step:", step_timer)
	#
	#else:
		#rest_time += delta		
		#if rest_time >= rest_duration:
			#start_work()
			
		
# Debug：监听 worker 状态变化
func _on_assign_worker_to_mapA():
	start_work()	

func stop_work():
	print("时间到")	
	# 停止所有 Working 相关 timer
	step_timer.stop()
	work_timer.stop()
	
	# 结算碎片	
	GameState.gain_fragment(fragment_A_per_time_mapA, fragment_B_per_time_mapA)	
	
	# 停止 worker 行为
	worker_working.hide()
	worker_working.stop_move()
	worker_working.position = Vector2(480,300)  # 设置初始坐标
	
	# 切换状态为 Resting
	GameState.set_worker_state(GameState.WorkerState.Resting)
	
	# 启动休息倒计时
	rest_timer.start(rest_duration)	

func start_work():
	print("开始工作")
	#work_time = 0.0
	#rest_time = 0.0
	GameState.set_worker_state(GameState.WorkerState.Working)
	
	worker_working.show()
	worker_working.start_move()	
	
	work_timer.start(work_duration)# 启动工作总时长计时
	step_timer.start()# 启动 5 秒 tick 循环

#结束工作
func _on_work_finished():
	stop_work()
	
# 每 5 秒触发一次
func _on_step_tick():
	#update_work_speed()
	print("speed:", current_speed)

#接受hover_area的信号，将hover_active的bool值和信号保持一致
func _on_worker_hover(active):
	print("HOVER:", active)
	hover_active = active
	
# 根据 hover 状态更新速度
func update_work_speed():
	if hover_active:
		current_speed = work_speed_normal * work_speed_monitor_multiplier
	else:
		current_speed = work_speed_normal
		
#用于加速时间的按钮
#func _on_test_skip_button_pressed() -> void:
	#if GameState.worker_state == GameState.WorkerState.Working:
		#work_time = work_duration
	#else:
		#rest_time = rest_duration
