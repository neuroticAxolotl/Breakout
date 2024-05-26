extends ColorRect


var _err

# Called when the node enters the scene tree for the first time.
func _ready():
	_err = Events.connect("setting_changed", self, "_update_visibility")
	_update_visibility()

func _update_visibility():
	visible = Settings.crt_filter_on

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
