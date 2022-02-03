extends Node2D

export(Script) var game_save_class

var save_vars = ["name", "height", "length", "player_pos", "player_inventory", "tilemap_cells"]

onready var tileMap = $TileMap
onready var inventory = $Player/Gui/PauseGui/Inventory

#save/load https://www.youtube.com/watch?v=ldKFOGRQDzo
#search files in dir https://godotengine.org/qa/5175/how-to-get-all-the-files-inside-a-folder

func _ready():
	load_world(Global.world)
	
	inventory.initInventorySlots()

func verify_save(world_save):
	for v in save_vars:
		if world_save.get(v) == null:
			return false
	return true

func save_world():
	var new_save = game_save_class.new()
	var old_save_data = load(Global.world)
	new_save.name = old_save_data.name
	new_save.height = old_save_data.height
	new_save.length = old_save_data.length

	var dir = Directory.new()
	if not dir.dir_exists(Global.savePath):
		dir.make_dir_recursive(Global.savePath)

	#!===================================================
	#var world_save = load(Global.world)
	new_save.player_pos = $Player.position
	new_save.player_inventory = PlayerInventory.inventory

	#var size = $TileMap.get_used_rect()
	#print(size)
	#var length = Vector2(size.position.x, size.size.x) # get the lenght of the map
	#var height = Vector2(size.position.y, size.size.y) # get the height of the map
	#print(length)
	#print(height)

	var tilemap_cells = []
	for x in range(old_save_data.length):
		tilemap_cells.append([])
		for y in range(old_save_data.height):
			tilemap_cells[x].append(tileMap.get_cell(x, y))
	new_save.tilemap_cells = tilemap_cells

	return ResourceSaver.save(Global.world, new_save)

func load_world(path):
	var dir = Directory.new()
	if not dir.file_exists(path):
		return false
	
	var world_save = load(path)
	if not verify_save(world_save):
		return false

	$Player.position = world_save.player_pos
	PlayerInventory.inventory = world_save.player_inventory

	#map is loaded verticaly (leftTop -> down)
	for x in range(world_save.length): #length
		for y in range(world_save.height):
			if world_save.tilemap_cells[x][y] != null:
				$TileMap.set_cell(x, y, world_save.tilemap_cells[x][y])

	return true
