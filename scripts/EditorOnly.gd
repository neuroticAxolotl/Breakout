tool
extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# delete self if not in editor
	if not Engine.editor_hint:
		self.queue_free()

