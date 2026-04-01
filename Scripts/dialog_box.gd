extends MarginContainer

@onready var letter_timer_display: Timer = $letter_timer_display
@onready var text_label: Label = $label_margin/text_label

#Largura maxima da caixa
const MAX_WIDTH = 256
#Vai limpar o nosso texto 
var text = ""
#Efeito de de datilografia ao calulcar o lugar da letra
var letter_index = 0

#Gerenciamento do timer 
#Surgimento da letra, spaço e pontuação
var letter_display_timer = 0.07
var space_display_timer = 0.05
var punctuation_display_timer = 0.2

#sinal para dizer que o texto acabou 
signal text_display_finished()


#Definindo o nosso texto
func diplay_text(text_to_display: String):
#A nossa variavel text lá em cima q está vazia vai ganhar coisas que sera 
#a variavel text_to_diplay uma string 
	text = text_to_display
#Ai acessamos o nó text_label e sua propriedade text (O lugar que colocamos ou escrevemos um texto)
#e definimos que ela sera a variavel text_to_display
	text_label.text = text_to_display
#Caso o nosso texto seja redimensionado aguarde um pouco
	await resized
#verifique o tamanho do objeteto junto com o tamanho maximo e se ele passou
	custom_minimum_size.x = min(size.x,MAX_WIDTH)


#caso o tamanho seja maior que o permitido 
	if size.x > MAX_WIDTH:
#Pegue o texto e reajuste de maneira adequada quebrando ele e ps arrume a sua altura
		text_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
#Posiçao e ondde o texto sempre vai aparecer ou seja no meio do objeto e 24 pixeis acima 
	global_position.x -= size.x/2
	global_position.y -= size.y+24
	text_label.text = ""
	display_letter()




func display_letter():
#cada letra do texto vai ser uma posição do index
	text_label.text += text[letter_index]
	letter_index += 1
#Para a posição da letra se for maior q a altura da caixa emita um sinal de acabou
	if letter_index >= text.length():
		text_display_finished.emit()
		return
#Verificando as letras dentro do texto, se tiver os sinais dde pontuação
#dispare o timer com a especificação determinaddda lá em cima
#2 = spaço 3 = qualquer outra letra 
	match text[letter_index]:
		"!",",",".","?":
			letter_timer_display.start(punctuation_display_timer)
		" ":
			letter_timer_display.start(space_display_timer)
		_:
			letter_timer_display.start(letter_display_timer)
#Sempre que finalizar o timer dispara o texto 
func _on_letter_timer_display_timeout() -> void:
	display_letter()
