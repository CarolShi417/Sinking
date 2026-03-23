extends Control

signal game_start

@onready var start_menu: Control = $StartMenu
@onready var opening_comic: Control = $OpeningComic
@onready var dialogue_control: Control = $DialogueControl


func _ready():
	# 初始状态	
	start_menu.show()
	opening_comic.hide()
	dialogue_control.hide()

	# 监听信号
	start_menu.start_pressed.connect(_on_start_pressed)
	opening_comic.comic_finished.connect(_on_comic_finished)
	dialogue_control.dialogue_finished.connect(_on_dialogue_finished)

# ===============================
# 点击 StartMenu Start 
# ===============================
func _on_start_pressed():
	start_menu.hide()
	opening_comic.show()
	opening_comic.start()
	


# ===============================
# 漫画播放结束
# ===============================
func _on_comic_finished():
	opening_comic.hide()
	dialogue_control.show()
	# 👉 此时游戏自然露出来（GameScene一直在）
	
func _on_dialogue_finished():
	dialogue_control.hide()
	game_start.emit()
