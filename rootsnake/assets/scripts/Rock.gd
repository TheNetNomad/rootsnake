extends Area2D


var direction = -1
var tilemap = "../TileMap"
var death_countdown = 1

onready var sprite = $Sprite
onready var particles = $Particles2D

const MOVE_SPEED = 8
const TILE_SIZE = 64
const TILE_OFFSET = 32

func _process(delta):
	if death_countdown < 1:
		death_countdown -= delta
		if death_countdown <= 0:
			self.queue_free()

	if death_countdown == 1:
		if direction == 0:
			position.y -= MOVE_SPEED
		elif direction == 1:
			position.x += MOVE_SPEED
		elif direction == 2:
			position.y += MOVE_SPEED
		elif direction == 3:
			position.x -= MOVE_SPEED
	
	if int(position.x) % TILE_SIZE-TILE_OFFSET == 0 and int(position.y) % TILE_SIZE-TILE_OFFSET == 0:
		position.x = int(position.x)
		position.y = int(position.y)
		direction = -1
		
		if check_for_fall(): direction = 2

func check_for_death_tile(direction = 0):
	if direction == 0 and get_node(tilemap).get_cell( (position.x/TILE_SIZE) , (position.y/TILE_SIZE)-1 ) == 1:
		return true
	elif direction == 1 and get_node(tilemap).get_cell( (position.x/TILE_SIZE)+1 , (position.y/TILE_SIZE) ) == 1:
		return true
	elif direction == 2 and get_node(tilemap).get_cell( (position.x/TILE_SIZE) , (position.y/TILE_SIZE)+1 ) == 1:
		return true
	elif direction == 3 and get_node(tilemap).get_cell( (position.x/TILE_SIZE)-1 , (position.y/TILE_SIZE) ) == 1:
		return true

func check_for_fall():
	if get_node(tilemap).get_cell( (position.x/TILE_SIZE) , (position.y/TILE_SIZE)+1 ) == -1:
		return true

func push(new_direction):
	if direction == -1:
		direction = new_direction
	
		if check_for_death_tile(direction) == true:
			begin_break()

func begin_break():
	particles.emitting = true
	sprite.visible = false
	death_countdown = 0.5

func _on_Rock_area_entered(area):
	if "Rock" in area.name or "SnakeSegment" in area.name:
		begin_break()

func _on_FallOnArea_area_entered(area):
	direction = 2
	if "SnakeHead" in area.name and death_countdown == 1:
		area.queue_free()
	elif "Rock" in area.name:
		begin_break()
		area.begin_break()
