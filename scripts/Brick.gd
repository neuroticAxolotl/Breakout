extends KinematicBody2D

var _err

export var hp = 1
export var value = 1

var particleEmitter = preload("res://scenes/game/ParticleBurst.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	_err = Events.connect("ball_collided", self, "_on_ball_collided")


func _on_ball_collided(collision):
	if collision.collider_id == self.get_instance_id():
		hp -= 1
		if hp <= 0:
			Events.emit_signal("brick_broken", value)
			var emitter = particleEmitter.instance()
			emitter.position = self.position
			emitter.color = self.modulate
			get_parent().add_child(emitter)
			self.queue_free()
		

