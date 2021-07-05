extends RigidBody2D

func _ready():
	var animation_names = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = animation_names[randi() % animation_names.size()]


func gone_off_screen(_arg):
	queue_free()
