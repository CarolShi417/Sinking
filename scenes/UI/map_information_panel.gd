extends PanelContainer

@onready var label = $MarginContainer/VBoxContainer/Label
@onready var panel_container = $"../MapSelectPanel"
var current_hover_map_id: String = ""
func _ready():
	hide() #初始隐藏
	# 监听 鼠标悬停/离开 信号
	panel_container.map_hovered.connect(_on_map_info_show)
	panel_container.map_unhovered.connect(_on_map_info_hide)
	# 监听 状态
	panel_container.assignment_changed.connect(_on_assignment_changed)
	
# ===============================
# 鼠标悬停/离开 显示info 面板
# active表示是否hover
# ===============================
func _on_map_info_show(map_id: String, active: bool, unlocked: bool):
	if not active:
		hide()   # 鼠标离开隐藏面板
		#print("鼠标未悬停在button上")
	else:
		# 鼠标悬停显示面板
		current_hover_map_id = map_id
		show()
		# 获取对应地图信息
		var data = MapInfoData.get_map_info(map_id)# 从MapInfoData全局获取数据
		if data.is_empty():
			label.text = "N/A"
			return

		# 根据解锁状态显示不同文案
		if unlocked == true:
			# 地图解锁文案
			var assigned_once = panel_container.is_map_assigned_once(map_id)
			var assignment_line := "[ Click Again To Assign ]"
			if assigned_once:
				assignment_line = "[ Assignment Ongoing ]"
			label.text = """[MAP INFO] %s
Assign time: %s
Gain: %s
%s""" % [
				data.title,
				data.time,
				data.gain,
				assignment_line
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
			# print("地图被锁定了")

func _on_map_info_hide(_map_id: String, active: bool):
	if not active:
		hide()
		current_hover_map_id = ""

		
func _on_assignment_changed(map_id: String, _has_assigned_once: bool, _assignment_ongoing: bool):
	if current_hover_map_id == map_id and visible:
		_on_map_info_show(map_id, true, true)		
