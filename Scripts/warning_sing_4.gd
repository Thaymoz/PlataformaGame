extends Node2D
@onready var area_sign: Area2D = $area_sing
@onready var texture: Sprite2D = $texture

const lines : Array[String] = [
	"sdasdasdasdasdas",
	"esbvnbvnbvnvbnvbr",
	"seopioprteplerktte se levantou",
	"e cxczxcorveczxzxccczxito",
	"não é poqwekslka,nfxzxhdfusifimnudam tudo",
]

func _unhandled_input(event: InputEvent) -> void:
	if area_sign.get_overlapping_bodies().size()>0:
		#texture.show()
		if event.is_action_pressed("interact") && !DialogManager.is_message_actived:
			texture.hide()
			DialogManager.start_message(global_position, lines)
		#else:
			#texture.hide()

func _on_area_2d_body_entered(_body: Node2D) -> void:
	texture.show()


func _on_area_2d_body_exited(_body: Node2D) -> void:
	texture.hide()
	if  DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_actived = false
			DialogManager.current_line = 0
