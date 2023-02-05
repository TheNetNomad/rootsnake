extends Area2D


var random = RandomNumberGenerator.new()
var tilemap = "../TileMap"
var snakehead = "../SnakeHead"
var camera = "../Camera2D"
onready var sprite = $Sprite

var horizontal_direction = 0
var direction = -1
var moving = false
var death_countdown = 1

const TILE_SIZE = 64
const TILE_OFFSET = 32
const MOVESPEED = 2
const FALLSPEED = 8


func _ready():
	random.randomize()
	$AnimationPlayer.current_animation = "Default"
	$AnimationPlayer.play()

func _process(delta):
	check_if_offscreen()
	if death_countdown != 1:
		death_countdown -= delta
		if death_countdown <= 0: self.queue_free()
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
		var local_position:Vector2 = get_node(tilemap).to_local(position)
		var cell_position:Vector2 = local_position/get_node(tilemap).cell_size

#		print(get_node(tilemap).get_cellv( cell_position ))

		cell_position.x -= 1
		if horizontal_direction == 1 and get_node(tilemap).get_cellv( cell_position ) == -1:
			direction = 3
			sprite.scale.x = -2.5
		cell_position.x += 2
		if horizontal_direction == 2 and get_node(tilemap).get_cellv( cell_position ) == -1:
			direction = 1
			sprite.scale.x = 2.5

func move():
	if direction == 2:
		self.position.y += FALLSPEED
	elif direction == 1:
		self.position.x += MOVESPEED
	elif direction == 3:
		self.position.x -= MOVESPEED


	if int(position.x) % TILE_SIZE-TILE_OFFSET == 0 and int(position.y) % TILE_SIZE-TILE_OFFSET == 0:
		position.x = int(position.x)
		position.y = int(position.y)
		moving = false
		direction = -1

func check_if_offscreen():
	if self.position.y < get_node(camera).position.y - (get_viewport().size.y / 1.8):
		self.queue_free()

func _on_Rabbit_area_entered(area):
	if "Snake" in area.name and death_countdown == 1:
		get_node(snakehead).death("rabbit")

func crush():
	if death_countdown == 1:
		death_countdown = 0.5
		$AudioStreamPlayer.play()
		$Sprite.scale.y = -2.5
		self.position.y += TILE_OFFSET
