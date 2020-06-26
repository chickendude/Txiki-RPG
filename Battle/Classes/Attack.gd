class_name Attack

enum {
	UP,
	DOWN,
	RIGHT,
	LEFT
}

const Letters = {
	UP: 'U',
	DOWN: 'D',
	RIGHT: 'R',
	LEFT: 'L',
}

var attacks : Array = []
var actor = null
var targets : Array = [] # in order of who to attack, e.g. if first target is dead move to second target and so on
var speed : int
