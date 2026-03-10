extends CharacterBody2D

@export var speed : float = 100.0 #公开变量
@export var worker_type : String

# 移动边界
var LEFT_LIMIT : float = 10.0
var RIGHT_LIMIT : float = 930.0

#移动状态和方向
var running : bool = false #判断是否运行worker
var moving : bool = false #判断worker是否移动
var direction := 1 #1=右

#func _ready() -> void:
	#mouse_entered.connect(_on_mouse_entered)

#如何移动
func _physics_process(_delta): #Godot 每一帧“物理更新”都会自动调用这个函数
	if GameState.current_behavior_state == DataTypes.BehaviorState.walk:
		velocity.x = speed * direction
	else:
		velocity.x = 0
	#真正执行移动 + 自动处理碰撞
	move_and_slide() 
	
	# ===== 边界检测 =====
	if position.x <= LEFT_LIMIT:
		position.x = LEFT_LIMIT
		direction = 1   # 强制向右		
		#print("现在往右走，direction为", direction)

	if position.x >= RIGHT_LIMIT:
		position.x = RIGHT_LIMIT
		direction = -1  # 强制向左
		#print("现在往左走，direction为", direction)
		


		
