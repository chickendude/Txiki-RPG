extends Node2D

const WIDTH = 80
const Y = 205

var character : PartyMember

func load_character(_character : PartyMember):
	var party_size = len(Player.party)
	var index = Player.party.find(_character)

	var screen_w = ProjectSettings.get_setting("display/window/size/width")
	position.x = (screen_w - party_size * WIDTH) / 2 + index * WIDTH + WIDTH/2 # WIDTH / 2 is because the position is based in the center
	position.y = Y
	
	character = _character
	$NameLabel.text = character.name
	$LevelLabel.text = str(character.level)
	$MaxHPLabel.text = str(character.max_hp)
	$MPLabel.text = str(character.mp)
	$MaxMPLabel.text = str(character.max_mp)
	_update_hp_label(character.hp)
	
	var _e = character.connect("hp_changed", self, "_on_hp_changed")

func _on_hp_changed(old_hp, new_hp):
	# todo: switch to Tween for health change animation
	$Tween.interpolate_method(self, '_update_hp_label', old_hp, new_hp, 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func _update_hp_label(_hp):
	$HPLabel.text = str(int(_hp))
