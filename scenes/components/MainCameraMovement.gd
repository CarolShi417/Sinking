extends Camera2D

@export var edge_margin_ratio := 0.1    # 触发边缘占 viewport 的比例，10% = 0.1
@export var scroll_speed := 300.0       # Camera 移动速度（像素/秒）

func _process(delta):
	var vp := get_viewport()                   # 获取 Camera 所在的 SubViewport
	var mouse_pos := vp.get_mouse_position()   # 鼠标相对于 SubViewport 的坐标
	var visible_rect := vp.get_visible_rect()  # SubViewport 可见矩形区域

	# 如果鼠标不在 SubViewport 内，则不滚动
	if not visible_rect.has_point(mouse_pos):
		return

	# -------------------
	# 根据比例计算边缘触发区域
	# -------------------
	var edge_x = visible_rect.size.x * edge_margin_ratio
	#var edge_y = visible_rect.size.y * edge_margin_ratio

	var dir_x := 0
	var dir_y := 0

	# 左右滚动判断
	if mouse_pos.x < edge_x:
		dir_x -= 1
	elif mouse_pos.x > visible_rect.size.x - edge_x:
		dir_x += 1

	# -------------------
	# 更新 Camera 位置
	# -------------------
	if dir_x != 0 or dir_y != 0:
		position += Vector2(dir_x, dir_y) * scroll_speed * delta
