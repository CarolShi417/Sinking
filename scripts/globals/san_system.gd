extends Node

signal san_changed(value: float) #san改变信号，发给UI等
signal san_depleted #san耗尽信号，发给其他代码change state为dead

#需要获取worker是否被monitor hover
@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")
var hover_active := false

# ===============================
# SAN 数值范围
# ===============================
var san : float = 80.0 #初始san值
const SAN_MIN := 0.0
const SAN_MAX := 100.0
# SAN 基础设定
# 当前规则：
# 1. Working + Hover：每秒扣 5 SAN
# 2. Working + 非 Hover：SAN 不变
# 3. Resting：每秒回 5 SAN
# ===============================
const san_tick_interval := 1.0
const working_hover_san_change_per_second := -5.0
const resting_san_change_per_second := 5.0
var san_timer : Timer
var has_entered_working_once := false
var resting_recovery_enabled := false

# ========================
# 一些会影响san的bonus被动
# ========================
#var sofa_san_rate_bonus : float = 0.05#员工待机时，SAN值回复效率每分钟增加A


func _ready() -> void:
	# 监听全局状态；离开 Working 时要清掉 hover，避免状态残留。
	GameState.state_changed.connect(_on_state_changed)
	_create_san_timer()
	
	# 等场景树准备好后，连接 HoverArea 的信号。
	await get_tree().process_frame
	var hover_area = worker_work.get_node("HoverArea")#接收HoverArea信号
	if hover_area:
		hover_area.hover_changed.connect(set_hover_active)

	# 初始化时主动广播一次 SAN，方便 UI 在开局同步显示。
	_emit_san_changed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
#创建san计时器
func _create_san_timer() -> void:
	san_timer = Timer.new()
	san_timer.one_shot = false
	san_timer.wait_time = san_tick_interval
	san_timer.timeout.connect(_on_san_timer_timeout)
	add_child(san_timer)
	san_timer.start()

# SAN 现在独立按每秒结算，不再跟 fragment 共用 step_tick。
func _on_san_timer_timeout() -> void:
	var san_change := get_current_san_change_per_second() * san_tick_interval
	if is_zero_approx(san_change):
		return

	apply_san_change(san_change)


# 统一计算“当前这一秒 SAN 会变化多少”。
func get_current_san_change_per_second() -> float:
	if GameState.current_state == DataTypes.GameState.Working:
		if hover_active:
			return working_hover_san_change_per_second
		return 0.0

	if GameState.current_state == DataTypes.GameState.Resting:
		return resting_san_change_per_second

	return 0.0
	
# 真正修改 SAN 数值，并负责：
# 1. 限制在合法区间
# 2. 发出 san_changed
# 3. SAN 归零时发出 san_depleted，让 StateController 统一切状态
func apply_san_change(amount: float) -> void:
	var previous_san := san
	san = clamp(san + amount, SAN_MIN, SAN_MAX)

	if is_equal_approx(previous_san, san):
		return

	print("SAN:", san)
	_emit_san_changed()

	if is_zero_approx(san) and GameState.current_state == DataTypes.GameState.Working:
		hover_active = false
		san_depleted.emit()


# HoverArea 的状态入口；SAN 自己维护 hover_active，避免依赖 FragmentSystem。
func set_hover_active(active: bool) -> void:
	hover_active = active
	
# 只要离开 Working，就清掉 hover 状态，避免下一次沿用旧值。
# 同时记录是否已经进入过 Working，避免游戏开局第一个 Resting 就开始自动回 SAN。
func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		has_entered_working_once = true
		resting_recovery_enabled = false
	else:
		hover_active = false
	if state == DataTypes.GameState.Resting:
		resting_recovery_enabled = has_entered_working_once

# 对外统一广播当前 SAN。
func _emit_san_changed() -> void:
	san_changed.emit(san)
