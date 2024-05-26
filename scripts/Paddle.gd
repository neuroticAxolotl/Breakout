extends KinematicBody2D

var _err

var velocity = Settings.selected_mode["paddle_speed"]

onready var texture_wide = preload("res://sprites/brick_widest.png")
onready var texture_small = preload("res://sprites/brick.png")


# Called when the node enters the scene tree for the first time.
func _ready():
	$FakeBall.visible = false
	_err = Events.connect("ball_hit_ceiling", self, "_on_ball_hit_ceiling")
	_err = Events.connect("ball_spawn_init", self, "_on_ball_spawn_init")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.is_action_pressed("left"):
		var _slide = move_and_slide(Vector2.LEFT * velocity)
		
	
	if Input.is_action_pressed("right"):
		var _slide = move_and_slide(Vector2.RIGHT * velocity)
	
	if Input.is_action_pressed("up") and $FakeBall.visible:
		Events.emit_signal("ball_served", $FakeBall.global_position)
		$FakeBall.visible = false
	
	# completely disable sideways movement
	position.y = 525


func _on_ball_hit_ceiling(_ball):
	if Settings.selected_mode["name"] == "classic":
		shrink()


func shrink():
	$Sprite.texture = texture_small
	$CollisionShape2DWide.disabled = true
	$CollisionShape2DSmall.disabled = false


# unused
func expand():
	$Sprite.texture = texture_wide
	$CollisionShape2DSmall.disabled = true
	$CollisionShape2DWide.disabled = false


func _on_ball_spawn_init():
	# enables input check for serving the ball in _physics_process()
	$FakeBall.visible = true
