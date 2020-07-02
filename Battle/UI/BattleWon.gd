extends Control

onready var xp_label = $NinePatchRect/VBoxContainer/HBoxContainer/XPLabel
onready var sil_label = $NinePatchRect/VBoxContainer/HBoxContainer2/SilLabel
onready var vbox_container = $NinePatchRect/VBoxContainer

const CharacterStats = preload("res://Battle/UI/CharacterStats.tscn")

var xp : int
var added_xp := false
var all_character_stats = []


func input(_delta):
	accept_event()
	if not added_xp:
		if Input.is_action_just_pressed("ui_accept"):
			_add_xp()
	else:
		if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
			Event.end_battle()

func load_prizes(_xp : int, sils : int) -> void:
	xp = _xp
	xp_label.text = str(xp)
	sil_label.text = str(sils)
	for member in Player.party:
		var character_stats := CharacterStats.instance()
		character_stats.load_character(member)
		vbox_container.add_child(character_stats)
		all_character_stats.append(character_stats)
	Player.sils += sils

func _add_xp():
	added_xp = true
	for character_stats in all_character_stats:
		if character_stats.character.alive:
			character_stats.load_xp(xp)

func _on_level_up(member : PartyMember):
	pass
