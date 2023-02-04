extends Area2D


var creation_cooldown = 0.5


func _process(delta):
	creation_cooldown -= delta
