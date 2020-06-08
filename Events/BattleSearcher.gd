extends Area2D

export var title = ""
export (int) var frequency = 100
export (int) var min_steps = 25

var player_inside = false
var steps_until_ready

func _ready():
	steps_until_ready = min_steps
	var _e = connect("body_entered", self, "_player_entered")
	_e = connect("body_exited", self, "_player_exited")
	_e = Event.connect("check_battle", self, "_check_battle")

func _player_entered(_body):
	player_inside = true

func _player_exited(_body):
	player_inside = false

func _check_battle():
	if not player_inside:
		return
	if steps_until_ready > 1:
		steps_until_ready -= 1
	if randi() % (frequency * steps_until_ready / 16) == 0:
		_load_battle()

func _load_battle():
	steps_until_ready = min_steps
	Event.start_battle(name)
