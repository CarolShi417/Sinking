extends Node
# resing, working, dead状态下两个worker的显示与隐藏

@onready var worker_rest = get_tree().get_first_node_in_group("WorkerResting")
@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")
@onready var worker_work_behavior = worker_work.get_node("BehaviorController")
@onready var worker_rest_behavior = worker_rest.get_node("BehaviorController")

const REST_POSITION := Vector2(450, 190)
const WORK_POSITION := Vector2(1400, 225)

func _ready():
	GameState.state_changed.connect(_on_state_changed)
	
	worker_rest.z_index = 40
	worker_work.z_index = 11
	
	worker_rest.position = REST_POSITION
	worker_work.position = WORK_POSITION
	
	if GameState.current_state == DataTypes.GameState.Resting:
		_show_rest_worker()
		

func _on_state_changed(state):
	if state == DataTypes.GameState.Resting:		
		_show_rest_worker()
	elif state == DataTypes.GameState.Working:		
		_show_work_worker()
	elif state == DataTypes.GameState.Dead:
		_worker_dead()
		
func _show_rest_worker() -> void:
	await get_tree().create_timer(1.5).timeout
	worker_work_behavior.behavior_timer.stop() #隐藏前停掉work的动画状态机计时器
	worker_work.hide()
	worker_work.process_mode = Node.PROCESS_MODE_DISABLED  # 关闭所有worker.work逻辑
	worker_rest.show()	
	worker_rest.process_mode = Node.PROCESS_MODE_INHERIT  # 打开所有worker.rest逻辑 
	worker_rest.position = REST_POSITION
	worker_rest.reset_movement(1)
	worker_rest.LEFT_LIMIT = 10
	worker_rest.RIGHT_LIMIT = 900
	worker_rest_behavior.force_enter_idle() #显示后强制动画状态机为idle


func _show_work_worker() -> void:
	await get_tree().create_timer(1.5).timeout
	worker_rest_behavior.behavior_timer.stop() #隐藏前停掉work的动画状态机计时器
	worker_rest.hide()
	worker_rest.process_mode = Node.PROCESS_MODE_DISABLED  # 关闭所有worker.rest逻辑
	worker_work.show()
	worker_work.process_mode = Node.PROCESS_MODE_INHERIT  # 打开所有worker.work逻辑 
	worker_work.position = WORK_POSITION	
	worker_work.reset_movement(-1)
	worker_work.LEFT_LIMIT = 1000
	worker_work.RIGHT_LIMIT = 1900
	worker_work_behavior.force_enter_idle() #显示后强制动画状态机为idle

func _worker_dead() -> void:
	await get_tree().create_timer(2.0).timeout
	worker_work.hide()
	worker_work.process_mode = Node.PROCESS_MODE_DISABLED
	worker_rest.show()
	worker_rest.process_mode = Node.PROCESS_MODE_INHERIT
	worker_rest.position = REST_POSITION	
	worker_rest.reset_movement(1)
	
