extends Area2D

signal hover_changed(active)#发射鼠标是否悬停在worker上的信号
#
#
func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

#鼠标进入感应区
func _on_mouse_entered():
	hover_changed.emit(true)
	print("Mouse Entered HoverArea")

#鼠标离开感应区
func _on_mouse_exited():
	hover_changed.emit(false)
	print("Mouse Exited")
