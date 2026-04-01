extends Node
@onready var dialog_box_scene = preload("res://Preferbs/dialog_box.tscn")
var message_lines : Array[String] = []
var current_line = 0

var dialog_box 
var dialog_box_position := Vector2.ZERO

var is_message_actived = false
var can_advenced_message = false

func start_message(position: Vector2,lines:Array[String]):
	if is_message_actived:
		return
	
	message_lines = lines
	dialog_box_position = position
	show_text()
	is_message_actived = true
	
func show_text():
	dialog_box = dialog_box_scene.instantiate()
	dialog_box.text_display_finished.connect(_on_all_text_displayed)
	get_tree().root.add_child(dialog_box)
	dialog_box.global_position = dialog_box_position
	dialog_box.diplay_text(message_lines[current_line])
	can_advenced_message = true
	
func _on_all_text_displayed():
	can_advenced_message = true
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("advanced_message") && is_message_actived && can_advenced_message):
		dialog_box.queue_free()
		current_line += 1
		if current_line >= message_lines.size():
			is_message_actived = false
			current_line = 0 
			return
		show_text()
