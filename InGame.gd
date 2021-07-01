extends CanvasLayer

export (PackedScene) var Mob
export var Time_Increment_Interval = 0.005

onready var global_state = get_node('/root/GlobalState')
onready var difficulty_increment_interval = $DifficultyIncrementTimer.wait_time

var time = 0
var score = 0
var difficulty = 1
var difficulty_time_elapsed = 0


func set_difficulty_color(difficulty_int):
	var difficulty_clamped = clamp(difficulty_int, 1, 5)
	$DifficultyLabel.add_color_override("font_color", global_state.DIFFICULTY_COLORS[difficulty_clamped])

func set_difficulty_text_pre_impossible(difficulty_int):
	var difficulty_name = global_state.DIFFICULTY_NAMES[difficulty_int]
	$DifficultyLabel.text = "%s: %ss left" % [difficulty_name, difficulty_increment_interval - difficulty_time_elapsed]

func set_difficulty_text_post_impossible():
	$DifficultyLabel.text = "Impossible (MAX)!"

func increase_difficulty():
	difficulty = clamp(difficulty + 1, 1, 5)
	set_difficulty_color(difficulty)

	if difficulty < 5:
		difficulty_time_elapsed = -1
		set_difficulty_text_pre_impossible(difficulty)

		$MobSpawnTimer.wait_time = $MobSpawnTimer.wait_time - 0.5
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

	set_difficulty_color(difficulty)
	# set_difficulty_text_pre_impossible(difficulty)

func begin_game():
	$MobSpawnTimer.start()
	$TimeTimer.start()
	$DifficultyIncrementTimer.start()
	$DifficultyElapsedTimer.start()
	set_difficulty_text_pre_impossible(difficulty)

func spawn_mob():
	$MobSpawnPath/MobSpawnPoint.offset = randi()
	
	var mob = Mob.instance()
	mob.connect("mob_gone_off_screen", self, "handle_mob_gone_off_screen")
	add_child(mob)	
	
	var direction = $MobSpawnPath/MobSpawnPoint.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)

	mob.position = $MobSpawnPath/MobSpawnPoint.position
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


func increment_time_text():
	time += Time_Increment_Interval
	$TimerLabel.text = "%.3fs" % time


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
