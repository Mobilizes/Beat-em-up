extends KinematicBody2D

signal health_changed(new_health, max_health)
signal activateweapon()

onready var weapon = get_node("weaponslot")
var bullet = preload("res://scenes/normalbullet.tscn")

var max_health = 100
var health = max_health
var action = "idle"
var speed = 450
var velocity = Vector2(0, 0)
var firerate : float
var direction = Vector2(0, 0)
var invulnerable_timer = 0.75
var can_shoot = true
var interacting = false

func _ready():
	var _connection = self.connect("activateweapon", get_node("weaponslot/weapon"), "_use")

func _process(delta):
	# Animation
	$animation.play(action)
	
	# Move
	move(delta)
	
	# Border, 32 is there because the character would stick outside of the screen
	# self.position.x = clamp(self.position.x, 32, resolution.x - 32)
	# self.position.y = clamp(self.position.y, 32, resolution.y - 32)
	
	# Aim
	look_at(get_global_mouse_position())
	
	# Healthbar signal
	emit_signal("health_changed", health, max_health)
	
	# Interact
	if Input.is_action_just_pressed("interact"):
		interacting = true
	if Input.is_action_just_released("interact"):
		interacting = false

func move(delta):
	# Normal movement
	direction = Vector2(0, 0)
	
	if Input.is_action_pressed("move_right"):
		direction.x = 1
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	if Input.is_action_pressed("move_up"):
		direction.y = -1
	if Input.is_action_pressed("move_down"):
		direction.y = 1
	
	direction = direction.normalized()
	
	velocity = direction * speed * 50 * delta
	if $invulnerable_timer.time_left > 0:
		velocity = velocity * 2
	
	velocity = move_and_slide(velocity)
	
	# Shoot
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		can_shoot = false
		yield(get_tree().create_timer(firerate), "timeout")
		can_shoot = true

func shoot():
	if $invulnerable_timer.is_stopped():
		emit_signal("activateweapon")

func take_damage(damage):
	$invulnerable_timer.wait_time = invulnerable_timer
	if $invulnerable_timer.is_stopped():
		$invulnerable_timer.start()
		health -= damage
		if health <= 0:
			var _connection = get_tree().reload_current_scene()
		$hurt.play()
		action = "hurt"
		$hitbox.disabled = true
		yield($animation, "animation_finished")
		$hitbox.disabled = false
		action = "idle"

func _statsupdate(atkspd = -1, spd = -1):
	if atkspd != -1:
		firerate = atkspd
	if spd != -1:
		speed = spd

func _changeweapon():
	var _connection = self.connect("activateweapon", get_node("weaponslot/weapon"), "_use")
