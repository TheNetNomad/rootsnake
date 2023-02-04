extends Area2D


var random = RandomNumberGenerator.new()
var tilemap = "../TileMap"

var horizontal_direction = 0
var direction = 2
var moving = false

const TILE_SIZE = 64
const TILE_OFFSET = 32
const MOVESPEED = 2


func _ready():
	random.randomize()

func _process(delta):
	if moving == false:
		moving = true
		turn()
	else:
		move()

func turn():
	if get_node(tilemap).get_cell( (position.x/TILE_SIZE) , (position.y/TILE_SIZE)+1 ) == -1: #if fall
		direction = 2

	else:
		horizontal_direction = random.randi_range(1,2)
		if horizontal_direction == 1 and get_node(tilemap).get_cell( (position.x/TILE_SIZE)-1 , (position.y/TILE_SIZE) ) == -1:
			direction = 3
		elif horizontal_direction == 2 and get_node(tilemap).get_cell( (position.x/TILE_SIZE)+1 , (position.y/TILE_SIZE) ) == -1:
			direction = 1

func move():
	if direction == 2:
		self.position.y += MOVESPEED
	elif direction == 1:
		self.position.x += MOVESPEED
	elif direction == 3:
		self.position.x -= MOVESPEED


	if int(position.x) % TILE_SIZE-TILE_OFFSET == 0 and int(position.y) % TILE_SIZE-TILE_OFFSET == 0:
		position.x = int(position.x)
		position.y = int(position.y)
		moving = false
