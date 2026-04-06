extends Node2D


signal upgrade_requested(building_id: String)
signal upgraded(building_id: String, new_level: int)


@export var building_id := ""

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hover_area: Area2D = $BuildingHoverArea
@onready var upgrade_panel: PanelContainer = $Control/UpgradeBuildingPanel
@onready var info_label: Label = $Control/UpgradeBuildingPanel/MarginContainer/VBoxContainer/Label
@onready var upgrade_button: Button = $Control/UpgradeBuildingPanel/MarginContainer/VBoxContainer/Button

var is_hovering_building := false # 鼠标是否在建筑物上
var is_hovering_panel := false #鼠标是否在升级panel上

func _ready() -> void:
	_resolve_building_id()
	upgrade_panel.hide()
	hover_area.mouse_entered.connect(_on_building_hover_area_mouse_entered)
	hover_area.mouse_exited.connect(_on_building_hover_area_mouse_exited)
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	BuildingSystem.building_upgraded.connect(_on_building_upgraded)
	_refresh_view()

func _resolve_building_id() -> void:
	if !building_id.is_empty():
		return

	building_id = String(name).to_snake_case()

#更新建筑
func _refresh_view() -> void:
	# 获取当前等级
	var level := BuildingSystem.get_current_level(building_id)
	# 1) 播放当前等级对应动画
	sprite.play(BuildingSystem.get_animation_name(building_id, level))
	
	# 2) 读取UI需要的数据
	var currentlevel := BuildingSystem.get_current_level(building_id)
	var building_name := BuildingSystem.get_building_name(building_id)
	var effect_desc := BuildingSystem.get_upgrade_desc(building_id)
	var costs := BuildingSystem.get_upgrade_costs(building_id)
	var upgrade_costs := BuildingSystem.get_upgrade_costs(building_id)
	
	# 3) 满级状态：隐藏按钮，只显示 MAX
	if BuildingSystem.is_max_level(building_id):
		upgrade_button.hide()
		info_label.text = "MAX"
		return
	
	# 4) 非满级：按钮始终可点击（需求）
	upgrade_button.show()
	upgrade_button.disabled = false

	# 5) 组装消耗文本
	var cost_parts: Array[String] = []
	for fragment_type in ["A", "B", "C"]:
		var amount: float = upgrade_costs.get(fragment_type, 0.0)
		if amount > 0:
			cost_parts.append("Fragment %s * %d" % [fragment_type, int(amount)])
			
	

	# 👉 计算总 cost（你现在只用 A）
	var total_cost := int(costs.get("A", 0.0))
	info_label.text = "[LV. %d] %s\n\n%s\nUpgrade Cost: %d" % [
		currentlevel,
		building_name,
		effect_desc,
		total_cost
	]
	

# ===============================
# 鼠标悬停/离开，显示/隐藏升级面板
# ===============================
func _on_building_hover_area_mouse_entered() -> void:
	_refresh_view()
	is_hovering_building = true
	upgrade_panel.show()
	upgrade_panel.position = Vector2(0, -180)

func _on_building_hover_area_mouse_exited() -> void:
	is_hovering_building = false
	hide_panel()

func _on_upgrade_building_panel_mouse_entered() -> void:
	is_hovering_panel = true
	#print("is hover upgrade building panel")

func _on_upgrade_building_panel_mouse_exited() -> void:
	is_hovering_panel = false
	hide_panel()

func hide_panel():
	if !is_hovering_building and ! is_hovering_panel:
		upgrade_panel.hide()
	
# ===============================
# 按下升级按钮
# ===============================	
func _on_upgrade_button_pressed() -> void:
	# 满级时按钮会被隐藏，这里做一次防御判断避免误调用
	if BuildingSystem.is_max_level(building_id):
		return
		
	upgrade_requested.emit(building_id)
	if BuildingSystem.try_upgrade(building_id):
		var new_level := BuildingSystem.get_current_level(building_id)
		upgraded.emit(building_id, new_level)
		
	# 无论是否升级成功，都刷新一下：
	# - 成功：会更新等级/动画
	# - 失败：由 main_total_fragment_panel.gd 接收失败信号并做碎片红色反馈	
	_refresh_view()


func _on_building_upgraded(changed_building_id: String, _new_level: int) -> void:
	if changed_building_id == building_id:
		_refresh_view()
