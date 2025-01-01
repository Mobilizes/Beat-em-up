extends Node2D

onready var player = $player
var enemyrangespawn = 750

var basicenemy = preload("res://scenes/basicenemy.tscn")
var basicenemyspawned : int
var basicenemykilled : int
onready var basicenemyspawn = $basicenemytimer

func _process(_delta):
	basicenemyspawn.wait_time = 1 * (1 - (min(basicenemykilled, 75) * 0.01))

func _on_enemytimer_timeout():
	randomize()
	var e = basicenemy.instance()
	var pos = randf()
	if randf() > 0.5:
		pos = Vector2(sqrt(2-(pow(pos, 2))), pos)
	else:
		pos = Vector2(pos, sqrt(2-(pow(pos, 2))))
	if randf() > 0.5:
		pos.y *= -1
	if randf() > 0.5:
		pos.x *= -1
	pos *= enemyrangespawn

	e.scale = Vector2(0.01, 0.01)
	e.position = Vector2(pos.x + $player.position.x, pos.y + $player.position.y)
	add_child(e)
	basicenemyspawned += 1

func _enemykilled(enemytype):
	if enemytype == "basicenemy":
		basicenemykilled += 1
