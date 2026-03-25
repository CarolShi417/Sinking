extends PanelContainer

@export var map_A_panel: PanelContainer
@export var map_B_panel: PanelContainer
@export var map_C_panel: PanelContainer

@export var map_b_unlock_fragment_threshold: float = 10.0
@export var map_c_unlock_fragment_threshold: float = 30.0

signal map_hovered(map_id: String)
signal map_unhovered(map_id: String)
#signal map_unlocked(map_id: String)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#接收ABC panel的悬停信号
	map_A_panel.hover_changed.connect(_on_hover_changed)
	map_B_panel.hover_changed.connect(_on_hover_changed)
	map_C_panel.hover_changed.connect(_on_hover_changed)

	# 初始状态：A开，B/C锁
	map_A_panel.set_unlocked(true)
	map_B_panel.set_unlocked(false)
	map_C_panel.set_unlocked(false)
	
func _on_hover_changed(map_id: String, active: bool) -> void:
	if active:
		map_hovered.emit(map_id)
	else:
		map_unhovered.emit(map_id)
