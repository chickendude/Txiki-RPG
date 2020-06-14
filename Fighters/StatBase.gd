extends Resource

class_name StatBase

export var name = ""
export var max_hp = 0
export var hp = 0 setget _set_hp
export var max_mp = 0
export var mp = 0 setget _set_mp
export var level = 0
export var attack_ud = 0 # upper and lower attacks (kicks)
export var attack_lr = 0 # mid attacks (punches)
export var defense_u = 0 # most attacks except low/down attacks
export var defense_d = 0 # attacks aimed at the lower body (legs)
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
	var defense = defense_u
	if location == Attack.DOWN:
		defense = defense_d
	# if defense = 0 that means it is immune to that attack
	if not defense:
		return 0
	# a.atk * (a.atk + a.level) / (a.atk + b.def + b.level) * rand(.9, 1.1)
	var damage = int(atk_strength * (atk_strength + atk_level) / (atk_strength + defense + level) * rand_range(.9, 1.1)) + 1
	self.hp -= damage
	return damage
