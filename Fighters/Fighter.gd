extends KinematicBody2D

class_name Fighter

export (Resource) var stats

const SPEED = 200

onready var sprite = $Sprite
onready var tween_move = $TweenMove
onready var tween_blink = $TweenBlink

var starting_position : Vector2
var velocity = Vector2.ZERO

var alive = true

signal destination_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = stats.sprite
	sprite.hframes = stats.h_frames
	sprite.vframes = stats.v_frames
	stats.connect("died", self, "_on_died")
#	tween.connect("tween_completed", self, "_tween_completed")

func _on_died():
	print("Oh no, hil naiz :'(")
	alive = false
	visible = false

func move_to(destination):
	tween_move.interpolate_property(self, "position", position, destination, .6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween_move.start()
	yield(tween_move, "tween_completed")
	emit_signal("destination_reached")

func _tween_completed(_obj, _key):
	emit_signal("destination_reached")

func start_highlight():
	tween_blink.repeat = true
	tween_blink.interpolate_property(self, 'modulate', Color(1,1,1,1), Color(.8, .8, .8, 1), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween_blink.start()

func end_highlight():
	tween_blink.repeat = false
	yield(tween_blink, "tween_completed")
#	tween_blink.stop_all()
	modulate = Color(1, 1, 1, 1)
