extends KinematicBody2D

signal health_changed(new_health, max_health)
signal enemykilled(enemytype)

onready var player = get_parent().get_node("player")
onready var spawntime = get_parent().get_node("basicenemytimer")

var max_health = 100
var health = max_health
var speed = 175
var size = Vector2(0.5, 0.5)
var spawning = true
var collision_info

func _process(delta):
	var dir = (player.global_position - global_position).normalized()
	if scale == size:
		spawning = false
		collision_info = move_and_collide(dir * speed * delta)
	look_at(player.global_position)
	emit_signal("health_changed", health, max_health)
	
	if scale < size:
		scale += Vector2(1 * delta, 1 * delta)
	if scale > size:
		scale = size
	
	if collision_info:
		if collision_info.collider.is_in_group("player"):
			attack()

func take_damage(damage):
	if not spawning:
		health -= damage
		if health <= 0:
			var level = get_parent()
			var _connection = self.connect("enemykilled", level, "_enemykilled")
			emit_signal("enemykilled", "basicenemy")
			queue_free()
		$enemyhurt.play()

func attack():
	collision_info.collider.take_damage(25)
