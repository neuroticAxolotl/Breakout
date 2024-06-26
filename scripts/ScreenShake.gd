extends Camera2D

# script modified from this:
# https://shaggydev.com/2022/02/23/screen-shake-godot/

var _err

# How quickly to move through the noise
export var NOISE_SHAKE_SPEED: float = 40.0
# Noise returns values in the range (-1, 1)
# So this is how much to multiply the returned value by
export var NOISE_SHAKE_STRENGTH: float = 20.0
# Multiplier for lerping the shake strength to zero
export var SHAKE_DECAY_RATE: float = 10.0


onready var noise = OpenSimplexNoise.new()


# Used to keep track of where we are in the noise
# so that we can smoothly move through it
var noise_i: float = 0.0

var shake_strength: float = 0.0

func _ready() -> void:
	
	# Randomize the generated noise
	noise.seed = randi()
	# Period affects how quickly the noise changes values
	noise.period = 2

	_err = Events.connect("ball_hit_floor", self, "_shake")
	_err = Events.connect("brick_broken", self, "_shake")

func _shake(_value):
	if Settings.screen_shake_on:
		apply_noise_shake()

func apply_noise_shake() -> void:
	shake_strength = NOISE_SHAKE_STRENGTH

func _process(delta: float) -> void:
	# Fade out the intensity over time
	shake_strength = lerp(shake_strength, 0, SHAKE_DECAY_RATE * delta)

	# Shake by adjusting camera.offset so we can move the camera around the level via it's position
	offset = get_noise_offset(delta)

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * NOISE_SHAKE_SPEED
	# Set the x values of each call to 'get_noise_2d' to a different value
	# so that our x and y vectors will be reading from unrelated areas of noise
	return Vector2(
		noise.get_noise_2d(1, noise_i) * shake_strength,
		noise.get_noise_2d(100, noise_i) * shake_strength
	)
