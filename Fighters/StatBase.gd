extends Resource

class_name StatBase

export var name = ""
export var max_hp = 0
export var hp = 0 setget _set_hp
export var max_mp = 0
export var mp = 0 setget _set_mp
export var level = 0
export var attack = 0 # base attack, weapon/equipment damage is added to this
export var defense = 0 # base defense, equipment/armor added to this
export (String) var immune_locations
export var intelligence = 0 # "magic" attack + defense
export var speed = 0 # determine player's turn in battle + critical hits

export (Texture) var sprite
export var h_frames = 3
export var v_frames = 1

var alive = true

signal died

var combo = [] # ?? perhaps not needed anymore ??

# setters

func _set_hp(_hp):
	hp = clamp(_hp, 0, max_hp)
	alive = hp == 0
	if not alive:
		emit_signal("died")

func _set_mp(_mp):
	mp = clamp(_mp, 0, max_mp)

# battle functions

func receive_attack(atk_strength, atk_level, location) -> int:
	if Attack.Letters[location] in immune_locations:
		return 0
	# a.atk * (a.atk + a.level) / (a.atk + b.def + b.level) * rand(.9, 1.1)
	var damage = int(atk_strength * (atk_strength + atk_level) / (atk_strength + defense + level) * rand_range(.9, 1.1)) + 1
	self.hp -= damage
	return damage

func get_attack(location):
	pass
