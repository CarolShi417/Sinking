extends Area2D

signal hover_entered()
signal hover_exited()


func _on_mouse_entered() -> void:
	hover_entered.emit()
	print("鼠标选中了建筑1")


func _on_mouse_exited() -> void:
	hover_exited.emit()
