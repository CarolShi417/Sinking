extends Control

@onready var sanLabel = $SanNumberPanel/MarginContainer/SanNumberLabel
@onready var sanNumPanel: PanelContainer = $SanNumberPanel
func _ready():
	SanSystem.san_changed.connect(_on_san_changed)

	# 初始化显示一次（很重要）
	_on_san_changed(SanSystem.san)
	#初始化隐藏NumberPanel
	sanNumPanel.hide()

func _on_san_changed(san):
	sanLabel.text = str(round(san))


func _on_hover_area_mouse_entered() -> void:
	sanNumPanel.show()


func _on_hover_area_mouse_exited() -> void:
	sanNumPanel.hide()
