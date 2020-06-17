extends StatBase

class_name PartyMember

export var Combos = [
	{'moves': "UDU", 'name': "Clockwheel", 'power': 1.2, 'num_hits': 2},
	{'moves': "LRU", 'name': "Slobdash", 'power': 1.2, 'num_hits': 2},
	{'moves': "RRD", 'name': "Hellthy", 'power': .9, 'num_hits': 4},
	{'moves': "DUU", 'name': "Summer Salt", 'power': 1.2, 'num_hits': 2},
	{'moves': "LLUU", 'name': "Floatlag", 'power': 1.3, 'num_hits': 2},
	{'moves': "LRLLD", 'name': "Sinking Sill", 'power': 1.2, 'num_hits': 3},
]


# stats

export var xp = 0 setget _set_xp
export var total_xp = 0
export var attack_bar = 0

# items, etc.
var starting_armor = Equipment.t_shirt
var starting_weapon = Equipment.fist

#var weapons = []
#var armor = []
var combos_learned = []
var prev_attacks = []
#var items = {}
var equipped_weapon = null
var equipped_armor = null

# movement

signal player_dead
signal level_up
signal hp_changed(old_hp, new_hp)

func _ready():
	equipped_armor = starting_armor
	equipped_weapon = starting_weapon

func _set_hp(_hp):
	var old_hp = hp
	hp = clamp(_hp, 0, max_hp)
	if hp == 0:
		emit_signal("player_dead")
		Event.player_died()
	emit_signal("hp_changed", old_hp, hp)

func _set_xp(_xp):
	xp = _xp
	var next_level_xp = _next_level_xp()
	while xp >= next_level_xp:
		_level_up(next_level_xp)

func _level_up(next_level_xp) -> void:
	total_xp += next_level_xp
	xp -= next_level_xp
	level += 1
	max_hp += 5
	hp += 5
	attack += 2
	defense += 2
	speed += 2
	attack_bar += 4.5
	emit_signal("level_up")

func _next_level_xp() -> int:
	var lvl = level + 2
	var part1 = lvl * lvl * lvl * .6
	var part2 = lvl * lvl * .8
	var part3 = lvl * 10
	return int(part1 + part2 + part3)

func xp_until_next_level() -> int:
	return _next_level_xp() - xp

# stats

func get_attack(location):
	var weapon_atk := 0
	if equipped_weapon:
		print(equipped_weapon.name)
		weapon_atk = equipped_weapon.attack_u if location == Attack.UP else equipped_weapon.attack_d
	return attack + weapon_atk
