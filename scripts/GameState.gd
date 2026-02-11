extends Node
#两个场景共享数据
#计时
#信号

# 碎片数量发生变化
signal fragment_changed(type, value)

var total_fragment_A := 0
var total_fragment_B := 0
var total_fragment_C := 0

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:

# 碎片增加
func gain_fragment(a: int, b: int):
	total_fragment_A += a
	total_fragment_B += b
	fragment_changed.emit("A", total_fragment_A)
	fragment_changed.emit("B", total_fragment_B)
	print("当前碎片A数量为", total_fragment_A, "碎片B数量为",  total_fragment_B)
	
	
func consume_fragment_A(amount: int) -> bool:
	#判断当前碎片数量是否充足
	if total_fragment_A < amount:
		return false
	
	total_fragment_A -= amount
	fragment_changed.emit("A", total_fragment_A)
	return true
	
