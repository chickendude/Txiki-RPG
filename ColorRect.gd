extends ColorRect

var duration = 10
var pos := 0.0

func _ready():
	var start_color = self.color
	var end_color = Color(0,0,0,1)
	$Tween.interpolate_property(self, 'color', start_color, end_color, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_update_color()
	

func _update_color():
	pos = min(pos + .5, duration)
	$Tween.seek(pos)
	get_tree().create_timer(1).connect("timeout", self, "_update_color")
