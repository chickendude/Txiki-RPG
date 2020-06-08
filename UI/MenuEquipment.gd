extends NinePatchRect

onready var cursor = $Cursor
onready var equipped_weapon_label = $Characters/Equipment/EquipVbox/MarginContainer/EquipmentContainer/WeaponContainer/EquippedWeapon
onready var equipped_armor_label = $Characters/Equipment/EquipVbox/MarginContainer/EquipmentContainer/ArmorContainer/EquippedArmor
onready var equipment_container = 	$Characters/Equipment/EquipVbox
# weapon
onready var weapon_container = $Characters/Equipment/WeaponVbox
onready var weapons_label = $Characters/Equipment/WeaponVbox/MarginContainer/WeaponListLabel
# armor
onready var armor_container = $Characters/Equipment/ArmorVbox
onready var armor_label = $Characters/Equipment/ArmorVbox/MarginContainer/ArmorListLabel
# description
onready var description_container = $Characters/Equipment/Description
onready var description_label = $Characters/Equipment/Description/Label

onready var equipment_containers = [
	equipment_container,
	weapon_container,
	armor_container,
]

const Y_OFF = 12
const X_OFF = 8
const CHAR_HEIGHT = 40

const TEXT_X = 60
const TEXT_Y = 30
const TEXT_HEIGHT = 15
const ITEM_HEIGHT = 12
const NUM_TEXTS = 2

signal equipment_menu_closed

enum Action {
	CHAR_SELECT,
	EQUIP_SELECT,
	WPN_SELECT,
	ARM_SELECT,
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
	equipped_weapon_label.text = Player.equipped_weapon.name
	equipped_armor_label.text = Player.equipped_armor.name
	description_label.text = ""
	_start_char_select()
	_load_container(equipment_container)

func _unhandled_input(event):
	accept_event()
	if action == Action.CHAR_SELECT:
		_char_select_keys()
	elif action == Action.EQUIP_SELECT:
		_equip_select_keys()
	else:
		_item_select_keys()

# Character selection

func _start_char_select():
	description_container.visible = false
	cursor.position.y = Y_OFF + CHAR_HEIGHT / 2
	cursor.position.x = X_OFF
	action = Action.CHAR_SELECT

func _char_select_keys():
	if Input.is_action_just_pressed("ui_accept"):
		_start_equip_select()
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("equipment_menu_closed")
		queue_free()
		
# Equipment selection

func _start_equip_select():
	description_container.visible = false
	_load_container(equipment_container)
	cursor.position.y = TEXT_Y
	cursor.position.x = TEXT_X
	action = Action.EQUIP_SELECT

func _equip_select_keys():
	if Input.is_action_just_pressed("ui_down"):
		cursor.position.y = min(cursor.position.y + TEXT_HEIGHT, TEXT_HEIGHT * (NUM_TEXTS - 1) + TEXT_Y)
	if Input.is_action_just_pressed("ui_up"):
		cursor.position.y = max(cursor.position.y - TEXT_HEIGHT, TEXT_Y)
	if Input.is_action_just_pressed("ui_accept"):
		_equip_select()
	if Input.is_action_just_pressed("ui_cancel"):
		_start_char_select()

func _equip_select():
	description_container.visible = true
	var selection = int((cursor.position.y - TEXT_Y) / TEXT_HEIGHT)
	match selection:
		Equipment.WEAPON:
			_start_weapon_select()
		Equipment.ARMOR:
			_start_armor_select()

# Weapon selection

func _start_weapon_select():
	item_list = Player.weapons
	cursor.position.y = TEXT_Y
	cursor.position.x = TEXT_X
	action = Action.WPN_SELECT
	weapons_label.text = _join_array(item_list, Player.equipped_weapon)
	_load_container(weapon_container)
	
# Armor selection

func _start_armor_select():
	item_list = Player.armor
	cursor.position.y = TEXT_Y
	cursor.position.x = TEXT_X
	action = Action.ARM_SELECT
	armor_label.text = _join_array(item_list, Player.equipped_armor)
	_load_container(armor_container)

# Weapon/Armor shared

func _item_select_keys() -> void:
	if Input.is_action_just_pressed("ui_down"):
		cursor.position.y = min(cursor.position.y + ITEM_HEIGHT, ITEM_HEIGHT * (len(item_list) - 1) + TEXT_Y)
	if Input.is_action_just_pressed("ui_up"):
		cursor.position.y = max(cursor.position.y - ITEM_HEIGHT, TEXT_Y)
	if Input.is_action_just_pressed("ui_cancel"):
		_start_equip_select()
	_update_description()

func _load_container(new_container):
	for container in equipment_containers:
		container.visible =  container == new_container

func _join_array(arr, current_item) -> String:
	var joined = ""
	for item in arr:
		if item == current_item:
			joined += "*"
		joined += item.name + '\n'
	if joined:
		joined = joined.left(len(joined) - 1)
	return joined

func _update_description():
	var index = _get_item_index()
	description_label.text = item_list[index].description

func _get_item_index() -> int:
	return int((cursor.position.y - TEXT_Y) / ITEM_HEIGHT)
