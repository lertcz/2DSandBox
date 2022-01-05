extends TileMap

export(int) var max_x = 200
export(int) var max_y = 50

var snap_size_x = 8
var snap_size_y = 8

onready var selector: Sprite = $selector

func _physics_process(_delta: float) -> void:
	if(Input.is_action_pressed("LMB")):
		var tile: Vector2 = world_to_map(selector.mouse_pos * 8) # gets the tile we click
		var tile_id = get_cellv(tile) # return the Id of the cell
		
		var new_id = -1
		
		if(tile_id != -1): # check if we clicked on block
			#if(tile_id < 5): # we can increase the mud block
			#	new_id = (tile_id + 1)
			#else:
			new_id = -1
			
			set_cellv(tile, new_id)
		
	if(Input.is_action_pressed("RMB")):
		var tile: Vector2 = world_to_map(selector.mouse_pos * 8)
		set_cellv(tile, 0)
	
	print(selector.mouse_pos)
	#print(selector.mouse_pos * 8)

