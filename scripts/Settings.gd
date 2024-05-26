extends Node


# general
var master_volume : int = -12 # 0 is max, -60 is inaudible
var crt_filter_on : bool = true
var screen_shake_on : bool = true

# debug
var infinite_lives : bool = false
var extra_points : int = 0

# gamemodes
var levels = [
		preload("res://scenes/levels/Level0_Classic.tscn"),
		preload("res://scenes/levels/Level1_Wall.tscn"),
		preload("res://scenes/levels/Level2_Holes.tscn"),
		preload("res://scenes/levels/Level3_Filler.tscn"),
		preload("res://scenes/levels/Level4_Structure.tscn"),
		preload("res://scenes/levels/Level5_Pyramids.tscn"),
		preload("res://scenes/levels/Level6_Grid.tscn"),
		preload("res://scenes/levels/Level7_Core.tscn"),
		preload("res://scenes/levels/Level8_Stairs.tscn"),
		preload("res://scenes/levels/Level9_Divided.tscn"),
		preload("res://scenes/levels/Level10_Pipes.tscn"),
]

var modes = {
		"classic" : {
				"name" : "classic", # can't get name from key because only the value is assigned
				"levels" : [levels[0]],
				"loop_levels" : true,
				"starting_lives" : 3,
				"extra_lives_enabled" : false,
				"extra_lives_score" : 250,
				"paddle_speed" : 650,
				"ball_base_speed" : 400,
				"speed_up_enabled" : true,
				"speed_up_threshold" : -1, # unused
				"speed_up_increment" : 75,
				"speed_up_maximum" : -1, # unused
				},
		"levels" : {
				"name" : "levels",
				"levels" : [
						levels[1],
						levels[2],
						levels[3],
						levels[4],
						levels[5],
						levels[6],
						levels[7],
						levels[8],
						levels[9],
						levels[10],
						# add new levels here
						],
				"loop_levels" : false,
				"starting_lives" : 10,
				"extra_lives_enabled" : true,
				"extra_lives_score" : 250,
				"paddle_speed" : 650,
				"ball_base_speed" : 400,
				"speed_up_enabled" : true,
				"speed_up_threshold" : 5,
				"speed_up_increment" : 75,
				"speed_up_maximum" : 1,
				},
		"custom" : {
				"name" : "custom",
				"levels" : [levels[0]],
				"loop_levels" : true,
				"starting_lives" : 3,
				"extra_lives_enabled" : true,
				"extra_lives_score" : 250,
				"ball_base_speed" : 400,
				"paddle_speed" : 650,
				"speed_up_enabled" : true,
				"speed_up_threshold" : 5,
				"speed_up_increment" : 75,
				"speed_up_maximum" : 2,
				},
		}

var selected_mode = modes["classic"]
