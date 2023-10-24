extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("score_changed", self, "_on_score_changed")
	Events.connect("lives_changed", self, "_on_lives_changed")
	Events.connect("game_over", self, "_on_game_over")
	Events.connect("retry_button_pressed", self, "_on_game_restart")
	

func _on_score_changed(new_score):
	$SidebarLeft/Score/ScoreNumber.text = String(new_score)


func _on_lives_changed(new_lives):
	$SidebarLeft/Balls/BallsNumber.text = String(new_lives)


func _on_game_over(score):
	$GameEndOverlay/GameEndDialog/FinalScoreNumber.text = String(score)
	$GameEndOverlay.visible = true


func _on_game_restart():
	$GameEndOverlay.visible = false
