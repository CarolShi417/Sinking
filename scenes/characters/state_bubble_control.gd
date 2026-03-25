extends Node

@onready var hover_area: Area2D = $"../HoverArea"
@onready var state_bubble: Node2D = $"../StateBubble"
@onready var worker: CharacterBody2D = $".."

var hover_active : bool = false;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	#接收状态改变信号
	GameState.state_changed.connect(_on_state_changed)	
	#接收san改变信号
	SanSystem.san_changed.connect(_on_san_changed)
	#接收鼠标悬停在小人上的signal
	hover_area.hover_changed_all_state.connect(_on_hover_changed)
	
	state_bubble.hide()	

# 只有hover才判定bubble
func _on_hover_changed(active: bool):
	hover_active = active
	
	#只有hover时才判定bubble长什么样子
	if !hover_active:
		state_bubble.hide()
		return
		
	refresh_bubble();
	
# ===============================
# SAN变化（只有hover才判定bubble）
# ===============================
func _on_san_changed(_value):
	if !hover_active:
		return
	
	refresh_bubble()	
	
# ===============================
# 状态变化（只有hover才判定bubble）
# ===============================	
func _on_state_changed(_state):
	if !hover_active:
		return
	
	refresh_bubble()
	
# ===============================
# 刷新气泡（核心代码）
# ===============================	
func refresh_bubble():
	if GameState.current_state == DataTypes.GameState.Resting:
		if SanSystem.san >= 50:
			state_bubble.show_rest_high()
		else:
			state_bubble.show_rest_low()

	elif GameState.current_state == DataTypes.GameState.Working:
		if SanSystem.san >= 50:
			state_bubble.show_work_high()
		else:
			state_bubble.show_work_low()

	elif GameState.current_state == DataTypes.GameState.Dead:
		return

	state_bubble.show()
	
