extends Area2D


var direction = -1
var tilemap = "../TileMap"
var camera = "../Camera2D"
var death_countdown = 1

onready var sprite = $Sprite
onready var particles = $Particles2D

const MOVE_SPEED = 8
const TILE_SIZE = 64
const TILE_OFFSET = 32

func _process(delta):
	check_if_offscreen()

	if death_countdown < 1:
		death_countdown -= delta
		if death_countdown <= 0:
			self.queue_free()

	if direction == -1 or death_countdown < 1:
		$AudioStreamPlayer.playing = false
	elif $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.playing = true

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
		dig()

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
	if death_countdown == 1:
		particles.emitting = true
		sprite.visible = false
		$BreakStreamPlayer.play()
		death_countdown = 0.5

func check_if_offscreen():
	if self.position.y < get_node(camera).position.y - (get_viewport().size.y / 1.8):
		self.queue_free()

func dig():
	var local_position:Vector2 = get_node(tilemap).to_local(position)
	var cell_position:Vector2 = local_position/get_node(tilemap).cell_size

	if get_node(tilemap).get_cellv(cell_position) == 0: #NORMAL SOIL
		get_node(tilemap).set_cellv(cell_position,-1)
	elif get_node(tilemap).get_cellv(cell_position) == 2: #RICH SOIL
		get_node(tilemap).set_cellv(cell_position,-1)

func _on_Rock_area_entered(area):
	if "Rock" in area.name or "SnakeSegment" in area.name:
		begin_break()

func _on_FallOnArea_area_entered(area):
	if direction == -1:
		direction = 2
	if "SnakeHead" in area.name and death_countdown == 1:
		area.queue_free()
	elif "Rock" in area.name:
		begin_break()
		area.begin_break()
	elif "Rabbit" in area.name:
		area.crush()
