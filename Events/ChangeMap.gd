extends Area2D

export var map_name = ""
export var x = 0
export var y = 0
export var facing_up = false

func _ready():
	var _e = connect("body_entered", self, "_change_map")

func _change_map(_body):
	print('entered')
	Event.load_map(map_name, x, y, facing_up)

