extends Area2D


var direction = 2
var new_direction = direction

export(NodePath) var tilemap
var score = '../Camera2D/ScoreDisplay'

var target_x = 0
var target_y = 0

var MOVE_SPEED = 4
var next_move_speed_target_score = 1000
const TILE_SIZE = 64
const TILE_OFFSET = 32


func _ready():
	place_segment(true)
	dig()

	target_x = self.position.x
	target_y = 96

func _process(delta):

	get_direction()

	move()


	if get_node(score).score > next_move_speed_target_score:
		next_move_speed_target_score *= 3
		MOVE_SPEED += 1

	if has_reached_tile():
		position.x = target_x
		position.y = target_y

		turn()
		place_segment()
		dig()

		direction = new_direction
		if direction == 0:
			target_y = position.y - 64
			target_x = position.x
		elif direction == 1:
			target_y = position.y
			target_x = position.x + 64
		elif direction == 2:
			target_y = position.y + 64
			target_x = position.x
		elif direction == 3:
			target_y = position.y
			target_x = position.x - 64

		if check_for_death_tile(direction):
			death("wall")

func has_reached_tile():
	if direction == 0 and position.y <= target_y:
		return true
	if direction == 1 and position.x >= target_x:
		return true
	if direction == 2 and position.y >= target_y:
		return true
	if direction == 3 and position.x <= target_x:
		return true
	return false

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

func turn():

	if new_direction == 0:
		$Sprite.rotation_degrees = 180
	if new_direction == 1:
		$Sprite.rotation_degrees = 270
	if new_direction == 2:
		$Sprite.rotation_degrees = 0
	if new_direction == 3:
		$Sprite.rotation_degrees = 90

func place_segment(first_call = false):
	var segment = load("res://assets/scenes/SnakeSegment.tscn").instance()
	segment.position = position
#	segment.get_child(0).rotation = $Sprite.rotation

	if direction == 0 and new_direction == 0 or direction == 2 and new_direction == 2:
		segment.rotation_degrees = 0
	if direction == 1 and new_direction == 1 or direction == 3 and new_direction == 3:
		segment.rotation_degrees = 90
	
	if direction == 0 and new_direction == 1 or direction == 3 and new_direction == 2:
		segment.get_child(0).texture = load('res://assets/sprites/rootsnake_turn_1.png')
		segment.rotation_degrees = 90
	if direction == 1 and new_direction == 2 or direction == 0 and new_direction == 3:
		segment.get_child(0).texture = load('res://assets/sprites/rootsnake_turn_1.png')
		segment.rotation_degrees = 180
	if direction == 2 and new_direction == 3 or direction == 1 and new_direction == 0:
		segment.get_child(0).texture = load('res://assets/sprites/rootsnake_turn_1.png')
		segment.rotation_degrees = 270
	if direction == 3 and new_direction == 0 or direction == 2 and new_direction == 1:
		segment.get_child(0).texture = load('res://assets/sprites/rootsnake_turn_1.png')
		segment.rotation_degrees = 0

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

	$Particles2D.emitting = true
	if get_node(tilemap).get_cellv(cell_position) == 0: #NORMAL SOIL
		get_node(tilemap).set_cellv(cell_position,-1)
	elif get_node(tilemap).get_cellv(cell_position) == 2: #RICH SOIL
		get_node(tilemap).set_cellv(cell_position,-1)
		get_node(score).add_score(100)
		$AudioStreamPlayer.play()
	else:
		$Particles2D.emitting = false

func death(cause):
	Globals.globalScore = int(get_node(score).text)
	Globals.causeOfDeath = cause
	get_tree().change_scene("res://assets/scenes/gameOver.tscn")

func _on_SnakeHead_area_entered(area):
	if "SnakeSegment" in area.name and area.creation_cooldown <= 0:
		death("yourself")
	elif "Rock" in area.name and area.death_countdown == 1:
		area.push(direction)
