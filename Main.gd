extends Node

export (PackedScene) var Mob
var score
var elapsed_time = 0.000

func show_message(msg):
	$CanvasLayer/Message.show()
	$CanvasLayer/Message.text = msg

func _ready():
	randomize()

func new_game():
	score = 0
	$Player.start($PlayerStartPos.position)
	$StartDelayTimer.start()
	
	$CanvasLayer/StartButton.hide()
	$CanvasLayer/ScoreLabel.show()
	$CanvasLayer/TimerLabel.show()

func _on_StartDelayTimer_timeout():
	$MobSpawnTimer.start()
	$ScoreIncrementTimer.start()
	$TimeElapsedTimer.start()

func _on_ScoreIncrementTimer_timeout():
	score += 1
	$CanvasLayer/ScoreLabel.text = "%s" % score

func _on_MobSpawnTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	
	var mob = Mob.instance()
	add_child(mob)	
	
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	
	mob.position = $MobPath/MobSpawnLocation.position
	mob.rotation = direction
	
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


func game_over():
	$ScoreIncrementTimer.stop()
	$MobSpawnTimer.stop()
	$TimeElapsedTimer.stop()
	
	show_message("Game over!")
	

func _on_StartButton_pressed():
	$CanvasLayer/Message.hide()
	new_game()


func _on_TimeElapsedTimer_timeout():
	elapsed_time += 0.01
	$CanvasLayer/TimerLabel.text = "%.3fs" % elapsed_time
