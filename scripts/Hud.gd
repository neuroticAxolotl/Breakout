extends Control

onready var total_score = 0
onready var ball_count = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("brick_broken", self, "_on_brick_broken")
	Events.connect("ball_hit_floor", self, "_on_ball_hit_floor")
	Events.connect("game_over", self, "_on_game_over")


func _on_brick_broken(value):
	total_score += value * 100
	$SidebarLeft/Score/ScoreNumber.text = String(total_score)


func _on_ball_hit_floor(_ball):
	var balls = int($SidebarLeft/Balls/BallsNumber.text)
	balls -= 1
	if balls == 0:
		Events.emit_signal("game_over", total_score)
	$SidebarLeft/Balls/BallsNumber.text = String(balls)


func _on_game_over(score):
	get_tree().paused = true
	$GameEndOverlay/GameEndDialog/FinalScoreNumber.text = String(score)
	$GameEndOverlay.visible = true
