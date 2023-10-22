extends Node2D


var ball_scene = preload("res://scenes/Ball.tscn")
var current_ball_id

var level_score = 0

var levels = [preload("res://scenes/Level0.tscn")]
var current_level_id
var current_level_index = 0
var level_max_score = 0

var is_game_over : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# make rng random
	randomize()
	
	load_level(0)
	
	Events.connect("ball_stuck", self, "respawn_ball")
	Events.connect("ball_hit_floor", self, "respawn_ball")
	
	Events.connect("brick_broken", self, "_on_brick_broken")
	Events.connect("level_cleared", self, "_on_level_cleared")
	Events.connect("game_over", self, "_on_game_over")
	
	# the paddle listens for ball_spawn_init, and lets the player choose where to serve the ball.
	# paddle emits ball_served with the desired spawn position when the player hits a key.
	# this script is listening for ball_served, and activates spawn_ball() at the position
	Events.connect("ball_served", self, "spawn_ball")
	Events.emit_signal("ball_spawn_init")


func spawn_ball(ball_position : Vector2):
	var ball = ball_scene.instance()
	
	ball.position = ball_position
	ball.direction = Vector2(rand_range(-0.3, 0.3), -1)
	
	current_ball_id = ball.get_instance_id()
	
	Events.emit_signal("ball_spawned", current_ball_id)
	
	self.call_deferred("add_child_below_node", $Background, ball)


func load_level(level_index):
	if current_level_id != null:
		instance_from_id(current_level_id).queue_free()
	
	var new_level = levels[level_index].instance()
	
	current_level_id = new_level.get_instance_id()
	
	level_max_score = 0
	for brick in new_level.get_children():
		level_max_score += brick.value
	
	self.call_deferred("add_child_below_node", $Background, new_level)


func respawn_ball(ball):
	ball.queue_free()
	if not Events.is_game_over:
		Events.emit_signal("ball_spawn_init")


func _on_brick_broken(value):
	level_score += value
	if level_score >= level_max_score:
		level_score = 0
		Events.emit_signal("level_cleared")


func _on_level_cleared():
	respawn_ball(instance_from_id(current_ball_id))
	var next_level_index = current_level_index + 1
	if next_level_index >= levels.size():
		next_level_index = 0
	load_level(next_level_index)
	current_level_index = next_level_index


func _on_game_over(_score):
	is_game_over = true

