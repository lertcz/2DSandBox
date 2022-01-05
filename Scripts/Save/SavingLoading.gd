extends Node

#export(Script) var game_save_class
const game_save_class = preload("res://Scripts/Save/game_save.gd")

var save_vars = ["name", "height", "length", "player_pos", "tilemap_cells"]

onready var tileMap = $TileMap

#save/load https://www.youtube.com/watch?v=ldKFOGRQDzo
#search files in dir https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder

func verify_save(world_save):
	for v in save_vars:
		if world_save.get(v) == null:
			return false
	return true
	
func save_world(player):
	var new_save = game_save_class.new()
	
	var dir = Directory.new()
	var path = "res://saves/"
	if not dir.dir_exists(path):
		dir.make_dir_recursive(path)

	var world_save = load(Global.world)
	new_save.player_pos = player.position
	
	var tilemap_cells = []
	var size = $TileMap.get_used_rect()
	print(size)
	#for x in range(world_save.length):
	#	tilemap_cells.append([])
	#	for y in range(world_save.height):
	#		tilemap_cells[x].append(tileMap.get_cell(x, y))
	#new_save.tilemap_cells = tilemap_cells

	#ResourceSaver.save(Global.world, new_save)
	
func load_world(path, gameNode):#, player=null, tileMap=null):
	var dir = Directory.new()
	if not dir.file_exists(path):
		return false
	
	var world_save = load(path)
	if not verify_save(world_save):
		return false
	
	#player.position = world_save.player_pos
	
	for x in range(world_save.length):
		for y in range(world_save.height):
			tileMap.set_cell(x, y, world_save.tilemap_cells[x][y])
	
	return true

var noise: OpenSimplexNoise = OpenSimplexNoise.new()
func randomPreset() -> void:
	randomize()
	
	noise.seed = randi()
	noise.octaves = 0
	noise.period = 5
	noise.persistence = 0.588 
	noise.lacunarity = 2.43

func generate_level(name: String, max_x: int, max_y: int):
	randomPreset()
	var Map = []
	for x in max_x:
		Map.append([])
		var noise_height = int(noise.get_noise_1d(x) * 4.5) # -10 to get the map lower
		
		Map[x].append(Global.blocks.grass)
		#set_cell(x, noise_height, Blocks.blocks.grass) # position, height, mud

		var rand_limit = int(rand_range(noise_height+4, noise_height+6))
		for depth in range(noise_height+1, rand_limit):
			Map[x].append(Global.blocks.mud)
			#set_cell(x, depth, blocks.mud)

		for depth in range(rand_limit, max_y):
			var tile_id = generate_id(noise.get_noise_2d(x, depth))
			
			if(depth > rand_limit+3):
				if(tile_id != -1):
					Map[x].append(Global.blocks.stone)
					#set_cell(x, depth, blocks.stone)
			else:
				Map[x].append(Global.blocks.stone)
				#set_cell(x, depth, blocks.stone)

	#save_world()

func generate_id(noise_level: float):
	if(noise_level <= -0.3): # value when the block wont show else it will show the block
		return -1
	else:
		return 0
