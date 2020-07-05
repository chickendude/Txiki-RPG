extends Control

const StatsBox = preload("res://Battle/UI/StatsBox.tscn")
const TRANSPARENT = .5

var stat_boxes := []

func _ready():
	for member in Player.party:
		var stat_box := StatsBox.instance()
		stat_box.load_character(member)
		add_child(stat_box)
		stat_boxes.append(stat_box)

func focus_player(character : PartyMember):
	var index := Player.party.find(character)
	for i in range(len(stat_boxes)):
		var alpha = 1.0 if i == index else TRANSPARENT
		stat_boxes[i].modulate = Color(1, 1, 1, alpha)

func unfocus():
	for stat_box in stat_boxes:
		stat_box.modulate = Color(1, 1, 1, 1)
