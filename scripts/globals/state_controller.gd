extends Node

@export var time_circling: Node
@export var button_controller: Node

var is_first_assigned : bool = false # 用于判定是否是第一次按下assign按钮

# Called when the node enters the scene tree for the first time.
func _ready():

	# 游戏开始默认 Resting
	enter_resting()
	
	time_circling.step_tick.connect(FragmentSystem._on_step_tick)# 碎片系统接收计时器信号
	time_circling.san_tick.connect(SanSystem._on_san_tick)
	time_circling.work_finished.connect(_on_work_finished)
	time_circling.rest_finished.connect(_on_rest_finished)
	
	BehaviorTimeCircling.dead_flow_finished.connect(_on_dead_flow_finished)#接收dea flow结束信号
	
	SanSystem.san_depleted.connect(_on_san_depleted)#接收san归零信号
	
	button_controller.on_assign_worker.connect(_on_assign_worker)# 碎片系统接收按钮器信号

# ===============================
# 请求进入 Working
# ===============================
func request_work():
	# 如果已经在 Working，就不处理
	if GameState.current_state == DataTypes.GameState.Working:
		return

	enter_working()
	
# ===============================
# 请求进入 Resting
# ===============================
func request_rest():
	# 如果已经在 Resting，就不处理
	if GameState.current_state == DataTypes.GameState.Resting:
		return
	enter_resting()
	



func _on_assign_worker():
	if GameState.current_state == DataTypes.GameState.Dead:
		return
		
	if !is_first_assigned:
		is_first_assigned = true
		GameState.mark_first_rest_completed()#判定第一次休息结束啦
		enter_working()
	else:
		if GameState.current_state == DataTypes.GameState.Resting:
			print("Rest → 提前进入 Work")
			enter_working()
		
		
			
# =====================
# Timer结束
# =====================

func _on_work_finished():
	if GameState.current_state == DataTypes.GameState.Working:
		enter_resting()


func _on_rest_finished():
	if GameState.current_state == DataTypes.GameState.Resting:
		enter_working()


func _on_san_depleted():
	if GameState.current_state == DataTypes.GameState.Working:
		enter_dead()

# ===============================
# dead state如何转化为resting state
# ===============================
#func _on_dead_recovery_finished():
	#if GameState.current_state == DataTypes.GameState.Dead:
		#worker_controller.start_alive_recovery()
func _on_dead_sequence_finished():
	if GameState.current_state == DataTypes.GameState.Dead:
		enter_resting()
				
# ===============================
# 真正进入 Working
# ===============================
func enter_working():
	GameState.set_state(DataTypes.GameState.Working)
	print("STATE → Working")
	# 启动工作计时
	time_circling.start_work_timer()


# ===============================
# 真正进入 Resting
# ===============================
func enter_resting():
	GameState.set_state(DataTypes.GameState.Resting)
	print("STATE → Resting")
	# 启动休息计时
	time_circling.start_rest_timer()
	
# ===============================
# 真正进入 Dead
# ===============================
func enter_dead():
	if GameState.current_state == DataTypes.GameState.Dead:
		return

	GameState.set_state(DataTypes.GameState.Dead)
	print("STATE → Dead")
	time_circling.stop_all_timers()
	#GameState.set_behavior(DataTypes.BehaviorState.dying)
	time_circling.start_dead_timer()

func _on_dead_flow_finished():
	if GameState.current_state == DataTypes.GameState.Dead:
		enter_resting()
