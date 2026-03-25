extends PanelContainer

@onready var label = $MarginContainer/Label

@onready var panel_container = get_tree().get_first_node_in_group("MapSelect")
# ===============================
# 数据
# ===============================
var map_info = {
	"A": {
		"title": "FOREST",
		"time": "10 MIN",
		"gain": "Fragments * 120"
	},
	"B": {
		"title": "VILLAGE",
		"time": "10 MIN",
		"gain": "Fragments * 300; Blocks * 50"
	},
	"C": {
		"title": "DESERT",
		"time": "10 MIN",
		"gain": "Fragments * 1000; Blocks * 200"
	}
}




func _ready():
	hide()
	#panel_container.map_select_pressed.connect(_on_map_selected)
	#panel_container.assign_pressed.connect(_hide_map_info_panel)
	panel_container.hover_changed.connect(_on_hover_changed)
# ===============================
# 接收按钮信号
# ===============================
func _on_hover_changed(map_id, active):
	if active:
		show()
		var data = map_info.get(map_id)

		if data == null:
			label.text = "N/A"
			return
		
		
		label.text = """[MAP INFO] %s

		Assign time: %s
		Gain: %s

		[ Click Again To Assign ]""" % [
				data.title,
				data.time,
				data.gain
			]
	else:
		hide()
		print("信息面板隐藏")
		
	
