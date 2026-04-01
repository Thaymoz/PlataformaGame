extends EnemyBase

func _ready() -> void:
	texture = $texture
	wall_detector = $"wall detector"
	anim.animation_finished.connect(kill_ground_enemy)
	
func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	movement(delta)
	flip_direction()
	
