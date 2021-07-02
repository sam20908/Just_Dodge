extends CanvasLayer

export (PackedScene) var Mob

onready var global_state = get_node('/root/GlobalState')
onready var difficulty_increment_interval = $DifficultyIncrementTimer.wait_time
onready var time_increment_interval = $TimeTimer.wait_time

var time = 0
var score = 0
var difficulty = 1
var difficulty_time_elapsed = 0
var max_miss_radians = PI / 4


func set_difficulty_color(difficulty_int):
	var difficulty_clamped = clamp(difficulty_int, 1, 5)
	$DifficultyLabel.add_color_override("font_color", global_state.DIFFICULTY_COLORS[difficulty_clamped])

func set_difficulty_text_pre_impossible(difficulty_int):
	var difficulty_name = global_state.DIFFICULTY_NAMES[difficulty_int]
	$DifficultyLabel.text = "%s: %ss left" % [difficulty_name, difficulty_increment_interval - difficulty_time_elapsed]

func set_difficulty_text_post_impossible():
	$DifficultyLabel.text = "Impossible (MAX)!"

func increase_difficulty():
	difficulty += 1
	global_state.mob_min_speed += 25
	global_state.mob_max_speed += 25
	max_miss_radians -= PI / 12
	set_difficulty_color(difficulty)
	$MobSpawnTimer.wait_time -= 0.5

	if difficulty < 5:
		difficulty_time_elapsed = -1
		set_difficulty_text_pre_impossible(difficulty)
	else:
		set_difficulty_text_post_impossible()
		$DifficultyIncrementTimer.disconnect("timeout", self, "_on_DifficultyIncrementTimer_timeout")
		$DifficultyElapsedTimer.disconnect("timeout", self, "_on_DifficultyElapsedTimer_timeout")

func increase_difficulty_time_elapsed():
	difficulty_time_elapsed += 1
	if difficulty < 5:
		set_difficulty_text_pre_impossible(difficulty)

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
	$DifficultyElapsedTimer.start()

	set_difficulty_color(difficulty)
	set_difficulty_text_pre_impossible(difficulty)
	increment_time_text()

func spawn_mob():
	$MobSpawnPath/MobSpawnPoint.offset = randi()
	
	var mob = Mob.instance()
	mob.connect("mob_gone_off_screen", self, "handle_mob_gone_off_screen")
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
	
	mob.linear_velocity = Vector2(rand_range(global_state.mob_min_speed, global_state.mob_max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(radians_to_player)


func increment_time_text():
	time += time_increment_interval
	$TimerLabel.text = "%ss" % time


func game_over():
	global_state.score = score
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://GameOver.tscn")



func _on_MobSpawnTimer_timeout():
	spawn_mob()


func _on_TimeTimer_timeout():
	increment_time_text()


func handle_mob_gone_off_screen():
	score += 1
	$ScoreLabel.text = str(score)


func _on_StartDelayTimer_timeout():
	begin_game()


func _on_DifficultyIncrementTimer_timeout():
	increase_difficulty()


func _on_DifficultyElapsedTimer_timeout():
	increase_difficulty_time_elapsed()
