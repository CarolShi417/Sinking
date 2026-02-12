extends Node2D

@onready var worker = $"../Worker"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	worker.show()                       # 显示 worker
	worker.position = Vector2(480,300)  # 设置初始坐标
	print(worker.position) 
	worker.start_move()
