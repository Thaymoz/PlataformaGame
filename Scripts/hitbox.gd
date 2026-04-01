extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		#owner.queue_free() #owner é aquele possui o "objeto"
		body.velocity.y = -body.jump_velocity
#Aqui antes era um owner.anim ele buscava o nó referente 
#tipo antes so tinha o inimigo base que possuia o no chmado anim, mas quando adicionamos o rocket 
#cherry ele n possui esse nó pois na verdade ele é o base_patrol que tem os nó rocket_ que ai 
#tem o nó anim. Ou seja o get_parente é para pegar o objeto e ver ser se ele tem um parente com esse
#nome
		get_parent().anim.play("hurt")
