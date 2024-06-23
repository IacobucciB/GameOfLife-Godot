extends Node2D

@onready var MAPA = $MAPA
@onready var DELAY = $TEMPO
@onready var CAM = $CAMARA

var layer_id = 0
var tile_id = 0
var atlas_dead_coords = Vector2i(1, 0)
var atlas_alive_coords = Vector2i(0, 0)

var rng = RandomNumberGenerator.new()

var FILAS = 72
var COLUMNAS = 128
var TAM_CELULA = 10
var TABLERO = []
var TABLERO_BUFFER = []
var VIVA = 1
var MUERTA = 0

func iniciar_tablero():
	TABLERO.clear()
	for fila in range(FILAS):
		var nFila = []
		for columna in range(COLUMNAS):
			nFila.append(MUERTA)
		TABLERO.append(nFila)

func iniciar_tablero_buffer():
	TABLERO_BUFFER.clear()
	for fila in range(FILAS):
		var nFila = []
		for columna in range(COLUMNAS):
			nFila.append(MUERTA)
		TABLERO_BUFFER.append(nFila)

func iniciar_celulas():
	# Blinker
	TABLERO[20][10] = VIVA
	TABLERO[21][10] = VIVA
	TABLERO[22][10] = VIVA
	
	TABLERO[21][9] = VIVA
	TABLERO[22][11] = VIVA

	# Toad
	TABLERO[5][5] = VIVA
	TABLERO[5][6] = VIVA
	TABLERO[5][7] = VIVA
	TABLERO[6][6] = VIVA
	TABLERO[6][7] = VIVA
	TABLERO[6][8] = VIVA


func calcula_vecinas():
	for filas in range(1, FILAS - 1):
		for columnas in range(1, COLUMNAS - 1):
			var aux = 0
			if TABLERO[filas - 1][columnas - 1] == VIVA: aux += 1
			if TABLERO[filas][columnas - 1] == VIVA: aux += 1
			if TABLERO[filas + 1][columnas - 1] == VIVA: aux += 1
			
			if TABLERO[filas - 1][columnas] == VIVA: aux += 1
			if TABLERO[filas + 1][columnas] == VIVA: aux += 1
			
			if TABLERO[filas - 1][columnas + 1] == VIVA: aux += 1
			if TABLERO[filas][columnas + 1] == VIVA: aux += 1
			if TABLERO[filas + 1][columnas + 1] == VIVA: aux += 1

			if TABLERO[filas][columnas] == MUERTA:
				if aux == 3:
					TABLERO_BUFFER[filas][columnas] = VIVA
				else:
					TABLERO_BUFFER[filas][columnas] = MUERTA
			else:
				if aux == 3 or aux == 2:
					TABLERO_BUFFER[filas][columnas] = VIVA
				else:
					TABLERO_BUFFER[filas][columnas] = MUERTA

	for i in range(FILAS):
		for j in range(COLUMNAS):
			TABLERO[i][j] = TABLERO_BUFFER[i][j]

func actualizar_tablero():
	for filas in range(FILAS):
		for columnas in range(COLUMNAS):
			if TABLERO[filas][columnas] == VIVA:
				MAPA.set_cell(layer_id, Vector2i(columnas, filas), tile_id, atlas_alive_coords)
			elif TABLERO[filas][columnas] == MUERTA:
				MAPA.set_cell(layer_id, Vector2i(columnas, filas), tile_id, atlas_dead_coords)

func actualizar_mapa():
	for filas in range(FILAS):
		for columnas in range(COLUMNAS):
			var dead_or_alive = rng.randf_range(-10.0, 10.0)
			if dead_or_alive > 8:
				TABLERO[filas][columnas] = VIVA
			else:
				TABLERO[filas][columnas] = MUERTA

func _ready():
	iniciar_tablero()
	iniciar_tablero_buffer()
	iniciar_celulas()
	actualizar_tablero()
	DELAY.start()

func _process(delta):
	pass

func _on_tempo_timeout():
	calcula_vecinas()
	actualizar_tablero()
