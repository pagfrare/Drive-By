extends CharacterBody2D

var potenciamotor = 1000 #pra controlar a aceleracao
# aqui é onde o filho chora e a mãe não vẽ.....
var volantemax = 20 #controla o quanto o carro vai virar
var atrito = -50 #controla o atrito que desacelera o carro
var resistAr = -1 #Resistência do ar
var freio = -200 #freio do carro
var tracaoBase = 8 # tração base das rodas
var velocidademaxre = 300
var distRodas = 50 #distância entre as rodas do carro pra tentar fazer ele bonitin igual o real
var direcaoVolante  #pra onde o carro tá virando
var aceleracao = Vector2.ZERO
var Fatrito
var teste
var tanqueCombustivel = 200.0
var controle
var points = 0

@onready var area_2d: Area2D = $"../Area2D" #gasolina Pick Up
@onready var gasosa_2: Area2D = $"../Gasosa2"
@onready var area_2d_2: Area2D = $"../Area2D2"

func _physics_process(delta: float) -> void:
		aceleracao = Vector2.ZERO
		get_input()
		calculaVirada(delta)
		aplicaAtrito(delta)
		velocity += aceleracao * delta
		gastaCombustivel(delta)
		teste = velocity
		move_and_slide()
		gameover()
		trocacarro()
		$"../Interface de Usuario/Label".text = "%d" % points


func get_input():
	controle = 0
	var virar = Input.get_axis("Esquerda", "Direita")
	direcaoVolante = virar * deg_to_rad(volantemax)

	if Input.is_action_pressed("Acelerar"):
		if tanqueCombustivel > 0:
			controle = 1
			aceleracao = potenciamotor * transform.x #pelo oq entendi esse tranform.x serve pra calcular o vetor movimentação modificado

	if Input.is_action_pressed("Frear"):
		if tanqueCombustivel > 0:
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
	var tracao = tracaoBase
	if velocity.length() > 1100:
		tracao = tracaoBase * 0.25
		atrito = -70
	else:
		tracao = tracaoBase
		atrito = -50

	var d = novaDirecao.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, novaDirecao * velocity.length(), tracao * delta)

	if d < 0:
		velocity = - novaDirecao * min(velocity.length(), velocidademaxre)
	# muda o carro pra apontar pra onde tá indo
	rotation = novaDirecao.angle()
	
#Combustível aqui ó
func gastaCombustivel(delta):
	if velocity.length() > 400:
		if controle == 1:
			tanqueCombustivel -= delta * 10 + points * delta * 0.05
		else:
			tanqueCombustivel -= delta * 5 + points * delta* 0.05
	if tanqueCombustivel <= 0:
		tanqueCombustivel = 0
	atualizaCombustivel()

func atualizaCombustivel():
	$"../Interface de Usuario/Barra do Combustivel".value = tanqueCombustivel / 2
	var stylebox = $"../Interface de Usuario/Barra do Combustivel".get("theme_override_styles/background")
	stylebox.bg_color.h = lerp(0, 200, tanqueCombustivel / 100)

func gameover():
	if velocity == Vector2.ZERO && tanqueCombustivel == 0:
		get_tree().change_scene_to_file("res://GameOver.tscn")

func trocacarro():
	if (points % 10 == 0):
		$Sprite2D2.visible = true
		$Sprite2D.visible = false
	elif (points % 10 == 5):
		$Sprite2D2.visible = false
		$Sprite2D.visible = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	points += 1
	await get_tree().create_timer(1).timeout
	$"../Area2D/CollisionShape2D".disabled = false
	$"../Area2D/Sprite2D".visible = true
func _on_area_2d_body_entered(body: Node2D) -> void:
	tanqueCombustivel += 40
	potenciamotor += 25
	$"../Area2D/CollisionShape2D".disabled = true
	$"../Area2D/Sprite2D".visible = false
func _on_gasosa_2_body_exited(body: Node2D) -> void:
	points += 1
	await get_tree().create_timer(1).timeout
	$"../Gasosa2/CollisionShape2D".disabled = false
	$"../Gasosa2/Sprite2D".visible = true
	$"../Gasosa2/CollisionShape2D2".disabled =false
	$"../Gasosa2/Sprite2D2".visible = true
func _on_gasosa_2_body_entered(body: Node2D) -> void:
	tanqueCombustivel += 40
	potenciamotor += 25
	$"../Gasosa2/CollisionShape2D".disabled = true
	$"../Gasosa2/Sprite2D".visible = false
	$"../Gasosa2/CollisionShape2D2".disabled = true
	$"../Gasosa2/Sprite2D2".visible = false
func _on_caixa_body_entered(body: Node2D) -> void:
	velocity = velocity * 0.3
	tanqueCombustivel -= 20
	$"../Caixa/Sprite2D".visible = false
	$"../Caixa/CollisionShape2D".disabled = true
func _on_caixa_body_exited(body: Node2D) -> void:
	await get_tree().create_timer(1).timeout
	$"../Caixa/Sprite2D".visible = false
	$"../Caixa/CollisionShape2D".disabled = true

func _on_caixa_2_body_entered(body: Node2D) -> void:
	velocity = velocity * 0.3
	tanqueCombustivel -= 20
	$"../Caixa2/Sprite2D".visible = false
	$"../Caixa2/CollisionShape2D".disabled = true

func _on_caixa_2_body_exited(body: Node2D) -> void:
	await get_tree().create_timer(1).timeout
	$"../Caixa2/Sprite2D".visible = false
	$"../Caixa2/CollisionShape2D".disabled = true
