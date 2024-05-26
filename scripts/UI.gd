extends Control

var _err

# Called when the node enters the scene tree for the first time.
func _ready():
	_err = Events.connect("score_changed", self, "_on_score_changed")
	_err = Events.connect("lives_changed", self, "_on_lives_changed")
	_err = Events.connect("game_over", self, "_on_game_over")
	_err = Events.connect("game_won", self, "_on_game_won")
	_err = $GameEndOverlay/GameEndDialog/ButtonRetry.connect("pressed", self, "_on_game_restart")
	_err = $PauseOverlay/PauseDialog/ButtonRetry.connect("pressed", self, "_on_game_restart")
	_err = Events.connect("game_unpaused", self, "_on_game_unpaused")
	_err = Events.connect("game_paused", self, "_on_game_paused")
	_err = $PauseOverlay/PauseDialog/ButtonContinue.connect("pressed", self, "_unpause")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and $GameEndOverlay.visible == false:
		if $PauseOverlay.visible == false:
			Events.emit_signal("game_paused")
		elif $PauseOverlay.visible == true:
			Events.emit_signal("game_unpaused")


func _on_score_changed(new_score):
	$SidebarLeft/Score/ScoreNumber.text = String(new_score)


func _on_lives_changed(new_lives):
	$SidebarLeft/Balls/BallsNumber.text = String(new_lives)


func _on_game_over(score):
	$GameEndOverlay/GameEndDialog/GameEndTitle.text = "GAME OVER"
	$GameEndOverlay/GameEndDialog/FinalScoreNumber.text = String(score)
	$GameEndOverlay.visible = true

func _on_game_won(score):
	$GameEndOverlay/GameEndDialog/GameEndTitle.text = "YOU WIN!"
	$GameEndOverlay/GameEndDialog/FinalScoreNumber.text = String(score)
	$GameEndOverlay.visible = true

func _on_game_restart():
	$GameEndOverlay.visible = false
	$PauseOverlay.visible = false

func _on_game_paused():
	$PauseOverlay.visible = true

func _unpause():
	Events.emit_signal("game_unpaused")

func _on_game_unpaused():
	$PauseOverlay.visible = false
	
