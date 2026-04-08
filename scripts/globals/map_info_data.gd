extends Node
"""
全局地图数据（单例）
只负责存储和提供地图信息
"""

# ===============================
# 地图数据
# ===============================
var map_info = {}

# ===============================
# 初始化数据
# ===============================
func _ready():
	_rebuild_map_info()

# ===============================
# 构建地图数据
# ===============================
func _rebuild_map_info() -> void:
	map_info = {
		"A": {
			"title": "FOREST",
			"time": "10 MIN",
			"gain": "Fragments * 120",
			"unlock_requirement": ""
		},
		"B": {
			"title": "VILLAGE",
			"time": "10 MIN",
			"gain": "Fragments * 300; Blocks * 50",
			"unlock_requirement": "Fragments * 250"
		},
		"C": {
			"title": "DESERT",
			"time": "10 MIN",
			"gain": "Fragments * 1000; Blocks * 200",
			"unlock_requirement": "Blocks * 200"
		}
	}

# ===============================
# 提供接口（推荐这样访问）
# ===============================
func get_map_info(map_id: String) -> Dictionary:
	return map_info.get(map_id, {})
