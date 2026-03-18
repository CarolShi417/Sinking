extends Node

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
			
# ===============================
# 死亡时，状态有所不同
# ===============================
func _on_state_changed(state):
	if state == DataTypes.GameState.Dead:
		behavior_timer.stop()
		GameState.set_behavior(DataTypes.BehaviorState.idle)
	elif state == DataTypes.GameState.Resting:
		start_idle_timer()
	elif state == DataTypes.GameState.Working:
		start_idle_timer()
		
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
