extends Control

@onready var label_total_fragment = $"../../../../Control/TotalFragment"


var total_A := 0# 本地缓存的 A 碎片数量（用于 UI 显示）
var total_B := 0# 本地缓存的 B 碎片数量（用于 UI 显示）

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# 监听 GameState 发出的碎片变化信号 只要 A 或 B 改变，就会调用
	GameState.fragment_changed.connect(_on_fragment_updated)


	
func _on_fragment_updated(type, value):
	if type == "A":
		total_A = value
	elif type == "B":
		total_B = value
		
	label_total_fragment.text = "A = " + str(total_A) + "   B = " + str(total_B)
