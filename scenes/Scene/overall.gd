extends Node2D

@onready var game: Node2D = $Game
@onready var over_all_screen_UI: Control = $OverallScreenUI
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_game()
	
	over_all_screen_UI.game_start.connect(resume_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
# ===============================
# 暂停游戏
# ===============================
func pause_game() -> void:
	# 禁用Game节点的process
	game.process_mode = Node.PROCESS_MODE_DISABLED
	
	
# ===============================
# 恢复游戏
# ===============================
func resume_game() -> void:
	# 恢复Game节点的process
	game.process_mode = Node.PROCESS_MODE_INHERIT
