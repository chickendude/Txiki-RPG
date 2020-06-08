extends Container

onready var name_label = $NameLabel
onready var text_label = $TextLabel
onready var tween = $Tween

const CHAR_DELAY = .03
const WIDTH = 37

var text_queue = []
var text_pos = 0
var current_text : String
var current_line = ""
var end_of_page_index = 0
var lines = []

func _ready():
	text_label.text = ""
	visible = false
	var _e = Event.connect("display_text", self, "_display_text")

func _display_text(name, text):
	for t in _split_text(text):
		text_queue.append([name, t])
	if not visible:
		_display_line()
		visible = true

func _split_text(text : String) -> String:
	var pages = []
	var lines = PoolStringArray()
	var output = ""
	for word in text.split(' '):
		if len(word) + len(output) > WIDTH:
			lines.append(output.strip_edges())
			output = ''
		if len(lines) == 3:
			pages.append(lines.join('\n'))
			lines.resize(0)
		output += ' ' + word
	lines.append(output.strip_edges())
	pages.append(lines.join('\n'))
	return pages

func _display_line():
	text_label.visible_characters = 0
	var dialog = text_queue.pop_front()
	name_label.text = dialog[0]
	text_label.text = dialog[1]
	_start_tween()

func _input(_event):
	if visible:
		accept_event()
		if Input.is_action_just_pressed("ui_accept"):
			if tween.is_active():
				tween.stop_all()
				text_label.visible_characters = -1
			else:
				if len(text_queue):
					_display_line()
				else:
					visible = false

func _start_tween() -> void:
	var text_length = len(text_label.text) - text_label.text.count(' ')
	tween.interpolate_property(text_label, "visible_characters", 0, text_length, CHAR_DELAY * text_length, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
