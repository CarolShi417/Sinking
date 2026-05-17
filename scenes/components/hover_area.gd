extends Area2D

signal hover_changed(active)#发射鼠标是否Working State悬停在worker上的信号

signal hover_changed_all_state(active)
#
var enabled := false # 默认关闭

func _ready():
	GameState.state_changed.connect(_on_state_changed)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	#print(get_path())
		
#鼠标进入感应区
func _on_mouse_entered():
	hover_changed_all_state.emit(true)
	if !enabled:
		return
	hover_changed.emit(true)
	#print("Mouse Entered")

#
func _on_mouse_exited():
	hover_changed_all_state.emit(false)
	if !enabled:
		return
	hover_changed.emit(false)
	#print("Mouse Exited")
	
func _on_state_changed(state):
	if state == DataTypes.GameState.Resting:
		enabled = false
	if state == DataTypes.GameState.Working:
		enabled = true
