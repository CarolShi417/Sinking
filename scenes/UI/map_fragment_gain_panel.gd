extends Node2D

@export var fragment_gain_timeline_display: HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FragmentSystem.fragment_gain_per_step.connect(_on_fragment_step)
	
	GameState.state_changed.connect(_on_state_changed)


func _on_fragment_step(level: String):

	var rect := ColorRect.new()

	# 确认timeline颜色
	match level:
		"high":
			rect.color = Color.RED
		"low":
			rect.color = Color.WHITE
		_:
			rect.color = Color.GRAY
			
	rect.custom_minimum_size = Vector2(10, 20)

	fragment_gain_timeline_display.add_child(rect)

# 重置
func _on_state_changed(state):

	if state == DataTypes.GameState.Resting:
		for child in fragment_gain_timeline_display.get_children():
			child.queue_free()
