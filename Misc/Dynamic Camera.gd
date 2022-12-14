extends Camera2D



export var min_size = .2
export var max_size = 1.1


var warning = preload("res://Misc/Warning.tscn")
var warnings = []

var players
var z = 0
var last_z = 0
var last_pos = Vector2.ZERO

var one_player = false

func _ready():
	z = max_size
	players = get_tree().get_nodes_in_group("Jugadores")
	if len(players) < 1: print("Explota la camara")
	

func _process(_delta):

	var centros = []	
 
	var center = Vector2.ZERO
	
	for i in players:
		if not is_instance_valid(i):
			players.erase(i)
			continue
			
		centros.append(i.global_position)
		
		
		
	if is_instance_valid(Singleton.base):
		
		centros.append(Singleton.base.global_position)
		
		
	for vector in centros:
		center += vector
	
	center = Vector2(center.x / centros.size(), center.y / centros.size())

		




	var mx_x = -INF
	var mn_x = INF
	
	var mx_y = -INF
	var mn_y = INF
	
	for player in players:
		mx_x = max(player.global_position.x, mx_x)
		mn_x = min(player.global_position.x, mn_x)
		
		mx_y = max(player.global_position.y, mx_y)
		mn_y = min(player.global_position.y, mn_y)
		# TODO: que cambie con la diferencia en altura. Está desactivado porque cada salto lo hacía cambiar un montón
		# Capaz poniéndole un threshhold o un suavizado mas agrasivo
	
	if is_instance_valid(Singleton.base):
		mx_x = max(Singleton.base.global_position.x, mx_x)
		mn_x = min(Singleton.base.global_position.x, mn_x)

		mx_y = max(Singleton.base.global_position.y, mx_y)
		mn_y = min(Singleton.base.global_position.y, mn_y)
		

	var spread = ((mx_x - mn_x + mx_y - mn_y) / 2) -40 # 



	
	
	z = range_lerp(spread, -40, 200, min_size, max_size)
	
	
	z = clamp(z , min_size, max_size)
	
	z = lerp(last_z, z, 0.07) 

	last_z = z

	zoom = Vector2(z, z)

	global_position = center # + Vector2(0, -30)
	
	

