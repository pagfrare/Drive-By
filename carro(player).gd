extends CharacterBody2D

var potenciamotor = 1200 #pra controlar a aceleracao
# aqui é onde o filho chora e a mãe não vẽ.....
var volantemax = 20 #controla o quanto o carro vai virar
var atrito = -50 #controla o atrito que desacelera o carro
var resistAr = -1 #Resistência do ar
var freio = -200 #freio do carro
var tracaoBase = 8 # tração base das rodas
var velocidademaxre = -100
var distRodas = 65 #distância entre as rodas do carro pra tentar fazer ele bonitin igual o real
var direcaoVolante  #pra onde o carro tá virando
var aceleracao = Vector2.ZERO
var Fatrito
var teste

func _physics_process(delta: float) -> void:
		aceleracao = Vector2.ZERO
		get_input()  # Take input from player
		calculaVirada(delta)
		aplicaAtrito(delta)
		velocity += aceleracao * delta
		teste = velocity
		move_and_slide()


func get_input():
	# Get steering input and translate it to an angle
	var virar = Input.get_axis("Esquerda", "Direita")
	direcaoVolante = virar * deg_to_rad(volantemax)

	# If accelerate is pressed, apply engine power to the car's forward direction
	if Input.is_action_pressed("Acelerar"):
		aceleracao = potenciamotor * transform.x #pelo oq entendi esse tranform.x serve pra calcular o vetor movimentação modificado

	# If brake is pressed, apply braking force
	if Input.is_action_pressed("Frear"):
		aceleracao = freio * transform.x

func aplicaAtrito(delta):
	if aceleracao == Vector2.ZERO and velocity.length() < 10: #para o carro se tiver muito lerdo
		velocity = Vector2.ZERO
	Fatrito = velocity * delta * atrito
	aceleracao += Fatrito

func calculaVirada(delta):
	# Calcula onde ficam as rodas
	var rodaTraseira = position - transform.x * distRodas / 2.0
	var rodaDianteira = position + transform.x * distRodas / 2.0
	# Ajusta a posição das rodas
	rodaTraseira += velocity * delta
	rodaDianteira += velocity.rotated(direcaoVolante) * delta
	# Calcula pra onde o carro vai (eu espero)
	var novaDirecao = rodaTraseira.direction_to(rodaDianteira)

	# Choose the traction model based on the current speed
	var tracao = tracaoBase
	if velocity.length() > 1100:
		tracao = tracaoBase * 0.25

	# Dot product represents how aligned the new heading is with the current velocity direction
	var d = novaDirecao.dot(velocity.normalized())

	# If not braking (d > 0), adjust the car velocity smoothly towards the new heading
	if d > 0:
		velocity = lerp(velocity, novaDirecao * velocity.length(), tracao * delta)

	# If braking (d < 0), reverse the direction and limit the speed
	if d < 0:
		velocity = - novaDirecao * min(velocity.length(), velocidademaxre)
	# muda o carro pra apontar pra onde tá indo
	rotation = novaDirecao.angle()
