extends Resource

class_name EnemyBase

export var name = ""
export var hp = 0 setget _set_hp
export var level = 0
export var attack_l = 0
export var attack_r = 0
export var attack_u = 0
export var attack_d = 0
export var magic = 0
export var defense = 0
export var magic_defense = 0
export var speed = 0
export var xp = 0 # xp for killing monster
export var sils = 0 # sils (money) for beating monster

export (Texture) var sprite
export var h_frames = 3
export var v_frames = 1

signal died

var combo = []

func _set_hp(_hp):
	hp = max(0, _hp)
	if hp == 0:
		emit_signal("died")

func receive_attack(atk_strength, atk_level, _location) -> float:
	# a.atk * (a.atk + a.level) / (a.atk + b.def + b.level) * rand(.9, 1.1)
	var damage = int(atk_strength * (atk_strength + atk_level) / (atk_strength + defense + level) * rand_range(.9, 1.1)) + 1
	self.hp -= damage
	return damage
