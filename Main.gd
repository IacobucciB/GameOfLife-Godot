extends Node2D

@onready var MAPA = $MAPA
@onready var DELAY = $TEMPO
@onready var CAM = $CAMARA

var layer_id = 0
var tile_id = 3
var atlas_dead_coords = Vector2i(1,0)
var atlas_alive_coords = Vector2i(0,0)

var rng = RandomNumberGenerator.new()

var FILAS = 20
var COLUMNAS = 20
var TAM_CELULA = 32
var TABLERO = []

func iniciarTablero():
	for fila in range(FILAS):
		var nFila = []
		for columna in range(COLUMNAS):
			nFila.append(0)
		TABLERO.append(nFila)

func iniciarCelulas():
	TABLERO[5][5] = 1
	TABLERO[5][6] = 1
	TABLERO[5][7] = 1
	TABLERO[6][6] = 1
	TABLERO[7][9] = 1

func actualizarTablero():
	for filas in range(FILAS):
		for columnas in range(COLUMNAS):
			if TABLERO[filas][columnas] == 1:
				MAPA.set_cell(layer_id,Vector2i(filas,columnas),tile_id,atlas_alive_coords)
			elif TABLERO[filas][columnas] == 0:
				MAPA.set_cell(layer_id,Vector2i(filas,columnas),tile_id,atlas_dead_coords)
				
func actualizarMapa():
	for filas in range(FILAS):
		for columnas in range(COLUMNAS):
			var dead_or_alive = rng.randf_range(-10.0,10)
			if dead_or_alive > 8:
				TABLERO[filas][columnas] = 1
			else:
				TABLERO[filas][columnas] = 0

func _ready():
	iniciarTablero()
	iniciarCelulas()
	actualizarTablero()
	DELAY.start()
	
	
func _process(delta):
	pass

func _on_tempo_timeout():
	actualizarMapa()
	actualizarTablero()
