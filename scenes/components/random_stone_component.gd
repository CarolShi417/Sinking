extends Node2D

# ===============================
# 参数
# ===============================
@export var speed := 50.0         # 下落速度
@export var gravity := 800.0       # 重力
@export var rotation_speed := 20.0  # 旋转速度
@export var life_time := 5.0       # 落地后存在时间
@export var ground_y := 210.0      # 地面位置

var velocity := Vector2.ZERO
var is_grounded := false

# ===============================
# 初始化（设置45°方向）
# ===============================
func _ready():
	# 45°斜向下（右下）
	velocity = Vector2(1, 1).normalized() * speed


# ===============================
# 每帧更新
# ===============================
func _process(delta):

	if not is_grounded:
		# 重力
		velocity.y += gravity * delta

		# 移动
		position += velocity * delta

		# 旋转
		rotation += rotation_speed * delta

		# 简单地面检测（假设地面在 y = 600）
		if position.y >= ground_y:
			position.y = ground_y
			_on_hit_ground()


# ===============================
# 落地逻辑
# ===============================
func _on_hit_ground():
	is_grounded = true
	velocity = Vector2.ZERO

	# 5秒后消失
	await get_tree().create_timer(life_time).timeout
	queue_free()
