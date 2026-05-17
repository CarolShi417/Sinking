extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")

# 飞行
var _tween: Tween               # 当前正在运行的 Tween，方便随时中断
var original_position = Vector2(1400, 225)# 初始位置
var current_position: Vector2    # 当前位置
var worker_current_position = Vector2(1400, 225)
const FLY_DURATION := 1.0       # 向上位移的持续时间（秒）
const FLY_DISTANCE_Y := -80.0   # 向上移动的像素（负值为向上）
const FLY_DISTANCE_X := -40.0   # 向左移动的像素（负值为向左/右）
# 防止循环动画重复启动
var loop_running := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:		
	# 监听 behavior 变化
	GameState.behavior_changed.connect(_on_behavior_changed)
	
	# 鼠标hover在worker上时，为碎片位置做准备
	await get_tree().process_frame  # 等一帧，确保所有节点都已就绪
	var hover_area = worker_work.get_node("HoverArea")	
	if hover_area:
		hover_area.hover_changed.connect(_on_hover_changed)
	
	current_position = original_position# + Vector2(-25, -25)
	position = current_position
	# 隐藏本体
	hide()
	
func _on_hover_changed(is_hovering : bool)-> void:
	if is_hovering:
		worker_current_position = worker_work.position
		#print("worker_current_position = ", worker_current_position)
	else:
		worker_current_position = Vector2(1400, 225)

# 当hover时，显示碎片到正确位置
func _on_behavior_changed(new_behavior) -> void:	
	
	if new_behavior == DataTypes.BehaviorState.gather:
		#print("当前behavior状态为：", new_behavior)
		if not loop_running:			
			# 出现在worker附近
			
			loop_running = true
			#play_frament_increase_loop()
			
	elif new_behavior == DataTypes.BehaviorState.send or \
		 new_behavior == DataTypes.BehaviorState.receive or \
		 new_behavior == DataTypes.BehaviorState.scare:
		# 这些状态是 gather 前后的过渡，不打断循环
		pass
		
	else:
		#print("当前behavior状态为：", new_behavior)
		# 不再是 gather，停止循环
		loop_running = false
		stop_loop()
		
	
	while loop_running:
		if _tween:        # 加这两行
			_tween.kill() # 确保上一轮 tween 完全停止再复位位置
		current_position = worker_current_position + Vector2(-15, -25)
		position = current_position
		modulate.a = 1.0
		show()
		
		# 播放爆炸动画
		animated_sprite_2d.play("explode")
		await animated_sprite_2d.animation_finished
		await get_tree().create_timer(0.1).timeout
		
		# 播放fly动画，同步位移
		current_position = worker_current_position + Vector2(-50, -50)
		#print("碎片循环次数：", circlecount)
		#print("碎片当前位置为：", position)
		#print("worker_current_position = ", worker_current_position)
		animated_sprite_2d.play("fly")
		start_fly_tween()
		await animated_sprite_2d.animation_finished
		#circlecount += 1
		
		
		
	stop_loop()
		
# 位移
func start_fly_tween() -> void:
	if _tween:
		_tween.kill() # 如果有上一次未结束的 Tween，先强制停止
	_tween = create_tween()
	_tween.set_parallel(true)      # 开启并行，让位移和淡出同时进行
	_tween.tween_property(self, "position:y", current_position.y + FLY_DISTANCE_Y, FLY_DURATION) # 向上移动
	_tween.tween_property(self, "position:x", current_position.x + FLY_DISTANCE_X, FLY_DURATION) # 向左/右移动
	_tween.tween_property(self, "modulate:a", 0.0, FLY_DURATION) # 同时逐渐透明

	
func stop_loop() -> void:
	#print("停止增长碎片动画")
	loop_running = false
	animated_sprite_2d.stop()
	
	if _tween:
		_tween.kill()            # 停止 Tween
	hide()                       # 隐藏节点
	current_position = worker_current_position
	modulate.a = 1.0             # 透明度复位
