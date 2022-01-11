extends TileMap

export(int) var max_x = 200
export(int) var max_y = 50

var snap_size_x = 8
var snap_size_y = 8

onready var selector: Sprite = $selector

func removeBlock():
	#TODO implement damage
	var tile: Vector2 = world_to_map(selector.mouse_pos * 8) # gets the tile we click
	var tile_id = get_cellv(tile) # return the Id of the cell

	var new_id = -1 # air

	if (tile_id != -1): # check if we clicked on block
		set_cellv(tile, new_id)

func placeBlock(blockID):
	var tile: Vector2 = world_to_map(selector.mouse_pos * 8)
	var tile_id = get_cellv(tile) # return the Id of the cell
	
	if (tile_id == -1):
		set_cellv(tile, blockID)

func _physics_process(_delta: float) -> void:
	pass

	#print(selector.mouse_pos)
	#print(selector.mouse_pos * 8)

