extends CanvasLayer

const Attack = preload("res://Equipment/Attack.gd")

onready var battle_menu = $BattleMenu
onready var attack_menu = $AttackMenu
onready var item_menu = $ItemsMenu
onready var battle_won_screen = $BattleWon
onready var stats = $Stats

var current_menu : Control setget set_current_menu
var monsters setget set_monsters
var party = []
var current_character : PartyMember
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
	_load_next_character()
	self.current_menu = battle_menu
	battle_menu.connect("open_attack_menu", self, "_open_attack_menu")
	battle_menu.connect("open_item_menu", self, "_open_item_menu")
	attack_menu.connect("back_button", self, "open_battle_menu")
	attack_menu.connect("attack_selected", self, "_player_attack_selected")
	item_menu.connect("close_menu", self, "open_battle_menu")
	item_menu.connect("item_selected", self, "_on_item_selected")

func _input(delta) -> void:
	if not starting_keys_released:
		_check_all_keys_released()
	elif current_menu and current_menu.has_method("input"):
		current_menu.input(delta)

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

func _load_next_character():
	# todo: handle fainted characters and move _dispatch_attacks call here
	var index = len(player_attacks)
	current_character = Player.party[index]

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

func open_battle_menu() -> void:
	self.current_menu = battle_menu

func open_battle_won_screen() -> void:
	stats.visible = false
	battle_won_screen.load_prizes(xp, sils)
	self.current_menu = battle_won_screen

# handling attacks

func _player_attack_selected(attack) -> void:
	player_attacks.append(attack)
	# todo: handle fainted party members
	if len(player_attacks) == len(Player.party):
		_dispatch_attacks()
	else:
		_load_next_character()
		open_battle_menu()

func _dispatch_attacks() -> void:
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
		attack.target = party[0]
		attack.attacks = [Attack.UP]
		attack.speed = monster.stats.speed
		attacks.append(attack)
	return attacks

func _on_item_selected(item_attack: ItemAttack) -> void:
	player_items.append(item_attack)
	_dispatch_attacks()
