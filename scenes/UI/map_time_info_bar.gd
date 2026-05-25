extends Control
"""
Map&TimeInfoBar — 纯UI面板
显示：当前地图名 / 工作剩余时间 / 碎片获取效率档位 / 本次探索碎片数
所有数据来源于全局系统，本脚本只负责展示，不做任何数值计算
"""

@onready var current_frag_effi_label: Label = $HBoxContainer3/low_steady_high_percent # 采集效率挡位
@onready var current_fragment_num_label: Label = $CurrentFragment # 本次采集获取总数
@onready var current_map_label: Label = $HBoxContainer/CurrentMap # 当前地图名（A/B/C）
@onready var current_time_left_label: Label = $HBoxContainer2/CurrentTimeLeft # 工作剩余时间

# ===============================
# 获取 MapSelectPanelController 节点（用于读取当前选中的地图）
# ===============================
@onready var map_select_panel: PanelContainer = get_node("../../MapSelectPanel")

# ===============================
# InfoBar 专用 hover 触发区（Area2D，挂 info_bar_hover_area.gd）
# 需要在编辑器中把该 Area2D 节点路径填到这里
# ===============================
@onready var info_bar_hover_area: Area2D = get_node("../RealTimeFragGainArea2D")
@export var hide_delay: float = 2.0 #隐藏时间，以inspector为准

# Working 开始后延迟隐藏的计时器
var _hide_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#FragmentSystem.fragment_gained_this_exploration_updated.connect(_on_fragment_updated)
	# 接收碎片系统的step_tick信号（每5秒更新一次）
	FragmentSystem.fragment_gain_per_step.connect(_on_step_update)
	# 接收碎片系统的本次探索碎片更新信号
	FragmentSystem.fragment_gained_this_exploration_updated.connect(_on_fragment_updated)
	# 接收状态切换信号（用于非Working状态时清空显示）
	GameState.state_changed.connect(_on_state_changed)

	# 连接 InfoBar 触发区的 hover 信号（控制显示/隐藏）
	if info_bar_hover_area:
		info_bar_hover_area.info_bar_hover_changed.connect(_on_info_bar_hover)
	
	# 创建延迟隐藏计时器（Working开始后2秒隐藏）
	_hide_timer = Timer.new()
	_hide_timer.one_shot = true
	_hide_timer.timeout.connect(_on_hide_timer_timeout)
	add_child(_hide_timer)
	
# ===============================
# 每5秒更新一次（与step_tick同步）
# 更新：当前地图 / 剩余时间 / 效率档位
# ===============================
func _on_step_update(_speed_level: String) -> void:
	# 只在Working状态下更新
	if GameState.current_state != DataTypes.GameState.Working:
		return
	
	_refresh_current_map()
	_refresh_time_left()
	_refresh_efficiency()

# ===============================
# 更新当前地图Label
# 从 MapSelectPanelController 读取当前派遣的地图ID
# ===============================
func _refresh_current_map() -> void:
	var map_id: String = map_select_panel.current_assigned_map_id
	if map_id.is_empty():
		current_map_label.text = "--"
	else:
		current_map_label.text = map_id

# ===============================
# 更新剩余时间Label
# 从 TimeCirclingSystem 读取工作计时器剩余秒数
# 格式化为 00'00'' （分'秒''）
# ===============================
func _refresh_time_left() -> void:
	var seconds_left: float = TimeCirclingSystem.get_work_time_left()
	var minutes: int = int(seconds_left) / 60
	var seconds: int = int(seconds_left) % 60
	current_time_left_label.text = "%02d'%02d''" % [minutes, seconds]

# ===============================
# 更新效率档位Label
# 格式：high ▲ (72%)
# 档位：FragmentSystem.current_efficiency_level
# 趋势：FragmentSystem.hustling_trend（▲ / ▼ / —）
# 百分比：FragmentSystem.hustling_percent（hover碎片占总碎片）
# ===============================
func _refresh_efficiency() -> void:
	var level := FragmentSystem.current_efficiency_level
	var trend := FragmentSystem.hustling_trend
	var percent := FragmentSystem.hustling_percent
	current_frag_effi_label.text = "%s %s (%d%%)" % [level, trend, int(percent)]

# ===============================
# 更新本次探索碎片数Label
# ===============================
func _on_fragment_updated(amount: float) -> void:
	current_fragment_num_label.text = "%.1f" % amount

# ===============================
# 状态切换时清空/重置显示
# ===============================
func _on_state_changed(state) -> void:
	if state == DataTypes.GameState.Working:
		visible = true
		_hide_timer.start(hide_delay)
		return # Working状态由step_update驱动更新
	
	# 非Working状态，重置所有Label
	current_map_label.text = "--"
	current_time_left_label.text = "--'--''"
	current_fragment_num_label.text = "0.0"
	current_frag_effi_label.text = "low — (0%)"
	
# ===============================
# 计时结束，隐藏 InfoBar
# ===============================
func _on_hide_timer_timeout() -> void:
	visible = false

# ===============================
# InfoBar 触发区的 hover 回调
# hover 进入时显示，离开时隐藏（仅 Working 状态下生效）
# ===============================
func _on_info_bar_hover(active: bool) -> void:
	if GameState.current_state != DataTypes.GameState.Working:
		return
	# hover 进入时停止自动隐藏计时器，防止刚显示又被藏起来
	if active:
		_hide_timer.stop()
		visible = true
	else:
		_hide_timer.start(hide_delay)
