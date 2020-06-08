extends Node2D

onready var player = $TileMap2/Yuji

func _ready():
	player.position = Player.position
