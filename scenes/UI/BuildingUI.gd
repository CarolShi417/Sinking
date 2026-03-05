extends Control

# 显示building panel
@export var building_upgrade_panel: PanelContainer
var hover_area
@onready var building = get_tree().current_scene.get_node(
	"MainTexture/Building/ArchComponent"
)

#升级建筑，改变building sprite
@onready var building_sprite = get_tree().current_scene.get_node(
	"MainTexture/Building/ArchComponent/AnimatedSprite2D"
)


func _ready():

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

#func _process(_delta):
#
	#if building_upgrade_panel.visible:
#
		#var world_pos = building.global_position
		#var camera = get_viewport().get_camera_2d()
#
		#var screen_pos = camera.unproject_position(world_pos)
#
		#building_upgrade_panel.position = screen_pos + Vector2(0,-80)
