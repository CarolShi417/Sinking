extends Node2D

@onready var worker_working = $"../Worker" #申明worker
#@onready var worker_resting = $Worker
@onready var control = $"../Control" #申明UI

# Working State
var work_time := 0.0
const work_duration := 300.0 #单次探索工作时间为10分钟
const work_speed := 0.20 #正常获取碎片效率为0.2个/秒
const work_speed_monitor = 1.20 #monitor状态增益

# Resting State
var rest_time := 0.0
const rest_duration := 600.0 #worker最长待机时间为5分钟

# 正常状态获取碎片数量
var fragment_A_per_time_mapA := 30
var fragment_B_per_time_mapA := 10
var fragment_C_per_time_mapA := 10

#测试用 最好挪到UIControl里面
@onready var test_skip_button = $"../Control/Test_SkipButton"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	worker_working.hide()
	#control.assign_worker_to_mapA.connect(_on_assign_worker_to_mapA)
	GameState.worker_state_changed.connect(_on_worker_state_changed)
	
func _on_worker_state_changed(state):
	print("worker state changed:", state)
	
func _process(delta) -> void:
	if GameState.worker_state == GameState.WorkerState.Working:
		work_time += delta		
		if work_time >= work_duration:
			stop_work()	
	else:
		rest_time += delta		
		if rest_time >= rest_duration:
			start_work()
			
		
#按下确认派出员工的按钮
func _on_assign_worker_to_mapA():
	start_work()	

func stop_work():
	print("时间到")	
	#isWorking = false
	GameState.gain_fragment(fragment_A_per_time_mapA, fragment_B_per_time_mapA)	
	work_time = 0.0
	rest_time = 0.0
	worker_working.hide()
	worker_working.stop_move()
	GameState.set_worker_state(GameState.WorkerState.Resting)

func start_work():
	print("开始工作")
	work_time = 0.0
	rest_time = 0.0
	worker_working.show()
	worker_working.position = Vector2(480,300)  # 设置初始坐标
	worker_working.start_move()
	GameState.set_worker_state(GameState.WorkerState.Working)

#用于加速时间的按钮
func _on_test_skip_button_pressed() -> void:
	if GameState.worker_state == GameState.WorkerState.Working:
		work_time = work_duration
	else:
		rest_time = rest_duration
