extends Node

var position = Vector2(19*16 - 8, 3*16 - 8)
var direction = Vector2.DOWN

var Members = {
	'Yuji': preload("res://Fighters/Party/Yuji.tres"),
	'Ximi': preload("res://Fighters/Party/Ximi.tres")
}


var party := []
var weapons := []
var armor := []
var items := {}
var sils = 200 # money

var can_move := true

func _ready():
	# starting party
	party.append(Members.Yuji)
	party.append(Members.Ximi)
	
	# items and equipment you start with in inventory
	armor.append(Equipment.ximis_coat)
	weapons.append(Equipment.pocket_knife)
	weapons.append(Equipment.dagger)
	weapons.append(Equipment.short_sword)
	receive_items('tissue', 3)
	receive_items('handkerchief', 1)

func receive_items(item_name : String, amt = 0) -> void:
	# Adds an item to the player's inventory.
	#
	# item_name: the name of the item being used
	# amt:       the number of times received
	print("Received " + str(amt) + " " + item_name + "(s)")
	if items.has(item_name):
		items[item_name] = min(items[item_name] + amt, 99)
	else:
		items[item_name] = amt

func use_item(character : PartyMember, item_name : String) -> void:
	# uses an item on a character
	#
	# character: the character to use the item on
	# item_name: the name of the item being used
	if items.has(item_name):
		items[item_name] -= 1
		if items[item_name] <= 0:
			var _e = items.erase(item_name)
		var item = Items.all[item_name]
		if item.permanent:
			character.max_hp += item.hp
			character.max_mp += item.mp
		else:
			character.hp += item.hp
			character.mp += item.mp

func num_living_members() -> int:
	var num = 0
	for member in party:
		if member.alive:
			num += 1
	return num
