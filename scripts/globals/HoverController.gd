extends Node

# hover就马上发出
signal hover_changed(active: bool)
# 5秒内累计 hover 超过2秒 → 有效，否则无效
signal effective_hover_changed(is_effective: bool)

# 当前是否处于有效 hover 状态（供其他系统直接读取）
var is_effective_hover: bool = false

# 当前原始 hover 状态（鼠标是否在 worker 上）
var _is_hovering: bool = false

# 本探索周期内累计 hover 时长（秒）
var _hover_accumulated: float = 0.0

# 有效 hover 的最低时长阈值（秒）
const EFFECTIVE_HOVER_THRESHOLD := 2.0

func _ready() -> void:
	GameState.state_changed.connect(_on_state_changed)
	
# ===============================
# 一hover马上发信号
# ===============================	
func set_hover(active: bool) -> void:
	_is_hovering = active
	hover_changed.emit(active)

# ===============================
# Working 状态下每帧累加 hover 时长
# ===============================
func _process(delta: float) -> void:
	if GameState.current_state != DataTypes.GameState.Working:
		return
	if _is_hovering:
		_hover_accumulated += delta

# ===============================
# 每个 step 周期（5秒）结算一次
# 由 StateController 转发 step_tick 时调用
# ===============================
func evaluate_step() -> void:
	var was_effective := is_effective_hover
	# 判定：本周期累计 hover 时长是否达到阈值
	is_effective_hover = _hover_accumulated >= EFFECTIVE_HOVER_THRESHOLD
	# 重置累计器，开始下一个周期
	_hover_accumulated = 0.0
	# 仅在状态变化时发出信号，减少无意义调用
	if is_effective_hover != was_effective:
		effective_hover_changed.emit(is_effective_hover)

# ===============================
# 状态切换时重置所有数据
# ===============================
func _on_state_changed(_state) -> void:
	_is_hovering = false
	_hover_accumulated = 0.0
	is_effective_hover = false
