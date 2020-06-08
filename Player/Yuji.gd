extends KinematicBody2D

const SPEED = 60
const RUN_SPEED = 150

signal destination_reached

onready var animation = $AnimationTree
onready var animation_state = animation["parameters/playback"]
onready var tween = $Tween
var is_running = false
var can_move = true
var direction = Vector2.ZERO
var stats = Player
var starting_position : Vector2
var alive = true

func _ready():
	_set_animation_direction(Player.direction)
	tween.connect("tween_completed", self, "_tween_completed")

func _process(_delta):
	if not Player.can_move:
		return
	if direction:
		Event.check_battle()
		animation_state.travel("Walk")
		Player.direction = direction
		Player.position = position
		_set_animation_direction(direction)
	else:
		animation_state.travel("Idle")

	if can_move:
		var speed = RUN_SPEED if is_running else SPEED	
		var _e = move_and_slide(direction.normalized() * speed)

func _unhandled_key_input(_event):
	if Player.can_move:
		_read_buttons()
		direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")

# external functions

func move_to(destination):
	tween.interpolate_property(self, "position", position, destination, .6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

# internal functions

func _tween_completed(_obj, _key):
	emit_signal("destination_reached")

func _read_buttons():
	is_running = Input.is_action_pressed("run")
	if Input.is_action_just_pressed("menu"):
		Event.open_menu()

func _set_animation_direction(_direction):
	animation.set("parameters/Walk/blend_position", _direction)
	animation.set("parameters/Idle/blend_position", _direction)
