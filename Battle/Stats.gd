extends Control
#
#onready var name_label = $HBoxContainer/VBoxContainer/NinePatchRect/NameContainer/NameLabel
#onready var level_label = $HBoxContainer/VBoxContainer/NinePatchRect/NameContainer/LevelLabel
#onready var hp_label = $HBoxContainer/VBoxContainer/StatsContainer/VBoxContainer/HPContainer/HPLabel
#onready var max_hp_label = $HBoxContainer/VBoxContainer/StatsContainer/VBoxContainer/HPContainer/MaxHPLabel
#onready var mp_label = $HBoxContainer/VBoxContainer/StatsContainer/VBoxContainer/MPContainer/MPLabel
#onready var max_mp_label = $HBoxContainer/VBoxContainer/StatsContainer/VBoxContainer/MPContainer/MaxMPLabel

const StatsBox = preload("res://Battle/StatsBox.tscn")

var stat_boxes := []

func _ready():
#	name_label.text = Player._name
#	level_label.text = str(Player.level)
#	max_hp_label.text = str(Player.max_hp)
#	max_mp_label.text = str(Player.max_mp)
#	_hp_changed()
#	_mp_changed()
#	var _e = Player.connect("hp_changed", self, "_hp_changed")
	for member in Player.party:
		var stat_box := StatsBox.instance()
		stat_box.load_character(member)
		add_child(stat_box)
		
#
#func _hp_changed():
#	hp_label.text = str(Player.hp)
#
#func _mp_changed():
#	mp_label.text = str(Player.mp)
