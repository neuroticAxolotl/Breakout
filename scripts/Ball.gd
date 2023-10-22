extends KinematicBody2D


var velocity = 400
var direction = null

onready var particle_emitter = get_node("CPUParticles2D")

var pos_list = []

var collision_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	particle_emitter.emitting = false
	
	
	if !direction:
		randomize()
		direction = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	
	# how many frames the ball has to be still to be considered stuck
	for _i in range(5):
		pos_list.append(Vector2.ZERO)


func _physics_process(delta):
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
	
	if collision_count == 4:
		velocity = 475
	if collision_count == 12:
		velocity = 550
	
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
