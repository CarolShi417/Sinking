extends HBoxContainer
"""
作用：
- 显示当前碎片数量（每帧刷新）
- 升级失败、碎片不足时闪红反馈
"""

# 这个容器负责哪种碎片："A" / "B" / "C"
@export var fragment_type: String = "A"

# 拖入对应的图标节点和数字 Label
@export var fragment_button: Button
@export var number_label: Label
@export var icon: Texture2D

const ERROR_RED := Color(1.0, 0.2, 0.2, 1.0)
const NORMAL_WHITE := Color(1.0, 1.0, 1.0, 1.0)


func _ready() -> void:
	fragment_button.icon = icon
	fragment_button.show()
	BuildingSystem.upgrade_failed_insufficient_fragments.connect(_on_upgrade_failed)
	_update_number()
	

func _process(_delta: float) -> void:
	_update_number()


# ===============================
# 根据 fragment_type 更新数字显示
# ===============================
func _update_number() -> void:
	var value: float
	match fragment_type:
		"A": value = FragmentSystem.total_fragment_a
		"B": value = FragmentSystem.total_fragment_b
		"C": value = FragmentSystem.total_fragment_c
	number_label.text = str(round(value))


# ===============================
# 升级失败时，如果缺的是自己这种碎片，就闪红
# ===============================
func _on_upgrade_failed(missing_fragment_types: Array[String]) -> void:
	if fragment_type in missing_fragment_types:
		_flash()


func _flash() -> void:
	fragment_button.modulate = ERROR_RED
	number_label.modulate = ERROR_RED
	await get_tree().create_timer(0.5).timeout
	fragment_button.modulate = NORMAL_WHITE
	number_label.modulate = NORMAL_WHITE
