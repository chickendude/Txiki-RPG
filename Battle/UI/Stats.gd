extends Control

const StatsBox = preload("res://Battle/UI/StatsBox.tscn")

var stat_boxes := []

func _ready():
	for member in Player.party:
		var stat_box := StatsBox.instance()
		stat_box.load_character(member)
		add_child(stat_box)
