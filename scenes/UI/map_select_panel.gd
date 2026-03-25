extends PanelContainer

@export var map_id: String   # "A" / "B" / "C"

@export var button_map: Button
@export var button_assign: Button

# 发送信号，派出worker至指定地图
signal assign_pressed()
signal map_select_pressed()


func _ready() -> void:
	# mapbutton初始化
	button_map.show()
	button_assign.hide()
	
	button_map.pressed.connect(_on_map_pressed)
	button_assign.pressed.connect(_on_assign_pressed)
	print("map:", button_map)
	print("assign:", button_assign)
	GameState.state_changed.connect(_on_state_changed)# 监听状态变化

func _on_map_pressed() -> void:
	button_map.hide()
	button_assign.show()
	map_select_pressed.emit()
	print("按钮按下")

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
