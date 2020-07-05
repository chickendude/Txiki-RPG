extends BaseFighter

class_name Enemy

# stats

export var xp = 0 # xp for killing monster
export var sils = 0 # sils (money) for beating monster

export var Combos = []

# items, etc.

export (Array) var items # items the enemy can drop

# perhaps add attacks / special attacks var?

func get_attack(_location):
	return attack
