extends Area2D


var direction = 2

const MOVE_SPEED = 4
const TILE_SIZE = 64
const TILE_OFFSET = 32


func _ready():
	place_segment(true)

func _process(_delta):

	move()
	
	if int(position.x) % TILE_SIZE-TILE_OFFSET == 0 and int(position.y) % TILE_SIZE-TILE_OFFSET == 0:
		position.x = int(position.x)
		position.y = int(position.y)
		
		get_direction()
		
		place_segment()

func get_direction():
	if Input.is_action_pressed("ui_up"):
		direction = 0
	if Input.is_action_pressed("ui_down"):
		direction = 2
	if Input.is_action_pressed("ui_left"):
		direction = 3
	if Input.is_action_pressed("ui_right"):
		direction = 1

func move():
	if direction == 0:
		position.y -= MOVE_SPEED
	elif direction == 1:
		position.x += MOVE_SPEED
	elif direction == 2:
		position.y += MOVE_SPEED
	elif direction == 3:
		position.x -= MOVE_SPEED

func place_segment(first_call = false):
	var segment = load("res://assets/scenes/SnakeSegment.tscn").instance()
	segment.position = position

	if first_call:
		get_parent().call_deferred("add_child",segment)
	else:
		get_parent().add_child(segment)


func _on_SnakeHead_area_entered(area):
	if "SnakeSegment" in area.name and area.creation_cooldown <= 0:
		self.queue_free()
