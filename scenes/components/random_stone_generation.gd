extends Node2D

@export var stone_component: PackedScene   # 拖 StoneComponent.tscn
@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")

var hover_active := false

func _ready() -> void:
	# ===============================
	#接收鼠标悬停在小人上的signal
	# ===============================	
	await get_tree().process_frame	
	
	worker_work = get_tree().get_first_node_in_group("WorkerWorking")
	
	var hover_area = worker_work.get_node("HoverArea")	
	if hover_area:
		hover_area.hover_changed.connect(_on_hover_changed)
		
# 只有悬停才生成石子
func _on_hover_changed(active: bool):
	hover_active = active

	# ✅ 只有 Working + hover 才生成
	#if hover_active and GameState.current_state == DataTypes.GameState.Working:
		#generate_stone()		

# 生成石子 后面可以加很多个石子
func generate_stone():
	var stone = stone_component.instantiate()
	add_child(stone)

	# ✅ 随机 x（1000~1500）
	var random_x = randf_range(1000.0, 1500.0)

	# ✅ 固定 y = 0
	stone.global_position = Vector2(random_x, 0)
	print("random_x")
