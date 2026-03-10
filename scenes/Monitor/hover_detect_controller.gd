extends Node2D

@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")
@onready var collision = worker_work.get_node("CollisionShape2D")

signal hover_changed(active)#发射鼠标是否悬停在worker上的信号
var hovering := false   # 记录上一帧是否在 worker 上

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
#func _process(_delta):
#
	#var mouse = worker_work.to_local(get_global_mouse_position())
	#var r = collision.shape.radius
#
	#hovering = mouse.length_squared() <= r * r
#
	#hover_changed.emit(hovering)
	#print(hovering)
