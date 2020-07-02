extends CanvasLayer

const Attack = preload("res://Battle/Classes/Attack.gd")

onready var battle_menu = $BattleMenu
onready var attack_menu = $AttackMenu
onready var item_menu = $ItemsMenu
onready var battle_won_screen = $BattleWon
onready var stats = $Stats

var current_menu : Control setget set_current_menu
var monsters setget set_monsters
var party = []
var current_character : Fighter
var player_attacks = []
var player_items = []
var enemy_attacks = []
var xp = 0
var sils = 0
var starting_keys_released = false

signal all_attacks_selected(player_attacks, enemy_attacks, player_items)

func _ready() -> void:
	attack_menu.hide()
	battle_won_screen.hide()
	item_menu.hide()
	self.current_menu = battle_menu
	battle_menu.connect("open_attack_menu", self, "_open_attack_menu")
	battle_menu.connect("open_item_menu", self, "_open_item_menu")
	battle_menu.connect("back_button", self, "_load_previous_character")
	attack_menu.connect("back_button", self, "_open_battle_menu")
	attack_menu.connect("attack_selected", self, "_player_attack_selected")
	item_menu.connect("close_menu", self, "open_battle_menu")
	item_menu.connect("item_selected", self, "_on_item_selected")

func _input(event):
	if not starting_keys_released:
		_check_all_keys_released()
	elif current_menu and current_menu.has_method("input"):
		current_menu.input(event)

func load_battle_ui(_party : Array, _monsters : Array):
	party = _party
	self.monsters = _monsters
	reload_battle_ui()

func reload_battle_ui():
	current_character = party[0]
	current_character.start_highlight()
	yield(get_tree(), "idle_frame")
	_open_battle_menu()

func set_current_menu(menu : Control) -> void:
	if current_menu:
		current_menu.visible = false
	menu.visible = true
	current_menu = menu

func set_monsters(_monsters):
	monsters = _monsters
	# calculate xp and sils for winning the battle
	for monster in monsters:
		xp += monster.stats.xp
		sils += monster.stats.sils
	var num_monsters = len(monsters)
	# xp gets a bonus of: (num_monsters ^ 2 - 50) / (num_monsters ^ 2 + 50) + 2
	xp *= (num_monsters * num_monsters - 50) / (num_monsters * num_monsters + 50) + 2
	# sils gets a bonus of: (num_monsters / 8) + 1
	sils *= num_monsters / 8 + 1

# internal functions

func _check_all_keys_released():
	starting_keys_released = true
	for key in ['ui_left', 'ui_up', 'ui_right', 'ui_down']:
		if Input.is_action_pressed(key):
			starting_keys_released = false

func _load_character(new_index : int) -> void:
	current_character.end_highlight()
	current_character = party[new_index]
	current_character.start_highlight()
	stats.focus_player(current_character.stats)

func _load_next_character():
	var index = party.find(current_character)
	_load_character(index + 1)
	if not current_character.alive:
		_player_attack_selected(null)

func _load_previous_character():
	var _e = player_attacks.pop_front()
	var index = party.find(current_character) - 1
	while not party[index].alive and index > 0:
		index -= 1
	if index < 0:
		_flee()
	else:
		_load_character(index)
		_open_battle_menu()

func _flee():
	Event.end_battle()

# menu functions

func _close_menu() -> void:
	current_menu.visible = false
	current_menu = null

func _open_attack_menu() -> void:
	attack_menu.load_attack_container(current_character, monsters)
	self.current_menu = attack_menu

func _open_item_menu() -> void:
	item_menu.character = current_character
	item_menu.load_items()
	self.current_menu = item_menu

func _open_battle_menu() -> void:
	stats.focus_player(current_character.stats)
	self.current_menu = battle_menu

func open_battle_won_screen() -> void:
	stats.visible = false
	battle_won_screen.load_prizes(xp, sils)
	self.current_menu = battle_won_screen

# handling attacks

func _player_attack_selected(attack : Attack) -> void:
	if attack:
		player_attacks.append(attack)
	if len(player_attacks) == Player.num_living_members():
		current_character.end_highlight()
		_dispatch_attacks()
	else:
		_load_next_character()
		_open_battle_menu()

func _dispatch_attacks() -> void:
	stats.unfocus()
	_close_menu()
	enemy_attacks = _enemy_attacks()
	emit_signal("all_attacks_selected", player_attacks, enemy_attacks, player_items)
	player_attacks = []
	player_items = []
	
func _enemy_attacks() -> Array:
	var attacks = []
	for monster in monsters:
		var attack = Attack.new()
		attack.actor = monster
		attack.attacks = [Attack.UP]
		attack.speed = monster.stats.speed
		var first_choice = randi() % party.size()
		attack.targets.append(party[first_choice])
		for i in range(len(party)):
			if i != first_choice:
				attack.targets.append(party[i])
		attacks.append(attack)
	return attacks

func _on_item_selected(item_attack: ItemAttack) -> void:
	player_items.append(item_attack)
	_dispatch_attacks()
