extends Node

var san : float = 80.0


var san_decrease : float = 0.2# 每次减少多少

# ========================
#？？？？这个float需要由timing统一管理吗？？
# ========================
var decay_interval : float = 5.0 # # 每多少秒减少，

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_san_decrease()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func start_san_decrease() -> void:

	while true:

		await get_tree().create_timer(decay_interval).timeout

		# 只有监视器激活才减少 SAN
		# ========================
		# ？？？？？这里需要和fragmentsystem分开判定吗
		# ========================
		if FragmentSystem.hover_active:
			san -= san_decrease
			print("SAN:", san)
