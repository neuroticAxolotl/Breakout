extends Node2D

var _err

var main_menu = preload("res://scenes/menus/MainMenu.tscn").instance()
var options_menu = preload("res://scenes/menus/OptionsMenu.tscn").instance()
var modes_menu = preload("res://scenes/menus/ModesMenu.tscn").instance()
var custom_mode_settings_menu = preload("res://scenes/menus/CustomModeSettingsMenu.tscn").instance()

var game_scene = preload("res://scenes/game/Breakout.tscn")

var current_menu #set when changed

# Called when the node enters the scene tree for the first time.
func _ready():
	
	add_child(main_menu)
	
	current_menu = main_menu
	
	connect_buttons()


func replace_current_menu(scene_instance):
	remove_child(current_menu)
	add_child(scene_instance)
	current_menu = scene_instance

func connect_buttons():
	#main
	_err = main_menu.get_node("Elements/ButtonOptions").connect("pressed", self, "navigate_to_options")
	_err = main_menu.get_node("Elements/ButtonPlay").connect("pressed", self, "navigate_to_modes")
	#options
	_err = options_menu.get_node("Elements/ButtonBack").connect("pressed", self, "navigate_to_main")
	#modes
	_err = modes_menu.get_node("Elements/ButtonBack").connect("pressed", self, "navigate_to_main")
	_err = modes_menu.get_node("Elements/ButtonClassic").connect("pressed", self, "start_classic_mode")
	_err = modes_menu.get_node("Elements/ButtonLevels").connect("pressed", self, "start_levels_mode")
	_err = modes_menu.get_node("Elements/ButtonCustom").connect("pressed", self, "navigate_to_custom_mode_settings")
	#custom mode
	_err = custom_mode_settings_menu.get_node("Elements/MenuBackgroundPanel/ButtonBack").connect("pressed", self, "navigate_to_modes")
	_err = custom_mode_settings_menu.get_node("Elements/MenuBackgroundPanel/ButtonStart").connect("pressed", self, "start_custom_mode")
	
	

func navigate_to_options():
	replace_current_menu(options_menu)

func navigate_to_modes():
	replace_current_menu(modes_menu)

func navigate_to_main():
	replace_current_menu(main_menu)

func start_classic_mode():
	Settings.selected_mode = Settings.modes["classic"]
	get_tree().get_root().add_child(game_scene.instance())
	self.queue_free()

func start_levels_mode():
	Settings.selected_mode = Settings.modes["levels"]
	get_tree().get_root().add_child(game_scene.instance())
	self.queue_free()

func navigate_to_custom_mode_settings():
	replace_current_menu(custom_mode_settings_menu)

func start_custom_mode():
	
	var level_list = $CustomModeSettingsMenu/Elements/MenuBackgroundPanel/LevelList/VBoxContainer
	var selected_levels = []
	for i in range(level_list.get_child_count()):
		if level_list.get_child(i).pressed == true:
			selected_levels.append(Settings.levels[i])
	
	var controls = $CustomModeSettingsMenu/Elements/MenuBackgroundPanel/Settings
	Settings.modes["custom"]["levels"] = selected_levels
	Settings.modes["custom"]["loop_levels"] = controls.get_node("EndlessMode").pressed
	Settings.modes["custom"]["starting_lives"] = controls.get_node("StartingLives/SpinBox").value
	Settings.modes["custom"]["extra_lives_enabled"] = controls.get_node("ExtraLives").pressed
	Settings.modes["custom"]["extra_lives_score"] = controls.get_node("ExtraLifePoints/SpinBox").value
	Settings.modes["custom"]["ball_base_speed"] = controls.get_node("BallSpeed/SpinBox").value
	Settings.modes["custom"]["paddle_speed"] = controls.get_node("PaddleSpeed/SpinBox").value
	Settings.modes["custom"]["speed_up_enabled"] = controls.get_node("SpeedUp").pressed
	Settings.modes["custom"]["speed_up_threshold"] = controls.get_node("SpeedUpFrequency/SpinBox").value
	Settings.modes["custom"]["speed_up_increment"] = controls.get_node("SpeedUpIncrement/SpinBox").value
	Settings.modes["custom"]["speed_up_maximum"] = controls.get_node("SpeedUpMaximum/SpinBox").value
	
	Settings.selected_mode = Settings.modes["custom"]
	
	get_tree().get_root().add_child(game_scene.instance())
	self.queue_free()









