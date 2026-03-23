extends Control

#signal dialogue_started()
signal dialogue_finished()
var current_index: int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(10.0).timeout #测试用 后面要删除
	current_index += 1
	dialogue_finished.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
