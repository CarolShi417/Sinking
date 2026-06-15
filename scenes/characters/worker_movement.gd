extends CharacterBody2D



@export var speed : float = 100.0 #公开变量
#@export var worker_type : String

# 移动边界
var LEFT_LIMIT : float = 10.0
var RIGHT_LIMIT : float = 930.0

#移动状态和方向
var running : bool = false #判断是否运行worker
var moving : bool = false #判断worker是否移动
var direction := 1 #1=右
var fixed_y : float #y轴位置锁定

# 随机石子事件
signal stone_walk_started   # 开始走向石子
signal stone_walk_finished  # 到达石子
var is_gathering_random_stone := false  # 移动中时暂停正常的 walk 逻辑
var x := 0.0

func _ready() -> void:	
	# 随机石子事件，悬停时worker立刻走到石子旁边
	RandomStoneController.go_to_stone_position.connect(_go_to_stone_position)
	
	collision_layer = 0
	collision_mask = 0
	lock_to_current_y()

func lock_to_current_y() -> void:
	fixed_y = global_position.y
	velocity.y = 0
	global_position.y = fixed_y

# 发给worker_controller的
func reset_movement(start_dir: int) -> void:
	direction = start_dir
	velocity = Vector2.ZERO
	lock_to_current_y()
	
#如何移动
func _physics_process(_delta): #Godot 每一帧“物理更新”都会自动调用这个函数
	# 死亡下 速度为0
	if GameState.current_state == DataTypes.GameState.Dead:
		velocity.x = 0
	#如果随机石子事件发生
	elif is_gathering_random_stone:
		velocity.x = speed * direction
		# 到达目标附近时停止
		if abs(position.x - x) < 5.0:
			position.x = x
			velocity.x = 0
			is_gathering_random_stone = false
			stone_walk_finished.emit()  # 到达
	#如果走路状态
	elif GameState.current_behavior_state == DataTypes.BehaviorState.walk:
		velocity.x = speed * direction
	else:
		velocity.x = 0
	velocity.y = 0# 永远锁定 Y
	
	#真正执行移动 + 自动处理碰撞
	move_and_slide() 
	
	global_position.y = fixed_y#再次锁定
	
	
	# ===== 边界检测 =====
	if position.x <= LEFT_LIMIT:
		position.x = LEFT_LIMIT
		direction = 1   # 强制向右		
		#print("现在往右走，direction为", direction)

	if position.x >= RIGHT_LIMIT:
		position.x = RIGHT_LIMIT
		direction = -1  # 强制向左
		#print("现在往左走，direction为", direction)
		
func _go_to_stone_position(target_x: float) -> void:
	if not get_parent().visible: return  #禁止worker_rest/work隐藏后继续执行代码
	x = target_x
	is_gathering_random_stone = true
	# 根据目标位置决定方向
	if target_x > position.x:
		direction = 1   # 向右
	else:
		direction = -1  # 向左
		
	stone_walk_started.emit()  # 开始走


		
