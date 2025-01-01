extends "res://source/guns/bullet.gd"

func _ready():
	speed = 2000
	atk = 100
	var shooter = get_tree().get_root().get_node("Level").get_node("player")
	self.connect("fireratesignal", shooter, "_statsupdate")
	emit_signal("fireratesignal", 1)
