extends Camera2D


export(NodePath) var snakehead


func _process(delta):
	if is_instance_valid(get_node(snakehead)):
		if get_node(snakehead).position.y > self.position.y: #move down with snake
			self.position.y = get_node(snakehead).position.y
