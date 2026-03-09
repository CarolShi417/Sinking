extends Node

@onready var test_button_speedup = get_tree().get_first_node_in_group("TestButton")
@onready var panel_container_A = get_tree().get_first_node_in_group("PanelContainerA")
# ===============================
# 工作 / 休息时间
# ===============================

const WORK_DURATION := 600.0
const REST_DURATION := 300.0
const step_duration := 5.0

# ===============================
# Timer
# ===============================
var work_timer : Timer
var rest_timer : Timer
var step_timer : Timer

# 时间倍率
#var time_scale : float = 1.0

# 信号
signal step_tick(duration)
signal work_finished
signal rest_finished

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

	# Step Timer（每5秒触发一次）
	step_timer = Timer.new()
	step_timer.one_shot = false
	step_timer.wait_time = step_duration
	step_timer.timeout.connect(_on_step_tick)
	add_child(step_timer)

# ===============================
# 启动工作计时
# ===============================
func start_work_timer():
	rest_timer.stop()
	work_timer.start(WORK_DURATION)
	step_timer.start()
	

# ===============================
# 启动休息计时
# ===============================
func start_rest_timer():
	work_timer.stop()
	step_timer.stop()
	rest_timer.start(REST_DURATION)


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
# 每5秒触发，用于计时结束事件触发
# ===============================
func _on_step_tick():
	#print("STEP TICK")
	step_tick.emit(step_duration)

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
		print("第一次按下")
		# 第一次的逻辑
	else:
		print("之后按下")
		# 后续逻辑
