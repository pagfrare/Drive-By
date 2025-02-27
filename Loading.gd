extends Control

var progresso = []
var loadbarra = 0
var carro
var cena
var sucesso = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	carro = "res://Carro.tscn"
	ResourceLoader.load_threaded_request(carro)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (sucesso == 1):
		tela(cena)
	loadbarra = ResourceLoader.load_threaded_get_status(carro, progresso)
	$ProgressBar.value = progresso[0] * 100
	if ($ProgressBar.value == 100):
		$ProgressBar.visible = false
		$ProgressBar2.visible = true
		$loading.visible = false
	if (loadbarra == ResourceLoader.THREAD_LOAD_LOADED):
		cena = ResourceLoader.load_threaded_get(carro)
		sucesso = 1
		$Msg.visible = true
		tela(cena)

func tela (proxcena):
	if Input.is_action_pressed("ui_accept"):
		get_tree().change_scene_to_packed(proxcena)
