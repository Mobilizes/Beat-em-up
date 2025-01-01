extends Area2D

signal fireratesignal(firerate)

var speed
var atk
var firerate : int

func _ready():
	$shoot.play()

func _process(delta):
	position += transform.x * speed * delta

func _on_bullet_body_entered(body):
	if body.is_in_group("enemy"):
		body.take_damage(atk)
		if not body.spawning:
			queue_free()

func _on_bullet_area_entered(area):
	if area.is_in_group("enemy"):
		area.take_damage(atk)
		if not area.spawning:
			queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
