extends Control
# 此代码用于管理building升级的UI

# ===============================
# 建筑
# ===============================

@onready var building = get_parent()
# @export var building_sprite: AnimatedSprite2D
@onready var hover_area = get_node("../BuildingHoverArea")
@onready var upgrade_building_panel = get_node("UpgradeBuildingPanel")
#@onready var lv0_to_lv1_button = get_tree().get_first_node_in_group("UpgradeBuildingButtonGroup")


func _ready():
	#upgrade building UI 显示与隐藏
	upgrade_building_panel.hide()
	
	#获取upgradebutton的signal
	#lv0_to_lv1_button.UpgradeButton_0to1_Pressed.connect(upgrade_lv0_to_lv1)

func _on_building_hover_area_mouse_exited() -> void:
	upgrade_building_panel.hide()


func _on_building_hover_area_mouse_entered() -> void:
	upgrade_building_panel.show()
	#upgrade_building_panel.position = building.global_position + Vector2(0, -100) # ui在control坐标上，可能与node不同，这样写比较保险
	upgrade_building_panel.position = Vector2(0, -200)
