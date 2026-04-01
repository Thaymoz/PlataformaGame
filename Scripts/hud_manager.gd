extends Control

@onready var coins_counter: Label = $container/coins_container/coins_counter
@onready var timer_counter: Label = $container/timer_container/timer_counter
@onready var score_counter: Label = $container/score_container/score_counter
@onready var life_counter: Label = $container/life_container/life_counter
@onready var clock_timer: Timer = $clock_timer

var minutes = 0 
var seconds = 0 
@export_range(0,59) var deflaut_minutes := 1 
@export_range(0,59) var deflaut_seconds := 0

signal time_is_up()

func _ready() -> void:
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)
	timer_counter.text = str("%02d" % deflaut_minutes) + ":" + str("%02d" % deflaut_seconds)
	reset_clocker_timer()
func _process(_delta: float) -> void:
#Na variavel pegue o elemento texto transforme em uma string tudo o que a dentro do parentesses 
#e dps defina que sempre dever ter 4 DIGITOS e diga que isso equivale no script de GLOBAlS 
#o termo coins
	coins_counter.text = str("%04d" % Globals.coins)
	score_counter.text = str("%06d" % Globals.score)
	life_counter.text = str("%02d" % Globals.player_life)

	if minutes ==0 and seconds ==0:
		emit_signal("time_is_up")

func _on_clock_timer_timeout() -> void:
	if seconds == 0:
		if minutes > 0:
			minutes -= 1 
			seconds = 60
	seconds -= 1
	
	timer_counter.text = str("%02d" % minutes) + ":" + str("%02d" % seconds)
	
func reset_clocker_timer():
	minutes = deflaut_minutes
	seconds = deflaut_seconds
