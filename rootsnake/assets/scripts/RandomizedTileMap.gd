extends TileMap


export(NodePath) var camera = null

var random = RandomNumberGenerator.new()
var rabbit_difficulty = 1
var rabbit_ammount = 1
var next_rab_dif_increase = 20

const WIDTH_IN_TILES = 16
const CAMERA_HEIGHT_IN_TILES = 10
const TILE_SIZE = 64

func _ready():
	random.randomize()

func _process(delta):
	if camera != null:
		var camera_cell_y = int(get_node(camera).position.y) / TILE_SIZE
		if self.get_cell(0,camera_cell_y+CAMERA_HEIGHT_IN_TILES) == -1:
			generate_row(camera_cell_y+CAMERA_HEIGHT_IN_TILES)
			rabbit_difficulty += 1
			
			if rabbit_difficulty >= next_rab_dif_increase:
				rabbit_ammount += 1
				rabbit_difficulty = 0
				next_rab_dif_increase *= 2

func generate_row(y):
	var row_type = random.randi_range(1,7)

	if row_type in [1,2]: #just dirt
		for x in range(WIDTH_IN_TILES):
			set_cell(x,y,0)
			if x in [0,WIDTH_IN_TILES-1]:
				set_cell(x,y,1)
	
	elif row_type == 3: #few walls
		for x in range(WIDTH_IN_TILES):
			set_cell(x,y,0)
			if x in [0,WIDTH_IN_TILES-1]:
				set_cell(x,y,1)
		for i in range(random.randi_range(1,5)):
			var tile_x = random.randi_range(0,WIDTH_IN_TILES-1)
			set_cell(tile_x,y,1)

	elif row_type == 4: #rock:
		for x in range(WIDTH_IN_TILES):
			set_cell(x,y,random.randi_range(0,1))
			if x in [0,WIDTH_IN_TILES-1]:
				set_cell(x,y,1)

		var rock = load("res://assets/scenes/Rock.tscn").instance()
		rock.position.x = TILE_SIZE * random.randi_range(2,WIDTH_IN_TILES-2) + (TILE_SIZE / 2)
		rock.position.y = y * TILE_SIZE - (TILE_SIZE / 2)
		self.get_parent().add_child(rock)

		var local_position:Vector2 = to_local(rock.position)
		var cell_position:Vector2 = local_position/cell_size
		set_cellv(cell_position,-1)

	elif row_type == 5: #gaps in dirt
		for x in range(WIDTH_IN_TILES):
			set_cell(x,y,random.randi_range(-1,0))
			if x in [0,WIDTH_IN_TILES-1]:
				set_cell(x,y,1)
	
	elif row_type == 6: #rabbit!
		for x in range(WIDTH_IN_TILES):
			set_cell(x,y,random.randi_range(-1,0))
			if x in [0,WIDTH_IN_TILES-1]:
				set_cell(x,y,1)

		for r in range(rabbit_ammount):

			var rabbit = load("res://assets/scenes/Rabbit.tscn").instance()
			rabbit.position.x = TILE_SIZE * random.randi_range(2,WIDTH_IN_TILES-2) + (TILE_SIZE / 2)
			rabbit.position.y = y * TILE_SIZE - (TILE_SIZE / 2)
			self.get_parent().add_child(rabbit)

			var local_position:Vector2 = to_local(rabbit.position)
			var cell_position:Vector2 = local_position/cell_size
			cell_position.x -= 1
			for i in range(3):
				if get_cellv(cell_position) != 1:
					set_cellv(cell_position,-1)
				cell_position.x += 1

	elif row_type == 7: #rich dirt
		for x in range(WIDTH_IN_TILES):
			set_cell(x,y,0)
			if x in [0,WIDTH_IN_TILES-1]:
				set_cell(x,y,1)
		for i in range(random.randi_range(1,5)):
			var tile_x = random.randi_range(1,WIDTH_IN_TILES-2)
			set_cell(tile_x,y,2)
