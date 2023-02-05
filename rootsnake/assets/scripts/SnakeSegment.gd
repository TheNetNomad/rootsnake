extends Area2D


var creation_cooldown = 0.5
var camera = "../Camera2D"

func _process(delta):
	check_if_offscreen()
	creation_cooldown -= delta

func check_if_offscreen():
	if self.position.y < get_node(camera).position.y - (get_viewport().size.y / 1.8):
		self.queue_free()
