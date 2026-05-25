extends PanelContainer

@export var empty_texture: Texture2D
@export var filled_texture: Texture2D

@onready var hbox : HBoxContainer = $MarginContainer/HBoxContainer
@onready var vacancyInfoPanel : PanelContainer = get_node("../BuildingVacancyInfoPanel")

var capacity := 5
var occupied := 0

func _ready():
	vacancyInfoPanel.hide()
	initial_vacancies()
	# 接收建筑升级信号
	BuildingSystem.building_upgraded.connect(_on_vacancy_filled)
	
# 初始化（全部设为empty_texture）
func initial_vacancies():
	var vacancies = hbox.get_children()
	for vacancy in vacancies:
		vacancy.texture = empty_texture
		
		
# ===============================
# 任一建筑升级，对应更新一个vacancy
# ===============================			
func _on_vacancy_filled(_building_id: String, new_level: int):
	if new_level != 1:
		return

	occupied = min(occupied + 1, capacity)
	update_vacancies()
	
# 更新vacancy（核心）
func update_vacancies():
	var vacancies = hbox.get_children()
	for i in vacancies.size():
		if i < occupied:
			vacancies[i].texture = filled_texture
		else:
			vacancies[i].texture = empty_texture

	
# ===============================
# 鼠标悬停，显示vacancy panel信息
# ===============================
func _on_area_2d_mouse_entered() -> void:
	vacancyInfoPanel.show()	

func _on_area_2d_mouse_exited() -> void:
	vacancyInfoPanel.hide()
