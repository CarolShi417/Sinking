extends Control

signal comic_finished #所有漫画播放完毕，发出信号给总UI Control

@export var comic_images: Array[Texture2D] #存放漫画
@onready var subtitle_label = $CenterContainer/PanelContainer/Label  # 单个 Label 节点
@onready var texture_rect = $CenterContainer/TextureRect   #申明漫画载体节点

var index := 0 # 当前播放到第几张漫画
var comic_done: bool = false   # 标记漫画是否已经播放完毕

func start():
	index = 0    # 重置索引，从第一张开始
	comic_done = false #重置
	subtitle_label.show()
	show_comic() # 显示第一张漫画

# ===============================
# 显示当前漫画 + 对应字幕
# ===============================
func show_comic():
	texture_rect.texture = comic_images[index]
	
# 点击进入下一张
func _input(event):
	if comic_done:              # 已经结束就不再处理任何点击
		return
	if event is InputEventMouseButton and event.pressed:
		next()

# ===============================
# 切换到下一张漫画
# ===============================
func next():
	index += 1
	#如果已经是最后一张，停止播放漫画
	if index >= comic_images.size():
		finish()
	else:#如果不是，播放下一张漫画
		show_comic()

# ===============================
# 结束播放
# ===============================
func finish():
	comic_done = true # 标记为已结束
	subtitle_label.hide()	
	comic_finished.emit() #发出信号，漫画播放完毕
	set_process_input(false) # 彻底停止接收输入（双重保险）
