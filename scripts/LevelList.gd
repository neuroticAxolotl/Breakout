extends ScrollContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	for level in Settings.levels:
		var list_item = CheckBox.new()
		list_item.text = level.get_state().get_node_name(0)
		$VBoxContainer.add_child(list_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
