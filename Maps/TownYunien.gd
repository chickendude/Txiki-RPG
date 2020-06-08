extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var player = $TileMap3/Yuji
onready var camera = $Camera2D

const MAP_W = 57 * 16
const MAP_H = 39 * 16

# Called when the node enters the scene tree for the first time.
func _ready():
	player.position = Player.position
	camera.limit_right = MAP_W + 8
	camera.limit_bottom = MAP_H + 8
