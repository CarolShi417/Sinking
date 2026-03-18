extends Control

@onready var sanLabel = $SanNumberPanel/MarginContainer/SanNumberLabel
func _ready():
	SanSystem.san_changed.connect(_on_san_changed)

	# 初始化显示一次（很重要）
	_on_san_changed(SanSystem.san)


func _on_san_changed(san):
	sanLabel.text = str(san)
