extends Node

@export var time_circling: Node



# Called when the node enters the scene tree for the first time.
func _ready():

	# 游戏开始默认 Resting
	enter_resting()
	
	# 碎片系统接收计时器信号
	time_circling.step_tick.connect(FragmentSystem._on_step_tick)
	

# ===============================
# 请求进入 Working
# ===============================
func request_work():

	# 如果已经在 Working，就不处理
	if GameState.current_state == DataTypes.GameState.Working:
		return

	# 未来可以加 San 判断
	# if SanController.san <= 0:
	#     return

	enter_working()
	
	
	
# ===============================
# 请求进入 Resting
# ===============================
func request_rest():

	# 如果已经在 Resting，就不处理
	if GameState.current_state == DataTypes.GameState.Resting:
		return

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
