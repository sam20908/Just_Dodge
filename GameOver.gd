extends Node

onready var global_state = get_node('/root/GlobalState')


func _ready():
	$CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/ScoreLabel.text = (
		"You Survived %s Seconds!"
		% global_state.time_survived
	)


func restart():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://InGame.tscn")
