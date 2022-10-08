extends Node

var inventario
var base

func _ready():
	for i in get_parent().get_children():
		if i.name == "nivel":
			for j in i.get_children():
				if j is Inventario:
					inventario = j
				if j is Home:
					base = j
func levantar_loot(loot: Loot):
	inventario.change_plata(loot.valor)
	loot.destroy()
