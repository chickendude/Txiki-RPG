extends PanelContainer

onready var cursor = $Cursor
onready var items_list_label = $Node2D/ItemsListLabel
onready var description_label = $Node2D/ItemDescriptionContainer/ItemDescriptionLabel
onready var description_container = $Node2D/ItemDescriptionContainer

const PopupMenu = preload("res://UI/MenuPopup.tscn")
const ItemAttack = preload("res://Items/Item.gd")

const TEXT_X = 7
const TEXT_Y = 7
const ITEM_HEIGHT = 9

var party = []

signal close_menu
signal item_selected(item)

# overwritten functions

func _ready():
	cursor.position.y = TEXT_Y
	cursor.position.x = TEXT_X
	_update_description()

func _unhandled_input(_event):
	accept_event()
	_item_select_keys()

func load_items():
	if len(Player.items):
		items_list_label.text = _join_dictionary(Player.items)
		cursor.visible = true
		description_container.visible = true
	else:
		items_list_label.text = "- You have no items! -"
		cursor.visible = false
		description_container.visible = false

func _item_select_keys() -> void:
	if Input.is_action_just_pressed("ui_down"):
		_cursor_up()
	if Input.is_action_just_pressed("ui_up"):
		cursor.position.y = max(cursor.position.y - ITEM_HEIGHT, TEXT_Y)
		_update_description()
	if Input.is_action_just_pressed("ui_accept"):
		_open_item()
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("close_menu")

func _cursor_up():
	cursor.position.y = min(cursor.position.y + ITEM_HEIGHT, ITEM_HEIGHT * (len(Player.items) - 1) + TEXT_Y)
	_update_description()

func _join_dictionary(item_dict : Dictionary) -> String:
	var joined = ""
	for key in item_dict.keys():
		joined += Items.all[key].name + ' x ' + str(Player.items[key]) + '\n'
	if joined:
		joined = joined.left(len(joined) - 1)
	return joined

func _update_description():
	if Player.items:
		var index = _get_item_index()
		var item_name = Player.items.keys()[index]
		description_label.text = Items.all[item_name].description

func _get_item_index() -> int:
	return int((cursor.position.y - TEXT_Y) / ITEM_HEIGHT)

func _open_item() -> void:
	if Player.items:
		var popup = PopupMenu.instance()
		popup.load_choices(["Use"])
		popup.connect("choice_selected", self, "_choice_made")
		get_parent().add_child(popup)

func _choice_made(choice : int) -> void:
	if choice == 0:
		_use_item()

func _use_item() -> void:
	var index = _get_item_index()
	var item = Player.items.keys()[index]
	var item_attack = ItemAttack.new()
	item_attack.item_name = item
	item_attack.actor = party[0]
	item_attack.target = party[0]
	emit_signal("item_selected", item_attack)
#	Player.use_item(item)
#	_load_items()
#	if _get_item_index() >= len(Player.items):
#		_cursor_up()
#	description_label.text = "Used " + item + "!"
#	yield(get_tree().create_timer(1), "timeout")
#	_update_description()
