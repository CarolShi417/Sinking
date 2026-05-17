extends Node2D

@export var building_id := ""
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hover_area: Area2D = $BuildingHoverArea
@onready var upgrade_panel: Control = $UpgradeBuildingControl
@onready var info_label: Label = $UpgradeBuildingControl/UpgradeBuildingPanel/MarginContainer/VBoxContainer/GrayPanel/MarginContainer/VBoxContainer/MainContentLabel
@onready var upgrade_button: Button = $UpgradeBuildingControl/UpgradeBuildingPanel/MarginContainer/VBoxContainer/Button

# 鼠标是否在建筑物上
var is_hovering_building := false
#鼠标是否在升级panel上
var is_hovering_panel := false 

func _ready() -> void:
	_resolve_building_id()
	upgrade_panel.hide()
	#hover_area.mouse_entered.connect(_on_building_hover_area_mouse_entered)
	hover_area.mouse_exited.connect(_on_building_hover_area_mouse_exited)
	#upgrade_button.pressed.connect(_on_upgrade_button_pressed)
	BuildingSystem.building_upgraded.connect(_on_building_upgraded)
	_refresh_animation()

# ===============================
# 如果 Inspector 没有填 building_id，自动从节点名转换为 snake_case 作为 ID
# ===============================
func _resolve_building_id() -> void:
	if !building_id.is_empty():
		return

	building_id = String(name).to_snake_case()
	
# ===============================
# 收到BuildingSystem升级信号，如果是自己，就刷新动画
# ===============================	
func _on_building_upgraded(changed_building_id: String, _new_level: int) -> void:
	if changed_building_id == building_id:
		_refresh_animation()
		
# ===============================
# 更新动画
# ===============================
func _refresh_animation() -> void:
	# 获取当前等级
	var level := BuildingSystem.get_current_level(building_id)
	# 1) 播放当前等级对应动画
	sprite.play(BuildingSystem.get_animation_name(building_id, level))
		

# ===============================
# 鼠标悬停/离开，显示/隐藏升级面板
# ===============================
func _on_building_hover_area_mouse_entered() -> void:
	_refresh_animation()
	is_hovering_building = true
	#print("builidng hovering")
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
	
