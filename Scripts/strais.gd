extends Node2D


func _ready() -> void:
	Globals.boss_defeated.connect(show_strais)
	#await get_tree().create_timer(2.0).timeout
	#show_strais()
	
func show_strais():
	for block in get_children():
		block.get_node("anim").play("grow")
