extends NinePatchRect

onready var cursor = $Cursor

enum {
	ITEM,
	EQUIPMENT,
	STATS,
	EXIT
}

const START_Y = 9
const HEIGHT = 11
const NUM_OPTIONS = 4

var active = false

func _ready():
	visible = false
	var _e = Event.connect("open_menu", self, "_open_menu")

func _unhandled_input(_event):
	if visible and active:
		accept_event()
		if Input.is_action_just_pressed("ui_down"):
			cursor.position.y = min(cursor.position.y + HEIGHT, START_Y + HEIGHT * (NUM_OPTIONS - 1))
		elif Input.is_action_just_pressed("ui_up"):
			cursor.position.y = max(cursor.position.y - HEIGHT, START_Y)
		elif Input.is_action_just_pressed("ui_accept"):
			_select_option()
		elif Input.is_action_just_pressed("ui_cancel"):
			_close_menu()

func _select_option() -> void:
	var option = int((cursor.position.y - START_Y) / HEIGHT)
	match option:
		ITEM:
			_open_item_menu()
		EQUIPMENT:
			_open_equipment_menu()
		STATS:
			_open_stats_menu()
		EXIT:
			_close_menu()

func _open_menu() -> void:
	cursor.position.y = START_Y
	active = true
	visible = true

func _close_menu() -> void:
	visible = false
	active = false

func _open_item_menu() -> void:
	var MenuItems = load("res://UI/MenuItems.tscn")
	var menuItems = MenuItems.instance()
	# parent should be UI
	
	active = false
	menuItems.connect("menu_closed", self, "_return_to_menu")
	get_parent().add_child(menuItems)

func _open_equipment_menu() -> void:
	var EquipmentMenu = load("res://UI/MenuEquipment.tscn")
	var equipmentMenu = EquipmentMenu.instance()
	# parent should be UI
	
	active = false
	equipmentMenu.connect("equipment_menu_closed", self, "_return_to_menu")
	get_parent().add_child(equipmentMenu)

func _open_stats_menu() -> void:
	var StatsMenu = load("res://UI/MenuStats.tscn")
	var statsMenu = StatsMenu.instance()
	# parent should be UI
	
	active = false
	statsMenu.connect("menu_closed", self, "_return_to_menu")
	get_parent().add_child(statsMenu)

func _return_to_menu():
	active = true
