extends Button

signal UpgradeButton_0to1_Pressed(amount)

@export var amount : int = 10

#func _ready():
	#if FragmentSystem.total_fragment_a < amount:
		#disabled = true
	#else:
		#disabled = false
		##print("按钮可以按下")
	
	
#func _process(_delta : float) -> void:
	#if FragmentSystem.total_fragment_a < amount:
		#disabled = true
	#else:
		#disabled = false
		##print("按钮可以按下")
		
		
func pressed() -> void: #这里press挂在button自身上，不需要_on_pressed
	if FragmentSystem.total_fragment_a >= amount:
		UpgradeButton_0to1_Pressed.emit(amount)
		#disabled = true #这里应该转移到control统一控制
		#print("UpgradeButton_0to1_Pressed信号已发出")
