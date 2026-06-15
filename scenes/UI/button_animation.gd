extends Button
class_name HoverButton
"""
注意：
- 此脚本为通用脚本,如果有定制逻辑，记得加在父节点上
"""

# ===============================
# 开关：方便调试时一键关闭动画
# ===============================
@export var hover_animate: bool = true
@export var disabled_hover: bool = false  # 和 Button 自带的 disabled 区分开

# 是否根据按钮宽度动态调整放大比例
@export var scale_w_width: bool = false
@export var width_full_rot: float = 100.0

var tween: Tween


func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	# 等一帧，确保布局完成后 size 是准确的，
	# 否则刚进场景时第一次悬停的缩放锚点可能不准
	await get_tree().process_frame
	pivot_offset = size / 2.0


func _on_mouse_entered() -> void:
	hover()


func _on_mouse_exited() -> void:
	unhover()


# ===============================
# 鼠标悬停：放大 + 轻微晃动
# ===============================
func hover() -> void:
	if disabled_hover or disabled:
		return
	if not hover_animate:
		return

	pivot_offset = size / 2.0

	var scale_ratio: float = 1.0
	var scale_target: float = 1.2

	if scale_w_width:
		scale_ratio = clampf(width_full_rot / size.x, 0.5, 1.0)
		scale_target = 1.0 + 0.2 * scale_ratio

	if tween and tween.is_running():
		tween.kill()

	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale:x", scale_target, 0.2)
	tween.parallel().tween_property(self, "scale:y", scale_target, 0.35)
	tween.parallel().tween_property(
		self, "rotation_degrees", 5.0 * scale_ratio * [-1.0, 1.0].pick_random(), 0.1
	)
	tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.1).set_delay(0.1)


# ===============================
# 鼠标离开：恢复原状
# ===============================
func unhover() -> void:
	if disabled_hover or disabled:
		return
	if not hover_animate:
		return

	if tween and tween.is_running():
		tween.kill()

	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale:x", 1.0, 0.25)
	tween.parallel().tween_property(self, "scale:y", 1.0, 0.35)
	tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.1)
