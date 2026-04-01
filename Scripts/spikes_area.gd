extends Area2D
#Linkando os filhos aos nos pais
@onready var texture: Sprite2D = $texture
@onready var collision: CollisionShape2D = $collision


func _ready() -> void:
#acesse a variavel collision entre na propriedade Shape na configuração do size
#e isso sera a mesma coisa que a função de se ajustar da variavel textura e pegue o 
#atributo de tamanho
	collision.shape.size = texture.get_rect().size
	
#quando um corpo entrar SE o corpo ter o nome igual a Player E o corpo possuir o metodo take damage
#ent esse corpo vai executar a funçao take damage movendo se o vectro2 do body para os eixos...
func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" && body.has_method("take_damage"):
		body.take_damage(Vector2(0,-250))
