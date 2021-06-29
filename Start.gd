extends CanvasLayer

func activate_game():
	get_tree().change_scene("res://InGame.tscn")



func _on_StartButton_pressed():
	activate_game()
