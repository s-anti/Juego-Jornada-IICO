extends Area2D

class_name Torreta

onready var detec = $Deteccion
onready var eje = $Eje

onready var health_bar = $Control/HealthBar

enum {
	CLOSEST_TO_BASE,
	LOWEST_LIFE,
	HIGHEST_LIFE,
	CLOSEST_TO_SELF,
}

export (int, "CLOSEST_TO_BASE", "LOWEST_LIFE", "HIGHEST_LIFE", "CLOSEST_TO_SELF") var target_mode
export var tiro = preload("res://Torretas/Tiros/HitscanTurretShot.tscn") 
export var dmg = 1

var currentTarget = null
var targeting = false

var can_shoot = true

var vida = 100

var inmune = false

# TODO: borrarlo del navmesh, mas que nada si ponemos barricadas

func _physics_process(_delta):
	check_target()
	
	mirar()
	
	check_shoot()
	
	if inmune:
		$Sprite.modulate.r = 40
	else:
		
		$Sprite.modulate.r = 0
	

func check_shoot():
	if not targeting:
		return
	else:
		# TODO: si el arma tiene que girar antes de dispararle se fija
		#if abs(eje.rotation - eje.get_angle_to(currentTarget.global_position)) < .4
		if can_shoot:
			can_shoot = false
		
			var t = tiro.instance()
			get_parent().add_child(t)
			t.global_position = eje.global_position
			t.rotation = eje.rotation
			t.damage = dmg
			
			$shotCD.start()


	
func mirar():
	if targeting:
		
		eje.rotate(eje.get_angle_to(currentTarget.global_position))
	else:
		eje.rotation = lerp_angle(eje.rotation, 0, 0.1)

func check_target():
	var posibles = []
	targeting = false
	for i in detec.get_overlapping_bodies():
		if is_instance_valid(i) and i is Enemy:
			posibles.append(i)
			targeting = true
	
	match target_mode:
		CLOSEST_TO_BASE:
			for i in posibles:
				if not is_instance_valid(currentTarget):
					currentTarget = i
					continue
				if i.position.distance_to(Singleton.base.position) < currentTarget.position.distance_to(Singleton.base.position):
					currentTarget = i
					
		LOWEST_LIFE:
			print("No esta disponible")
		HIGHEST_LIFE:
			print("No esta disponible")
		CLOSEST_TO_SELF:
			print("No esta disponible")


func _on_shotCD_timeout():
	can_shoot = true


func _on_stasis_timeout():
	inmune = false

func die():
	call_deferred("queue_free")

func take_damage(damage):
	if inmune:
		return
	inmune = true
	$stasis.start()
	vida -= damage
	health_bar.hp = vida
	
	if vida <= 0:
		die()

func _on_TorretaBase_body_entered(body):
	print("Taking damage")
	if not body is Enemy:
		print("No es enemy??")
	take_damage(body.turret_damage)
	