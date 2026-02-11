extends CharacterBody2D

@export var speed := 100.0 #公开变量

# 移动边界
const LEFT_LIMIT := 10.0
const RIGHT_LIMIT := 950.0

#移动状态和方向
var running := false #判断是否运行worker
var moving := false #判断worker是否移动
var direction := 1 #1=右
var isWorking := false #判断是否派出了worker


#如何移动
func _physics_process(delta): #Godot 每一帧“物理更新”都会自动调用这个函数
	if moving:
		velocity.x = speed * direction
	else:
		velocity.x = 0
	#真正执行移动 + 自动处理碰撞
	move_and_slide() 
	
	# ===== 边界检测 =====
	if position.x <= LEFT_LIMIT:
		position.x = LEFT_LIMIT
		direction = 1   # 强制向右

	if position.x >= RIGHT_LIMIT:
		position.x = RIGHT_LIMIT
		direction = -1  # 强制向左

#确定是否移动，持续时间
func start_move():
	if isWorking:
		return   # 防止重复启动
	
	isWorking = true
	
	while isWorking: #循环		
		moving = true #开始移动
		await get_tree().create_timer(5.0).timeout# 持续5秒
		
		moving = false #停止移动
		await get_tree().create_timer(10.0).timeout# 停止10秒
		
		direction *= -1# 换方向
		
func stop_move():
	isWorking = false
	velocity = Vector2.ZERO
	print("下班")
