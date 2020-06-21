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
var target = null
var speed : int
