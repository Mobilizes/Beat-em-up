extends Node2D

signal firerateupdate(firerate)

var state
onready var parentnode = get_parent().get_parent()
var can_shoot = true
var bullet = preload("res://scenes/normalbullet.tscn")
var firerate = 0.2

func _ready():
	if parentnode.name == "player":
		state = "equipped"
		var _connection = self.connect("firerateupdate", parentnode, "_statsupdate")
		emit_signal("firerateupdate", firerate)
		print("connected")
	elif parentnode.name == "Level":
		state = "dropped"

func _use():
	var bullet_instance = bullet.instance()
	bullet_instance.position = $Muzzle.get_global_position()
	bullet_instance.rotation_degrees = parentnode.rotation_degrees
	get_tree().get_root().add_child(bullet_instance)
	
