extends Control
@onready var button_mapA = $MapAButton
@onready var button_assignWorkerToMapA = $AssignWorkerButton
@onready var test_button_skip = $Test_SkipButton

@onready var fragment_progress_on_Working = $"../FragmentProgressContainer"

signal assign_worker_to_mapA

var button_assignWorkerToMapA_visible := false #button可见性 一开始不可见
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_assignWorkerToMapA.hide()	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
	
func _on_MapAButton_pressed() -> void:
	print("按下")
	button_assignWorkerToMapA_visible = !button_assignWorkerToMapA_visible
	if button_assignWorkerToMapA_visible:
		button_assignWorkerToMapA.show()
	else:
		button_assignWorkerToMapA.hide()

func _on_assign_worker_button_pressed() -> void:
		print("worker start to collect in map A")
		emit_signal("assign_worker_to_mapA")
		
		button_assignWorkerToMapA.hide()
