extends PanelContainer
"""
作用：
- 控制单个地图按钮
- 管理解锁状态（只负责表现）
"""
# ===============================
# 基本配置
# ===============================
@export var map_id: String   # "A" / "B" / "C"
@export var starts_unlocked: bool = true # 初始状态，地图是否已解锁
# ===============================
# 地图按钮Texture
# ===============================
@export var map_icon_unlocked: Texture2D
@export var map_icon_locked: Texture2D
# ===============================
# 2种地图按钮
# ===============================
@export var button_map: Button
@export var button_assign: Button

# ===============================
# 探索时长选项
# ===============================
# 时长解锁顺序：第1个一直可用，每探索1次解锁下一个
const DURATION_OPTIONS: Array[int] = [10, 30, 300]
# 整个"时长选项"容器
@export var duration_options_container: Control
# 在场景里预先放好对应数量的按钮
# 按 DURATION_OPTIONS 的顺序，依次拖入这个数组
@export var duration_buttons: Array[Button] = []

var exploration_count: int = 0          # 该地图已探索次数
var selected_duration: int = DURATION_OPTIONS[0]  # 当前选中的时长

# ===============================
# 信号
# ===============================
signal assign_pressed(map_id: String)# 发送信号，派出worker至指定地图
signal map_select_pressed(map_id) #发送 点击A/B/C地图信号
# 判断鼠标是否悬停在当前按钮上
# active true表示鼠标悬停，false表示离开
signal hover_changed(map_id: String, active: bool, unlocked: bool)
# 玩家选择了某个探索时长时发出（10s / 30s / 5min 等任意选项都会发）
signal duration_selected(map_id: String, duration: int)

var is_unlocked: bool = false # 当前地图是否解锁
var is_assigned: bool = false # 是否派出
var has_assigned_once: bool = false
var blocked_by_other_assignment: bool = false

func _ready() -> void:	
	# 按钮初始化
	button_map.show()
	button_assign.hide()
	duration_options_container.hide()
	
	# 鼠标点击按钮事件
	button_map.pressed.connect(_on_map_pressed)
	button_assign.pressed.connect(_on_assign_pressed)
	
	# 鼠标悬停按钮事件
	button_map.mouse_entered.connect(_on_map_button_mouse_entered)
	button_map.mouse_exited.connect(_on_map_button_mouse_exited)
	
	GameState.state_changed.connect(_on_state_changed)# 监听状态变化
	
	# 初始化时长按钮：设置文字、开启toggle、连接点击信号
	for i in range(duration_buttons.size()):
		var btn := duration_buttons[i]
		btn.text = str(DURATION_OPTIONS[i]) + "s"
		btn.toggle_mode = true
		btn.pressed.connect(_on_duration_button_pressed.bind(i))
		
	set_unlocked(starts_unlocked) #设置地图初始锁定/解锁状态
	
# ===============================
# 鼠标点击地图按钮
# ===============================
func _on_map_pressed() -> void:
	#如果当前地图未解锁，return
	if is_unlocked == false:
		return
	#如果玩家已在其他地图被派出，return
	print("map 按钮被按下")
	map_select_pressed.emit(map_id)
	if blocked_by_other_assignment:
		#显示对应地图样式
		
		#隐藏worker
		return
		
	else:
		button_map.hide()
		button_assign.show()
		duration_options_container.show()
		_update_duration_options()
		#print("按钮按下")
	
# ===============================
# 鼠标点击发配按钮
# ===============================
func _on_assign_pressed() -> void:
	has_assigned_once = true
	is_assigned = true
	
	button_map.show()
	button_assign.hide()
	duration_options_container.hide()  # 👈 整体隐藏时长选项
	#显示对应map
	assign_pressed.emit(map_id)
	duration_selected.emit(map_id, selected_duration)  # 👈 确认分配时才广播选中的时长
	
# ===============================
# 只有Working状态，assign按钮才可以点击
# ===============================
func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		button_assign.disabled = true
		button_map.disabled = true
	else:
		button_assign.disabled = false
		button_map.disabled = false
		
# ===============================
# 地图解锁
# ===============================
func set_unlocked(unlocked: bool) -> void:
	is_unlocked = unlocked	

	if is_unlocked:		
		if map_icon_unlocked:
			button_map.icon = map_icon_unlocked
	# 如果地图锁定
	else:
		#这里增加该按钮不可被按下（但悬停有反应）
		if map_icon_locked:
			button_map.icon = map_icon_locked
		
func set_assigned(active: bool) -> void:
	is_assigned = active

func set_blocked_by_other_assignment(blocked: bool) -> void:
	blocked_by_other_assignment = blocked
	if blocked:
		button_assign.hide()
		button_map.show()
		duration_options_container.hide()
		
# ===============================
# 鼠标悬停事件
# ===============================
func _on_map_button_mouse_entered() -> void:
	hover_changed.emit(map_id, true, is_unlocked) # 鼠标悬停 发射悬停信号
	#print("isHover")

func _on_map_button_mouse_exited() -> void:
	hover_changed.emit(map_id, false, is_unlocked) #鼠标离开 发射离开信号
	#print("ExitHover")

# ===============================
# 探索时长选项
# ===============================

# 根据 exploration_count 显示/隐藏对应数量的时长按钮
func _update_duration_options() -> void:
	# 已探索0次 -> 解锁1个选项(10s)；已探索1次 -> 解锁2个选项(10s/30s)；以此类推
	var unlocked_count: int = clampi(exploration_count + 1, 1, duration_buttons.size())

	for i in range(duration_buttons.size()):
		duration_buttons[i].visible = i < unlocked_count

	# 默认选中第一个选项（10s），并广播一次探索时长
	selected_duration = DURATION_OPTIONS[0]
	if duration_buttons.size() > 0:
		duration_buttons[0].button_pressed = true


# 时长按钮被点击时，记录当前选中的时长
func _on_duration_button_pressed(index: int) -> void:
	selected_duration = DURATION_OPTIONS[index]

# ===============================
# 探索完成后调用：解锁下一个时长选项
# 需要在"探索结束"的逻辑里手动调用这个函数
# ===============================
func increment_exploration_count() -> void:
	exploration_count += 1
