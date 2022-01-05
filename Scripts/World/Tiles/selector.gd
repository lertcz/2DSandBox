extends Sprite

export(int) var snap_size_x = 8
export(int) var snap_size_y = 8

var mouse_pos: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	update_position_snapped()

func update_position_snapped():
	var x = get_global_mouse_position().x / snap_size_x
	var y = get_global_mouse_position().y / snap_size_y
	
	if x <= 0:
		x -= 1
	if y <= 0:
		y -= 1

	mouse_pos = Vector2(int(x), int(y))

	global_position = mouse_pos * snap_size_x
