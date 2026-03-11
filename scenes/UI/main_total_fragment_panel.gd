extends PanelContainer

@export var total_fragment_a_display: Label
@export var total_fragment_b_display: Label
@export var total_fragment_c_display: Label

func _ready() -> void:
	total_fragment_a_display.text = str(int(FragmentSystem.total_fragment_a))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	total_fragment_a_display.text = str(int(FragmentSystem.total_fragment_a))
