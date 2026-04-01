extends CharacterBody2D

const FIREBALL = preload("res://Preferbs/fireball.tscn")

var move_speed := 20.0
var direction := 1
var health_points := 3 

@onready var sprite: Sprite2D = $sprite
@onready var anim: AnimationPlayer = $anim
@onready var fireball_spwan_point: Marker2D = $fireball_spwan_point
@onready var ground_detector: RayCast2D = $ground_detector
@onready var player_detector: RayCast2D = $player_detector
@onready var hurt_sprite: Sprite2D = $sprite/hurt_sprite

enum EnemyState {PATROl, ATTACK, HURT}
var current_state = EnemyState.PATROl
@export var target : CharacterBody2D

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	#if player_detector.is_colliding():
		#anim.play("shooting")
	#else:
		#anim.play("running")
		match(current_state):
			EnemyState.PATROl : patrol_state()
			EnemyState.ATTACK : attack_state()

	
func patrol_state():
	anim.play("running")
	if is_on_wall():
		flip_enemy()
	if not ground_detector.is_colliding():
		flip_enemy()
	velocity.x = move_speed*direction
	if player_detector.is_colliding():
		_change_state(EnemyState.ATTACK)
		
	move_and_slide()
	
func attack_state():
	anim.play("shooting")
	if not player_detector.is_colliding():
		_change_state(EnemyState.PATROl)

func hurt_state():
	anim.play("hurt")
	hurt_sprite.visible = true
	await get_tree().create_timer(0.3).timeout
	hurt_sprite.visible = false
	_change_state(EnemyState.PATROl)
	if health_points > 0:
		health_points -= 1
	else:
		queue_free()
	
func _change_state(state):
	current_state = state

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1
	player_detector.scale.x *= -1
	fireball_spwan_point.position.x *= -1

func spawn_fireball():
	var new_fireball = FIREBALL.instantiate()
	if sign(fireball_spwan_point.position.x) == 1:
		new_fireball.set_direction(1)
	else:
		new_fireball.set_direction(-1)
	add_sibling(new_fireball)
	new_fireball.global_position = fireball_spwan_point.global_position


@warning_ignore("unused_parameter")
func _on_hitbox_body_entered(body: Node2D) -> void:
	_change_state(EnemyState.HURT)
	hurt_state()
