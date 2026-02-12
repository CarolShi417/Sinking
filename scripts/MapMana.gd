extends Node2D

@onready var worker = $"../Worker"
@onready var control = $"../Control"
#@onready var timer = $"../WorkTimer"

#工作&休息
var isWorking := false
var work_time := 0.0
var rest_time := 0.0
const work_duration := 300.0 #单次探索工作时间为10分钟
const max_rest_duration := 600.0 #worker最长待机时间为5分钟

#获取碎片
var fragment_A_per_time_mapA := 30
var fragment_B_per_time_mapA := 10
var fragment_C_per_time_mapA := 10

#测试用
@onready var test_skip_button = $"../Control/Test_SkipButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	worker.hide()
	control.assign_worker_to_mapA.connect(_on_assign_worker_to_mapA)
	#timer.timeout.connect(_on_timer_timeout)

func _process(delta) -> void:
	if isWorking:
		work_time += delta
		
		if work_time >= work_duration:
			stop_work()
	
	else:
		rest_time += delta
		
		if rest_time >= max_rest_duration:
			start_work()
			
		
#按下确认派出员工的按钮
func _on_assign_worker_to_mapA():
	start_work()
	#timer.start()
	#
	#workTime = Time.get_ticks_msec() / 1000.0
	#print("时间:", workTime)

func stop_work():
	print("时间到")	
	isWorking = false
	GameState.gain_fragment(fragment_A_per_time_mapA, fragment_B_per_time_mapA)	
	work_time = 0.0
	rest_time = 0.0
	worker.hide()
	worker.stop_move()

func start_work():
	#if isWorking:
		#return
	isWorking = true
	print("开始工作")
	work_time = 0.0
	rest_time = 0.0
	worker.show()
	worker.position = Vector2(480,300)  # 设置初始坐标
	worker.start_move()

#用于加速时间的按钮
func _on_test_skip_button_pressed() -> void:
	if isWorking:
		work_time = work_duration
	else:
		rest_time = max_rest_duration
