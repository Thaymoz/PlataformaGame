extends Node
var a : int = 2
var b : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(a + b)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
