extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var master_bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus_index, Settings.master_volume)
	
	Events.connect("ball_collided", self, "_on_ball_collided")
	Events.connect("brick_broken", self, "_on_brick_broken")
	Events.connect("ball_hit_floor", self, "_on_ball_hit_floor")
	Events.connect("button_selected", self, "_on_button_selected")
	Events.connect("any_button_pressed", self, "_on_button_pressed")
	

func _on_ball_collided(_collision):
	$Hit.play()

func _on_brick_broken(_value):
	$Explosion.pitch_scale = rand_range(0.7, 1.3)
	$Explosion.play()

func _on_ball_hit_floor(_ball):
	$Explosion2.play()

func _on_button_selected():
	$Select.play()

func _on_button_pressed():
	$Hit.play()
