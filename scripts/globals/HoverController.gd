extends Node

signal hover_changed(active: bool)

func set_hover(active: bool) -> void:
	hover_changed.emit(active)
