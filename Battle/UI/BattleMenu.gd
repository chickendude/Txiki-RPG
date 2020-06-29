extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var attack_rect = $AttackRect
onready var item_rect = $ItemRect
onready var magic_rect = $MagicRect
onready var spirit_rect = $SpiritRect

var starting_color : Color


signal back_button
signal open_attack_menu
signal open_item_menu
#signal open_magic_menu

func _ready():
	starting_color = attack_rect.color

func input(_event):
	accept_event()
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("back_button")
	if Input.is_action_pressed("battle_attack"):
		_highlight_button(attack_rect)
	elif Input.is_action_pressed("battle_item"):
		_highlight_button(item_rect)
	elif Input.is_action_pressed("battle_magic"):
		_highlight_button(magic_rect)
	elif Input.is_action_pressed("battle_spirit"):
		_highlight_button(spirit_rect)
	else:
		_highlight_button(null)
	
	if Input.is_action_just_released("battle_attack") or Input.is_action_pressed("ui_accept"):
		emit_signal("open_attack_menu")
	if Input.is_action_just_released("battle_item"):
		emit_signal("open_item_menu")
	

func _highlight_button(pressed_rect):
	for rect in [attack_rect, item_rect, magic_rect, spirit_rect]:
		if rect == pressed_rect:
			rect.color = Color(.5, .5, .2, 1)
		else:
			rect.color = starting_color
