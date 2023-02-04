extends TileMap


export(NodePath) var camera = null

var random = RandomNumberGenerator.new()

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

func generate_row(y):
	var row_type = random.randi_range(1,3)

	if row_type in [1,2]: #just dirt
		for x in range(WIDTH_IN_TILES):
			set_cell(x,y,0)
			if x in [0,WIDTH_IN_TILES-1]:
				set_cell(x,y,1)
	
	elif row_type == 3: #few walls
		for x in range(WIDTH_IN_TILES):
			set_cell(x,y,random.randi_range(0,1))
			if x in [0,WIDTH_IN_TILES-1]:
				set_cell(x,y,1)
