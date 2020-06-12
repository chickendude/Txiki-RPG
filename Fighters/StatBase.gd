extends Resource

class_name StatBase

export var name = ""
export var hp = 0 setget _set_hp
export var level = 0
export var attack_ud = 0 # upper and lower attacks (kicks)
export var attack_lr = 0 # mid attacks (punches)
export var defense_u = 0 # most attacks except low/down attacks
export var defense_d = 0 # attacks aimed at the lower body (legs)
export var intelligence = 0 # "magic" attack + defense
export var speed = 0 # determine player's turn in battle
export var xp = 0 # xp for killing monster
export var sils = 0 # sils (money) for beating monster

export (Texture) var sprite
export var h_frames = 3
export var v_frames = 1

signal died

var combo = [] # ?? perhaps not needed anymore ??

func _set_hp(_hp):
	hp = max(0, _hp)
	if hp == 0:
		emit_signal("died")

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
