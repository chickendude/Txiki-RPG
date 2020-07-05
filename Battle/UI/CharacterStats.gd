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
var starting_level : int

func _ready():
	character_name.text = character.name
	xp_left.text = str(character.xp_until_next_level())
	not_level_up_label.visible = true
	level_up_label.visible = false
	next_level.text = str(character.level + 1)

func load_character(_character : PartyMember) -> void:
	character = _character
	starting_level = character.level

func update_xp(_xp):
	var next_lev_xp = character.xp_until_next_level() - (_xp - added_xp)
	next_lev_xp = max(next_lev_xp, 0)
	xp_left.text = str(int(next_lev_xp))

	if next_lev_xp == 0:
		character.xp += _xp - added_xp
		added_xp = _xp
		next_level.text = str(character.level + 1)
		level_up_label.show()

func add_all_xp(xp):
	character.xp += xp - added_xp
	xp_left.text = str(character.xp_until_next_level())
	next_level.text = str(character.level + 1)
	level_up_label.visible = starting_level != character.level
