extends Node


# warning-ignore:unused_signal
signal ball_spawn_init
# from: Breakout.gd
# to: Paddle.gd

# warning-ignore:unused_signal
signal ball_served(position)
# from: Paddle.gd
# to: Breakout.gd

# warning-ignore:unused_signal
signal ball_spawned(id)
# from: Breakout.gd
# to: none (Audio?)

# warning-ignore:unused_signal
signal ball_collided(collision)
# from: Ball.gd
# to: Brick.gd

# warning-ignore:unused_signal
signal ball_hit_ceiling(ball)
# from: Ball.gd
# to: Paddle.gd

# warning-ignore:unused_signal
signal ball_hit_floor(ball)
# from: Ball.gd
# to: Breakout.gd, UI.gd

# warning-ignore:unused_signal
signal ball_stuck(ball)
# from: Ball.gd
# to: Breakout.gd

# warning-ignore:unused_signal
signal ball_out_of_bounds(ball)
# from: Ball.gd
# to: Breakout.gd

# warning-ignore:unused_signal
signal brick_broken(value)
# from: Brick.gd
# to: Breakout.gd, UI.gd

# warning-ignore:unused_signal
signal score_changed(new_score)
# from: Breakout.gd
# to: UI.gd

# warning-ignore:unused_signal
signal lives_changed(new_lives)

# warning-ignore:unused_signal
signal level_cleared()
# from: Breakout.gd
# to: Breakout.gd

# warning-ignore:unused_signal
signal game_over(score)
# from: UI.gd
# to: Breakout.gd

# warning-ignore:unused_signal
signal button_selected
# from: CustomButton.gd
# to: SoundPlayer.gd

# warning-ignore:unused_signal
signal button_pressed
# from: CustomButton.gd
# to: SoundPlayer.gd

# warning-ignore:unused_signal
signal retry_button_pressed
# from: retry button (instance of CustomButton)
# to: Breakout.gd, UI.gd

# warning-ignore:unused_signal
signal exit_button_pressed
# from: exit button (instance of CustomButton)
# to: Breakout.gd
