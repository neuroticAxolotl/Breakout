extends KinematicBody2D

var base_velocity = Settings.selected_mode["ball_base_speed"]
var velocity = base_velocity
var stored_velocity = null
var increment = Settings.selected_mode["speed_up_increment"]
var collision_count = 0
var speed_up_count = 1
var next_speed_up = Settings.selected_mode["speed_up_threshold"]


var direction = null

onready var particle_emitter = get_node("CPUParticles2D")

var pos_list = []



# Called when the node enters the scene tree for the first time.
func _ready():
	particle_emitter.emitting = false
	
	# random direction if placed in editor / direction not given
	if !direction:
		randomize()
		direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	
	# how many frames the ball has to be still to be considered stuck
	for _i in range(5):
		pos_list.append(Vector2.ZERO)


func _physics_process(delta):
	
	# speed up when pressing down
	if Input.is_action_pressed("down"):
		if stored_velocity == null:
			stored_velocity = velocity
		velocity = stored_velocity * 3
	else:
		if stored_velocity != null:
			velocity = stored_velocity
		stored_velocity = null

	
	var collision = move_and_collide(direction.normalized()*velocity*delta)
	
	if collision:
		particle_emitter.restart()
		direction = direction.bounce(collision.normal)
		direction += collision.collider_velocity.normalized()
		Events.emit_signal("ball_collided", collision)
		
		# send ball up even if it hits the side of the paddle (top half only)
		if collision.collider.name == "Paddle" and position.y <= collision.collider.position.y:
			direction.y = -abs(direction.y)
			collision_count += 1
	
	if Settings.selected_mode["name"] == "classic":
		# done at weird intervals to match the original game
		if collision_count == 4:
			velocity = 400 + 75
		if collision_count == 12:
			velocity = 400 + 75 + 75
	else:
		# if ball has collided with paddle x number of times, speed up
		if collision_count == next_speed_up and speed_up_count <= Settings.selected_mode["speed_up_maximum"]:
			velocity = base_velocity + (increment * speed_up_count)
			speed_up_count += 1
			next_speed_up = Settings.selected_mode["speed_up_threshold"] * speed_up_count
			print_debug(velocity)
	
	
	if position.y <= 10:
		Events.emit_signal("ball_hit_ceiling", self)
	if position.y >= 610:
		Events.emit_signal("ball_hit_floor", self)
	
	
	# send signal if ball gets stuck
	# checks if position has changed at all in 5 frames
	
	var same_pos_count = 0
	
	for pos in pos_list:
		if pos == position:
			same_pos_count += 1
		else:
			break
	
	if same_pos_count >= 5:
		Events.emit_signal("ball_stuck", self)
	
	pos_list.push_back(position)
	pos_list.pop_front()
