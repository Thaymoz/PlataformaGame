extends CharacterBody2D

const coin_instance = preload("res://Preferbs/coin_rigid.tscn")
@onready var spawn_coin: Marker2D = $spawn_coin
@onready var hit_block: AudioStreamPlayer = $hit_block


const  box_pieces = preload("res://Preferbs/box_pieces.tscn")
@onready var anim: AnimationPlayer = $anim
#deixa no inspetor para a gente vver o PIECES é um array onde colocamos o gaminho do png que criamos
@export var pieces : PackedStringArray
@export var hitpoints := 3 
var impulse := 120

#break sprite é a função para aparecer os pedacinhos que quebram
func break_sprite():
	for piece in pieces.size():
#Para a variavel de pedaços que vao aparecer eles vão surgir do caixa de pedaços
		var piece_instantiate = box_pieces.instantiate()
#que vai se tornar um filho caixa que pode ser quebrada
		get_parent().add_child(piece_instantiate)
#o nó da textura do caixa de pedaços vai se tornar o string de arrays
		piece_instantiate.get_node("texture").texture = load(pieces[piece])
#a posiçao desses pedaços criados vai ser a mesma posiçao da caixa quebavel
		piece_instantiate.global_position = global_position
#com os pedaços criados ele vai aplicar um impulso dentro dos vetores que terao o Fator X 
# que pode ser de tal -numero ate tal numero e o Fator Y que pode ser de tal -numero a tal -numero
		piece_instantiate.apply_impulse(Vector2(randi_range(-impulse, impulse),randi_range(-impulse,-impulse*2)))
	queue_free()

func create_coin():
	var coin = coin_instance.instantiate()
	get_parent().call_deferred("add_child",coin)
	coin.global_position = spawn_coin.global_position
	coin.apply_impulse(Vector2(randi_range(-50,50),-150))
