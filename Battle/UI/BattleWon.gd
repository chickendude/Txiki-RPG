extends Control

onready var xp_label = $NinePatchRect/VBoxContainer/HBoxContainer/XPLabel
onready var sil_label = $NinePatchRect/VBoxContainer/HBoxContainer2/SilLabel
onready var xp_left_label = $NinePatchRect/VBoxContainer/HBoxContainer3/XPLeftLabel
onready var next_level_label = $NinePatchRect/VBoxContainer/HBoxContainer3/NextLevelLabel
onready var level_up_container = $NinePatchRect/VBoxContainer/LevelUpContainer
onready var level_label = $NinePatchRect/VBoxContainer/LevelUpContainer/HBoxContainer4/LevelLabel

func _ready():
	# todo: connect to party members' level up signals
	var _e = Player.connect("level_up", self, "_on_level_up")
	level_up_container.visible = false
	

func input(_delta):
	accept_event()
	if Input.is_action_just_pressed("ui_cancel") or Input.is_action_just_pressed("ui_accept"):
		Event.end_battle()

func load_prizes(xp : int, sils : int) -> void:
	xp_label.text = str(xp)
	sil_label.text = str(sils)
	for member in Player.party:
		if member.alive:
			member.xp += xp
		xp_left_label.text = str(member.xp_until_next_level())
		next_level_label.text = str(member.level + 1)

	Player.sils += sils

func _on_level_up():
	level_up_container.visible = true
	level_label.text = str(Player.level)