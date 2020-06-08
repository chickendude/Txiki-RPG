extends NinePatchRect

onready var cursor = $Cursor
onready var detailed_stats = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/DetailedStatsContainer
onready var player_name_label = $Characters/Stats/StatsVbox/HBoxContainer/NameLabel
onready var level_label = $Characters/Stats/StatsVbox/HBoxContainer/LevelLabel
onready var cur_hp_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/HPContainer/CurHPLabel
onready var max_hp_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/HPContainer/MaxHPLabel
onready var cur_mp_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/MPContainer/CurMPLabel
onready var max_mp_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/MPContainer/MaxMPLabel
onready var atk_l_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/DetailedStatsContainer/ATKL/ATKLLabel
onready var atk_r_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/DetailedStatsContainer/ATKR/ATKRLabel
onready var atk_u_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/DetailedStatsContainer/ATKU/ATKULabel
onready var atk_d_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/DetailedStatsContainer/ATKD/ATKDLabel
onready var def_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/DetailedStatsContainer/DEF/DefLabel
onready var spd_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/DetailedStatsContainer/SPD/SpeedLabel
onready var xp_left_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/XPContainer/XPLeftLabel
onready var next_level_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/XPContainer/NextLevelLabel
onready var sils_label = $Characters/Stats/StatsVbox/MarginContainer/BasicStatsContainer/SilsContainer/SilsLabel

const Y_OFF = 12
const X_OFF = 8
const CHAR_HEIGHT = 40

const TEXT_X = 60
const TEXT_Y = 30
const TEXT_HEIGHT = 15
const ITEM_HEIGHT = 12
const NUM_TEXTS = 2

signal menu_closed

enum Action {
	CHAR_SELECT,
	DETAILED_STATS,
}

enum Equipment {
	WEAPON,
	ARMOR,
}

var action = Action.CHAR_SELECT
var item_list = []
var list_size = 0

# overwritten functions

func _ready():
	cursor.position.y = Y_OFF + CHAR_HEIGHT / 2
	cursor.position.x = X_OFF
	player_name_label.text = Player._name
	level_label.text = str(Player.level)
	cur_hp_label.text = str(Player.hp)
	cur_mp_label.text = str(Player.mp)
	max_hp_label.text = str(Player.max_hp)
	max_mp_label.text = str(Player.max_mp)
	atk_l_label.text = str(Player.attack_l)
	atk_r_label.text = str(Player.attack_r)
	atk_u_label.text = str(Player.attack_u)
	atk_d_label.text = str(Player.attack_d)
	def_label.text = str(Player.defense)
	spd_label.text = str(Player.speed)
	xp_left_label.text = str(Player.xp_until_next_level())
	next_level_label.text = str(Player.level + 1)
	sils_label.text = str(Player.sils)
	_start_char_select()

func _unhandled_input(_event):
	accept_event()
	if action == Action.CHAR_SELECT:
		_char_select_keys()
	else:
		_detailed_stats_keys()

# Character selection

func _start_char_select():
	detailed_stats.visible = false
	cursor.position.y = Y_OFF + CHAR_HEIGHT / 2
	cursor.position.x = X_OFF
	action = Action.CHAR_SELECT

func _char_select_keys():
	if Input.is_action_just_pressed("ui_accept"):
		_show_detailed_stats()
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("menu_closed")
		queue_free()
		
# Detailed Stats

func _show_detailed_stats():
	detailed_stats.visible = true
	action = Action.DETAILED_STATS

func _detailed_stats_keys():
	if Input.is_action_just_pressed("ui_cancel"):
		_start_char_select()
