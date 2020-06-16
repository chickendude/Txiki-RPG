extends KinematicBody2D

class_name Fighter

export (Resource) var stats

const SPEED = 200

onready var sprite = $Sprite
onready var tween = $Tween

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
	tween.connect("tween_completed", self, "_tween_completed")

func _on_died():
	print("Oh no, hil naiz :'(")
	alive = false
	visible = false

func move_to(destination):
	tween.interpolate_property(self, "position", position, destination, .6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func _tween_completed(_obj, _key):
	emit_signal("destination_reached")
