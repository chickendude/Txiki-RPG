extends NinePatchRect

onready var choices_list = $ChoicesListLabel
onready var cursor = $Cursor

const LINE_HEIGHT = 9
const PADDING = 6
const CURSOR_Y = 10

var num_choices : int
var choices_text = ""

signal back_pressed
signal choice_selected(choice)

func _ready():
	choices_list.text = choices_text
	rect_size.y = num_choices * LINE_HEIGHT + PADDING * 2
	cursor.position.y = CURSOR_Y

func _unhandled_input(_event):
	accept_event()
	if Input.is_action_just_pressed("ui_down"):
		cursor.position.y = min(cursor.position.y + LINE_HEIGHT, LINE_HEIGHT * (num_choices - 1) + CURSOR_Y)
	if Input.is_action_just_pressed("ui_up"):
		cursor.position.y = max(cursor.position.y - LINE_HEIGHT, PADDING)
	if Input.is_action_just_pressed("ui_accept"):
		var choice = (cursor.position.y - CURSOR_Y) / num_choices
		emit_signal("choice_selected", choice)
		queue_free()
	if Input.is_action_just_pressed("ui_cancel"):
		emit_signal("back_pressed")
		queue_free()

func load_choices(choices : Array):
	num_choices = len(choices) + 1
	choices_text = ""
	for choice in choices:
		choices_text += choice + '\n'
	choices_text += 'Close'

