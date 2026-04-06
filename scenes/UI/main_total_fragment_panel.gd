extends PanelContainer

@export var total_fragment_a_display: Label
@export var total_fragment_b_display: Label
@export var total_fragment_c_display: Label

# 申明icon
@onready var icon_a: TextureRect = $MarginContainer/HBoxContainer/HBoxContainerA/FragmentAIcon
@onready var icon_b: TextureRect = $MarginContainer/HBoxContainer/HBoxContainerB/FragmentBIcon
@onready var icon_c: TextureRect = $MarginContainer/HBoxContainer/HBoxContainerC/FragmentCIcon

# 申明不同状态icon颜色
const ERROR_RED := Color(1.0, 0.2, 0.2, 1.0)
const NORMAL_WHITE := Color(1.0, 1.0, 1.0, 1.0)

func _ready() -> void:
	#total_fragment_a_display.text = str(round(FragmentSystem.total_fragment_a))
	# 更新碎片Label数量
	_update_fragment_numbers()
	# 初始化时刷新所有不足的碎片显示（A/B/C）
	BuildingSystem.upgrade_failed_insufficient_fragments.connect(_on_upgrade_failed_insufficient_fragments)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	#total_fragment_a_display.text = str(round(FragmentSystem.total_fragment_a))
	# 每一帧刷新所有碎片数量显示
	_update_fragment_numbers()

# ===============================
# 更新显示的碎片Label数量
# ===============================
func _update_fragment_numbers() -> void:
	total_fragment_a_display.text = str(round(FragmentSystem.total_fragment_a))
	total_fragment_b_display.text = str(round(FragmentSystem.total_fragment_b))
	total_fragment_c_display.text = str(round(FragmentSystem.total_fragment_c))

# ===============================
# 升级失败时，不足碎片会有反馈
# ===============================
func _on_upgrade_failed_insufficient_fragments(missing_fragment_types: Array[String]) -> void:
	for fragment_type in missing_fragment_types:
		match fragment_type:
			"A":
				_flash_fragment_ui(icon_a, total_fragment_a_display)
			"B":
				_flash_fragment_ui(icon_b, total_fragment_b_display)
			"C":
				_flash_fragment_ui(icon_c, total_fragment_c_display)
# ===============================
# 具体如何反馈：闪红效果函数
# ===============================
func _flash_fragment_ui(icon: TextureRect, number_label: Label) -> void:
	icon.modulate = ERROR_RED
	number_label.modulate = ERROR_RED
	await get_tree().create_timer(0.5).timeout
	icon.modulate = NORMAL_WHITE
	number_label.modulate = NORMAL_WHITE
