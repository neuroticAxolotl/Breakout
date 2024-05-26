extends Node

var _err

func _enter_tree():
	update_volume_settings()
	
	_err = Events.connect("ball_collided", self, "_on_ball_collided")
	_err = Events.connect("brick_broken", self, "_on_brick_broken")
	_err = Events.connect("ball_hit_floor", self, "_on_ball_hit_floor")
	_err = Events.connect("button_selected", self, "_on_button_selected")
	_err = Events.connect("button_pressed", self, "_on_button_pressed")
	_err = Events.connect("setting_changed", self, "update_volume_settings")
	
	if get_tree().is_connected("node_added", self, "_on_node_added") == false:
		_err = get_tree().connect("node_added", self, "_on_node_added")

func _on_node_added(node:Node) -> void:
	if node is Button:
		if node.is_connected("mouse_entered", self, "_on_button_selected") == false:
			_err = node.connect("mouse_entered", self, "_on_button_selected")
		if node.is_connected("pressed", self, "_on_button_pressed") == false:
			_err = node.connect("pressed", self, "_on_button_pressed")


func update_volume_settings():
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus_index, Settings.master_volume)

func _on_ball_collided(_collision):
	$Hit.play()

func _on_brick_broken(_value):
	$Explosion.pitch_scale = rand_range(0.7, 1.3)
	$Explosion.play()

func _on_ball_hit_floor(_ball):
	$Explosion2.play()

func _on_button_selected():
	$Click.play()


func _on_button_pressed():
	$Select.play()
