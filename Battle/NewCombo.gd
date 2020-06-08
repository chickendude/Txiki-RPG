extends PanelContainer


onready var tween = $Tween

signal animation_done

# Called when the node enters the scene tree for the first time.
func _ready():
	margin_left = 320

func play_animation():
	rect_position.x = 0
	margin_left = 320
	margin_right = 0
	tween.interpolate_property(self, "margin_left", 320, 0, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()
	yield(tween, "tween_completed")
	print("done")
	tween.interpolate_property(self, "rect_position:x", 0, -320, .3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("animation_done")
