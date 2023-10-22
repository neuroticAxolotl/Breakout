tool
extends NinePatchRect


onready var default_sprite = preload("res://sprites/box_black_bg.png")
onready var selected_sprite = preload("res://sprites/box_black_bg_thick.png")

export var label_text : String = "BUTTON" setget set_label_text
export var label_font_size : int = 22 setget set_label_size

export var signal_name : String = "" setget set_signal_name


# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("mouse_entered", self, "_on_mouse_entered")
	self.connect("mouse_exited", self, "_on_mouse_exited")


func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			Events.emit_signal(signal_name)
			Events.emit_signal("any_button_pressed")


func _on_mouse_entered():
	texture = selected_sprite
	Events.emit_signal("button_selected")


func _on_mouse_exited():
	texture = default_sprite


func set_label_text(new_text):
	label_text = new_text
	$Label.text = label_text


func set_label_size(new_size):
	var font = $Label.get_font("font", "")
	label_font_size = new_size
	font.size = label_font_size
	$Label.add_font_override("font", font)


func set_signal_name(new_signal_name):
	signal_name = new_signal_name


