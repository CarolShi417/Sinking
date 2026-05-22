extends Area2D
"""
InfoBar 专用的 hover 触发区
仅控制 InfoBar 的显示/隐藏，不影响游戏系统（不走 HoverController）
鼠标悬停满x秒后才触发显示信号，防止误触
"""

# UI 显示/隐藏信号，与游戏逻辑的 hover 完全独立
signal info_bar_hover_changed(active: bool)

# 悬停多少秒后才算有效 hover，可在 Inspector 中调整
@export var hover_threshold: float = 1.5

# 悬停计时器
var _hover_timer: Timer
# 当前鼠标是否在区域内
var _is_mouse_inside: bool = false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# 创建悬停计时器
	_hover_timer = Timer.new()
	_hover_timer.one_shot = true
	_hover_timer.timeout.connect(_on_hover_timer_timeout)
	add_child(_hover_timer)

# 鼠标进入触发区，开始计时
func _on_mouse_entered():
	_is_mouse_inside = true
	_hover_timer.start(hover_threshold)

# 鼠标离开触发区，取消计时并通知隐藏
func _on_mouse_exited():
	_is_mouse_inside = false
	_hover_timer.stop()
	# 无论是否曾触发过显示，离开时都发出隐藏信号
	info_bar_hover_changed.emit(false)

# 计时结束，鼠标仍在区域内，视为有效 hover
func _on_hover_timer_timeout():
	if _is_mouse_inside:
		info_bar_hover_changed.emit(true)
