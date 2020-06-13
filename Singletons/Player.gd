extends Node

var position = Vector2(19*16 - 8, 3*16 - 8)
var direction = Vector2.DOWN

var Members = {
	'Yuji': preload("res://Fighters/Party/Yuji.tres"),
	'Ximi': preload("res://Fighters/Party/Ximi.tres")
}


var party := []
var weapons := []
var armor := []
var items := {}

var can_move := true

func _ready():
	# starting party
	party.append(Members.Yuji)
	party.append(Members.Ximi)
	
	# starting equipment
#	armor.append(starting_armor)
	armor.append(Equipment.ximis_coat)
#	weapons.append(starting_weapon)
	weapons.append(Equipment.pocket_knife)
	weapons.append(Equipment.dagger)
	weapons.append(Equipment.short_sword)
#	equipped_weapon = starting_weapon
	receive_items('tissue', 3)
	receive_items('handkerchief', 1)

func receive_items(item_name : String, amt = 0) -> void:
	print("Received " + str(amt) + " " + item_name + "(s)")
	if items.has(item_name):
		items[item_name] = min(items[item_name] + amt, 99)
	else:
		items[item_name] = amt

func use_item(item_name : String):
	if items.has(item_name):
		items[item_name] -= 1
		if items[item_name] <= 0:
			items.erase(item_name)
		var item = Items.all[item_name]
		if item.permanent:
			max_hp += item.hp
			max_mp += item.mp
		else:
			self.hp += item.hp
			mp += item.mp





const Combos = [
	{'moves': "UDU", 'name': "Clockwheel", 'power': 1.2, 'num_hits': 2},
	{'moves': "LRU", 'name': "Slobdash", 'power': 1.2, 'num_hits': 2},
	{'moves': "RRD", 'name': "Hellthy", 'power': .9, 'num_hits': 4},
	{'moves': "DUU", 'name': "Summer Salt", 'power': 1.2, 'num_hits': 2},
	{'moves': "LLUU", 'name': "Floatlag", 'power': 1.3, 'num_hits': 2},
	{'moves': "LRLLD", 'name': "Sinking Sill", 'power': 1.2, 'num_hits': 3},
]

var _name = "Yuji"

# stats
var max_hp = 65
var hp = max_hp setget _set_hp
var max_mp = 5
var mp = 0
var attack_bar = 36.0
var spirit_multiplier = 1.5
var level = 1
var xp = 0 setget _set_xp
var total_xp = 0
var sils = 200 # money
var attack_lr = 6
var attack_ud = 7
var defense = 2
var speed = 12

# items, etc.
var starting_armor = Equipment.t_shirt
var starting_weapon = Equipment.fist


var combos_learned = []
var equipped_weapon = null
var equipped_armor = null

# movement

signal player_dead
signal level_up
signal hp_changed


func _set_hp(_hp):
	hp = clamp(_hp, 0, max_hp)
	if hp == 0:
		emit_signal("player_dead")
		Event.player_died()
	emit_signal("hp_changed")

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
	attack_lr += 2
	attack_ud += 2
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

func receive_attack(atk_strength, atk_level, _location) -> int:
	# a.atk * (a.atk + a.level) / (a.atk + b.def + b.level)
	var damage = int(atk_strength * (atk_strength + atk_level) / (atk_strength + defense + level) * rand_range(.9, 1.1)) + 1
	self.hp -= damage
	return damage
