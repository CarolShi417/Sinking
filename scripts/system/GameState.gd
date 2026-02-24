extends Node

# 存储worker状态
enum WorkerState{
	Working, #在外面工作中
	Resting  #在基地休息中
	#之后可能会增加其他状态
}
signal worker_state_changed(state) # 当 worker 状态发生变化时，对外发出的信号
var worker_state := WorkerState.Resting # 初始为 Resting（空闲）
# 信号 碎片数量变化
signal fragment_changed(type, value)

#信号 建筑等级变化

#信号 worker状态变化

# 存储碎片数量
var total_fragment_A := 0
var total_fragment_B := 0
var total_fragment_C := 0

# 存储建筑等级

# 存储升级建筑所需要碎片数量

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:

# 修改 worker 状态的统一入口函数
func set_worker_state(state):	
	if worker_state == state:# 如果新状态和当前状态一样，就什么都不做
		return	
	worker_state = state# 更新当前状态	
	worker_state_changed.emit(worker_state)# 通知所有监听者：worker 状态变了
		
# 获得碎片
func gain_fragment(a: int, b: int):
	total_fragment_A += a
	total_fragment_B += b
	fragment_changed.emit("A", total_fragment_A)#发射信号 碎片总数量变化
	fragment_changed.emit("B", total_fragment_B)
	print("当前碎片A数量为", total_fragment_A, "碎片B数量为",  total_fragment_B)
	
# 消耗碎片	
func consume_fragment_A(amount: int) -> bool:
	#判断当前碎片数量是否充足
	if total_fragment_A < amount:
		return false
	
	total_fragment_A -= amount
	fragment_changed.emit("A", total_fragment_A)#发射信号 碎片总数量变化
	return true
	
