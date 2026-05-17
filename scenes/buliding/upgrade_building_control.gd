extends Control

# 专门负责 UpgradeBuilding 的所有 UI

# 与 building_component 保持一致
var building_id := ""
# 升级面板根容器
@export var upgrade_panel: PanelContainer
# 显示当前等级
@export var level_label: Label 
# 显示建筑名称
@export var building_name_label: Label
# 显示升级效果描述和费用的 Label
@export var main_content_label: Label
# 升级按钮，满级时隐藏
@export var upgrade_button: Button

func _ready() -> void:
	# 直接读取父节点 building_component 的 building_id
	building_id = get_parent().building_id	
		
	upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	BuildingSystem.building_upgraded.connect(_on_building_upgraded)
	_refresh_ui()
	
# ===============================
# 按下升级按钮：尝试升级，无论成功失败都刷新 UI
# 升级失败时碎片不足的反馈由 BuildingSystem 发信号给其他系统处理
# ===============================
func _on_upgrade_button_pressed() -> void:
	if BuildingSystem.is_max_level(building_id):
		return
	BuildingSystem.try_upgrade(building_id)
	_refresh_ui()
	
# ===============================
# 收到 BuildingSystem 升级信号时，如果是自己的建筑则刷新 UI
# ===============================
func _on_building_upgraded(changed_building_id: String, _new_level: int) -> void:
	if changed_building_id == building_id:
		_refresh_ui()
		
# ===============================		
# 根据当前等级刷新所有 UI 内容（等级、名称、描述、费用、按钮状态）
# ===============================
func _refresh_ui() -> void:
	# 获取当前等级
	var level := BuildingSystem.get_current_level(building_id)
	
	var building_name := BuildingSystem.get_building_name(building_id)
 	
	level_label.text = "LV. %d" % level
	building_name_label.text = building_name
 
	# 满级时隐藏按钮，只显示 MAX
	if BuildingSystem.is_max_level(building_id):
		upgrade_button.hide()
		main_content_label.text = "MAX"
		return
 
	# 非满级时显示升级按钮
	upgrade_button.show()
	upgrade_button.disabled = false
 
	var effect_desc := BuildingSystem.get_upgrade_desc(building_id)
	# var upgrade_costs := BuildingSystem.get_upgrade_costs(building_id)
	# var total_cost := int(upgrade_costs.get("A", 0.0)) # 目前只用 A 类碎片
 
	# main_content_label.text = "%s\nUpgrade Cost: %d" % [effect_desc]
	main_content_label.text = effect_desc
 
