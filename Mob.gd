extends RigidBody2D

signal mob_gone_off_screen

func _ready():
	var animation_names = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = animation_names[randi() % animation_names.size()]


func gone_off_screen(_arg):
	emit_signal("mob_gone_off_screen")
	queue_free()
