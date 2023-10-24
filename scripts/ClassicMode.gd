extends Node2D


var ball_scene = preload("res://scenes/Ball.tscn")
var current_ball_id

var levels = [preload("res://scenes/Level0.tscn")]
var current_level_id
var current_level_index = 0
var level_max_score = 0
var level_score = 0

var total_score = 0
var lives = 3


# Called when the node enters the scene tree for the first time.
func _ready():
	# make rng random
	randomize()
	
	load_level(0)
	
	Events.connect("ball_hit_floor", self, "respawn_ball")
	Events.connect("ball_stuck", self, "_on_ball_stuck")
	Events.connect("brick_broken", self, "_on_brick_broken")
	Events.connect("level_cleared", self, "_on_level_cleared")
	Events.connect("game_over", self, "_on_game_over")
	Events.connect("retry_button_pressed", self, "_on_game_restart")
	Events.connect("exit_button_pressed", self, "_on_game_exit")
	Events.connect("ball_served", self, "spawn_ball")
	
	Events.emit_signal("ball_spawn_init")


func spawn_ball(ball_position : Vector2):
	var ball = ball_scene.instance()
	
	ball.position = ball_position
	ball.direction = Vector2(rand_range(-0.3, 0.3), -1)
	
	current_ball_id = ball.get_instance_id()
	
	Events.emit_signal("ball_spawned", current_ball_id)
	
	self.call_deferred("add_child_below_node", $Background, ball)


func load_level(level_index : int):
	
	# delete old level if there is one
	if current_level_id != null:
		instance_from_id(current_level_id).queue_free()
	
	var new_level = levels[level_index].instance()
	
	current_level_id = new_level.get_instance_id()
	
	# used to determine when a level is complete
	level_max_score = 0
	for brick in new_level.get_children():
		level_max_score += brick.value
	
	self.call_deferred("add_child_below_node", $Background, new_level)


func respawn_ball(ball):
	ball.queue_free()
	lives -= 1
	Events.emit_signal("lives_changed", lives)
	if lives > 0:
		Events.emit_signal("ball_spawn_init")
	else:
		Events.emit_signal("game_over", total_score)


func _on_ball_stuck(ball):
	ball.queue_free()
	Events.emit_signal("ball_spawn_init")


func _on_brick_broken(value : int):
	level_score += value
	total_score += value
	
	Events.emit_signal("score_changed", total_score)
	
	if level_score >= level_max_score:
		level_score = 0
		Events.emit_signal("level_cleared")


func _on_level_cleared():
	
	respawn_ball(instance_from_id(current_ball_id))
	
	# next level in list
	var level_index = current_level_index + 1
	
	# loop to beginning when index out of bounds
	if level_index >= levels.size():
		level_index = 0
	
	load_level(level_index)
	current_level_index = level_index


func _on_game_over(_score):
	get_tree().paused = true


func _on_game_restart():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_game_exit():
	get_tree().paused = false
	get_tree().change_scene("res://scenes/MainMenu.tscn")













