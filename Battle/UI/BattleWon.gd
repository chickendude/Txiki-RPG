extends Control

onready var sil_label = $NinePatchRect/VBoxContainer/HBoxContainer2/SilLabel
onready var tween = $Tween
onready var vbox_container = $NinePatchRect/VBoxContainer
onready var xp_label = $NinePatchRect/VBoxContainer/HBoxContainer/XPLabel

const CharacterStats = preload("res://Battle/UI/CharacterStats.tscn")
const XP_TIME = 2

enum {
	WAITING, ADDING_XP, DONE_ADDING_XP
}

var xp : int
var all_character_stats = []
var state : int

func input(_delta):
	accept_event()
	var accept_pressed = Input.is_action_just_pressed("ui_accept")
	match state:
		WAITING:
			if accept_pressed:
				_add_xp()
		ADDING_XP:
			if accept_pressed:
				tween.stop_all()
				_update_xp_complete()
		DONE_ADDING_XP:
			if Input.is_action_just_pressed("ui_cancel") or accept_pressed:
				Event.end_battle()
	

func load_prizes(_xp : int, sils : int) -> void:
	state = WAITING
	xp = _xp
	xp_label.text = str(xp)
	sil_label.text = str(sils)
	Player.sils += sils
	_load_character_stats()

func _load_character_stats() -> void:
	for member in Player.party:
		var character_stats := CharacterStats.instance()
		character_stats.load_character(member)
		vbox_container.add_child(character_stats)
		all_character_stats.append(character_stats)

func _add_xp():
	state = ADDING_XP
	tween.interpolate_method(self, '_update_xp', 0, xp, XP_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	tween.connect("tween_completed", self, '_update_xp_complete')

func _update_xp(_xp):
	xp_label.text = str(int(xp - _xp))
	for character_stats in all_character_stats:
		if character_stats.character.alive:
			character_stats.update_xp(_xp)

func _update_xp_complete(_obj = null, _key = null):
	state = DONE_ADDING_XP
	xp_label.text = '0'
	for character_stats in all_character_stats:
		if character_stats.character.alive:
			character_stats.add_all_xp(xp)
