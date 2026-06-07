extends Node

@onready var white_noise_bgm: AudioStreamPlayer2D = $AudioStreamPlayer_whiteNoisebgm


func _ready():	
	white_noise_bgm.play()

#func _on_game_start():
	#white_noise_bgm.play()
