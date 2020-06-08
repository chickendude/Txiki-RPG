extends Node2D

onready var change_map = $Events/ChangeMap

onready var player = $Objects/Yuji

func _ready():
	player.position = Player.position
	if not Event.events[Event.WAKE_UP]:
		Event.events[Event.WAKE_UP] = true
		Event.display_text("Yuji", "Seems like i slept a bit late...")
		Event.display_text("Yuji", "Ximi was supposed to come get me. Guess I'll have to head next door to find him.")
#	yield(get_tree().create_timer(.2), "timeout")
#	change_map._change_map(null)
