extends Node2D

onready var label = $Label
onready var tween = $Tween

var text : String
var start_pos : Vector2
var end_pos : Vector2
var duration = .5

func _ready():
	label.text = text
	tween.interpolate_property(label, "rect_position", start_pos, end_pos, duration, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	queue_free()

func set_amt(amt):
	text = str(amt)

func set_direction(direction):
	start_pos = Vector2(rand_range(1, -1), rand_range(1, -1))
	end_pos = Vector2(rand_range(6 * direction, 3 * direction), rand_range(-4, -7))

func set_text(_text):
	duration = 1
	text = _text
