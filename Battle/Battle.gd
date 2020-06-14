extends Node2D

onready var ui = $BattleUI
onready var new_combo = $BattleUI/NewCombo

var Monster = preload("res://Fighters/Enemy.tscn")
var Yuji = preload("res://Player/Yuji.tscn")
var DamageNode = preload("res://Battle/DamageNode.tscn")
var HPNode = preload("res://Battle/HPNode.tscn")

var monsters = []
var monster_objs = []
var party = []

const PLAYER_X = 220
const PLAYER_Y = 120
const X1 = 100
const X2 = 80
const SCREEN_H = 240
const Y_SPACING = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	_add_monsters()
	_add_party()
	ui.connect("all_attacks_selected", self, "_all_attacks_selected")
	ui.monsters = monster_objs

func _add_monsters():
	for monster_resource in Event.parameters:
		monsters.append(load(monster_resource))
	for index in range(len(monsters)):
		var monster = monsters[index].duplicate()
		var monster_obj = Monster.instance()
		monster_obj.stats = monster
		monster_obj.position = _get_monster_position(index)
		monster_objs.append(monster_obj)
		add_child(monster_obj)

func _get_monster_position(index : int) -> Vector2:
	var num_monsters = len(monsters)
	var starting_y = SCREEN_H / 2.0 - num_monsters * Y_SPACING / 2.0
	var x
	if num_monsters <= 2:
		x = X1
	else:
		x = X2 if index % 2 else X1
	var y = starting_y + Y_SPACING * index
	return Vector2(x, y)

func _add_party():
	var yuji = Yuji.instance()
	yuji.position = Vector2(PLAYER_X, PLAYER_Y)
	Player.direction = Vector2.LEFT
	yuji.can_move = false
	add_child(yuji)
	ui.party = [yuji]

func _all_attacks_selected(player_attacks : Array, enemy_attacks : Array, player_items : Array) -> void:
	var attacks = player_attacks
	attacks += enemy_attacks
	attacks.sort_custom(self, "_sort_by_speed")
	_use_items(player_items)
	_execute_attacks(attacks)
	
func _sort_by_speed(a, b):
	return a.speed > b.speed

func _use_items(items : Array) -> void:
	# todo: take into account speed
	for item in items:
		Player.use_item(item.target, item.item_name)
		var hp_node = HPNode.instance()
		hp_node.position = Vector2(item.target.position.x, item.target.position.y - 20)
		hp_node.set_amt(Items.all[item.item_name].hp)
		add_child(hp_node)
		yield(get_tree().create_timer(2), "timeout")

func _execute_attacks(attacks : Array) -> void:
	for attack in attacks:
		if not attack.actor.alive:
			continue
		var attacker : KinematicBody2D = attack.actor
		var target_position : Vector2 = attack.target.position
		attacker.starting_position = attacker.position
		if attacker.position.x > target_position.x:
			target_position.x += 12
		else:
			target_position.x -= 12
		attacker.move_to(target_position)
		yield(attacker, "destination_reached")
		var target : KinematicBody2D = attack.target
		if target.stats.has_method("start_attack"):
			target.stats.start_attack()
		var attacks_in_combo = []
		for atk in attack.attacks:
			if target.stats.hp:
				var num_hits = 1 # only hit once by default
				var atk_power : int
				var stats = attacker.stats
				atk_power = stats.attack_lr if atk == Attack.LEFT or atk == Attack.RIGHT else stats.attack_ud
#				match atk:
#					Attack.UP:
#						atk_power = stats.attack_u
#					Attack.DOWN:
#						atk_power = stats.attack_d
#					Attack.LEFT:
#						atk_power = stats.attack_l
#					Attack.RIGHT:
#						atk_power = stats.attack_r
				attacks_in_combo.append(atk)
				var combo = _check_combo(attacks_in_combo)
				if combo:
					if not combo.name in Player.combos_learned:
						new_combo.play_animation()
						yield(new_combo, "animation_done")
						Player.combos_learned.append(combo.name)
					var combo_node = DamageNode.instance()
					combo_node.position = Vector2(target.position.x - randi() % 6, target.position.y  - randi() % 6 - 34)
					combo_node.set_text(combo.name)
					add_child(combo_node)
					atk_power *= combo.power
					num_hits = combo.num_hits
				for _i in range(num_hits):
					if target.stats.hp:
						var damage = target.stats.receive_attack(atk_power, stats.level, atk)
						print(attacker.stats.name + " atk: " + str(damage) + ", " + target.stats.name + " hp left: " + str(target.stats.hp))
						var damage_node = DamageNode.instance()
						damage_node.position = Vector2(target.position.x - randi() % 6, target.position.y  - randi() % 6 - 24)
						damage_node.set_amt(damage)
						add_child(damage_node)
						yield(get_tree().create_timer(.2), "timeout")
				yield(get_tree().create_timer(.4), "timeout")
		attacker.move_to(attacker.starting_position)
		yield(attacker, "destination_reached")
	if _enemies_left():
		ui.open_battle_menu()
	else:
		_battle_won()

func _check_combo(attacks_in_combo : Array):
	var combo_letters = ""
	for attack in attacks_in_combo:
		combo_letters += Attack.Letters[attack]
	print(combo_letters)
	for combo in Player.Combos:
		if combo.moves in combo_letters:
			return combo
	return null

func _enemies_left() -> bool:
	for monster_obj in monster_objs:
		if monster_obj.alive:
			return true
	return false

func _battle_won():
	ui.open_battle_won_screen()
