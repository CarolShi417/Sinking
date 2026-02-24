extends Sprite2D

@export var area: Area2D

func _ready():
	if area == null:
		for child in get_children():
			if child is Area2D:
				area = child
				break
	area.mouse_entered.connect(toggle_highlight.bind(true))
	area.mouse_exited.connect(toggle_highlight.bind (false))

func toggle_highlight(on: bool):
	modulate = '#d2dae2' if on else '#808e9b'
	print("....")
