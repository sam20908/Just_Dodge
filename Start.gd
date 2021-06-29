extends Node

export (PackedScene) var Mob

func activate_game():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://InGame.tscn")

func spawn_mob():
	$MobSpawnPath/MobSpawnPoint.offset = randi()
	
	var mob = Mob.instance()
	add_child(mob)	
	
	var direction = $MobSpawnPath/MobSpawnPoint.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	
	mob.position = $MobSpawnPath/MobSpawnPoint.position
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


func _on_StartButton_pressed():
	activate_game()


func _on_MobSpawnTimer_timeout():
	spawn_mob()
