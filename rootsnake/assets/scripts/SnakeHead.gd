extends Area2D


var direction = 2
var new_direction = direction

export(NodePath) var tilemap
var score = '../Camera2D/ScoreDisplay'

const MOVE_SPEED = 4
const TILE_SIZE = 64
const TILE_OFFSET = 32


func _ready():
	place_segment(true)
	dig()

func _process(delta):

	get_direction()

	move()

	if int(position.x) % TILE_SIZE-TILE_OFFSET == 0 and int(position.y) % TILE_SIZE-TILE_OFFSET == 0:
		position.x = int(position.x)
		position.y = int(position.y)

		place_segment()
		dig()

		direction = new_direction

		if check_for_death_tile(direction):
			death()

func get_direction():
	if Input.is_action_pressed("ui_up") and direction != 2:
		new_direction = 0
	elif Input.is_action_pressed("ui_down") and direction != 0:
		new_direction = 2
	elif Input.is_action_pressed("ui_left") and direction != 1:
		new_direction = 3
	elif Input.is_action_pressed("ui_right") and direction != 3:
		new_direction = 1

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

func check_for_death_tile(direction = 0):
	if direction == 0 and get_node(tilemap).get_cell( (position.x/TILE_SIZE) , (position.y/TILE_SIZE)-1 ) == 1:
		return true
	elif direction == 1 and get_node(tilemap).get_cell( (position.x/TILE_SIZE)+1 , (position.y/TILE_SIZE) ) == 1:
		return true
	elif direction == 2 and get_node(tilemap).get_cell( (position.x/TILE_SIZE) , (position.y/TILE_SIZE)+1 ) == 1:
		return true
	elif direction == 3 and get_node(tilemap).get_cell( (position.x/TILE_SIZE)-1 , (position.y/TILE_SIZE) ) == 1:
		return true

func dig():
	var local_position:Vector2 = get_node(tilemap).to_local(position)
	var cell_position:Vector2 = local_position/get_node(tilemap).cell_size

	if get_node(tilemap).get_cellv(cell_position) == 0: #NORMAL SOIL
		get_node(tilemap).set_cellv(cell_position,-1)
	elif get_node(tilemap).get_cellv(cell_position) == 2: #RICH SOIL
		get_node(tilemap).set_cellv(cell_position,-1)
		get_node(score).add_score(100)

func death():
	get_tree().change_scene("res://assets/scenes/gameOver.tscn")

func _on_SnakeHead_area_entered(area):
	if "SnakeSegment" in area.name and area.creation_cooldown <= 0:
		death()
	elif "Rock" in area.name and area.death_countdown == 1:
		area.push(direction)
