extends Node2D

@onready var player := $Player as CharacterBody2D
@onready var player_scene =preload("res://Actors/player.tscn")

@onready var camera := $camera as Camera2D
@onready var control: Control = $HUD/control
@onready var player_start_position: Marker2D = $player_start_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player_start_position = player_start_position
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.players_has_died.connect(game_over)
	control.time_is_up.connect(game_over)



func reload_game():
	await get_tree().create_timer(1.0).timeout
	#get_tree().reload_current_scene()
	var player = player_scene.instantiate()
	add_child(player)
	control.reset_clocker_timer()
	Globals.player = player
	Globals.player.follow_camera(camera)
	Globals.player.players_has_died.connect(game_over)
	Globals.coins = 0 
	Globals.score = 0
	Globals.player_life = 3
	Globals.respawn_player()
	
func game_over():
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file("res://scene/game_over.tscn")
#func reload_game():
	#await get_tree().create_timer(1.0).timeout
	##get_tree().reload_current_scene()
	#var player = player_scene.instantiate()
	#add_child(player)
	#control.reset_clocker_timer()
	#Globals.player = player
	#Globals.player.follow_camera(camera)
	#Globals.player.players_has_died.connect(reload_game)
	#Globals.coins = 0 
	#Globals.score = 0
	#Globals.player_life = 3
	#Globals.respawn_player()
#e teria q mudar a condição para essa lá em cima Globals.player.players_has_died.connect(reload_game)
#resetaria tudo menos a vida deixando ele com zero e ficando sem nada até q ele pegue uma poti ou seila
