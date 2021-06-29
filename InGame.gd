extends CanvasLayer

export (PackedScene) var Mob
export var Time_Increment_Interval = 0.005

onready var global_state = get_node('/root/GlobalState')

var time = 0
var score = 0

func _ready():
	$Player.start($Player.position)
	$Player.connect("player_hit", self, "game_over")

func begin_game():
	$MobSpawnTimer.start()
	$TimeTimer.start()

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
