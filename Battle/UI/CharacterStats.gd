extends HBoxContainer

const HPNode = preload("res://Battle/Effects/HPNode.tscn")

onready var sprite = $Sprite
onready var character_name = $NameLabel
onready var xp_left = $XPLeftLabel
onready var not_level_up_label = $NotLevelUpLabel
onready var level_up_label = $LevelUpLabel
onready var next_level = $NextLevelLabel

var character : PartyMember
var added_xp : int

func _ready():
	character_name.text = character.name
	xp_left.text = str(character.xp_until_next_level())
	not_level_up_label.visible = true
	level_up_label.visible = false
	next_level.text = str(character.level + 1)

func load_character(_character : PartyMember) -> void:
	character = _character

func update_xp(_xp):
	var next_lev = character.xp_until_next_level()
	var xp = character.xp_until_next_level() - (_xp - added_xp)
	xp = max(xp, 0)
	xp_left.text = str(int(xp))

	if xp == 0:
		character.xp += _xp - added_xp
		added_xp = _xp
		next_level.text = str(character.level + 1)
		level_up_label.show()
