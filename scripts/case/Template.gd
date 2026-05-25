extends Node
# ============================================================
# GDScript 常用句法模板
# ============================================================

# ------------------------------------------------------------
# 1. 获取节点的几种方式
# ------------------------------------------------------------

# ① 绝对路径（⚠️ 不推荐，换场景根节点会报错）
#@onready var panel = get_node("/root/Game/GameScreenUI/MapSelectPanel")

# ② %UniqueNames（仅限同一场景 owner 内的节点）
#    编辑器里右键节点 → "Access as Unique Name"
#@onready var panel: PanelContainer = %MapSelectPanel

# ③ 相对路径（推荐，../ 往上爬）
#    例：从 Game/MapTexture/ScreenArea/maps 找 Game/GameScreenUI/MapSelectPanel
#@onready var panel: PanelContainer = get_node("../../../GameScreenUI/MapSelectPanel")

# ④ Groups（适合动态生成的节点）
#@onready var worker_rest = get_tree().get_first_node_in_group("WorkerResting")
#@onready var worker_work = get_tree().get_first_node_in_group("WorkerWorking")

# ------------------------------------------------------------
# 2. 信号连接
# ------------------------------------------------------------

#@onready var button = get_tree().get_first_node_in_group("TestButton")
#func _ready():
#    button.fast_button_pressed.connect(_speedup_timers)

# ------------------------------------------------------------
# 3. 状态切换（配合 Autoload）
# ------------------------------------------------------------

#func _ready():
#    GameState.state_changed.connect(_on_state_changed)
#
#func _on_state_changed(state):
#    if state == DataTypes.GameState.Resting:
#        pass
#    if state == DataTypes.GameState.Working:
#        pass
