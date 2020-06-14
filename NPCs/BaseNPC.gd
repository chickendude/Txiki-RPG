extends KinematicBody2D


export (String) var character_name
export (String) var event_id
export (String, MULTILINE) var text1
export (String, MULTILINE) var text2

onready var interaction_area = $InteractionArea

var player_looking = false

func _ready():
	interaction_area.connect("area_entered", self, "_player_entered")

func _unhandled_key_input(_event):
	if player_looking and Input.is_action_just_pressed("ui_accept"):
		var text = text1 if not event_id in Event.text_events else text2
		Event.text_events.append(event_id)
		Event.display_text(character_name, text)

func _player_entered(_area):
	player_looking = true

func _player_exited(_area):
	player_looking = false
