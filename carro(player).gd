extends CharacterBody2D


var velocidade = 500
var potenciamotor = 2 #pra controlar a aceleracao
# aqui é onde o filho chora e a mãe não vẽ.....
var volantemax = 15 #controla o quanto o carro vai virar
var atrito = -50 #controla o atrito que desacelera o carro
var resistAr = -1 #Resistência do ar
var freio = -2 #freio do carro
var tracao = 1 # tração das rodas

var distRodas = 80 #distância entre as rodas do carro pra tentar fazer ele bonitin igual o real
var direcaoVolante  #pra onde o carro tá virando
var aceleracao = Vector2.ZERO
 
func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.y = direction * velocidade
	else:
		velocity.y = move_toward(velocity.y, 0, velocidade)

	move_and_slide()
func get_input():
	# Get steering input and translate it to an angle
	var virar = Input.get_axis("move_left", "move_right")
	direcaoVolante = virar * deg_to_rad(volantemax)

	# If accelerate is pressed, apply engine power to the car's forward direction
	if Input.is_action_pressed("move_up"):
		aceleracao = potenciamotor * transform.x #pelo oq entendi esse tranform serve pra calcular o vetor movimentação modificado

	# If brake is pressed, apply braking force
	if Input.is_action_pressed("move_down"):
		aceleracao = freio * transform.x
		
