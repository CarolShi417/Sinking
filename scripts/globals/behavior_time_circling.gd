extends Node

signal dead_flow_finished #向state发送死亡流程结束信号，让state切换为dead

var behavior_timer: Timer
var current_behavior : DataTypes.BehaviorState

const rest_idle_duration := 5.0
const rest_walk_duration := 5.0
const work_idle_duration := 5.0
const work_walk_duration := 5.0
const work_gather_duration := 10.0

@export var state_machine: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	GameState.behavior_changed.connect(_on_behavior_changed)
	_create_behavior_timers()#
	if GameState.current_state == DataTypes.GameState.Resting:
		start_idle_timer()

#创建行为计时器
func _create_behavior_timers():
	behavior_timer = Timer.new()
	behavior_timer.one_shot = true
	behavior_timer.timeout.connect(_on_behavior_timeout)# Timer 结束时调用

	add_child(behavior_timer)
	
# ===============================
# 死亡时，状态有所不同
# ===============================
func _on_state_changed(state):	
	#停止行为计时器
	behavior_timer.stop()
	
	match state:
		
		DataTypes.GameState.Resting:
			start_idle_timer()

		DataTypes.GameState.Working:
			start_idle_timer()

		DataTypes.GameState.Dead:
			_start_dead_flow()

# ===============================
# 切换worker状态，连接不同动画
# ===============================
func _on_behavior_changed(new_behavior):

	match new_behavior:
		DataTypes.BehaviorState.idle:
			state_machine.transition_to("Idle")

		DataTypes.BehaviorState.walk:
			state_machine.transition_to("Walk")

		DataTypes.BehaviorState.gather:
			state_machine.transition_to("Gather")
		
		DataTypes.BehaviorState.gather:
			state_machine.transition_to("Dying")
		
		DataTypes.BehaviorState.gather:
			state_machine.transition_to("Dead_rest")
			
		DataTypes.BehaviorState.gather:
			state_machine.transition_to("Alive_rest")
		
		
# =====================
# 开始behavior计时
# =====================
func start_idle_timer():
	current_behavior = DataTypes.BehaviorState.idle
	GameState.set_behavior(current_behavior)

	var duration

	if GameState.current_state == DataTypes.GameState.Resting:
		duration = rest_idle_duration
	else:
		duration = work_idle_duration

	#print("idle duration:", duration)

	behavior_timer.start(duration)
	

func start_walk_timer():

	current_behavior = DataTypes.BehaviorState.walk
	GameState.set_behavior(current_behavior)

	var duration

	if GameState.current_state == DataTypes.GameState.Resting:
		duration = rest_walk_duration
	else:
		duration = work_walk_duration

	#print("walk duration:", duration)

	behavior_timer.start(duration)


func start_gather_timer():

	current_behavior = DataTypes.BehaviorState.gather
	GameState.set_behavior(current_behavior)

	#print("gather duration:", work_gather_duration)

	behavior_timer.start(work_gather_duration)
	
# =====================
# Timer结束
# =====================
func _on_behavior_timeout():

	match GameState.current_state:

		DataTypes.GameState.Resting:
			_rest_cycle()

		DataTypes.GameState.Working:
			_work_cycle()

# =====================
# Resting循环
# =====================

func _rest_cycle():

	match current_behavior:

		DataTypes.BehaviorState.idle:
			start_walk_timer()

		DataTypes.BehaviorState.walk:
			start_idle_timer()

# =====================
# Working循环
# =====================
func _work_cycle():

	match current_behavior:

		DataTypes.BehaviorState.idle:
			start_gather_timer()

		DataTypes.BehaviorState.gather:
			start_walk_timer()

		DataTypes.BehaviorState.walk:
			start_idle_timer()
			
func _start_dead_flow():

	# 1. dying（2秒）
	current_behavior = DataTypes.BehaviorState.dying
	GameState.set_behavior(current_behavior)
	await get_tree().create_timer(2.0).timeout

	# 2. dead_rest（5分钟）
	current_behavior = DataTypes.BehaviorState.dead_rest
	GameState.set_behavior(current_behavior)
	await get_tree().create_timer(300.0).timeout

	# 3. alive_rest（0.5秒）
	current_behavior = DataTypes.BehaviorState.alive_rest
	GameState.set_behavior(current_behavior)
	await get_tree().create_timer(0.5).timeout

	# 4. 回到Resting状态
	dead_flow_finished.emit()
