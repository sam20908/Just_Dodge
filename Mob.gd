extends RigidBody2D

export var min_speed = 150
export var max_speed = 250

signal mob_gone_off_screen

func _ready():
	var animation_names = $AnimatedSprite.frames.get_animation_names()
	$AnimatedSprite.animation = animation_names[randi() % animation_names.size()]


func gone_off_screen(_arg):
	emit_signal("mob_gone_off_screen")
	queue_free()
