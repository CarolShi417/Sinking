extends Node

func _ready():
	# 方法1：等待两帧，确保窗口完全初始化（更可靠）
	await get_tree().process_frame
	await get_tree().process_frame
	
	# 获取主窗口ID
	var window_id = 0
	
	# 获取窗口大小和屏幕信息
	var window_size = DisplayServer.window_get_size(window_id)
	var screen_rect = DisplayServer.screen_get_usable_rect()  # 排除任务栏的可用区域
	
	# 计算底部居中的位置
	var new_x = screen_rect.position.x + (screen_rect.size.x - window_size.x) / 2
	var new_y = screen_rect.position.y + screen_rect.size.y - window_size.y
	
	# 移动窗口
	DisplayServer.window_set_position(Vector2i(new_x, new_y), window_id)
	
