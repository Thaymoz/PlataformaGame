extends AnimatableBody2D

const SPEED := 100.0
const EXPLOSION = preload("res://Preferbs/explosion.tscn")

var velocity := Vector2.ZERO
var direction := 1

@onready var sprite: Sprite2D = $sprite
@onready var missle_collision: CollisionShape2D = $missle_collision
@onready var collision: CollisionShape2D = $area_detector/collision


func _process(delta: float) -> void:
	velocity.x = SPEED * direction * delta
	
	move_and_collide(velocity)


func set_direction(dir):
	direction = dir 
	if direction == 1:
		sprite.flip_h = true
	else: 
		sprite.flip_h = false
	

func _on_area_detector_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.take_damage()
	visible = false
	var explosion_instance= EXPLOSION.instantiate()
	get_parent().add_child(explosion_instance) # = add_sibling
	explosion_instance.global_position = global_position
	missle_collision.set_deferred("disabled", true)
	collision.set_deferred("disabled", true)
	await explosion_instance.animation_finished
	queue_free()
