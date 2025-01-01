extends TextureProgress


func _on_player_health_changed(new_health, max_health):
	value = new_health
	max_value = max_health
