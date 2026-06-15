extends Control

signal dialogue_finished()

@onready var label: Label = $Label

var current_index: int = 0
var dialogue_done: bool = false   # 标记对话是否已经结束

# 逐字显示效果
var is_typing: bool = false       # 当前是否正在打字机播放中
var typing_tween: Tween = null    # 当前打字机 Tween 引用

# 存储对话内容
var dialogues: Array[String] = [
	"Hey. You're the...handler. right?",
	"I saw you're hiring workers.",
	"I know the work is tough. \nBut...I have nowhere to go.",
	"Please give me a place...\nI'll do anything you told.",
	"Under the meteroite, I have Nothing but my body to pay back."
]

# 初始化对话面板
func _ready() -> void:
	current_index = 0
	visible = false
	dialogue_done = false
	print("DialogueControl _ready, 节点路径: ", get_path())

# 由外部（如 OverallScreenUI）在 opening comic 结束后调用，正式启动对话
func start_dialogue() -> void:
	await get_tree().process_frame
	_show_current_dialogue()

# 根据当前索引启动打字机效果；
# 若索引超出对话数组范围则隐藏整个节点并发出 dialogue_finished 信号
func _show_current_dialogue() -> void:
	print("DialogueControl _show_current_dialogue, 路径: ", get_path(), " current_index=", current_index)
	if current_index < dialogues.size():
		visible = true
		_start_typewriter(dialogues[current_index])
	else:
		# 所有对话结束，隐藏整个 DialogueControl
		if dialogue_done:
			return  # 已经结束过一次了，不再重复隐藏/emit
		dialogue_done = true
		visible = false
		dialogue_finished.emit()
		set_process_input(false)  # 彻底停止接收输入，避免之后的点击再被_input拦截

# 启动打字机效果：逐字符展开文本，播放完毕后标记 is_typing 为 false
func _start_typewriter(full_text: String) -> void:
	# 终止上一句残留的 Tween
	if typing_tween:
		typing_tween.kill()

	is_typing = true
	label.text = ""
	label.visible_characters = 0
	label.text = full_text

	var char_count: int = full_text.length()
	typing_tween = create_tween()
	typing_tween.tween_property(label, "visible_characters", char_count, char_count * 0.05)
	typing_tween.finished.connect(_on_typewriter_finished)

# 打字机播放完毕回调：标记当前句子已完整显示
func _on_typewriter_finished() -> void:
	is_typing = false

# 监听全局输入事件：
# - 打字机播放中点击左键 → 立即显示完整句子
# - 完整句子状态下点击左键 → 推进到下一句
func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_typing:
			# 跳过打字机，直接显示完整句子
			if typing_tween:
				typing_tween.kill()
			label.visible_characters = -1  # -1 表示显示全部字符
			is_typing = false
		else:
			# 完整句子，推进到下一句
			current_index += 1
			_show_current_dialogue()
		get_viewport().set_input_as_handled()
