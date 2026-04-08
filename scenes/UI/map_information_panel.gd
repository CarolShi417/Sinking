extends PanelContainer

@onready var label = $MarginContainer/VBoxContainer/Label
@onready var click_again_label = $MarginContainer/VBoxContainer/ClickAgainLabel
@onready var assign_ongo_label = $MarginContainer/VBoxContainer/AssignOngoLabel
@onready var panel_container = $"../MapSelectPanel"

func _ready():
	hide() #初始隐藏
	click_again_label.show() #初始 ClickAgaintoAssign
	assign_ongo_label.hide()
	# 监听 鼠标悬停/离开 信号
	panel_container.map_hovered.connect(_on_map_info_show)
	panel_container.map_unhovered.connect(_on_map_info_hide)
	# 监听 状态
	GameState.state_changed.connect(_on_state_changed)# 监听状态变化
	
# ===============================
# 鼠标悬停/离开 显示info 面板
# active表示是否hover
# ===============================
func _on_map_info_show(map_id: String, active: bool, unlocked: bool):
	if not active:
		hide()   # 鼠标离开隐藏面板
		print("鼠标未悬停在button上")
	else:
		# 鼠标悬停显示面板
		show()
		

		# 获取对应地图信息
		var data = MapInfoData.get_map_info(map_id)# 从MapInfoData全局获取数据
		if data.is_empty():
			label.text = "N/A"
			return

		# 根据解锁状态显示不同文案
		if unlocked == true:			
			# 地图解锁文案			
			label.text = """[MAP INFO] %s
	Assign time: %s
	Gain: %s""" % [
				data.title,
				data.time,
				data.gain
			]
		else:			
			# 地图锁定文案
			
			label.text = """[MAP INFO] %s
	Assign time: %s
	Gain: %s
	Unlock requirement: %s
	[ Click To Unlock ]""" % [
				data.title,
				data.time,
				data.gain,
				data.unlock_requirement
			]
			print("地图被锁定了")

func _on_map_info_hide(_map_id: String, active: bool):
	if not active:
		hide()

# ===============================
# Working状态下，显示
# ===============================
func _on_state_changed(state):
	if state == DataTypes.GameState.Working:
		assign_ongo_label.show()
		click_again_label.hide()
	else:
		assign_ongo_label.hide()
		click_again_label.show()
		
