extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var can_remove = false

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	can_remove = true


func _process(_delta):
	if can_remove and not emitting:
		self.queue_free()
