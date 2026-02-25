extends Control

# ====== 地图按钮 ======
#@export var button_mapA: Button
@onready var button_mapA: Button = $MapButtons/MapAButton
@onready var button_mapB: Button = $MapButtons/MapBButton
@onready var button_mapC: Button = $MapButtons/MapCButton

@onready var button_assignWorkerToMapA: Button = $MapButtons/AssignWorkerAButton
@onready var button_assignWorkerToMapB: Button = $MapButtons/AssignWorkerBButton
@onready var button_assignWorkerToMapC: Button = $MapButtons/AssignWorkerCButton

signal assign_worker_to_mapA
signal assign_worker_to_mapB
signal assign_worker_to_mapC

#var selected_map = null # 当前选中的 map
# ====== 测试 ====== 
@onready var test_button_skip = $Test_SkipButton

# ====== 地图背景 ====== 
@onready var bg_mapA: Sprite2D = $"../bgLocationMaps/bg location map A"
@onready var bg_mapB: Sprite2D = $"../bgLocationMaps/bg location map B"
@onready var bg_mapC: Sprite2D = $"../bgLocationMaps/bg location map C"

# ===== Fragment Gain Timeline Display
@onready var timeline := $FragmentGainingTimeline
@onready var MapMana := get_node("../MapMana") 
var segment_for_timeline : int

func _ready() -> void:
	# mapbutton初始化
	button_assignWorkerToMapA.hide()
	button_assignWorkerToMapB.hide()
	button_assignWorkerToMapC.hide()
	bg_mapA.show()
	bg_mapB.hide()
	bg_mapC.hide()
	# fragment timeline 初始
	segment_for_timeline = int(MapMana.segment)
	print("segmentfortimeline:", segment_for_timeline)
	MapMana.step_tick.connect(_on_mapmana_step_tick)#每5s接受一次信号
	
	#create_timeline()
	
# ====== 选择地图 ====== 
func _on_map_a_button_pressed() -> void:
	button_mapA.hide()
	button_assignWorkerToMapA.show()
	#print("mapA被按下")
	
	bg_mapA.show()
	bg_mapB.hide()
	bg_mapC.hide()
	
func _on_map_b_button_pressed() -> void:
	button_mapB.hide()
	button_assignWorkerToMapB.show()
	#print("mapB被按下")

	bg_mapB.show()
	bg_mapA.hide()
	bg_mapC.hide()

func _on_map_c_button_pressed() -> void:
	button_mapC.hide()
	button_assignWorkerToMapC.show()

	bg_mapC.show()
	bg_mapA.hide()
	bg_mapB.hide()

# ====== 确定派遣worker至选中地图 ======
func _on_assign_worker_a_button_pressed() -> void:
	emit_signal("assign_worker_to_mapA")
	button_assignWorkerToMapA.hide()
	button_mapA.show()
	
func _on_assign_worker_b_button_pressed() -> void:
	emit_signal("assign_worker_to_mapB")
	button_assignWorkerToMapB.hide()
	button_mapB.show()

func _on_assign_worker_c_button_pressed() -> void:
	emit_signal("assign_worker_to_mapC")
	button_assignWorkerToMapC.hide()
	button_mapC.show()

# 生成fragment Gaining Timeline
func _on_mapmana_step_tick(level: String):
	var rect := ColorRect.new()
	
	# 确认timeline颜色
	match level:
		"high":
			rect.color = Color.RED
		"low":
			rect.color = Color.WHITE
		_:
			rect.color = Color.GRAY
			
	rect.custom_minimum_size = Vector2(10, 20)
	timeline.add_child(rect)

	print("rect added")
