extends Node

@onready var white_noise_bgm: AudioStreamPlayer2D = $AudioStreamPlayer_whiteNoisebgm
@onready var poly_node :Polygon2D = $Polygon2D

func _ready():	
	#播放BGM
	white_noise_bgm.play()	
	
	#鼠标可与游戏下层窗口交互
	#var local_points := poly_node.polygon
	#var global_points := PackedVector2Array()
#
	#for p in local_points:
		#global_points.append(poly_node.global_transform * p)
		#
	#get_window().mouse_passthrough_polygon = global_points

#func _on_game_start():
	#white_noise_bgm.play()
