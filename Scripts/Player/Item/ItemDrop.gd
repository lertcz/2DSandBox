extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED =  225
var velocity = Vector2.ZERO
var item_name

var player = null
var being_picked_up = false

func _ready():
	item_name = "mud"

func _physics_process(delta):
	if !being_picked_up:
		velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
	else:
		if player:
			var dir = global_position.direction_to(player.global_position)
			velocity = velocity.move_toward(dir * MAX_SPEED, ACCELERATION * delta)
			
			var distance = global_position.distance_to(player.global_position)
			if distance < 4:
				PlayerInventory.add_item(item_name, 1)
				queue_free()
				player.reload_inventory()
		
	velocity = move_and_slide(velocity, Vector2.UP)

func pick_up_item(body):
	player = body
	being_picked_up = true
