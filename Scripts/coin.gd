extends Area2D
var coins := 1 
@onready var collect_sfx: AudioStreamPlayer = $collect_sfx


func _on_body_entered(_body: Node2D) -> void:
	$anim.play("brilho")
	collect_sfx.play()
#Para evitar o bug de conseguir colidir com a mesma moeda mais de uma vez
#a gente manda esperar pegar o nó dele chamado collision e ele realizar o queue_free
#para então seguir com o codigo -- NA VDD ELE DA UM QUEUE FREE NA AREA DE COLISÃO DO OBJETO ANTES
#MESMO DE ELE SUMIR 
	await $CollisionShape2D.call_deferred("queue_free")
	Globals.coins += 1

func _on_anim_animation_finished() -> void:
	queue_free()
