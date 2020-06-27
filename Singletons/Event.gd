extends Node

const Fade = preload("res://UI/FadeEffect.tscn")

signal open_menu
signal check_battle
signal display_text(name, text)

signal _map_loaded

# our events
enum {
	WAKE_UP,
}

var events = []
var text_events = []
var current_map : String
var player_direction : Vector2
var player_position : Vector2
var parameters = null

func _ready():
	for _i in range(10):
		events.append(false)

func load_map(map_name, x, y, facing_up):
	Player.can_move = false
	
	var fade_effect = Fade.instance()
	get_tree().root.add_child(fade_effect)
	fade_effect.fade_out()
	yield(fade_effect, "fade_done")

	current_map = map_name
	Player.position.x = x * 16 + 8
	Player.position.y = y * 16 + 8
	player_position = Player.position
	if facing_up:
		Player.position.y += 8
	var _e = get_tree().change_scene(Maps.maps[map_name])
	
	fade_effect.fade_in()
	yield(fade_effect, "fade_done")

	Player.can_move = true
	fade_effect.queue_free()
	emit_signal("_map_loaded")

func start_battle(battle_location):
	player_position = Player.position
	player_direction = Player.direction
	print(battle_location)
	var index = randi() % len(Maps.monsters_at[battle_location])
	# save monsters as parameters for battle scene
	parameters = Maps.monsters_at[battle_location][index]
	var _e = get_tree().change_scene(Maps.maps["Battle"])

func end_battle():
	Player.position = player_position
	Player.direction = player_direction
	var _e = get_tree().change_scene(Maps.maps[current_map])

func open_menu():
	print("open menu")
	emit_signal("open_menu")

func party_died():
	load_map("HouseYuji", 18, 2, false)
	yield(self, "_map_loaded")
	Player.sils /= 2
	for member in Player.party:
		member.hp = member.max_hp
		member.mp = member.max_mp
	display_text("Yuji", "I should really be more careful next time...")

func display_text(name, text):
	emit_signal("display_text", name, text)

# checks if a battle should be started
func check_battle():
	emit_signal("check_battle")
