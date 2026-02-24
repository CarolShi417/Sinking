extends Node2D

@onready var worker_resting = $"../Worker"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	worker_resting.show()                       # 显示 worker
	worker_resting.position = Vector2(480,300)  # 设置初始坐标
	print(worker_resting.position) 
	worker_resting.start_move()

func _on_worker_state_changed(state):
	print("worker state changed:", state)
	
func _process(_delta) -> void:
	if GameState.worker_state == GameState.WorkerState.Resting:
		worker_resting.show()
		worker_resting.start_move()
	else:
		worker_resting.hide()
