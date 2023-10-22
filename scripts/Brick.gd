extends KinematicBody2D

export var hp = 1
export var value = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("ball_collided", self, "_on_ball_collided")


func _on_ball_collided(collision):
	if collision.collider_id == self.get_instance_id():
		hp -= 1
		if hp <= 0:
			Events.emit_signal("brick_broken", value)
			self.queue_free()
		

