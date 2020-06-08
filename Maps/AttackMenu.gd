extends Control

const Attack = preload("res://Equipment/Attack.gd")
const AttackArrow = preload("res://Battle/AttackArrow.tscn")

const ARROW_W = 12
const PADDING = 3

onready var attack_container = $AttackContainer

var monsters : Array
var party = []
var attacks = []
var select_target = false
var attacks_preloaded = false
var prev_target_index = 0
var target_index = 0

signal back_button
signal attack_selected(attack)

func _ready():
	select_target = false
	_setup_attack_container()

func input(_delta):
	accept_event()
	if select_target:
		_target_keys()
	else:
		_attack_keys()

func _setup_attack_container():
	var screen_w = ProjectSettings.get_setting("display/window/size/width") 
	attack_container.rect_position.x = screen_w / 2 - Player.attack_bar / 2 - PADDING
	attack_container.rect_size.x = Player.attack_bar + PADDING * 2
	if len(attacks) > Player.attack_bar / ARROW_W:
		attacks.pop_front()
		attack_container.get_child(attack_container.get_child_count()-1).queue_free()

func _clear_attacks():
	attacks = []
	for child in  attack_container.get_children():
		child.queue_free()

# attack selection

func _attack_keys() -> void:
	if Input.is_action_just_pressed("ui_up"):
		_add_attack(Attack.UP)
	if Input.is_action_just_pressed("ui_down"):
		_add_attack(Attack.DOWN)
	if Input.is_action_pressed("ui_left"):
		_add_attack(Attack.LEFT)
	if Input.is_action_pressed("ui_right"):
		_add_attack(Attack.RIGHT)
	if Input.is_action_just_pressed("ui_accept"):
		if attacks:
			_highlight_target()
			select_target = true
	if Input.is_action_just_pressed("ui_cancel"):
		if attacks:
			_clear_attacks()
		else:
			_close_menu()

func _add_attack(direction : int) -> void:
	if attacks_preloaded:
		_clear_attacks()
		attacks_preloaded = false
	if len(attacks) >= int(Player.attack_bar / ARROW_W):
		return
	var attack_arrow = AttackArrow.instance()
	attack_arrow.frame = direction
	attack_arrow.position.x = len(attacks) * ARROW_W + PADDING
	attack_arrow.position.y = PADDING
	attacks.append(direction)
	attack_container.add_child(attack_arrow)

# target selection

func _target_keys():
	if Input.is_action_just_pressed("ui_cancel"):
		_close_menu()
	elif Input.is_action_just_pressed("ui_accept"):
		_attack_selected()
	else:
		if Input.is_action_just_pressed("ui_down"):
			target_index += 1
		if Input.is_action_just_pressed("ui_up"):
			target_index -= 1
		target_index = clamp(target_index, 0, len(monsters) - 1)
		_highlight_target()

func _close_menu():
	select_target = false
	monsters[prev_target_index].modulate = Color(1, 1, 1, 1)
	emit_signal("back_button")

func _highlight_target():
	# check if the target has been queued to be freed, aka dead
	var prev_target = monsters[prev_target_index]
	if not prev_target or not prev_target.alive:
		monsters.remove(prev_target_index)
		prev_target_index = min(len(monsters) - 1, prev_target_index)
		target_index = prev_target_index
	else:
		prev_target.modulate = Color(1, 1, 1, 1)
	prev_target_index = target_index
	monsters[target_index].modulate = Color(.2, .1, .5, .7)
	
func _attack_selected():
	select_target = false
	attacks_preloaded = true
	monsters[target_index].modulate = Color(1, 1, 1, 1)
	monsters[prev_target_index].modulate = Color(1, 1, 1, 1)
	var monster = monsters[target_index]
	var attack = Attack.new()
	attack.attacks = attacks
	attack.actor = party[0]
	attack.target = monster
	attack.speed = party[0].stats.speed
	print("attacking " + monster.stats.name + " with hp: " + str(monster.stats.hp))
	emit_signal("attack_selected", attack)
