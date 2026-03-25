extends PanelContainer

@export var map_id: String   # "A" / "B" / "C"

@export var starts_unlocked: bool = true
@export var map_icon_unlocked: Texture2D
@export var map_icon_locked: Texture2D

@export var button_map: Button
@export var button_assign: Button

# 发送信号，派出worker至指定地图
signal assign_pressed()
signal map_select_pressed(map_id)
# 是否hover
signal hover_changed(map_id: String, active: bool)

var is_unlocked: bool = true

func _ready() -> void:	
	# mapbutton初始化
	button_map.show()
	button_assign.hide()
	
	#点击
	button_map.pressed.connect(_on_map_pressed)
	button_assign.pressed.connect(_on_assign_pressed)
	
	#hover悬停
	button_map.mouse_entered.connect(_on_map_button_mouse_entered)
	button_map.mouse_exited.connect(_on_map_button_mouse_exited)
	
	GameState.state_changed.connect(_on_state_changed)# 监听状态变化
	
	set_unlocked(starts_unlocked)

func _on_map_pressed() -> void:
	button_map.hide()
	button_assign.show()
	map_select_pressed.emit(map_id)
	#print("按钮按下")

func _on_assign_pressed() -> void:
	button_map.show()
	button_assign.hide()
	#显示对应map
	assign_pressed.emit() 

func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		button_assign.disabled = true
	else:
		button_assign.disabled = false
		
#地图解锁
func set_unlocked(unlocked: bool) -> void:
	is_unlocked = unlocked
	button_map.disabled = !is_unlocked

	if is_unlocked:
		if map_icon_unlocked:
			button_map.icon = map_icon_unlocked
	else:
		if map_icon_locked:
			button_map.icon = map_icon_locked
		button_map.show()
		button_assign.hide()

# 是否hover
func _on_map_button_mouse_entered() -> void:
	hover_changed.emit(map_id, true)
	print("isHover")

func _on_map_button_mouse_exited() -> void:
	hover_changed.emit(map_id, false)
	print("ExitHover")
