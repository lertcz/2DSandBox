extends TileMap

export(int) var max_x = 200
export(int) var max_y = 50

var snap_size_x = 8
var snap_size_y = 8

onready var itemDrop = load("res://Scenes/Items/ItemDrop.tscn")

onready var selector: Sprite = $selector

func _ready():
	#if it is a block make the collision 2x smaller
	pass

func removeBlock():
	#TODO implement damage
	var tile: Vector2 = world_to_map(selector.mouse_pos * 8) # gets the tile we click
	var tile_id = get_cellv(tile) # return the Id of the cell


	if (tile_id != -1): # check if we clicked on block
		dropItem(tile, tile_id)

func dropItem(tile: Vector2, id: int):
	set_cellv(tile, -1) # set tile as air
	var item = itemDrop.instance()
	item.position = selector.mouse_pos * 8
	item.item_name = Global.blockIdDrop[id]
	print(item)
	print(item.item_name)
	add_child(item)

func placeBlock(blockID):
	var tile: Vector2 = world_to_map(selector.mouse_pos * 8)
	var tile_id = get_cellv(tile) # return the Id of the cell
	set_cellv(tile, blockID)

func return_cell_pos_and_id():
	var tile: Vector2 = world_to_map(selector.mouse_pos * 8)
	return [get_cellv(tile)]

#print(selector.mouse_pos)
#print(selector.mouse_pos * 8)

