extends Node

# ===============================
# 建筑
# ===============================
@export var building_upgrade_panel: PanelContainer
var hover_area
# 显示building panel

@onready var building = get_tree().current_scene.get_node(
	"MainTexture/Building/ArchComponent"
)
#升级建筑，改变building sprite
@onready var building_sprite = get_tree().current_scene.get_node(
	"MainTexture/Building/ArchComponent/AnimatedSprite2D"
)

func _ready():

	# upgrade building UI 显示与隐藏
	building_upgrade_panel.hide()

	hover_area = get_tree().current_scene.get_node(
        "MainTexture/Building/ArchComponent/BuildingHoverArea"
	)
	hover_area.hover_entered.connect(_on_hover_entered)
	hover_area.hover_exited.connect(_on_hover_exited)

func _on_hover_entered():	
	print("UI received hover_entered")
	building_upgrade_panel.show()
	building_upgrade_panel.position = building.position + Vector2(0, -100)


func _on_hover_exited():
	building_upgrade_panel.hide()
