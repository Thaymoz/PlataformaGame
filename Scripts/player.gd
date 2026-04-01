extends CharacterBody2D


const SPEED = 150.0
const AIR_FRICTION := 0.7

const COIN_SCENE := preload("res://Preferbs/coin_rigid.tscn")

#@export var player_life := 3 #aula 10
var knockback_vector := Vector2.ZERO
var direction
var knockback_power := 20 

var is_jumping := false 
var is_hurted := false

#handle jump and gravity especial 28,5
@export var jump_heigh := 64 #ele é 64 pq o personagem tem 32 de altura ai o clecio queria o dobro 
@export var max_time_to_peak := 0.5
var jump_velocity
var gravity
var fall_gravity

@onready var jump_sfx: AudioStreamPlayer = $jump_sfx
@onready var animation := $Anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D
@onready var destroy_sfx = preload("res://Sounds/destroy_sfx.tscn")
@onready var player_start_position: Marker2D = $"../player_start_position"

signal players_has_died()

func _ready() -> void:
	jump_velocity= (jump_heigh*2)/ max_time_to_peak
	gravity= (jump_heigh*2)/ pow(max_time_to_peak,2)
	fall_gravity = gravity*2
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
#Se eu mudar o velocity.x = 0 para aqui a velocidade q ele caminha fica mais lenta tmb, assim como o pulo
	if not is_on_floor():
		#velocity += get_gravity() * delta #esta linha esta deixando de ser usada pois criamos um metodo melhor na aula 28,5
		velocity.x = 0

	# Handle jump.
	if Input.is_action_just_pressed("Pulo") and is_on_floor():
		velocity.y = -jump_velocity
		is_jumping = true
		jump_sfx.play()
	elif is_on_floor():
		is_jumping = false
	
	if velocity.y > 0 or not Input.is_action_pressed("Pulo"):
		velocity.y += fall_gravity*delta
	else:
		velocity.y += gravity*delta
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("Esquerda ", "Direita ")
	
	if direction :
#aqui mudamos na aula 28,5 e estamos interpolando o vetor da velocidade para dar um toque mais real 
		velocity.x = lerp(velocity.x, direction * SPEED, AIR_FRICTION)
		animation.scale.x = direction
		#ESSE TECHO SUMIU DEVIDO AO STATE MACHINE DA AULA 12
		#if !is_jumping: #is_not jumping
			#animation.play("Run")
	#elif is_jumping:  # is_jumping == true
		#animation.play("Jump")
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		#animation.play("Idle")

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	_set_state()
	move_and_slide()

	for plataforms in get_slide_collision_count():
		var collision = get_slide_collision(plataforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)


func _on_hurtbox_body_entered(body: Node2D) -> void:
	#if $ray_right.is_colliding():
		#take_damage(Vector2(-300,-200))
#
	#elif $ray_left.is_colliding():
		#take_damage(Vector2(300,-200))
	var knockback = Vector2((global_position.x - body.global_position.x)*knockback_power, -200)
	take_damage(knockback)
	if body.is_in_group("fireball"):
		body.queue_free()
	
func follow_camera(camera):#aula 9
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force := Vector2.ZERO,duration := 0.25):#aula 10
	if Globals.player_life > 0:
		Globals.player_life -= 1
	else:
		queue_free()
		emit_signal("players_has_died")
		#await players_has_died
	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		animation.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property(animation,"modulate",Color(1,1,1,1),duration)
		
	lose_coin()
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

#criar um state machine que repete uma função inteira sem ter q copiar novamente
#verificamos a o estado do personagem 

func _set_state():
	var state = "Idle"
	if !is_on_floor():
		state = "Jump"
	elif direction != 0:
		state = "Run"
	if is_hurted:
		state= "hurt"
	if animation.name != state:
		animation.play(state)

#Se entrar um corpo dentro da colisão da cabeça colider 
func _on_head_collider_body_entered(body: Node2D) -> void:
#Ele verificada naquele corpo se tem um metodo chamado break
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 0:
			body.break_sprite()
			play_destroy_sfx()
		else:
			body.create_coin()
			body.hit_block.play()
			body.anim.play("hit")
			
func play_destroy_sfx():
#crio uma nova função para instanciar um outro som que posso chamar no geral
#eu faço com q esse som apareça com o instantiate e digo que sera a mesma coisa que aquele outro som
#porem eu preciso que ele seja adicionado na arvore de nos, para isso eu pego o pai no da cena e adiciono umfilho
#ent eu executo ele 
	var sound_sfx = destroy_sfx.instantiate()
	get_parent().add_child(sound_sfx)
	sound_sfx.play()
	await sound_sfx.finished
	sound_sfx.queue_free()

func lose_coin():
	var lost_coins :int = min(Globals.coins, 5)
	set_collision_layer_value(2, true)
#mudamos essa linha por conta do erro de colisão que fazia o personagem principal
#entrar dentro das paredes 
	#$collision.set_deferred("disabled", true)
	Globals.coins -= lost_coins
	for i in lost_coins:
		var coin = COIN_SCENE.instantiate()
		#get_parent().add_child(coin)
		get_parent().call_deferred("add_child", coin)
		coin.global_position = global_position
		coin.apply_impulse(Vector2(randi_range(-150,150),-300))
	await get_tree().create_timer(0.15).timeout
	set_collision_layer_value(2, false)
	#$collision.set_deferred("disabled", false)

func handle_death_zone():
	if Globals.player_life > 0:
		Globals.player_life -= 1
		visible = false
		set_physics_process(false)
		await  get_tree().create_timer(1.0).timeout
		Globals.respawn_player()
		#global_position = player_start_position.global_position
		set_physics_process(true)
		visible = true
	#voce tambem pode crirar essa função atraves de uma referencia direta marcando o Marker2d
	#q esta na main e serve para registrar a posição inicial do jogo ai vc faz uma referencia aquela 
	#posição e fala para ele ir para la 
	else:
		visible = false
		await get_tree().create_timer(0.5).timeout
		#emit_signal("players_has_died") #outra maneira de chamr o sinal
		players_has_died.emit()
