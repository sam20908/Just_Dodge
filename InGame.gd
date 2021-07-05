extends Node

export (PackedScene) var Mob

onready var global_state = get_node('/root/GlobalState')

var time = 0
var difficulty = 1
var max_miss_radians = PI / 4


func set_difficulty_text(difficulty_int):
	var difficulty_name = global_state.DIFFICULTY_NAMES[difficulty_int]
	$CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/DifficultyLabel.text = (
		"%s"
		% difficulty_name
	)
	$CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/DifficultyLabel.add_color_override(
		"font_color", global_state.DIFFICULTY_COLORS[difficulty_int]
	)


func increase_difficulty():
	difficulty += 1
	global_state.mob_min_speed += 25
	global_state.mob_max_speed += 25
	max_miss_radians -= PI / 12
	$MobSpawnTimer.wait_time -= 0.5

	set_difficulty_text(difficulty)

	if difficulty == 5:
		$DifficultyIncrementTimer.disconnect("timeout", self, "increase_difficulty")


func _ready():
	$Player.start($Player.position)
	# warning-ignore:return_value_discarded
	$Player.connect("hit", self, "game_over")

	global_state.mob_min_speed = 150
	global_state.mob_max_speed = 250


func begin_game():
	$MobSpawnTimer.start()
	$TimeTimer.start()
	$DifficultyIncrementTimer.start()

	set_difficulty_text(difficulty)
	increment_time_text()

func spawn_mob():
	$MobSpawnPath/MobSpawnPoint.offset = randi()

	var mob = Mob.instance()
	add_child(mob)

	# Try to make the monster travel towards the player, but move little to the sides to make it "fair"
	var player_pos = $Player.position
	var player_x = player_pos.x
	var player_y = player_pos.y
	var spawn_pos = $MobSpawnPath/MobSpawnPoint.position
	var spawn_x = spawn_pos.x
	var spawn_y = spawn_pos.y

	var radians_to_player = atan2(player_y - spawn_y, player_x - spawn_x)
	radians_to_player += rand_range(-max_miss_radians, max_miss_radians)

	mob.position = $MobSpawnPath/MobSpawnPoint.position
	mob.rotation = radians_to_player

	mob.linear_velocity = Vector2(
		rand_range(global_state.mob_min_speed, global_state.mob_max_speed), 0
	)
	mob.linear_velocity = mob.linear_velocity.rotated(radians_to_player)


func increment_time_text():
	time += 1
	$CanvasLayer/MarginContainer/HBoxContainer/VBoxContainer/TimeLabel.text = "%ss" % time


func game_over():
	global_state.score = time
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://GameOver.tscn")
