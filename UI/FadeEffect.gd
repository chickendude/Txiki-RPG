extends CanvasLayer


onready var tween = $Tween
onready var color_rect = $ColorRect

signal fade_done

func fade_out():
	tween.interpolate_property(color_rect, "modulate:a", 0, 1, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	tween.connect("tween_completed", self, "_tween_done")

func fade_in():
	tween.interpolate_property(color_rect, "modulate:a", 1, 0, .5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()

func _tween_done(_a, _b):
	emit_signal("fade_done")
