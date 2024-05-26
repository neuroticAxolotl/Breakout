extends Control

var _err

# Called when the node enters the scene tree for the first time.
func _ready():
	$VolumeSlider.value = db2linear(Settings.master_volume)
	_err = $VolumeSlider.connect("value_changed", self, "_on_volume_changed")
	_err = $FilterToggle.connect("toggled", self, "_on_filter_toggled")
	_err = $ShakeToggle.connect("toggled", self, "_on_shake_toggled")
	_updateVolumeLabel()


func _updateVolumeLabel():
	var volume = $VolumeSlider.value
	var percentValue = String(volume*100).pad_decimals(0) + "%"
	$VolumeSlider/ValueLabel.text = percentValue


func _on_volume_changed(value):
	#warning-ignore:narrowing_conversion
	Settings.master_volume = linear2db(value)
	_updateVolumeLabel()
	Events.emit_signal("setting_changed")


func _on_filter_toggled(toggle_state):
	Settings.crt_filter_on = toggle_state
	Events.emit_signal("setting_changed")


func _on_shake_toggled(toggle_state):
	Settings.screen_shake_on = toggle_state
	Events.emit_signal("setting_changed")
