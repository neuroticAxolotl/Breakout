tool
extends KinematicBody2D

var _err

export var hp = 1
export var value = 1 setget _set_value
export(String, "0.5", "1.0", "1.5", "2.0") var size = "1.0" setget _set_size

var colors = {
		0 : "595a61", # gray
		1 : "ff3030", # red
		2 : "ffaa00", # orange
		3 : "ffff00", # yellow
		4 : "00e33a", # green
		5 : "00d5ff", # blue
		6 : "5655ff", # indigo
		7 : "ec4ef9", # violet
		8 : "ffffff", # white
}

var sprites = {
	"0.5" : preload("res://sprites/brick_half.png"),
	"1.0" : preload("res://sprites/brick.png"),
	"1.5" : preload("res://sprites/brick_wide.png"),
	"2.0" : preload("res://sprites/brick_widest.png"),
}

var shape_extents = {
	"0.5" : Vector2(12,12),
	"1.0" : Vector2(24,12),
	"1.5" : Vector2(36,12),
	"2.0" : Vector2(48,12),
}

var particleEmitter = preload("res://scenes/game/ParticleBurst.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	if self.value > 0:
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


func _set_value(new_value):
	value = new_value
	if value in colors.keys():
		modulate = Color(colors[value])
	else:
		modulate = Color("ffffff")


func _set_size(new_size):
	size = new_size
	$Sprite.texture = sprites[size]
	var new_shape = RectangleShape2D.new()
	new_shape.extents = shape_extents[size]
	$CollisionShape2D.shape = new_shape




