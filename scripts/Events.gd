extends Node

# GAME

# warning-ignore:unused_signal
signal ball_spawn_init
# warning-ignore:unused_signal
signal ball_served(position)
# warning-ignore:unused_signal
signal ball_spawned(id)
# warning-ignore:unused_signal
signal ball_collided(collision)
# warning-ignore:unused_signal
signal ball_hit_ceiling(ball)
# warning-ignore:unused_signal
signal ball_hit_floor(ball)
# warning-ignore:unused_signal
signal ball_stuck(ball)
# warning-ignore:unused_signal
signal ball_out_of_bounds(ball)
# warning-ignore:unused_signal
signal brick_broken(value)
# warning-ignore:unused_signal
signal score_changed(new_score)
# warning-ignore:unused_signal
signal lives_changed(new_lives)
# warning-ignore:unused_signal
signal level_cleared()
# warning-ignore:unused_signal
signal game_over(score)
# warning-ignore:unused_signal
signal game_won(score)



# MENUS

# warning-ignore:unused_signal
signal button_selected
# warning-ignore:unused_signal
signal button_pressed(button)
# warning-ignore:unused_signal
signal setting_changed
# warning-ignore:unused_signal
signal game_paused
# warning-ignore:unused_signal
signal game_unpaused


