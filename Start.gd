extends Node

export (PackedScene) var Mob

onready var global_state = get_node('/root/GlobalState')


func activate_game():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://InGame.tscn")


func spawn_mob():
	$MobSpawnPath/MobSpawnPoint.offset = randi()

	var mob = Mob.instance()
	add_child(mob)

	# This just takes the side and apply inverse momentum (e.g. spawn on right -> go left) with random side velocity
	var direction = $MobSpawnPath/MobSpawnPoint.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)

	mob.position = $MobSpawnPath/MobSpawnPoint.position
	mob.rotation = direction

	mob.linear_velocity = Vector2(
		rand_range(global_state.mob_min_speed, global_state.mob_max_speed), 0
	)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)
