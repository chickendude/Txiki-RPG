extends HBoxContainer

onready var sprite = $Sprite
onready var character_name = $NameLabel
onready var xp_left = $XPLeftLabel
onready var not_level_up_label = $NotLevelUpLabel
onready var level_up_label = $LevelUpLabel
onready var next_level = $NextLevelLabel
onready var tween = $Tween

var character : PartyMember
var added_xp : int
var total_xp : int

func _ready():
	character_name.text = character.name
	xp_left.text = str(character.xp_until_next_level())
	not_level_up_label.visible = true
	level_up_label.visible = false
	next_level.text = str(character.level + 1)

func load_character(_character : PartyMember) -> void:
	character = _character

func load_xp(xp) -> void:
	added_xp = 0
	total_xp = xp
	tween.interpolate_method(self, '_update_xp', 0, total_xp, 2, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
	tween.connect("tween_completed", self, '_update_xp_complete')

func _update_xp(_xp):
	var next_lev = character.xp_until_next_level()
	var xp = character.xp_until_next_level() - (_xp - added_xp)
	xp = max(xp, 0)
	xp_left.text = str(int(xp))

	if xp == 0:
		character.xp += _xp - added_xp
		added_xp = _xp
		next_level.text = str(character.level + 1)

func _update_xp_complete(_obj, _key):
	character.xp += total_xp - added_xp
