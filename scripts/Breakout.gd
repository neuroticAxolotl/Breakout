extends Node2D

var _err # variable purely to make the editor shut up about return values

var ball_scene = preload("res://scenes/game/Ball.tscn")
var current_ball_id : int

var levels : Array
var current_level_id : int
var current_level_index : int = 0

var level_max_score : int
var level_score : int = 0
var total_score : int = 0

# extra life given at score*1, score*2, score*3 etc.
var extra_life_score : int = Settings.selected_mode["extra_lives_score"]
var extra_life_count : int = 1

var lives : int


# Called when the node enters the scene tree for the first time.
func _ready():
	# make rng random
	randomize()
	
	_err = Events.connect("ball_hit_floor", self, "respawn_ball")
	_err = Events.connect("ball_stuck", self, "_on_ball_stuck")
	_err = Events.connect("brick_broken", self, "_on_brick_broken")
	_err = Events.connect("level_cleared", self, "_on_level_cleared")
	_err = Events.connect("game_over", self, "_on_game_over")
	_err = Events.connect("game_won", self, "_on_game_over")
	_err = Events.connect("game_paused", self, "_on_game_paused")
	_err = Events.connect("game_unpaused", self, "_on_game_unpaused")
	_err = $UI/GameEndOverlay/GameEndDialog/ButtonRetry.connect("pressed", self, "_on_game_restart")
	_err = $UI/PauseOverlay/PauseDialog/ButtonRetry.connect("pressed", self, "_on_game_restart")
	_err = $UI/GameEndOverlay/GameEndDialog/ButtonExit.connect("pressed", self, "_on_game_exit")
	_err = $UI/PauseOverlay/PauseDialog/ButtonExit.connect("pressed", self, "_on_game_exit")
	_err = Events.connect("ball_served", self, "spawn_ball")
	
	levels = Settings.selected_mode["levels"]
	lives = Settings.selected_mode["starting_lives"]
	
	load_level(0)
	
	# debug
	if Settings.extra_points:
		total_score += Settings.extra_points
	
	# display initial values
	Events.emit_signal("lives_changed", lives)
	Events.emit_signal("score_changed", total_score)
	
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
	if current_level_id:
		instance_from_id(current_level_id).queue_free()
	
	if levels.size() == 0:
		levels.append(Settings.levels[1])
	var new_level = levels[level_index].instance()
	
	current_level_id = new_level.get_instance_id()
	
	# used to determine when a level is complete
	level_max_score = 0
	for child in new_level.get_children():
		if child.get("value") != null:
			level_max_score += child.value
	
	self.call_deferred("add_child_below_node", $Background, new_level)


func respawn_ball(ball, remove_life : bool = true):
	ball.queue_free()
	if remove_life:
		lives -= 1
	Events.emit_signal("lives_changed", lives)
	if lives > 0 or Settings.infinite_lives:
		Events.emit_signal("ball_spawn_init")
	else:
		Events.emit_signal("game_over", total_score)


func _on_ball_stuck(ball):
	respawn_ball(ball, false)


func _on_brick_broken(value : int):
	level_score += value
	total_score += value
	
	Events.emit_signal("score_changed", total_score)
	
	if Settings.selected_mode["extra_lives_enabled"]:
		if total_score >= extra_life_score * extra_life_count:
			lives += 1
			extra_life_count += 1
			Events.emit_signal("lives_changed", lives)
	
	if level_score >= level_max_score:
		level_score = 0
		Events.emit_signal("level_cleared")


func _on_level_cleared():
	respawn_ball(instance_from_id(current_ball_id), false)
	
	# next level in list
	var level_index = current_level_index + 1
	
	# loop to beginning or end game when out of levels
	if level_index >= levels.size():
		if Settings.selected_mode["loop_levels"]:
			level_index = 0
			load_level(level_index)
			current_level_index = level_index
		else:
			Events.emit_signal("game_won", total_score)
	else:
		load_level(level_index)
		current_level_index = level_index


func _on_game_over(_score):
	get_tree().paused = true

func _on_game_paused():
	get_tree().paused = true

func _on_game_unpaused():
	get_tree().paused = false 

func _on_game_restart():
	get_tree().paused = false
	_err = get_tree().change_scene_to(load("res://scenes/game/Breakout.tscn"))
	self.queue_free()

func _on_game_exit():
	get_tree().paused = false
	_err = get_tree().change_scene_to(load("res://scenes/menus/TitleScreen.tscn"))
	self.queue_free()













