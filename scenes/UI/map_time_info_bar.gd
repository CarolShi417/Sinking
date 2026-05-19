extends Control

@onready var current_fragment: Label = $CurrentFragment

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FragmentSystem.fragment_gained_this_exploration_updated.connect(_on_fragment_updated)

func _on_fragment_updated(amount: float) -> void:
	current_fragment.text = "%.1f" % amount
