extends CanvasLayer

onready var global_state = get_node('/root/GlobalState')

func _ready():
	$ScoreLabel.text = str(global_state.score)
	

func restart():
	get_tree().change_scene("res://InGame.tscn")



func _on_RetryButton_pressed():
	restart()
