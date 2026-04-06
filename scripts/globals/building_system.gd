extends Node

# 发送信号:建筑升级时通知其他系统（UI / 数值系统等）
signal building_upgraded(building_id: String, new_level: int)
# 发送信号:当前碎片数量不足
signal upgrade_failed_insufficient_fragments(missing_fragment_types: Array[String])
# ===============================
# 当前建筑等级（运行时数据）
# ===============================
var building_levels := {
	"sofa": 0,
	"fragment analyzer A": 0,
	"Physical Training House": 0,
	"Night Vision Monitor": 0,
	"Auto-focus Monitor": 0
}

# ===============================
# 建筑配置数据（静态表）
# 可在此添加
# ===============================
var building_data := {
	"sofa": {
		"display_name": "Sofa",
		"lv0_anim": "LV0",
		"lv1_anim": "LV1",
		"lv1_cost": {"A": 10.0, "B": 0.0, "C": 0.0},
		"lv1_desc": "The worker restores 0.5 more Sanity each minute"
	},
	"fragment analyzer A": {
		"display_name": "Fragment Analyzer A",
		"lv0_anim": "LV0",
		"lv1_anim": "LV1",
		"lv1_cost": {"A": 10.0, "B": 0.0, "C": 0.0},
		"lv1_desc": "Gain 10% more fragments in exploration"
	},
	"Physical Training House": {
		"display_name": "Physical Training House",
		"lv0_anim": "LV0",
		"lv1_anim": "LV1",
		"lv1_cost": {"A": 10.0, "B": 0.0, "C": 0.0},
		"lv1_desc": "?"
	},
	"Night Vision Monitor": {
		"display_name": "Night Vision Monitor",
		"lv0_anim": "LV0",
		"lv1_anim": "LV1",
		"lv1_cost": {"A": 200.0, "B": 0.0, "C": 0.0},
		"lv1_desc": "?"
	},
	"Auto-focus Monitor": {
		"display_name": "Auto-focus Monitor",
		"lv0_anim": "LV0",
		"lv1_anim": "LV1",
		"lv1_cost": {"A": 200.0, "B": 0.0, "C": 0.0},
		"lv1_desc": "?"
	}
}

# 获取显示名称（给UI用）
func get_building_name(building_id: String) -> String:
	return building_data.get(building_id, {}).get("display_name", building_id)

# 获取当前等级
func get_current_level(building_id: String) -> int:
	return building_levels.get(building_id, 0)

# 获取当前等级对应的动画名（用于切换外观）
func get_animation_name(building_id: String, level: int) -> String:
	var data: Dictionary = building_data.get(building_id, {})
	return data.get("lv%d_anim" % level, "LV0")

# 是否满级（当前项目里：0 -> 1，升到 1 就算满级）
func is_max_level(building_id: String) -> bool:
	if !building_data.has(building_id):
		return true
	return get_current_level(building_id) >= 1

# 获取升级消耗：
# - 未满级时返回 lv1_cost
# - 满级时返回空字典（表示没有下一次升级）
func get_upgrade_costs(building_id: String) -> Dictionary:
	if is_max_level(building_id):
		return {}

	var default_cost := {"A": 0.0, "B": 0.0, "C": 0.0}
	return building_data.get(building_id, {}).get("lv1_cost", default_cost)


# 获取升级描述（用于UI展示）
func get_upgrade_desc(building_id: String) -> String:
	if is_max_level(building_id):
		return "MAX"
	return building_data.get(building_id, {}).get("lv1_desc", "")

# ===============================
# 判断是否可以升级（核心逻辑判断）
# ===============================
func can_upgrade(building_id: String) -> bool:
	if !building_data.has(building_id):
		return false

	if is_max_level(building_id):
		return false

	var costs := get_upgrade_costs(building_id)
	if costs.is_empty():
		return false
	return FragmentSystem.can_spend_fragments(costs)
# ===============================
# 获取缺少哪些碎片，返回一个字符串
# ================================
func get_missing_fragments(building_id: String) -> Array[String]:
	var missing: Array[String] = []
	var costs := get_upgrade_costs(building_id)
	# 如果当前A碎片数量 小于 所需A碎片数量
	if FragmentSystem.total_fragment_a < costs.get("A", 0.0):
		missing.append("A")
	# 如果当前B碎片数量 小于 所需A碎片数量
	if FragmentSystem.total_fragment_b < costs.get("B", 0.0):
		missing.append("B")
	# 如果当前C碎片数量 小于 所需A碎片数量
	if FragmentSystem.total_fragment_c < costs.get("C", 0.0):
		missing.append("C")
	return missing
# ===============================
# 尝试升级某个建筑
# 👉 流程：
#   1. 检查是否可升级
#   2. 扣资源
#   3. 提升等级
#   4. 应用效果
#   5. 发信号通知系统
# ===============================
func try_upgrade(building_id: String) -> bool:
	if !building_data.has(building_id):
		return false
	if is_max_level(building_id):
		return false

	var missing := get_missing_fragments(building_id)
	if missing.size() > 0:
		upgrade_failed_insufficient_fragments.emit(missing)
		return false

	var costs := get_upgrade_costs(building_id)
	if !FragmentSystem.spend_fragments(costs):
		return false

	building_levels[building_id] = get_current_level(building_id) + 1
	var new_level := get_current_level(building_id)

	_apply_upgrade_effect(building_id, new_level)
	building_upgraded.emit(building_id, new_level)
	return true

# ===============================
# 应用建筑效果（数值/被动加成）
# 真正影响游戏的地方（最重要）
# ===============================
func _apply_upgrade_effect(building_id: String, level: int) -> void:
	match building_id:
		"sofa":# 这里以后加：SAN恢复加成
			print("BUILDING EFFECT → Sofa LV", level)
			
		"fragment analyzer A":# 这里以后加：碎片获取加成
			print("BUILDING EFFECT → Fragment Analyzer LV", level)
		
