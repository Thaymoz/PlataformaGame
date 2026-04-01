extends RigidBody2D

const EXPLOSION = preload("res://Preferbs/explosion.tscn")
@onready var collision: CollisionShape2D = $collision


func _on_body_entered(body: Node) -> void :
	if body.name == "Player":
		body.take_damage()
	visible = false
	var explosion_instance= EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance) # = add_sibling
	explosion_instance.global_position = global_position
	collision.set_deferred("disabled", true)
	await explosion_instance.animation_finished
	queue_free()
