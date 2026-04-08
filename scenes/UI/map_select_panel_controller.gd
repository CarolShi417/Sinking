extends PanelContainer
"""
作用：
- 管理 A/B/C 三个地图 panel
- 监听碎片变化 → 判断是否解锁
- 转发 hover 信号给 info panel
"""
# ===============================
# 申明 A/B/C PanelContainer
# ===============================
@export var map_A_panel: PanelContainer
@export var map_B_panel: PanelContainer
@export var map_C_panel: PanelContainer
# ===============================
# B/C 地图解锁条件 待修改
# ===============================

# ===============================
# 发送信号
# 鼠标悬停/离开时发送信号
# ===============================
signal map_hovered(map_id: String, active: bool, unlocked: bool) #鼠标悬停
signal map_unhovered(map_id: String, active: bool) #鼠标离开
signal assignment_changed(map_id: String, has_assigned_once: bool, assignment_ongoing: bool)
signal has_assigned()
var current_assigned_map_id: String = ""

func _ready() -> void:
	
	#接收ABC panel的悬停信号
	map_A_panel.hover_changed.connect(_on_hover_changed)
	map_B_panel.hover_changed.connect(_on_hover_changed)
	map_C_panel.hover_changed.connect(_on_hover_changed)
	
	#接收ABC panel的assign信号	
	map_A_panel.assign_pressed.connect(_has_assigned)
	map_B_panel.assign_pressed.connect(_has_assigned)
	map_C_panel.assign_pressed.connect(_has_assigned)
	
	# 初始状态：A开，B/C锁
	map_A_panel.set_unlocked(true)
	map_B_panel.set_unlocked(false)
	map_C_panel.set_unlocked(false)
	
	
	# 碎片数量变化时，判定是否能解锁地图
	FragmentSystem.total_fragment_changed.connect(unlock_maps)
	unlock_maps() #开始检测一次
	
# ===============================
# 鼠标悬停
# ===============================
func _on_hover_changed(map_id: String, active: bool, unlocked: bool) -> void:
	if active:#如果鼠标悬停，获取地图数据，通知显示info panel		
		map_hovered.emit(map_id, true, unlocked)
	else:# 如果鼠标离开，通知隐藏info panel
		map_unhovered.emit(map_id, false)
		#print("鼠标离开")
		
# ===============================
# 地图解锁条件
# ===============================		
func unlock_maps():
	var a = FragmentSystem.total_fragment_a
	var b = FragmentSystem.total_fragment_b
	# ---- B 解锁 ----
	if a >= 0 and b >= 0: #300,50
		if not map_B_panel.is_unlocked:
			map_B_panel.set_unlocked(true)
			_refresh_hover(map_B_panel)

	# ---- C 解锁 ----
	if a >= 0 and b >= 0:# 1000,200
		if not map_C_panel.is_unlocked:
			map_C_panel.set_unlocked(true)
			_refresh_hover(map_C_panel)
			
# ===============================
# 强制刷新 hover UI（关键）
# ===============================
func _refresh_hover(panel):
	# 如果鼠标正在这个 panel 上
	var mouse_pos = get_viewport().get_mouse_position()
	if panel.get_global_rect().has_point(mouse_pos):
		# 重新发一次 hover → 让 info panel 更新
		map_hovered.emit(panel.map_id, true, panel.is_unlocked)
		
# ===============================
# 员工已派出
# ===============================
func _has_assigned(map_id: String):
	if map_id.is_empty():
		return
	
	has_assigned.emit()
	current_assigned_map_id = map_id
	# ABC同一时间有且只有一个可以被assigned
	for panel in [map_A_panel, map_B_panel, map_C_panel]:
		var is_current_panel = panel.map_id == map_id
		panel.set_assigned(is_current_panel)
		panel.set_blocked_by_other_assignment(not is_current_panel)

	assignment_changed.emit(
		map_id,
		is_map_assigned_once(map_id),
		is_assignment_ongoing(map_id)
	)
	
func get_map_panel(_map_id: String):
	for panel in [map_A_panel, map_B_panel, map_C_panel]:
					return panel
	return null

func is_map_assigned_once(map_id: String) -> bool:
	var panel = get_map_panel(map_id)
	if panel == null:
		return false
	return panel.has_assigned_once

func is_assignment_ongoing(map_id: String) -> bool:
	if current_assigned_map_id.is_empty():
		return false
	return current_assigned_map_id == map_id
