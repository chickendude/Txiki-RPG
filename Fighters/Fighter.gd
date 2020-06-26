extends KinematicBody2D

class_name Fighter

export (Resource) var stats

const SPEED = 200

onready var sprite = $Sprite
onready var tween = $Tween
onready var animation_player = $AnimationPlayer
onready var cursor = $Cursor

var starting_position : Vector2
var velocity = Vector2.ZERO
var prev_target_index := 0

var alive = true

signal destination_reached

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.texture = stats.sprite
	sprite.hframes = stats.h_frames
	sprite.vframes = stats.v_frames
	var height = sprite.texture.get_size().y / sprite.vframes
	var width = sprite.texture.get_size().x / sprite.hframes
	cursor.position.y = -height/2 + 2
	cursor.position.x = -width/2
	cursor.visible = false
	stats.connect("died", self, "_on_died")

func _on_died():
	print("Oh no, hil naiz :'(")
	alive = false
	visible = false

func move_to(destination):
	tween.interpolate_property(self, "position", position, destination, .6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("destination_reached")

func _tween_completed(_obj, _key):
	emit_signal("destination_reached")

func start_highlight():
	cursor.visible = true
	animation_player.play("Blink")

func end_highlight():
	cursor.visible = false
	animation_player.stop()
	sprite.modulate = Color(1, 1, 1, 1)

