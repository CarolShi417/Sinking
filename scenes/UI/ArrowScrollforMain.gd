extends Area2D

@export var scroll_direction := 1      # 左箭头 = -1, 右箭头 = 1
@export var scroll_speed := 300.0
@onready var main_texture := get_node("../../../MainZoneClip/MainTexture")  # 地图 Node2D

var hovering := false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	hovering = true
	# print("arrow is hovered")

func _on_mouse_exited():
	hovering = false

func _process(delta):
	if hovering:
		main_texture.position.x += scroll_direction * scroll_speed * delta
		limit_scroll_range()

func limit_scroll_range():
	# 限制地图 X 轴位置，左边最多 +，右边最多 -
	main_texture.position.x = clamp(main_texture.position.x, -500, 350)
