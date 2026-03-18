extends Node


@onready var test_button_speedup = get_tree().get_first_node_in_group("TestButton")

# ===============================
# 工作 / 休息 / 死亡 / SAN时间
# ===============================

const WORK_DURATION := 600.0
const REST_DURATION := 300.0
const DEAD_DURATION := 302.0
const work_step_duration := 5.0
const san_step_duration := 1.0

# ===============================
# Timer
# ===============================
var work_timer : Timer
var rest_timer : Timer
var step_timer : Timer
var san_timer : Timer
var dead_timer : Timer

# 时间倍率
#var time_scale : float = 1.0

# 信号
signal work_finished
signal rest_finished
signal dead_recovery_finished
signal step_tick(duration)
signal san_tick(duration)
# 按下assign按钮，启动timer
var is_first_assign: bool = false;


func _ready():

	_create_timers()
	# 接收测试button的signal
	test_button_speedup.fast_button_pressed.connect(_speedup_timers)
		

# ===============================
# 创建 Timer
# ===============================
func _create_timers():

	# 工作计时器
	work_timer = Timer.new()
	work_timer.one_shot = true
	work_timer.timeout.connect(_on_work_finished)
	add_child(work_timer)

	# 休息计时器
	rest_timer = Timer.new()
	rest_timer.one_shot = true
	rest_timer.timeout.connect(_on_rest_finished)
	add_child(rest_timer)
	
	#死亡计时器
	dead_timer = Timer.new()
	dead_timer.one_shot = true
	dead_timer.timeout.connect(_on_dead_recovery_finished)
	add_child(dead_timer)

	# Step Timer（每5秒触发一次）
	step_timer = Timer.new()
	step_timer.one_shot = false
	step_timer.wait_time = work_step_duration
	step_timer.timeout.connect(_on_step_tick)
	add_child(step_timer)
	
	# SAN Timer（每1秒触发一次）
	san_timer = Timer.new()
	san_timer.one_shot = false
	san_timer.wait_time = san_step_duration
	san_timer.timeout.connect(_on_san_tick)
	add_child(san_timer)

# ===============================
# 启动工作计时
# ===============================
func start_work_timer():
	rest_timer.stop()
	dead_timer.stop()
	work_timer.start(WORK_DURATION)
	step_timer.start()
	san_timer.start()#work开，因为会降san

# ===============================
# 启动休息计时
# ===============================
func start_rest_timer():
	work_timer.stop()
	dead_timer.stop()
	step_timer.stop()
	rest_timer.start(REST_DURATION)
	san_timer.start()#rest开，因为会升san
	
# ===============================
# 启动死亡计时器
# ===============================
func start_dead_timer():
	_stop_all_timers()
	dead_timer.start(DEAD_DURATION)

# ===============================
# 工作结束，用于计时结束事件触发
# ===============================
func _on_work_finished():
	work_finished.emit()
	

# ===============================
# 休息结束，用于计时结束事件触发
# ===============================
func _on_rest_finished():
	rest_finished.emit()

# ===============================
# 死亡结束，触发死亡结束信号
# ===============================	
func _on_dead_recovery_finished():
	dead_recovery_finished.emit()
	
	
# ===============================
# 每5秒触发，用于计时结束事件触发
# ===============================
func _on_step_tick():
	#print("STEP TICK")
	step_tick.emit(work_step_duration)
	
# ===============================
# san每秒更新信号
# ===============================
func _on_san_tick():
	san_tick.emit(san_step_duration)
	
# ===============================
# 加速时间，engine整体加速
# ===============================
func _speedup_timers():
	if Engine.time_scale == 1:
		Engine.time_scale = 20
	else:
		Engine.time_scale = 1

func _on_assign_worker():
	if !is_first_assign:
		is_first_assign = true
		#print("第一次按下")
		# 第一次的逻辑
	#else:
		#print("之后按下")
		# 后续逻辑
		
# ===============================
# dead状态，停止所有计时器
# ===============================
func _stop_all_timers():
	work_timer.stop()
	rest_timer.stop()
	step_timer.stop()
	dead_timer.stop()
	san_timer.stop()
